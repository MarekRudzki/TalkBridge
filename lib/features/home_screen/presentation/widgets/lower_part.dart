import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkbridge/features/home_screen/presentation/cubits/language/language_cubit.dart';
import 'package:talkbridge/features/home_screen/presentation/cubits/voice_record/voice_record_cubit.dart';
import 'package:talkbridge/features/home_screen/presentation/widgets/language_pick_screen.dart';
import 'package:talkbridge/features/home_screen/presentation/widgets/voice_recorder.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class LowerPart extends StatelessWidget {
  const LowerPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: BlocBuilder<VoiceRecordCubit, VoiceRecordState>(
                  builder: (context, state) {
                    if (state is VoiceRecordInitial) {
                      return Padding(
                        padding: const EdgeInsets.all(14),
                        child: SingleChildScrollView(
                          child: Text(
                            state.speechText == ''
                                ? state.speechText
                                : state.speechText.capitalize(),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              Container(
                color: const Color.fromARGB(255, 213, 210, 210),
                child: Row(
                  children: [
                    const SizedBox(width: 15),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: BlocBuilder<LanguageCubit, LanguageState>(
                          builder: (context, state) {
                            if (state is LanguagesSelected) {
                              return CountryFlag.fromCountryCode(
                                state.sourceLanguage.substring(3, 5),
                                height: 31.2,
                                width: 40.3,
                                borderRadius: 6,
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LanguagePickScreen(
                                isSelectingSourceLng: true),
                          ),
                        );
                      },
                    ),
                    const Icon(
                      Icons.arrow_right_alt,
                      color: Colors.white,
                      size: 50,
                    ),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: BlocBuilder<LanguageCubit, LanguageState>(
                          builder: (context, state) {
                            if (state is LanguagesSelected) {
                              return CountryFlag.fromCountryCode(
                                state.targetLanguage.substring(3, 5),
                                height: 31.2,
                                width: 40.3,
                                borderRadius: 6,
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LanguagePickScreen(
                                isSelectingSourceLng: false),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      onPressed: () async {
                        await context.read<LanguageCubit>().reverseLanguages();
                      },
                      icon: const Icon(
                        Icons.cached,
                        color: Colors.white,
                        size: 33,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.bottomRight,
              child: VoiceRecorder(), //TODO change at upper
            ),
          ),
        ],
      ),
    );
  }
}
