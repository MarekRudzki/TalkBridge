import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkbridge/features/user_settings/presentation/cubits/user_settings/user_settings_cubit.dart';
import 'package:talkbridge/features/user_settings/presentation/widgets/auto_play.dart';
import 'package:talkbridge/features/user_settings/presentation/widgets/font_size.dart';
import 'package:talkbridge/features/user_settings/presentation/widgets/interface_language.dart';
import 'package:talkbridge/utils/l10n/localization.dart';

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 213, 210, 210),
        appBar: AppBar(
          title: BlocBuilder<UserSettingsCubit, UserSettingsState>(
            builder: (context, state) {
              if (state is UserSettingsInitial) {
                return Text(
                  context.l10n.settings,
                  style: TextStyle(
                    fontSize:
                        context.read<UserSettingsCubit>().getFontSize() + 3,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          backgroundColor: const Color.fromARGB(255, 75, 207, 143),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: BlocBuilder<UserSettingsCubit, UserSettingsState>(
            builder: (context, state) {
              if (state is UserSettingsInitial) {
                return Column(
                  children: [
                    FontSize(fontSize: state.fontSize),
                    AutoPlay(
                      isAutoPlay: state.isAutoPlay,
                    ),
                    InterfaceLanguage(
                      interfaceLanguage: state.interfaceLanguage,
                      fontSize: state.fontSize,
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
