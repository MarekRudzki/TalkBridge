// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:talkbridge/features/home_screen/presentation/cubit/home_screen_cubit_cubit.dart';
import 'package:talkbridge/utils/di.dart';
import 'package:translator_plus/translator_plus.dart';

// Project imports:
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
    final translator = GoogleTranslator();
    final HomeScreenCubit homeScreenCubit = getIt<HomeScreenCubit>();
    Timer? debounce;

    String displayInitialText() {
      return homeScreenCubit.getInitialText(
        userScreenType: userScreenType,
        userSpeaking: userSpeaking,
        translation: translation,
        speechText: speechText,
      );
    }

    Future<void> updateSpeechText({
      required BuildContext currentContext,
      required String text,
      required String sourceLanguage,
      required String targetLanguage,
    }) async {
      if (text.isEmpty) {
        currentContext.read<VoiceRecordCubit>().setInitialState();
      } else {
        await currentContext.read<VoiceRecordCubit>().updateSpeechText(
              text: text,
              sourceLanguage: sourceLanguage.substring(0, 2),
              targetLanguage: targetLanguage.substring(0, 2),
              userSpeaking: userSpeaking,
            );

        final translation = await translator.translate(
          text,
          from: sourceLanguage.substring(0, 2),
          to: targetLanguage.substring(0, 2),
        );

        final FlutterTts ftts = FlutterTts();
        await ftts.setPitch(1);
        await ftts.setVolume(1.0);
        await ftts.setSpeechRate(0.5);
        await ftts.setLanguage(targetLanguage.substring(0, 2));
        await ftts.speak(translation.text);
      }
    }

    return BlocBuilder<LanguagePickerCubit, LanguagePickerState>(
      builder: (context, languagePickerState) {
        if (languagePickerState is LanguagesSelected) {
          return Expanded(
            child: SingleChildScrollView(
              child: BlocBuilder<UserSettingsCubit, UserSettingsState>(
                builder: (context, userSettingsState) {
                  if (userSettingsState is UserSettingsInitial) {
                    return FutureBuilder(
                      future: homeScreenCubit.displayHintText(
                        sourceLanguage:
                            languagePickerState.sourceLanguage.substring(0, 2),
                        targetLanguage:
                            languagePickerState.targetLanguage.substring(0, 2),
                        userScreenType: userScreenType,
                        translator: translator,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return TextField(
                            readOnly: userScreenType == User.guest,
                            controller: TextEditingController()
                              ..text = displayInitialText()
                              ..selection = TextSelection.collapsed(
                                  offset: displayInitialText().length),
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            maxLines: 7,
                            cursorColor: Colors.greenAccent,
                            decoration: InputDecoration(
                              hintText: snapshot.data,
                              border: InputBorder.none,
                            ),
                            textAlign: TextAlign.center,
                            onSubmitted: (value) async {
                              if (debounce?.isActive ?? false) {
                                debounce?.cancel();
                              }
                              await updateSpeechText(
                                currentContext: context,
                                text: value,
                                sourceLanguage:
                                    languagePickerState.sourceLanguage,
                                targetLanguage:
                                    languagePickerState.targetLanguage,
                              );
                            },
                            style: TextStyle(
                              fontSize: context
                                      .read<UserSettingsCubit>()
                                      .getFontSize() +
                                  1,
                            ),
                            onChanged: (value) async {
                              if (debounce?.isActive ?? false) {
                                debounce?.cancel();
                              }
                              debounce = Timer(
                                const Duration(milliseconds: 2500),
                                () async {
                                  await updateSpeechText(
                                    currentContext: context,
                                    text: value,
                                    sourceLanguage:
                                        languagePickerState.sourceLanguage,
                                    targetLanguage:
                                        languagePickerState.targetLanguage,
                                  );
                                },
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
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
