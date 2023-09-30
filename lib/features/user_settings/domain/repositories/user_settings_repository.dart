import 'package:talkbridge/constants/enums.dart';
import 'package:talkbridge/features/user_settings/data/datasources/user_settings_local_data_source.dart';
import 'package:talkbridge/features/user_settings/data/models/user_settings_model.dart';

class UserSettingsRepository {
  final UserSettingsLocalDataSource _dataSource;

  UserSettingsRepository({required UserSettingsLocalDataSource dataSource})
      : _dataSource = dataSource;

  Future<void> setAutoPlay({
    required bool isAutoPlay,
  }) async {
    await _dataSource.setAutoPlay(isAutoPlay: isAutoPlay);
  }

  Future<void> setFontSize({
    required SelectedFontSize selectedFontSize,
  }) async {
    final String fontSize;
    if (selectedFontSize == SelectedFontSize.small) {
      fontSize = 'small';
    } else if (selectedFontSize == SelectedFontSize.medium) {
      fontSize = 'medium';
    } else {
      fontSize = 'large';
    }
    await _dataSource.setFontSize(fontSize: fontSize);
  }

  Future<void> setInterfaceLanguage({
    required SelectedInterfaceLanguage selectedInterfaceLanguage,
  }) async {
    final String interfaceLanguage;
    if (selectedInterfaceLanguage == SelectedInterfaceLanguage.english) {
      interfaceLanguage = 'english';
    } else {
      interfaceLanguage = 'polish';
    }
    await _dataSource.setInterfaceLanguage(
        interfaceLanguage: interfaceLanguage);
  }

  Future<UserSettingsModel> getUserSettings() async {
    final bool isAutoPlay = await _dataSource.getAutoPlay();
    final SelectedFontSize fontSize;
    final savedFontSize = await _dataSource.getFontSize();
    final savedInterfaceLanguage = await _dataSource.getInterfaceLanguage();

    if (savedFontSize == 'small') {
      fontSize = SelectedFontSize.small;
    } else if (savedFontSize == 'medium') {
      fontSize = SelectedFontSize.medium;
    } else {
      fontSize = SelectedFontSize.large;
    }

    return UserSettingsModel(
      isAutoPlay: isAutoPlay,
      fontSize: fontSize,
      interfaceLanguage: savedInterfaceLanguage == 'english'
          ? SelectedInterfaceLanguage.english
          : SelectedInterfaceLanguage.polish,
    );
  }
}
