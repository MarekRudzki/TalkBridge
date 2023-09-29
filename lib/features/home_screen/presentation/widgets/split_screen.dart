import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkbridge/constants/enums.dart';
import 'package:talkbridge/features/home_screen/presentation/widgets/languages_reverse.dart';
import 'package:talkbridge/features/language_picker/presentation/cubit/language_picker/language_picker_cubit.dart';

import 'package:talkbridge/features/language_picker/presentation/widgets/language_pick_screen.dart';
import 'package:talkbridge/features/voice_record/presentation/cubits/voice_record/voice_record_cubit.dart';
import 'package:talkbridge/features/voice_record/presentation/widgets/voice_recorder.dart';
import 'dart:math' as math;

class SplitScreen extends StatelessWidget {
  final User user;
  const SplitScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    String displayText({
      required User userSpeaking,
      required String speechText,
      required String translation,
    }) {
      if (user == User.host) {
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

    return Expanded(
      child: Transform.rotate(
        angle: user == User.host ? 0 : -math.pi,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: BlocBuilder<VoiceRecordCubit, VoiceRecordState>(
                    builder: (context, voiceRecordState) {
                      if (voiceRecordState is VoiceRecordLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (voiceRecordState is VoiceRecordInitial) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 20,
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              displayText(
                                userSpeaking: voiceRecordState.userSpeaking,
                                speechText: voiceRecordState.speechText,
                                translation: voiceRecordState.translation,
                              ),
                              textAlign: TextAlign.center,
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
                          child: BlocBuilder<LanguagePickerCubit,
                              LanguagePickerState>(
                            builder: (context, state) {
                              if (state is LanguagesSelected) {
                                return CountryFlag.fromCountryCode(
                                  user == User.host
                                      ? state.sourceLanguage.substring(3, 5)
                                      : state.targetLanguage.substring(3, 5),
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
                          child: BlocBuilder<LanguagePickerCubit,
                              LanguagePickerState>(
                            builder: (context, languagePickerState) {
                              if (languagePickerState is LanguagesSelected) {
                                return CountryFlag.fromCountryCode(
                                  user == User.host
                                      ? languagePickerState.targetLanguage
                                          .substring(3, 5)
                                      : languagePickerState.sourceLanguage
                                          .substring(3, 5),
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
                                isSelectingSourceLng: false,
                              ),
                            ),
                          );
                        },
                      ),
                      if (user == User.host) const LanguagesReverse(),
                      const Spacer(),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.bottomRight,
                child: VoiceRecorder(
                  currentUser: user,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
