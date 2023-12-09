// Package imports:
import 'package:hive/hive.dart';

class UserSettingsLocalDataSource {
  final _userSettings = Hive.box('user_settings');

  Future<void> setAutoPlay({
    required bool isAutoPlay,
  }) async {
    await _userSettings.put('is_auto_play', isAutoPlay);
  }

  Future<void> setFontSize({
    required String fontSize,
  }) async {
    await _userSettings.put('font_size', fontSize);
  }

  Future<void> setInterfaceLanguage({
    required String interfaceLanguage,
  }) async {
    await _userSettings.put('interface_language', interfaceLanguage);
  }

  Future<bool> getAutoPlay() async {
    if (!_userSettings.containsKey('is_auto_play')) {
      await setAutoPlay(isAutoPlay: true);
      return true;
    } else {
      return _userSettings.get('is_auto_play') as bool;
    }
  }

  Future<String> getFontSize() async {
    if (!_userSettings.containsKey('font_size')) {
      await setFontSize(fontSize: 'medium');
      return 'medium';
    } else {
      return _userSettings.get('font_size') as String;
    }
  }

  Future<String> getInterfaceLanguage() async {
    if (!_userSettings.containsKey('interface_language')) {
      await setInterfaceLanguage(interfaceLanguage: 'english');
      return 'english';
    } else {
      return _userSettings.get('interface_language') as String;
    }
  }
}
