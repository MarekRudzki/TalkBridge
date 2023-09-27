import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkbridge/features/home_screen/presentation/cubits/language/language_cubit.dart';

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
      'Mandarin (Chinese)': 'zh-CN',
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
            Expanded(
              child: ListView.builder(
                itemCount: langauges.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () async {
                          if (isSelectingSourceLng) {
                            await context
                                .read<LanguageCubit>()
                                .setSourceLanguage(
                                    language: langauges.values
                                        .map((e) => e)
                                        .toList()[index]);
                          } else {
                            await context
                                .read<LanguageCubit>()
                                .setTargetLanguage(
                                    language: langauges.values
                                        .map((e) => e)
                                        .toList()[index]);
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
                                langauges.values
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
                              langauges.keys.map((e) => e).toList()[index],
                            ),
                            const Spacer(),
                          ],
                        ),
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
            ),
          ],
        ),
      ),
    );
  }
}
