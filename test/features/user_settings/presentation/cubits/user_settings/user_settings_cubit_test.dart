import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talkbridge/constants/enums.dart';
import 'package:talkbridge/features/user_settings/data/models/user_settings_model.dart';
import 'package:talkbridge/features/user_settings/domain/repositories/user_settings_repository.dart';
import 'package:talkbridge/features/user_settings/presentation/cubits/user_settings/user_settings_cubit.dart';

class MockUserSettingsRepository extends Mock
    implements UserSettingsRepository {}

void main() {
  late UserSettingsCubit userSettingsCubit;
  late UserSettingsRepository userSettingsRepository;

  setUp(
    () {
      userSettingsRepository = MockUserSettingsRepository();
      userSettingsCubit = UserSettingsCubit(
        userSettingsRepository: userSettingsRepository,
      );

      when(() => userSettingsRepository.setAutoPlay(
          isAutoPlay: any(named: 'isAutoPlay'))).thenAnswer((_) async {});
      when(() => userSettingsRepository.setFontSize(
          selectedFontSize: SelectedFontSize.large)).thenAnswer((_) async {});
      when(() => userSettingsRepository.setInterfaceLanguage(
              selectedInterfaceLanguage: SelectedInterfaceLanguage.polish))
          .thenAnswer((_) async {});
      when(() => userSettingsRepository.getUserSettings())
          .thenAnswer((_) async => UserSettingsModel(
                isAutoPlay: true,
                fontSize: SelectedFontSize.large,
                interfaceLanguage: SelectedInterfaceLanguage.polish,
              ));
    },
  );

  group(
    'User settings cubit',
    () {
      blocTest<UserSettingsCubit, UserSettingsState>(
        'emits [UserSettingsInitial] with correct isAutoPlay value when setAutoPlay is triggered.',
        build: () => userSettingsCubit,
        act: (cubit) => cubit.setAutoPlay(isAutoPlay: false),
        expect: () => [
          const UserSettingsInitial(isAutoPlay: false),
        ],
      );

      blocTest<UserSettingsCubit, UserSettingsState>(
        'emits [UserSettingsInitial] with correct fontSize value when setFontSize is triggered.',
        build: () => userSettingsCubit,
        act: (cubit) =>
            cubit.setFontSize(selectedFontSize: SelectedFontSize.large),
        expect: () => [
          const UserSettingsInitial(fontSize: SelectedFontSize.large),
        ],
      );

      blocTest<UserSettingsCubit, UserSettingsState>(
        'emits [UserSettingsInitial] with correct interfaceLanguage value when setInterfaceLanguage is triggered.',
        build: () => userSettingsCubit,
        act: (cubit) => cubit.setInterfaceLanguage(
          selectedInterfaceLanguage: SelectedInterfaceLanguage.polish,
        ),
        expect: () => [
          const UserSettingsInitial(
              interfaceLanguage: SelectedInterfaceLanguage.polish),
        ],
      );

      blocTest<UserSettingsCubit, UserSettingsState>(
        'emits [UserSettingsInitial] with correct data when getUserSettings is triggered.',
        build: () => userSettingsCubit,
        act: (cubit) => cubit.getUserSettings(),
        expect: () => [
          const UserSettingsInitial(
            isAutoPlay: true,
            fontSize: SelectedFontSize.large,
            interfaceLanguage: SelectedInterfaceLanguage.polish,
          ),
        ],
      );
    },
  );
}
