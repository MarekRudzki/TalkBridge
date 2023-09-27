import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:record/record.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_speech/google_speech.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talkbridge/features/home_screen/presentation/cubits/language/language_cubit.dart';
import 'package:talkbridge/features/home_screen/presentation/cubits/voice_record/voice_record_cubit.dart';

class VoiceRecorder extends StatelessWidget {
  const VoiceRecorder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final record = Record();

    Future<void> startRecording() async {
      context.read<VoiceRecordCubit>().setRecordingStatus(
            isRecording: true,
          );

      final directory = await getApplicationDocumentsDirectory();

      if (await record.hasPermission()) {
        await record.start(
          path: '${directory.path}/speech.wav',
          encoder: AudioEncoder.wav,
          bitRate: 12800,
        );
      }
    }

    Future<void> stopRecording({required String languageCode}) async {
      await record.stop();
      context.read<VoiceRecordCubit>().setRecordingStatus(
            isRecording: false,
          );

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
          languageCode: languageCode,
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
      responseStream.listen((data) {
        final abc =
            data.results.map((e) => e.alternatives.first.transcript).join('\n');

        context
            .read<VoiceRecordCubit>()
            .updateSpeechText(text: abc, isRecording: false);
      });
    }

    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, languageCubit) {
        if (languageCubit is LanguagesSelected) {
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
                            languageCode: languageCubit.sourceLanguage)
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
              return const SizedBox.shrink();
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
