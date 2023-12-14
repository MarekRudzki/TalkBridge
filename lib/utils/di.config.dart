// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../features/language_picker/data/datasources/language_picker_local_data_source.dart'
    as _i3;
import '../features/language_picker/domain/repositories/language_picker_repository.dart'
    as _i4;
import '../features/language_picker/presentation/cubit/language_picker/language_picker_cubit.dart'
    as _i8;
import '../features/user_settings/data/datasources/user_settings_local_data_source.dart'
    as _i5;
import '../features/user_settings/domain/repositories/user_settings_repository.dart'
    as _i6;
import '../features/user_settings/presentation/cubits/user_settings/user_settings_cubit.dart'
    as _i9;
import '../features/voice_record/presentation/cubits/voice_record/voice_record_cubit.dart'
    as _i7;

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
    gh.lazySingleton<_i3.LanguagePickerLocalDataSource>(
        () => _i3.LanguagePickerLocalDataSource());
    gh.lazySingleton<_i4.LanguagePickerRepository>(() =>
        _i4.LanguagePickerRepository(
            languagePickerLocalDataSource:
                gh<_i3.LanguagePickerLocalDataSource>()));
    gh.lazySingleton<_i5.UserSettingsLocalDataSource>(
        () => _i5.UserSettingsLocalDataSource());
    gh.lazySingleton<_i6.UserSettingsRepository>(() =>
        _i6.UserSettingsRepository(
            dataSource: gh<_i5.UserSettingsLocalDataSource>()));
    gh.factory<_i7.VoiceRecordCubit>(() => _i7.VoiceRecordCubit());
    gh.factory<_i8.LanguagePickerCubit>(
        () => _i8.LanguagePickerCubit(gh<_i4.LanguagePickerRepository>()));
    gh.factory<_i9.UserSettingsCubit>(() => _i9.UserSettingsCubit(
        userSettingsRepository: gh<_i6.UserSettingsRepository>()));
    return this;
  }
}
