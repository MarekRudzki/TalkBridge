// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:talkbridge/features/language_picker/presentation/cubit/language_picker/language_picker_cubit.dart';
import 'package:talkbridge/features/voice_record/presentation/cubits/voice_record/voice_record_cubit.dart';

class LanguagesReverse extends StatelessWidget {
  const LanguagesReverse({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguagePickerCubit, LanguagePickerState>(
      builder: (context, languagePickerState) {
        if (languagePickerState is LanguagesSelected) {
          return BlocBuilder<VoiceRecordCubit, VoiceRecordState>(
            builder: (context, voiceRecordState) {
              return IconButton(
                onPressed: () async {
                  if (voiceRecordState is VoiceRecordInitial) {
                    await context
                        .read<LanguagePickerCubit>()
                        .reverseLanguages();
                    if (!context.mounted) return;
                    if (voiceRecordState.translation.isNotEmpty ||
                        voiceRecordState.speechText.isNotEmpty) {
                      context.read<VoiceRecordCubit>().reverseTranslations(
                            speechText: voiceRecordState.speechText,
                            translation: voiceRecordState.translation,
                          );
                    }
                  }
                },
                icon: const Icon(
                  Icons.cached,
                  color: Colors.white,
                  size: 33,
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
