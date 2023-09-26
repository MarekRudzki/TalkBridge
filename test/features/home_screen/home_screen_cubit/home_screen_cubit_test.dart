import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talkbridge/features/home_screen/domain/models/language_model.dart';
import 'package:talkbridge/features/home_screen/domain/repositories/language_repository.dart';
import 'package:talkbridge/features/home_screen/presentation/cubits/cubit/home_screen_cubit.dart';

class MockLanguageRepository extends Mock implements LanguageRepository {}

void main() {
  late HomeScreenCubit homeScreenCubit;
  late LanguageRepository languageRepository;

  setUp(() {
    languageRepository = MockLanguageRepository();
    homeScreenCubit = HomeScreenCubit(languageRepository);

    when(() => languageRepository.setSourceLanguage(
        language: any(named: 'language'))).thenAnswer((_) async {});
    when(() => languageRepository.setTargetLanguage(
        language: any(named: 'language'))).thenAnswer((_) async {});
    when(() => languageRepository.getSavedLanguages()).thenReturn(
        const LanguageModel(sourceLanguage: 'GR', targetLanguage: 'FR'));
  });

  group('home screen', () {
    blocTest<HomeScreenCubit, HomeScreenState>(
      'emits [LanguageSelected] with correct values when setSourceLanguage is triggered.',
      build: () {
        return homeScreenCubit;
      },
      act: (cubit) => cubit.setSourceLanguage(language: 'GR'),
      expect: () =>
          [LanguagesSelected(sourceLanguage: 'GR', targetLanguage: 'FR')],
    );

    blocTest<HomeScreenCubit, HomeScreenState>(
      'emits [LanguageSelected] with correct values when setTargetLanguage is triggered.',
      build: () {
        return homeScreenCubit;
      },
      act: (cubit) => cubit.setTargetLanguage(language: 'FR'),
      expect: () =>
          [LanguagesSelected(sourceLanguage: 'GR', targetLanguage: 'FR')],
    );

    blocTest<HomeScreenCubit, HomeScreenState>(
      'emits [LanguagesSelected] with correct values when setSavedLanguages is triggered.',
      build: () => homeScreenCubit,
      act: (cubit) => cubit.setSavedLanguages(),
      expect: () =>
          [LanguagesSelected(sourceLanguage: 'GR', targetLanguage: 'FR')],
    );

    blocTest<HomeScreenCubit, HomeScreenState>(
      'emits [LanguagesSelected] with reversed values when reverseLanguages is triggered.',
      build: () => homeScreenCubit,
      act: (cubit) => cubit.reverseLanguages(),
      expect: () =>
          [LanguagesSelected(sourceLanguage: 'FR', targetLanguage: 'GR')],
    );
  });
}
