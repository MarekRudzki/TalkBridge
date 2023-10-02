import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:record/record.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_speech/google_speech.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talkbridge/constants/enums.dart';
import 'package:talkbridge/features/language_picker/presentation/cubit/language_picker/language_picker_cubit.dart';
import 'package:talkbridge/features/user_settings/presentation/cubits/user_settings/user_settings_cubit.dart';

import 'package:talkbridge/features/voice_record/presentation/cubits/voice_record/voice_record_cubit.dart';
import 'package:translator_plus/translator_plus.dart';

class VoiceRecorder extends StatelessWidget {
  final User currentUser;
  const VoiceRecorder({
    super.key,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    final record = Record();

    Future<void> startRecording() async {
      final hasPermission = await record.hasPermission();
      if (hasPermission) {
        if (!context.mounted) return;
        context.read<VoiceRecordCubit>().setRecordingStatus(
              recordingUser: currentUser == User.host
                  ? RecordingUser.host
                  : RecordingUser.guest,
            );

        final directory = await getApplicationDocumentsDirectory();
        await record.start(
          path: '${directory.path}/speech.wav',
          encoder: AudioEncoder.wav,
          bitRate: 12800,
        );
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
      await record.stop();
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
              currentUser == User.host ? sourceLanguage : targetLanguage,
        ),
        interimResults: true,
      );

      Future<Stream<List<int>>> getAudioStream(String name) async {
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/$name';
        return File(path).openRead();
      }

      final audio = await getAudioStream('speech.wav');

      final responseStream =
          speechToText.streamingRecognize(streamingConfig, audio);

      responseStream.listen((data) async {
        transcription =
            data.results.map((e) => e.alternatives.first.transcript).join('\n');
      }).onDone(() async {
        if (transcription.isEmpty) {
          context.read<VoiceRecordCubit>().displayErrorMessage(
                sourceLanguage:
                    currentUser == User.host ? sourceLanguage : targetLanguage,
                userSpeaking: currentUser,
              );
        } else {
          await context.read<VoiceRecordCubit>().updateSpeechText(
                text: transcription,
                sourceLanguage:
                    currentUser == User.host ? sourceLanguage : targetLanguage,
                targetLanguage:
                    currentUser == User.host ? targetLanguage : sourceLanguage,
                userSpeaking: currentUser,
              );
          if (isAutoPlay) {
            final FlutterTts ftts = FlutterTts();
            final translator = GoogleTranslator();
            await ftts.setPitch(1);
            await ftts.setVolume(1.0);
            await ftts.setSpeechRate(0.5);
            await ftts.setLanguage(
                currentUser == User.host ? targetLanguage : sourceLanguage);

            final translation = await translator.translate(
              transcription,
              from: currentUser == User.host ? sourceLanguage : targetLanguage,
              to: currentUser == User.host ? targetLanguage : sourceLanguage,
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
                  if ((currentUser == User.host &&
                          state.recordingUser == RecordingUser.host) ||
                      (currentUser == User.guest &&
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
