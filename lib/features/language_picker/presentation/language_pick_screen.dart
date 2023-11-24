// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:country_flags/country_flags.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:talkbridge/features/language_picker/presentation/cubit/language_picker/language_picker_cubit.dart';
import 'package:talkbridge/features/user_settings/presentation/cubits/user_settings/user_settings_cubit.dart';
import 'package:talkbridge/features/voice_record/presentation/cubits/voice_record/voice_record_cubit.dart';
import 'package:talkbridge/utils/l10n/localization.dart';

class LanguagePickScreen extends StatelessWidget {
  final bool isSelectingSourceLng;

  const LanguagePickScreen({
    super.key,
    required this.isSelectingSourceLng,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> langauges = {
      context.l10n.lngArabic: 'ar-EG',
      context.l10n.lngBulgarian: 'bg-BG',
      context.l10n.lngCroatian: 'hr-HR',
      context.l10n.lngCzech: 'cs-CZ',
      context.l10n.lngDanish: 'da-DK',
      context.l10n.lngDutchBelgium: 'nl-BE',
      context.l10n.lngDutchNetherlands: 'nl-NL',
      context.l10n.lngEnglishAustralia: 'en-AU',
      context.l10n.lngEnglishCanada: 'en-CA',
      context.l10n.lngEnglishIndia: 'en-IN',
      context.l10n.lngEnglishUK: 'en-GB',
      context.l10n.lngEnglishUS: 'en-US',
      context.l10n.lngEstonian: 'et-EE',
      context.l10n.lngFrench: 'fr-FR',
      context.l10n.lngGerman: 'de-DE',
      context.l10n.lngGreek: 'el-GR',
      context.l10n.lngItalian: 'it-IT',
      context.l10n.lngLatvian: 'lv-LV',
      context.l10n.lngLithuanian: 'lt-LT',
      context.l10n.lngPolish: 'pl-PL',
      context.l10n.lngPortuguese: 'pt-PT',
      context.l10n.lngRomanian: 'ro-RO',
      context.l10n.lngRussian: 'ru-RU',
      context.l10n.lngSlovak: 'sk-SK',
      context.l10n.lngSlovenian: 'sl-SI',
      context.l10n.lngSpanish: 'es-ES',
      context.l10n.lngTurkish: 'tr-TR',
      context.l10n.lngUkrainian: 'uk-UA'
    };

    List<String> availableLanguagesKeys = [];
    List<String> availableLanguagesValues = [];

    return SafeArea(
      child: BlocBuilder<UserSettingsCubit, UserSettingsState>(
        builder: (context, userSettingsState) {
          if (userSettingsState is UserSettingsInitial) {
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
                    builder: (context, state) {
                      if (state is LanguagesSelected) {
                        final String targetLanguage = state.targetLanguage;
                        final String sourceLanguage = state.sourceLanguage;

                        return Expanded(
                          child: ListView.builder(
                            itemCount: langauges.length - 1,
                            itemBuilder: (context, index) {
                              // If user chose given language as source language it should not be available as target
                              // The same applies in reverse
                              if (isSelectingSourceLng) {
                                final ommitedMapEntry = langauges.entries
                                    .firstWhere((entry) =>
                                        entry.value == targetLanguage);

                                availableLanguagesKeys = langauges.keys
                                    .where((key) => key != ommitedMapEntry.key)
                                    .toList();
                                availableLanguagesValues = langauges.values
                                    .where((value) =>
                                        value != ommitedMapEntry.value)
                                    .toList();
                              } else {
                                final ommitedMapEntry = langauges.entries
                                    .firstWhere((entry) =>
                                        entry.value == sourceLanguage);

                                availableLanguagesKeys = langauges.keys
                                    .where((key) => key != ommitedMapEntry.key)
                                    .toList();
                                availableLanguagesValues = langauges.values
                                    .where((value) =>
                                        value != ommitedMapEntry.value)
                                    .toList();
                              }

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
                                                          availableLanguagesValues
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
                                                          availableLanguagesValues
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
                                                          availableLanguagesValues
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
                                                  availableLanguagesValues
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
                                                  availableLanguagesKeys
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
