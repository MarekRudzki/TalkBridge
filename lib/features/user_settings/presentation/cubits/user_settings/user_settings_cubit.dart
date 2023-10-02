import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkbridge/constants/enums.dart';
import 'package:talkbridge/features/user_settings/data/models/user_settings_model.dart';
import 'package:talkbridge/features/user_settings/domain/repositories/user_settings_repository.dart';

part 'user_settings_state.dart';

class UserSettingsCubit extends Cubit<UserSettingsState> {
  final UserSettingsRepository userSettingsRepository;
  UserSettingsCubit({
    required this.userSettingsRepository,
  }) : super(
          const UserSettingsInitial(),
        );

  Future<void> setAutoPlay({
    required bool isAutoPlay,
  }) async {
    await userSettingsRepository.setAutoPlay(
      isAutoPlay: isAutoPlay,
    );
    emit((state as UserSettingsInitial).copyWith(
      isAutoPlay: isAutoPlay,
    ));
  }

  Future<void> setFontSize({
    required SelectedFontSize selectedFontSize,
  }) async {
    await userSettingsRepository.setFontSize(
      selectedFontSize: selectedFontSize,
    );
    emit((state as UserSettingsInitial).copyWith(
      fontSize: selectedFontSize,
    ));
  }

  Future<void> setInterfaceLanguage({
    required SelectedInterfaceLanguage selectedInterfaceLanguage,
  }) async {
    await userSettingsRepository.setInterfaceLanguage(
      selectedInterfaceLanguage: selectedInterfaceLanguage,
    );
    emit((state as UserSettingsInitial).copyWith(
      interfaceLanguage: selectedInterfaceLanguage,
    ));
  }

  Future<void> getUserSettings() async {
    final UserSettingsModel settings =
        await userSettingsRepository.getUserSettings();

    emit(
      UserSettingsInitial(
        isAutoPlay: settings.isAutoPlay,
        fontSize: settings.fontSize,
        interfaceLanguage: settings.interfaceLanguage,
      ),
    );
  }

  double getFontSize() {
    final userSettingsState = state as UserSettingsInitial;

    if (userSettingsState.fontSize == SelectedFontSize.small) {
      return 16;
    } else if (userSettingsState.fontSize == SelectedFontSize.medium) {
      return 19;
    } else {
      return 22;
    }
  }

  double getSliderValue() {
    final userSettingsState = state as UserSettingsInitial;

    if (userSettingsState.fontSize == SelectedFontSize.small) {
      return 0;
    } else if (userSettingsState.fontSize == SelectedFontSize.medium) {
      return 0.5;
    } else {
      return 1;
    }
  }
}
