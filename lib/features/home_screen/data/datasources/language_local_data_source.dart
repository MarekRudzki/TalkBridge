import 'package:hive/hive.dart';

class LanguageLocalDataSource {
  final _languageBox = Hive.box('language_box');

  Future<void> setSourceLanguage({required String language}) async {
    await _languageBox.put('source_language', language);
  }

  Future<void> setTargetLanguage({required String language}) async {
    await _languageBox.put('target_language', language);
  }

  String getSourceLanguage() {
    if (!_languageBox.containsKey('source_language')) {
      setSourceLanguage(language: 'pl-PL');
    }
    final String sourceLanguage = _languageBox.get('source_language');
    return sourceLanguage;
  }

  String getTargetLanguage() {
    if (!_languageBox.containsKey('target_language')) {
      setTargetLanguage(language: 'en-GB');
    }
    final String targetLanguage = _languageBox.get('target_language');
    return targetLanguage;
  }
}
