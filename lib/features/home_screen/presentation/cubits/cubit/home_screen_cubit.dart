import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkbridge/features/home_screen/domain/models/language_model.dart';
import 'package:talkbridge/features/home_screen/domain/repositories/language_repository.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  final LanguageRepository repository;
  HomeScreenCubit(this.repository) : super(HomeScreenInitial());

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
}
