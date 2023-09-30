import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkbridge/features/user_settings/presentation/cubits/user_settings/user_settings_cubit.dart';
import 'package:talkbridge/features/user_settings/presentation/widgets/auto_play.dart';
import 'package:talkbridge/features/user_settings/presentation/widgets/font_size.dart';
import 'package:talkbridge/features/user_settings/presentation/widgets/interface_language.dart';

class UserSettingsScreen extends StatelessWidget {
  const UserSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 213, 210, 210),
        appBar: AppBar(
          title: const Text(
            'Settings',
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
                    AutoPlay(isAutoPlay: state.isAutoPlay),
                    InterfaceLanguage(
                        interfaceLanguage: state.interfaceLanguage),
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
