// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../features/home_screen/presentation/cubit/home_screen_cubit_cubit.dart'
    as _i3;
import '../features/language_picker/data/datasources/language_picker_local_data_source.dart'
    as _i4;
import '../features/language_picker/domain/repositories/language_picker_repository.dart'
    as _i5;
import '../features/language_picker/presentation/cubit/language_picker/language_picker_cubit.dart'
    as _i9;
import '../features/user_settings/data/datasources/user_settings_local_data_source.dart'
    as _i6;
import '../features/user_settings/domain/repositories/user_settings_repository.dart'
    as _i7;
import '../features/user_settings/presentation/cubits/user_settings/user_settings_cubit.dart'
    as _i10;
import '../features/voice_record/presentation/cubits/voice_record/voice_record_cubit.dart'
    as _i8;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i3.HomeScreenCubit>(() => _i3.HomeScreenCubit());
    gh.lazySingleton<_i4.LanguagePickerLocalDataSource>(
        () => _i4.LanguagePickerLocalDataSource());
    gh.lazySingleton<_i5.LanguagePickerRepository>(() =>
        _i5.LanguagePickerRepository(
            languagePickerLocalDataSource:
                gh<_i4.LanguagePickerLocalDataSource>()));
    gh.lazySingleton<_i6.UserSettingsLocalDataSource>(
        () => _i6.UserSettingsLocalDataSource());
    gh.lazySingleton<_i7.UserSettingsRepository>(() =>
        _i7.UserSettingsRepository(
            dataSource: gh<_i6.UserSettingsLocalDataSource>()));
    gh.factory<_i8.VoiceRecordCubit>(() => _i8.VoiceRecordCubit());
    gh.factory<_i9.LanguagePickerCubit>(
        () => _i9.LanguagePickerCubit(gh<_i5.LanguagePickerRepository>()));
    gh.factory<_i10.UserSettingsCubit>(() => _i10.UserSettingsCubit(
        userSettingsRepository: gh<_i7.UserSettingsRepository>()));
    return this;
  }
}
