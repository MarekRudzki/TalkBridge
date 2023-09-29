import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkbridge/features/language_picker/presentation/cubit/language_picker/language_picker_cubit.dart';
import 'package:talkbridge/features/voice_record/presentation/cubits/voice_record/voice_record_cubit.dart';

class LanguagePickScreen extends StatelessWidget {
  final bool isSelectingSourceLng;

  const LanguagePickScreen({
    super.key,
    required this.isSelectingSourceLng,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> langauges = {
      'Arabic': 'ar-EG',
      'Bulgarian': 'bg-BG',
      'Croatian': 'hr-HR',
      'Czech': 'cs-CZ',
      'Danish': 'da-DK',
      'Dutch (Belgium)': 'nl-BE',
      'Dutch (Netherlands)': 'nl-NL',
      'English (Australia)': 'en-AU',
      'English (Canada)': 'en-CA',
      'English (India)': 'en-IN',
      'English (United Kingdom)': 'en-GB',
      'English (United States)': 'en-US',
      'Estonian': 'et-EE',
      'French': 'fr-FR',
      'German': 'de-DE',
      'Greek': 'el-GR',
      'Italian': 'it-IT',
      'Latvian': 'lv-LV',
      'Lithuanian': 'lt-LT',
      'Polish': 'pl-PL',
      'Portuguese': 'pt-PT',
      'Romanian': 'ro-RO',
      'Russian': 'ru-RU',
      'Slovak': 'sk-SK',
      'Slovenian': 'sl-SI',
      'Spanish': 'es-ES',
      'Turkish': 'tr-TR'
    };

    List<String> availableLanguagesKeys = [];
    List<String> availableLanguagesValues = [];

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 213, 210, 210),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 75, 207, 143),
          title: isSelectingSourceLng
              ? const Text('Source language')
              : const Text('Target language'),
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
                          final ommitedMapEntry = langauges.entries.firstWhere(
                              (entry) => entry.value == targetLanguage);

                          availableLanguagesKeys = langauges.keys
                              .where((key) => key != ommitedMapEntry.key)
                              .toList();
                          availableLanguagesValues = langauges.values
                              .where((value) => value != ommitedMapEntry.value)
                              .toList();
                        } else {
                          final ommitedMapEntry = langauges.entries.firstWhere(
                              (entry) => entry.value == sourceLanguage);

                          availableLanguagesKeys = langauges.keys
                              .where((key) => key != ommitedMapEntry.key)
                              .toList();
                          availableLanguagesValues = langauges.values
                              .where((value) => value != ommitedMapEntry.value)
                              .toList();
                        }

                        return Column(
                          children: [
                            BlocBuilder<VoiceRecordCubit, VoiceRecordState>(
                              builder: (context, voiceRecordState) {
                                if (voiceRecordState is VoiceRecordInitial) {
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
                                        if (voiceRecordState.speechText != '' ||
                                            voiceRecordState.translation !=
                                                '') {
                                          context
                                              .read<VoiceRecordCubit>()
                                              .updateSpeechText(
                                                text:
                                                    voiceRecordState.speechText,
                                                sourceLanguage: sourceLanguage
                                                    .substring(0, 2),
                                                targetLanguage:
                                                    availableLanguagesValues
                                                        .map((e) => e)
                                                        .toList()[index]
                                                        .substring(0, 2),
                                                userSpeaking: voiceRecordState
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
                                          padding: const EdgeInsets.all(15),
                                          child: CountryFlag.fromCountryCode(
                                            availableLanguagesValues
                                                .map((e) => e.substring(3, 5))
                                                .toList()[index],
                                            height: 38.4,
                                            width: 49.6,
                                            borderRadius: 8,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          availableLanguagesKeys
                                              .map((e) => e)
                                              .toList()[index],
                                        ),
                                        const Spacer(),
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
      ),
    );
  }
}
