// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:country_flags/country_flags.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:talkbridge/constants/enums.dart';
import 'package:talkbridge/features/home_screen/presentation/widgets/captured_text.dart';
import 'package:talkbridge/features/home_screen/presentation/widgets/languages_reverse.dart';
import 'package:talkbridge/features/home_screen/presentation/widgets/text_to_speech.dart';
import 'package:talkbridge/features/language_picker/presentation/cubit/language_picker/language_picker_cubit.dart';
import 'package:talkbridge/features/language_picker/presentation/language_pick_screen.dart';
import 'package:talkbridge/features/user_settings/presentation/user_settings_screen.dart';
import 'package:talkbridge/features/voice_record/presentation/cubits/voice_record/voice_record_cubit.dart';
import 'package:talkbridge/features/voice_record/presentation/widgets/voice_recorder.dart';

class SplitScreen extends StatelessWidget {
  final User userScreen;
  const SplitScreen({
    super.key,
    required this.userScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Transform.rotate(
        angle: userScreen == User.host ? 0 : -math.pi,
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  height: double.infinity,
                  width: 10,
                  color: const Color.fromARGB(255, 213, 210, 210),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 10,
                          ),
                          child:
                              BlocBuilder<VoiceRecordCubit, VoiceRecordState>(
                            builder: (context, voiceRecordState) {
                              if (voiceRecordState is VoiceRecordLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (voiceRecordState is VoiceRecordInitial) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CapturedText(
                                      speechText: voiceRecordState.speechText,
                                      translation: voiceRecordState.translation,
                                      userSpeaking:
                                          voiceRecordState.userSpeaking,
                                      userScreenType: userScreen,
                                    ),
                                  ],
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                      ),
                      Container(
                        color: const Color.fromARGB(255, 213, 210, 210),
                        child: Row(
                          children: [
                            InkWell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                child: BlocBuilder<LanguagePickerCubit,
                                    LanguagePickerState>(
                                  builder: (context, state) {
                                    if (state is LanguagesSelected) {
                                      return CountryFlag.fromCountryCode(
                                        userScreen == User.host
                                            ? state.sourceLanguage
                                                .substring(3, 5)
                                            : state.targetLanguage
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
                                    builder: (context) =>
                                        const LanguagePickScreen(
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                child: BlocBuilder<LanguagePickerCubit,
                                    LanguagePickerState>(
                                  builder: (context, languagePickerState) {
                                    if (languagePickerState
                                        is LanguagesSelected) {
                                      return CountryFlag.fromCountryCode(
                                        userScreen == User.host
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
                                    builder: (context) =>
                                        const LanguagePickScreen(
                                      isSelectingSourceLng: false,
                                    ),
                                  ),
                                );
                              },
                            ),
                            if (userScreen == User.host)
                              const LanguagesReverse(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: double.infinity,
                  width: 50,
                  color: const Color.fromARGB(255, 213, 210, 210),
                  child: Column(
                    children: [
                      TextToSpeech(
                        userScreen: userScreen,
                        speechSpeed: 0.5,
                        iconWidget: const Icon(
                          Icons.record_voice_over_outlined,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                      TextToSpeech(
                        userScreen: userScreen,
                        speechSpeed: 0.25,
                        iconWidget: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Image.asset('assets/turtle.png', scale: 5),
                        ),
                      ),
                      if (userScreen == User.host)
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const UserSettingsScreen(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (userScreen == User.host)
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 15, 15),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: VoiceRecorder(
                    currentUser: User.host,
                  ),
                ),
              )
            else
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 15, 15),
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
