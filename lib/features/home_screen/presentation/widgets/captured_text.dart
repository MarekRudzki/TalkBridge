import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkbridge/constants/enums.dart';
import 'package:talkbridge/features/language_picker/presentation/cubit/language_picker/language_picker_cubit.dart';
import 'package:talkbridge/features/user_settings/presentation/cubits/user_settings/user_settings_cubit.dart';
import 'package:talkbridge/features/voice_record/presentation/cubits/voice_record/voice_record_cubit.dart';

class CapturedText extends StatelessWidget {
  final String speechText;
  final String translation;
  final User userSpeaking;
  final User userScreenType;
  const CapturedText({
    super.key,
    required this.speechText,
    required this.translation,
    required this.userSpeaking,
    required this.userScreenType,
  });

  @override
  Widget build(BuildContext context) {
    Timer? debounce;

    String displayInitialText() {
      if (userScreenType == User.host) {
        if (userSpeaking == User.host) {
          return speechText == '' ? '' : speechText;
        } else {
          return translation == '' ? '' : translation;
        }
      } else {
        if (userSpeaking == User.guest) {
          return speechText == '' ? '' : speechText;
        } else {
          return translation == '' ? '' : translation;
        }
      }
    }

    return BlocBuilder<LanguagePickerCubit, LanguagePickerState>(
      builder: (context, languagePickerState) {
        if (languagePickerState is LanguagesSelected) {
          return Expanded(
            child: SingleChildScrollView(
              child: BlocBuilder<UserSettingsCubit, UserSettingsState>(
                builder: (context, state) {
                  if (state is UserSettingsInitial) {
                    return TextField(
                      controller: TextEditingController()
                        ..text = displayInitialText()
                        ..selection = TextSelection.collapsed(
                            offset: displayInitialText().length),
                      keyboardType: TextInputType.text,
                      maxLines: 7,
                      cursorColor: Colors.greenAccent,
                      decoration: const InputDecoration(
                        hintText: 'Start typing or use microphone',
                        border: InputBorder.none,
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize:
                            context.read<UserSettingsCubit>().getFontSize() + 1,
                      ),
                      onChanged: (value) {
                        if (debounce?.isActive ?? false) debounce?.cancel();
                        debounce = Timer(
                          const Duration(milliseconds: 1700),
                          () {
                            if (value == '') {
                              context
                                  .read<VoiceRecordCubit>()
                                  .setInitialState();
                            } else {
                              context.read<VoiceRecordCubit>().updateSpeechText(
                                    text: value,
                                    sourceLanguage: languagePickerState
                                        .sourceLanguage
                                        .substring(0, 2),
                                    targetLanguage: languagePickerState
                                        .targetLanguage
                                        .substring(0, 2),
                                    userSpeaking: userSpeaking,
                                  );
                            }
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
