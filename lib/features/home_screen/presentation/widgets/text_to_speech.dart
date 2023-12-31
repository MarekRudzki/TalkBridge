// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';

// Project imports:
import 'package:talkbridge/constants/enums.dart';
import 'package:talkbridge/features/home_screen/presentation/cubit/home_screen_cubit_cubit.dart';
import 'package:talkbridge/features/language_picker/presentation/cubit/language_picker/language_picker_cubit.dart';
import 'package:talkbridge/features/voice_record/presentation/cubits/voice_record/voice_record_cubit.dart';
import 'package:talkbridge/utils/di.dart';

class TextToSpeech extends StatelessWidget {
  final User userScreen;
  final double speechSpeed;

  const TextToSpeech({
    super.key,
    required this.userScreen,
    required this.speechSpeed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguagePickerCubit, LanguagePickerState>(
      builder: (context, languagePickerState) {
        if (languagePickerState is LanguagesSelected) {
          return BlocBuilder<VoiceRecordCubit, VoiceRecordState>(
            builder: (context, voiceRecordState) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: speechSpeed == 0.5
                        ? const Icon(
                            Icons.record_voice_over_outlined,
                            color: Colors.white,
                            size: 25,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(5),
                            child: Image.asset('assets/turtle.png', scale: 5),
                          ),
                  ),
                  onTap: () async {
                    if (voiceRecordState is VoiceRecordInitial) {
                      final FlutterTts ftts = FlutterTts();
                      await ftts.setPitch(1);
                      await ftts.setVolume(1.0);
                      await ftts.setSpeechRate(speechSpeed);
                      await ftts.setLanguage(
                        userScreen == User.host
                            ? languagePickerState.sourceLanguage.substring(0, 2)
                            : languagePickerState.targetLanguage
                                .substring(0, 2),
                      );

                      await ftts.speak(
                        getIt<HomeScreenCubit>().getTextToSpeak(
                          voiceRecordState: voiceRecordState,
                          userScreen: userScreen,
                        ),
                      );
                    }
                  },
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
