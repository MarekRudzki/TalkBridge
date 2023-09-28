import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkbridge/constants/enums.dart';
import 'package:talkbridge/features/home_screen/presentation/cubits/language/language_cubit.dart';
import 'package:talkbridge/features/home_screen/presentation/cubits/voice_record/voice_record_cubit.dart';
import 'dart:math' as math;

import 'package:talkbridge/features/home_screen/presentation/widgets/language_pick_screen.dart';
import 'package:talkbridge/features/home_screen/presentation/widgets/voice_recorder.dart';

class UpperPart extends StatelessWidget {
  const UpperPart({super.key});

  @override
  Widget build(BuildContext context) {
    String displayText({
      required User userSpeaking,
      required String speechText,
      required String translation,
    }) {
      if (userSpeaking == User.guest) {
        return speechText == '' ? '' : speechText;
      } else {
        return translation == '' ? '' : translation;
      }
    }

    return Expanded(
      child: Transform.rotate(
        angle: -math.pi,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: BlocBuilder<VoiceRecordCubit, VoiceRecordState>(
                    builder: (context, state) {
                      if (state is VoiceRecordLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is VoiceRecordInitial) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 20,
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              displayText(
                                userSpeaking: state.userSpeaking,
                                speechText: state.speechText,
                                translation: state.translation,
                              ),
                              style: const TextStyle(
                                fontSize: 18,
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
                                  isSelectingSourceLng: false),
                            ),
                          );
                        },
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
                child: VoiceRecorder(
                  currentUser: User.guest,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
