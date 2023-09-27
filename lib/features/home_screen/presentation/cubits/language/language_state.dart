part of 'language_cubit.dart';

class LanguageState extends Equatable {
  @override
  List<Object> get props => [];
}

class LanguageInitial extends LanguageState {}

class LanguagesSelected extends LanguageState {
  final String sourceLanguage;
  final String targetLanguage;

  LanguagesSelected({
    required this.sourceLanguage,
    required this.targetLanguage,
  });

  @override
  List<Object> get props => [
        sourceLanguage,
        targetLanguage,
      ];
}
