import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkbridge/features/language_picker/domain/models/language_model.dart';
import 'package:talkbridge/features/language_picker/domain/repositories/language_picker_repository.dart';

part 'language_picker_state.dart';

class LanguagePickerCubit extends Cubit<LanguagePickerState> {
  final LanguagePickerRepository repository;
  LanguagePickerCubit(this.repository) : super(LanguagePickerInitial());

  Future<void> setSourceLanguage({required String language}) async {
    final LanguageModel languageModel = await repository.getSavedLanguages();
    await repository.setSourceLanguage(language: language);
    emit(
      LanguagesSelected(
        sourceLanguage: language,
        targetLanguage: languageModel.targetLanguage,
      ),
    );
  }

  Future<void> setTargetLanguage({required String language}) async {
    final LanguageModel languageModel = await repository.getSavedLanguages();
    await repository.setTargetLanguage(language: language);
    emit(
      LanguagesSelected(
        targetLanguage: language,
        sourceLanguage: languageModel.sourceLanguage,
      ),
    );
  }

  Future<void> setSavedLanguages() async {
    final LanguageModel languageModel = await repository.getSavedLanguages();
    setSourceLanguage(language: languageModel.sourceLanguage);
    setTargetLanguage(language: languageModel.targetLanguage);
  }

  Future<void> reverseLanguages() async {
    final LanguageModel languageModel = await repository.getSavedLanguages();

    await repository.setTargetLanguage(language: languageModel.sourceLanguage);
    await repository.setSourceLanguage(language: languageModel.targetLanguage);
    emit(
      LanguagesSelected(
        sourceLanguage: languageModel.targetLanguage,
        targetLanguage: languageModel.sourceLanguage,
      ),
    );
  }
}
