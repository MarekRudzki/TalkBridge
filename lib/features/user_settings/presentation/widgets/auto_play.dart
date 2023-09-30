import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkbridge/features/user_settings/presentation/cubits/user_settings/user_settings_cubit.dart';

class AutoPlay extends StatelessWidget {
  final bool isAutoPlay;

  const AutoPlay({
    super.key,
    required this.isAutoPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          const Text(
            'Auto play',
          ),
          const Spacer(),
          Switch(
            activeColor: const Color.fromARGB(255, 91, 234, 96),
            inactiveTrackColor: Colors.grey,
            value: isAutoPlay,
            onChanged: (value) {
              context.read<UserSettingsCubit>().setAutoPlay(
                    isAutoPlay: value,
                  );
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
