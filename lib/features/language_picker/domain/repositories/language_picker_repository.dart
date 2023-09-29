import 'package:talkbridge/features/language_picker/data/datasources/language_picker_local_data_source.dart';
import 'package:talkbridge/features/language_picker/domain/models/language_model.dart';

class LanguagePickerRepository {
  final LanguagePickerLocalDataSource languagePickerLocalDataSource;

  LanguagePickerRepository({required this.languagePickerLocalDataSource});

  Future<LanguageModel> getSavedLanguages() async {
    final String sourceLanguage =
        await languagePickerLocalDataSource.getSourceLanguage();
    final String targetLanguage =
        await languagePickerLocalDataSource.getTargetLanguage();
    return LanguageModel(
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );
  }

  Future<void> setSourceLanguage({required String language}) async {
    await languagePickerLocalDataSource.setSourceLanguage(language: language);
  }

  Future<void> setTargetLanguage({required String language}) async {
    await languagePickerLocalDataSource.setTargetLanguage(language: language);
  }
}
