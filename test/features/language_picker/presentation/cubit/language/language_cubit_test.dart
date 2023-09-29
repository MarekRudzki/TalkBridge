import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talkbridge/features/language_picker/domain/models/language_model.dart';
import 'package:talkbridge/features/language_picker/domain/repositories/language_picker_repository.dart';
import 'package:talkbridge/features/language_picker/presentation/cubit/language_picker/language_picker_cubit.dart';

class MockLanguageRepository extends Mock implements LanguagePickerRepository {}

void main() {
  late LanguagePickerCubit homeScreenCubit;
  late LanguagePickerRepository languageRepository;

  setUp(() {
    languageRepository = MockLanguageRepository();
    homeScreenCubit = LanguagePickerCubit(languageRepository);

    when(() => languageRepository.setSourceLanguage(
        language: any(named: 'language'))).thenAnswer((_) async {});
    when(() => languageRepository.setTargetLanguage(
        language: any(named: 'language'))).thenAnswer((_) async {});
    when(() => languageRepository.getSavedLanguages()).thenAnswer((_) async =>
        const LanguageModel(sourceLanguage: 'GR', targetLanguage: 'FR'));
  });

  group(
    'home screen',
    () {
      blocTest<LanguagePickerCubit, LanguagePickerState>(
        'emits [LanguageSelected] with correct values when setSourceLanguage is triggered.',
        build: () => homeScreenCubit,
        act: (cubit) => cubit.setSourceLanguage(language: 'GR'),
        expect: () =>
            [LanguagesSelected(sourceLanguage: 'GR', targetLanguage: 'FR')],
      );

      blocTest<LanguagePickerCubit, LanguagePickerState>(
        'emits [LanguageSelected] with correct values when setTargetLanguage is triggered.',
        build: () => homeScreenCubit,
        act: (cubit) => cubit.setTargetLanguage(language: 'FR'),
        expect: () =>
            [LanguagesSelected(sourceLanguage: 'GR', targetLanguage: 'FR')],
      );

      blocTest<LanguagePickerCubit, LanguagePickerState>(
        'emits [LanguagesSelected] with correct values when setSavedLanguages is triggered.',
        build: () => homeScreenCubit,
        act: (cubit) => cubit.setSavedLanguages(),
        expect: () =>
            [LanguagesSelected(sourceLanguage: 'GR', targetLanguage: 'FR')],
      );

      blocTest<LanguagePickerCubit, LanguagePickerState>(
        'emits [LanguagesSelected] with reversed values when reverseLanguages is triggered.',
        build: () => homeScreenCubit,
        act: (cubit) => cubit.reverseLanguages(),
        expect: () =>
            [LanguagesSelected(sourceLanguage: 'FR', targetLanguage: 'GR')],
      );
    },
  );
}
