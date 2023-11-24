// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:talkbridge/features/user_settings/presentation/cubits/user_settings/user_settings_cubit.dart';
import 'package:talkbridge/utils/l10n/localization.dart';

class NoNetwork extends StatelessWidget {
  const NoNetwork({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.grey.withOpacity(0.85),
      child: BlocBuilder<UserSettingsCubit, UserSettingsState>(
        builder: (context, state) {
          if (state is UserSettingsInitial) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.wifi_off_outlined,
                  color: Colors.white,
                  size: 60,
                ),
                const SizedBox(height: 40),
                Text(
                  context.l10n.noNetworkInfo,
                  style: TextStyle(
                    fontSize: context.read<UserSettingsCubit>().getFontSize(),
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    context.l10n.noNetworkMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: context.read<UserSettingsCubit>().getFontSize(),
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
