import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkbridge/constants/enums.dart';
import 'package:talkbridge/features/user_settings/presentation/cubits/user_settings/user_settings_cubit.dart';

class FontSize extends StatelessWidget {
  final SelectedFontSize fontSize;

  const FontSize({
    super.key,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final double sliderFontValue;
    if (fontSize == SelectedFontSize.small) {
      sliderFontValue = 0;
    } else if (fontSize == SelectedFontSize.medium) {
      sliderFontValue = 0.5;
    } else {
      sliderFontValue = 1;
    }
    return Row(
      children: [
        const Text(
          'Font size',
        ),
        const Spacer(),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 12,
            inactiveTrackColor: Colors.grey,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
          ),
          child: Slider(
            thumbColor: const Color.fromARGB(255, 91, 234, 96),
            activeColor: const Color.fromARGB(255, 91, 234, 96),
            divisions: 2,
            value: sliderFontValue,
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
        const Spacer(),
      ],
    );
  }
}
