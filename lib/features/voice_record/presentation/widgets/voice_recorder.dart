import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:record/record.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_speech/google_speech.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talkbridge/constants/enums.dart';
import 'package:talkbridge/features/language_picker/presentation/cubit/language_picker/language_picker_cubit.dart';

import 'package:talkbridge/features/voice_record/presentation/cubits/voice_record/voice_record_cubit.dart';

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
              isRecording: true,
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
    }) async {
      String transcription = '';

      if (!context.mounted) return;
      context.read<VoiceRecordCubit>().setRecordingStatus(
            isRecording: false,
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
          model: RecognitionModel.basic,
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
        await context.read<VoiceRecordCubit>().updateSpeechText(
              text: transcription,
              sourceLanguage:
                  currentUser == User.host ? sourceLanguage : targetLanguage,
              targetLanguage:
                  currentUser == User.host ? targetLanguage : sourceLanguage,
              userSpeaking: currentUser,
            );
      });
    }

    return BlocBuilder<LanguagePickerCubit, LanguagePickerState>(
      builder: (context, languagePickerState) {
        if (languagePickerState is LanguagesSelected) {
          return BlocBuilder<VoiceRecordCubit, VoiceRecordState>(
            builder: (context, state) {
              if (state is VoiceRecordInitial) {
                return AvatarGlow(
                  endRadius: 45,
                  animate: state.isRecording,
                  glowColor: Colors.red,
                  repeat: true,
                  duration: const Duration(milliseconds: 2000),
                  repeatPauseDuration: const Duration(milliseconds: 100),
                  child: InkWell(
                    onTap: () => state.isRecording
                        ? stopRecording(
                            sourceLanguage: languagePickerState.sourceLanguage
                                .substring(0, 2),
                            targetLanguage: languagePickerState.targetLanguage
                                .substring(0, 2),
                          )
                        : startRecording(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: state.isRecording
                            ? Colors.white
                            : Colors.greenAccent,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          width: 8,
                          color: Colors.white,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: AvatarGlow(
                        endRadius: 30,
                        animate: state.isRecording,
                        glowColor: Colors.red,
                        repeat: true,
                        duration: const Duration(milliseconds: 2000),
                        repeatPauseDuration: const Duration(milliseconds: 100),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            size: 45,
                            color: state.isRecording
                                ? Colors.greenAccent
                                : Colors.white,
                            Icons.keyboard_voice_outlined,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
              return AvatarGlow(
                endRadius: 45,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      width: 8,
                      color: Colors.white,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      size: 45,
                      color: Colors.white,
                      Icons.keyboard_voice_outlined,
                    ),
                  ),
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
