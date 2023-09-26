import 'package:talkbridge/features/home_screen/data/datasources/language_local_data_source.dart';
import 'package:talkbridge/features/home_screen/domain/models/language_model.dart';

class LanguageRepository {
  final LanguageLocalDataSource localDataSource;

  LanguageRepository({required this.localDataSource});

  LanguageModel getSavedLanguages() {
    return LanguageModel(
      sourceLanguage: localDataSource.getSourceLanguage(),
      targetLanguage: localDataSource.getTargetLanguage(),
    );
  }

  Future<void> setSourceLanguage({required String language}) async {
    await localDataSource.setSourceLanguage(language: language);
  }

  Future<void> setTargetLanguage({required String language}) async {
    await localDataSource.setTargetLanguage(language: language);
  }
}
