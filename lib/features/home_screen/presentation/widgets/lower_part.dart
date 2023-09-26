import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkbridge/features/home_screen/presentation/cubits/cubit/home_screen_cubit.dart';
import 'package:talkbridge/features/home_screen/presentation/widgets/language_pick_screen.dart';

class LowerPart extends StatelessWidget {
  const LowerPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Column(
            children: [
              const Spacer(),
              Container(
                color: Colors.amber,
                child: Row(
                  children: [
                    const SizedBox(width: 15),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: BlocBuilder<HomeScreenCubit, HomeScreenState>(
                          builder: (context, state) {
                            if (state is LanguagesSelected) {
                              return CountryFlag.fromCountryCode(
                                state.sourceLanguage,
                                height: 31.2,
                                width: 40.3,
                                borderRadius: 8,
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
                        child: BlocBuilder<HomeScreenCubit, HomeScreenState>(
                          builder: (context, state) {
                            if (state is LanguagesSelected) {
                              return CountryFlag.fromCountryCode(
                                state.targetLanguage,
                                height: 31.2,
                                width: 40.3,
                                borderRadius: 8,
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    width: 8,
                    color: Colors.white,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () {},
                    child: const Icon(
                      size: 45,
                      color: Colors.white,
                      Icons.keyboard_voice_outlined,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
