// Package imports:
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LanguagePickerLocalDataSource {
  final _languageBox = Hive.box('language_box');

  Future<void> setSourceLanguage({required String language}) async {
    await _languageBox.put('source_language', language);
  }

  Future<void> setTargetLanguage({required String language}) async {
    await _languageBox.put('target_language', language);
  }

  Future<String> getSourceLanguage() async {
    if (!_languageBox.containsKey('source_language')) {
      await setSourceLanguage(language: 'pl_PL');
    }
    final String sourceLanguage = _languageBox.get('source_language') as String;
    return sourceLanguage;
  }

  Future<String> getTargetLanguage() async {
    if (!_languageBox.containsKey('target_language')) {
      await setTargetLanguage(language: 'en_GB');
    }
    final String targetLanguage = _languageBox.get('target_language') as String;
    return targetLanguage;
  }
}
