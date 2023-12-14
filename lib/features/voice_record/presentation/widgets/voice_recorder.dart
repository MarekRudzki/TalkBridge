// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:talkbridge/utils/di.dart';
import 'package:translator_plus/translator_plus.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

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
  final SpeechToText _speechToText = SpeechToText();
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    await _speechToText.initialize();
    setState(() {});
  }

  Future<void> startRecording({
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    _lastWords = '';
    final hasPermission = await _speechToText.hasPermission;
    if (hasPermission) {
      if (!context.mounted) return;
      context.read<VoiceRecordCubit>().setRecordingStatus(
            recordingUser: widget.currentUser == User.host
                ? RecordingUser.host
                : RecordingUser.guest,
          );
    }

    await _speechToText.listen(
        onResult: _onSpeechResult,
        localeId:
            widget.currentUser == User.host ? sourceLanguage : targetLanguage);
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  Future<void> stopRecording({
    required String sourceLanguage,
    required String targetLanguage,
    required bool isAutoPlay,
  }) async {
    await _speechToText.stop();
    setState(() {});

    if (!context.mounted) return;
    context.read<VoiceRecordCubit>().startLoading();

    // Wait for _lastWords to update
    await Future.delayed(const Duration(seconds: 1));
    if (!context.mounted) return;
    context.read<VoiceRecordCubit>().setRecordingStatus(
          recordingUser: RecordingUser.none,
        );
    if (!context.mounted) return;
    if (_lastWords.isEmpty) {
      context.read<VoiceRecordCubit>().displayErrorMessage(
            sourceLanguage: widget.currentUser == User.host
                ? sourceLanguage
                : targetLanguage,
            userSpeaking: widget.currentUser,
          );
    } else {
      await context.read<VoiceRecordCubit>().updateSpeechText(
            text: _lastWords,
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
        await ftts.setLanguage(
            widget.currentUser == User.host ? targetLanguage : sourceLanguage);

        final translation = await translator.translate(
          _lastWords,
          from:
              widget.currentUser == User.host ? sourceLanguage : targetLanguage,
          to: widget.currentUser == User.host ? targetLanguage : sourceLanguage,
        );

        await ftts.speak(translation.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguagePickerCubit, LanguagePickerState>(
      builder: (context, languagePickerState) {
        if (languagePickerState is LanguagesSelected) {
          return BlocBuilder<VoiceRecordCubit, VoiceRecordState>(
            builder: (context, voiceRecordState) {
              if (voiceRecordState is VoiceRecordInitial) {
                return BlocBuilder<UserSettingsCubit, UserSettingsState>(
                  builder: (context, userSettingsState) {
                    final voiceRecordCubit = getIt<VoiceRecordCubit>();

                    final bool isMicrophoneAvailable =
                        voiceRecordCubit.isMicrophoneAvailable(
                      currentUser: widget.currentUser,
                      recordingUser: voiceRecordState.recordingUser,
                    );

                    final bool shouldAnimate = voiceRecordCubit.shouldAnimate(
                      userSettingsState: userSettingsState,
                      currentUser: widget.currentUser,
                      recordingUser: voiceRecordState.recordingUser,
                    );

                    if (userSettingsState is UserSettingsInitial) {
                      return InkWell(
                        onTap: () async {
                          if (isMicrophoneAvailable) {
                            if (voiceRecordState.recordingUser !=
                                RecordingUser.none) {
                              await stopRecording(
                                sourceLanguage: languagePickerState
                                    .sourceLanguage
                                    .substring(0, 2),
                                targetLanguage: languagePickerState
                                    .targetLanguage
                                    .substring(0, 2),
                                isAutoPlay: userSettingsState.isAutoPlay,
                              );
                            } else {
                              await startRecording(
                                sourceLanguage: languagePickerState
                                    .sourceLanguage
                                    .substring(0, 2),
                                targetLanguage: languagePickerState
                                    .targetLanguage
                                    .substring(0, 2),
                              );
                            }
                          }
                        },
                        child: isMicrophoneAvailable
                            ? Container(
                                decoration: BoxDecoration(
                                  color: shouldAnimate
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
                                  animate: shouldAnimate,
                                  glowColor: Colors.red,
                                  child: Icon(
                                    size: 45,
                                    color: shouldAnimate
                                        ? Colors.greenAccent
                                        : Colors.white,
                                    Icons.keyboard_voice_outlined,
                                  ),
                                ),
                              )
                            : Container(
                                height: 76,
                                width: 76,
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
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
