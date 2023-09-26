import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkbridge/features/home_screen/presentation/cubits/cubit/home_screen_cubit.dart';

class LanguagePickScreen extends StatelessWidget {
  final bool isSelectingSourceLng;
  const LanguagePickScreen({
    super.key,
    required this.isSelectingSourceLng,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> langauges = {
      'Arabic': 'EG',
      'Bulgarian': 'BG',
      'Mandarin (Chinese)': 'CN',
      'Croatian': 'HR',
      'Czech': 'CZ',
      'Danish': 'DK',
      'Dutch (Belgium)': 'BE',
      'Dutch (Netherlands)': 'NL',
      'English (Australia)': 'AU',
      'English (Canada)': 'CA',
      'English (India)': 'IN',
      'English (United Kingdom)': 'GB',
      'English (United States)': 'US',
      'Estonian': 'EE',
      'French': 'FR',
      'German': 'DE',
      'Greek': 'GR',
      'Italian': 'IT',
      'Latvian': 'LV',
      'Lithuanian': 'LT',
      'Polish': 'PL',
      'Portuguese': 'PT',
      'Romanian': 'RO',
      'Russian': 'RU',
      'Serbian': 'RS',
      'Slovak': 'SK',
      'Slovenian': 'SI',
      'Spanish': 'ES',
      'Turkish': 'TR'
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
                                .read<HomeScreenCubit>()
                                .setSourceLanguage(
                                    language: langauges.values
                                        .map((e) => e)
                                        .toList()[index]);
                          } else {
                            await context
                                .read<HomeScreenCubit>()
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
                                langauges.values.map((e) => e).toList()[index],
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
