import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkbridge/constants/enums.dart';
import 'package:talkbridge/features/user_settings/presentation/cubits/user_settings/user_settings_cubit.dart';
import 'package:talkbridge/utils/l10n/localization.dart';

class FontSize extends StatelessWidget {
  final SelectedFontSize fontSize;

  const FontSize({
    super.key,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Text(
            context.l10n.fontSize,
            style: TextStyle(
              fontSize: context.read<UserSettingsCubit>().getFontSize(),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 12,
              inactiveTrackColor: Colors.grey,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
            ),
            child: Slider(
              thumbColor: const Color.fromARGB(255, 91, 234, 96),
              activeColor: const Color.fromARGB(255, 91, 234, 96),
              divisions: 2,
              value: context.read<UserSettingsCubit>().getSliderValue(),
              onChanged: (value) {
                final SelectedFontSize selectedFontSize;
                if (value == 0) {
                  selectedFontSize = SelectedFontSize.small;
                } else if (value == 0.5) {
                  selectedFontSize = SelectedFontSize.medium;
                } else {
                  selectedFontSize = SelectedFontSize.large;
                }

                context.read<UserSettingsCubit>().setFontSize(
                      selectedFontSize: selectedFontSize,
                    );
              },
            ),
          ),
        ),
      ],
    );
  }
}
