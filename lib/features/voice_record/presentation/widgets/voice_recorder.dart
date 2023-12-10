// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

// Package imports:
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_speech/google_speech.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:translator_plus/translator_plus.dart';

// Project imports:
import 'package:talkbridge/constants/enums.dart';
import 'package:talkbridge/features/language_picker/presentation/cubit/language_picker/language_picker_cubit.dart';
import 'package:talkbridge/features/user_settings/presentation/cubits/user_settings/user_settings_cubit.dart';
import 'package:talkbridge/features/voice_record/presentation/cubits/voice_record/voice_record_cubit.dart';

class VoiceRecorder extends StatefulWidget {
  final User currentUser;
  const VoiceRecorder({
    super.key,
    required this.currentUser,
  });

  @override
  State<VoiceRecorder> createState() => _VoiceRecorderState();
}

class _VoiceRecorderState extends State<VoiceRecorder> {
  int _recordDuration = 0;
  Timer? _timer;
  late final AudioRecorder _audioRecorder;
  StreamSubscription<RecordState>? _recordSub;
  RecordState _recordState = RecordState.stop;
  Amplitude? _amplitude;
  StreamSubscription<Amplitude>? _amplitudeSub;

  @override
  void initState() {
    _audioRecorder = AudioRecorder();

    _recordSub = _audioRecorder.onStateChanged().listen((recordState) {
      _updateRecordState(recordState);
    });

    _amplitudeSub = _audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 300))
        .listen((amp) {
      setState(() => _amplitude = amp);
    });

    super.initState();
  }

  Future<Stream<List<int>>> getAudioStream(String name) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$name';
    return File(path).openRead();
  }

  Future<void> _pause() => _audioRecorder.pause();

  Future<void> _resume() => _audioRecorder.resume();

  void _updateRecordState(RecordState recordState) {
    setState(() => _recordState = recordState);

    switch (recordState) {
      case RecordState.pause:
        _timer?.cancel();
        break;
      case RecordState.record:
        _startTimer();
        break;
      case RecordState.stop:
        _timer?.cancel();
        _recordDuration = 0;
        break;
    }
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> startRecording() async {
      final hasPermission = await _audioRecorder.hasPermission();
      if (hasPermission) {
        if (!context.mounted) return;
        const encoder = AudioEncoder.wav;
        context.read<VoiceRecordCubit>().setRecordingStatus(
              recordingUser: widget.currentUser == User.host
                  ? RecordingUser.host
                  : RecordingUser.guest,
            );

        // We don't do anything with this but printing

        final isSupported = await _audioRecorder.isEncoderSupported(encoder);
        debugPrint('${encoder.name} supported: $isSupported');

        final devs = await _audioRecorder.listInputDevices();
        debugPrint(devs.toString());

        const config =
            RecordConfig(encoder: encoder, numChannels: 1, sampleRate: 16000);
        final directory = await getApplicationDocumentsDirectory();
        // Record to file
        String path;
        if (kIsWeb) {
          path = '';
        } else {
          path = p.join('${directory.path}/speech.wav');
        }
        await _audioRecorder.start(config, path: path);

        // Record to stream
        // final file = File(path);
        // final stream = await _audioRecorder.startStream(config);
        // stream.listen(
        //   (data) {
        //     // ignore: avoid_print
        //     print(
        //       _audioRecorder.convertBytesToInt16(Uint8List.fromList(data)),
        //     );
        //     file.writeAsBytesSync(data, mode: FileMode.append);
        //   },
        //   // ignore: avoid_print
        //   onDone: () => print('End of stream'),
        // );

        _recordDuration = 0;

        _startTimer();
      }
    }

    Future<void> stopRecording({
      required String sourceLanguage,
      required String targetLanguage,
      required bool isAutoPlay,
    }) async {
      String transcription = '';

      if (!context.mounted) return;
      context.read<VoiceRecordCubit>().setRecordingStatus(
            recordingUser: RecordingUser.none,
          );
      context.read<VoiceRecordCubit>().startLoading();
      await _audioRecorder.stop();

      // * here it will fail if you did not add your own json for google api
      final serviceAccount = ServiceAccount.fromString(
        await rootBundle.loadString(
          'assets/talkbridge_service_account.json',
        ),
      );

      final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
      final streamingConfig = StreamingRecognitionConfig(
        config: RecognitionConfig(
          encoding: AudioEncoding.LINEAR16,
          enableAutomaticPunctuation: true,
          sampleRateHertz: 44100,
          audioChannelCount: 2,
          languageCode:
              widget.currentUser == User.host ? sourceLanguage : targetLanguage,
        ),
        interimResults: true,
      );

      final audio = await getAudioStream('speech.wav');

      final responseStream =
          speechToText.streamingRecognize(streamingConfig, audio);

      responseStream.listen((data) async {
        transcription =
            data.results.map((e) => e.alternatives.first.transcript).join('\n');
      }).onDone(() async {
        if (transcription.isEmpty) {
          context.read<VoiceRecordCubit>().displayErrorMessage(
                sourceLanguage: widget.currentUser == User.host
                    ? sourceLanguage
                    : targetLanguage,
                userSpeaking: widget.currentUser,
              );
        } else {
          await context.read<VoiceRecordCubit>().updateSpeechText(
                text: transcription,
                sourceLanguage: widget.currentUser == User.host
                    ? sourceLanguage
                    : targetLanguage,
                targetLanguage: widget.currentUser == User.host
                    ? targetLanguage
                    : sourceLanguage,
                userSpeaking: widget.currentUser,
              );
          if (isAutoPlay) {
            final FlutterTts ftts = FlutterTts();
            final translator = GoogleTranslator();
            await ftts.setPitch(1);
            await ftts.setVolume(1.0);
            await ftts.setSpeechRate(0.5);
            await ftts.setLanguage(widget.currentUser == User.host
                ? targetLanguage
                : sourceLanguage);

            final translation = await translator.translate(
              transcription,
              from: widget.currentUser == User.host
                  ? sourceLanguage
                  : targetLanguage,
              to: widget.currentUser == User.host
                  ? targetLanguage
                  : sourceLanguage,
            );

            await ftts.speak(translation.text);
          }
        }
      });
    }

    return BlocBuilder<LanguagePickerCubit, LanguagePickerState>(
      builder: (context, languagePickerState) {
        if (languagePickerState is LanguagesSelected) {
          return BlocBuilder<VoiceRecordCubit, VoiceRecordState>(
            builder: (context, state) {
              if (state is VoiceRecordInitial) {
                bool shouldAnimate() {
                  if ((widget.currentUser == User.host &&
                          state.recordingUser == RecordingUser.host) ||
                      (widget.currentUser == User.guest &&
                          state.recordingUser == RecordingUser.guest)) {
                    return true;
                  } else {
                    return false;
                  }
                }

                return BlocBuilder<UserSettingsCubit, UserSettingsState>(
                  builder: (context, userSettingsState) {
                    if (userSettingsState is UserSettingsInitial) {
                      return InkWell(
                        onTap: () async {
                          if (state.recordingUser != RecordingUser.none) {
                            await stopRecording(
                              sourceLanguage: languagePickerState.sourceLanguage
                                  .substring(0, 2),
                              targetLanguage: languagePickerState.targetLanguage
                                  .substring(0, 2),
                              isAutoPlay: userSettingsState.isAutoPlay,
                            );
                          } else {
                            await startRecording();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: shouldAnimate()
                                ? Colors.white
                                : Colors.greenAccent,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              width: 8,
                              color: Colors.white,
                            ),
                          ),
                          child: AvatarGlow(
                            endRadius: 30,
                            animate: shouldAnimate(),
                            glowColor: Colors.red,
                            child: Icon(
                              size: 45,
                              color: shouldAnimate()
                                  ? Colors.greenAccent
                                  : Colors.white,
                              Icons.keyboard_voice_outlined,
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                );
              }
              return Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    width: 8,
                    color: Colors.white,
                  ),
                ),
                child: const Icon(
                  size: 45,
                  color: Colors.white,
                  Icons.keyboard_voice_outlined,
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
