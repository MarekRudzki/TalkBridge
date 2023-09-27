import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkbridge/features/home_screen/domain/models/language_model.dart';
import 'package:talkbridge/features/home_screen/domain/repositories/language_repository.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  final LanguageRepository repository;
  LanguageCubit(this.repository) : super(LanguageInitial());

  Future<void> setSourceLanguage({required String language}) async {
    await repository.setSourceLanguage(language: language);
    emit(LanguagesSelected(
        sourceLanguage: language,
        targetLanguage: repository.getSavedLanguages().targetLanguage));
  }

  Future<void> setTargetLanguage({required String language}) async {
    await repository.setTargetLanguage(language: language);
    emit(LanguagesSelected(
        targetLanguage: language,
        sourceLanguage: repository.getSavedLanguages().sourceLanguage));
  }

  void setSavedLanguages() {
    LanguageModel languageModel = repository.getSavedLanguages();
    setSourceLanguage(language: languageModel.sourceLanguage);
    setTargetLanguage(language: languageModel.targetLanguage);
  }

  Future<void> reverseLanguages() async {
    final sourceLanguage = repository.getSavedLanguages().sourceLanguage;
    final targetLanguage = repository.getSavedLanguages().targetLanguage;

    await repository.setTargetLanguage(language: sourceLanguage);
    await repository.setSourceLanguage(language: targetLanguage);
    emit(LanguagesSelected(
        sourceLanguage: targetLanguage, targetLanguage: sourceLanguage));
  }
}
