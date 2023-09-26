part of 'home_screen_cubit.dart';

class HomeScreenState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeScreenInitial extends HomeScreenState {}

class LanguagesSelected extends HomeScreenState {
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
