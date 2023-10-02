import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkbridge/constants/enums.dart';
import 'package:talkbridge/features/user_settings/presentation/cubits/user_settings/user_settings_cubit.dart';
import 'package:talkbridge/utils/l10n/localization.dart';

class InterfaceLanguage extends StatelessWidget {
  final SelectedInterfaceLanguage interfaceLanguage;
  final SelectedFontSize fontSize;

  const InterfaceLanguage({
    super.key,
    required this.interfaceLanguage,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Text(
            context.l10n.interfaceLanguage,
            style: TextStyle(
              fontSize: context.read<UserSettingsCubit>().getFontSize(),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: Column(
                  children: [
                    CountryFlag.fromCountryCode(
                      'GB',
                      height: 30.7,
                      width: 39.7,
                      borderRadius: 8,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                          color: interfaceLanguage ==
                                  SelectedInterfaceLanguage.english
                              ? const Color.fromARGB(255, 91, 234, 96)
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ],
                ),
                onTap: () {
                  context.read<UserSettingsCubit>().setInterfaceLanguage(
                        selectedInterfaceLanguage:
                            SelectedInterfaceLanguage.english,
                      );
                },
              ),
              const SizedBox(width: 20),
              InkWell(
                child: Column(
                  children: [
                    CountryFlag.fromCountryCode(
                      'PL',
                      height: 30.7,
                      width: 39.7,
                      borderRadius: 8,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 12,
                      width: 12,
                      decoration: BoxDecoration(
                          color: interfaceLanguage ==
                                  SelectedInterfaceLanguage.polish
                              ? const Color.fromARGB(255, 91, 234, 96)
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ],
                ),
                onTap: () {
                  context.read<UserSettingsCubit>().setInterfaceLanguage(
                        selectedInterfaceLanguage:
                            SelectedInterfaceLanguage.polish,
                      );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
