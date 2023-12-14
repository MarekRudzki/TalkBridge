// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:country_flags/country_flags.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:talkbridge/features/language_picker/presentation/cubit/language_picker/language_picker_cubit.dart';
import 'package:talkbridge/features/user_settings/presentation/cubits/user_settings/user_settings_cubit.dart';
import 'package:talkbridge/features/voice_record/presentation/cubits/voice_record/voice_record_cubit.dart';
import 'package:talkbridge/utils/di.dart';
import 'package:talkbridge/utils/l10n/localization.dart';

class LanguagePickScreen extends StatelessWidget {
  final bool isSelectingSourceLng;

  const LanguagePickScreen({
    super.key,
    required this.isSelectingSourceLng,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<UserSettingsCubit, UserSettingsState>(
        builder: (context, userSettingsState) {
          if (userSettingsState is UserSettingsInitial) {
            final Map<String, String> languages = context
                .read<LanguagePickerCubit>()
                .getLanguageList(
                  context: context,
                  currentInterfaceLanguage: userSettingsState.interfaceLanguage,
                );
            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 213, 210, 210),
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(255, 75, 207, 143),
                title: isSelectingSourceLng
                    ? Text(
                        context.l10n.sourceLanguage,
                        style: TextStyle(
                          fontSize:
                              context.read<UserSettingsCubit>().getFontSize() +
                                  3,
                        ),
                      )
                    : Text(
                        context.l10n.targetLanguage,
                        style: TextStyle(
                          fontSize:
                              context.read<UserSettingsCubit>().getFontSize() +
                                  3,
                        ),
                      ),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  BlocBuilder<LanguagePickerCubit, LanguagePickerState>(
                    builder: (context, languagePickerState) {
                      if (languagePickerState is LanguagesSelected) {
                        final String targetLanguage =
                            languagePickerState.targetLanguage;
                        final String sourceLanguage =
                            languagePickerState.sourceLanguage;

                        return Expanded(
                          child: ListView.builder(
                            itemCount: languages.length - 1,
                            itemBuilder: (context, index) {
                              final Map<String, String> availableLanguages =
                                  getIt<LanguagePickerCubit>()
                                      .getAvailableLanguages(
                                isSelectingSourceLng: isSelectingSourceLng,
                                languages: languages,
                                targetLanguage: targetLanguage,
                                sourceLanguage: sourceLanguage,
                              );

                              return Column(
                                children: [
                                  BlocBuilder<VoiceRecordCubit,
                                      VoiceRecordState>(
                                    builder: (context, voiceRecordState) {
                                      if (voiceRecordState
                                          is VoiceRecordInitial) {
                                        return InkWell(
                                          onTap: () async {
                                            if (isSelectingSourceLng) {
                                              await context
                                                  .read<LanguagePickerCubit>()
                                                  .setSourceLanguage(
                                                      language:
                                                          availableLanguages
                                                              .keys
                                                              .map((e) => e)
                                                              .toList()[index]);
                                              if (!context.mounted) return;
                                              context
                                                  .read<VoiceRecordCubit>()
                                                  .setInitialState();
                                            } else {
                                              await context
                                                  .read<LanguagePickerCubit>()
                                                  .setTargetLanguage(
                                                      language:
                                                          availableLanguages
                                                              .keys
                                                              .map((e) => e)
                                                              .toList()[index]);
                                              if (!context.mounted) return;
                                              if (voiceRecordState.speechText !=
                                                      '' ||
                                                  voiceRecordState
                                                          .translation !=
                                                      '') {
                                                context
                                                    .read<VoiceRecordCubit>()
                                                    .updateSpeechText(
                                                      text: voiceRecordState
                                                          .speechText,
                                                      sourceLanguage:
                                                          sourceLanguage
                                                              .substring(0, 2),
                                                      targetLanguage:
                                                          availableLanguages
                                                              .values
                                                              .map((e) => e)
                                                              .toList()[index]
                                                              .substring(0, 2),
                                                      userSpeaking:
                                                          voiceRecordState
                                                              .userSpeaking,
                                                    );
                                              }
                                            }
                                            if (!context.mounted) return;
                                            Navigator.of(context).pop();
                                          },
                                          child: Row(
                                            children: [
                                              const SizedBox(width: 10),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: context
                                                          .read<
                                                              UserSettingsCubit>()
                                                          .getFontSize() *
                                                      0.8,
                                                  horizontal: 15,
                                                ),
                                                child:
                                                    CountryFlag.fromCountryCode(
                                                  availableLanguages.keys
                                                      .map((e) =>
                                                          e.substring(3, 5))
                                                      .toList()[index],
                                                  height: 30.7,
                                                  width: 39.7,
                                                  borderRadius: 8,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Flexible(
                                                child: Text(
                                                  style: TextStyle(
                                                    fontSize: context
                                                            .read<
                                                                UserSettingsCubit>()
                                                            .getFontSize() -
                                                        1,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  availableLanguages.values
                                                      .map((e) => e)
                                                      .toList()[index],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    thickness: 2,
                                    height: 1,
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
