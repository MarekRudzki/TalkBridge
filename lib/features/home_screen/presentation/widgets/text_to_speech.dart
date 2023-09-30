import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:talkbridge/constants/enums.dart';
import 'package:talkbridge/features/language_picker/presentation/cubit/language_picker/language_picker_cubit.dart';
import 'package:talkbridge/features/voice_record/presentation/cubits/voice_record/voice_record_cubit.dart';

class TextToSpeech extends StatelessWidget {
  final User userScreen;
  final double speechSpeed;
  final Widget iconWidget;
  const TextToSpeech({
    super.key,
    required this.userScreen,
    required this.speechSpeed,
    required this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: BlocBuilder<LanguagePickerCubit, LanguagePickerState>(
        builder: (context, languagePickerState) {
          if (languagePickerState is LanguagesSelected) {
            return BlocBuilder<VoiceRecordCubit, VoiceRecordState>(
              builder: (context, voiceRecordState) {
                if (voiceRecordState is VoiceRecordInitial) {
                  return InkWell(
                    child: iconWidget,
                    onTap: () async {
                      FlutterTts ftts = FlutterTts();
                      await ftts.setPitch(1);
                      await ftts.setVolume(1.0);
                      await ftts.setSpeechRate(speechSpeed);
                      await ftts.setLanguage(
                        userScreen == User.host
                            ? languagePickerState.targetLanguage
                            : languagePickerState.sourceLanguage,
                      );

                      await ftts.speak(
                        userScreen == User.host
                            ? voiceRecordState.translation
                            : voiceRecordState.speechText,
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
