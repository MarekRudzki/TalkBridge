part of 'language_picker_cubit.dart';

class LanguagePickerState extends Equatable {
  @override
  List<Object> get props => [];
}

class LanguagePickerInitial extends LanguagePickerState {}

class LanguagesSelected extends LanguagePickerState {
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
