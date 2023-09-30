import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talkbridge/features/home_screen/home_screen.dart';
import 'package:talkbridge/features/language_picker/data/datasources/language_picker_local_data_source.dart';
import 'package:talkbridge/features/language_picker/domain/repositories/language_picker_repository.dart';
import 'package:talkbridge/features/language_picker/presentation/cubit/language_picker/language_picker_cubit.dart';
import 'package:talkbridge/features/user_settings/data/datasources/user_settings_local_data_source.dart';
import 'package:talkbridge/features/user_settings/domain/repositories/user_settings_repository.dart';
import 'package:talkbridge/features/user_settings/presentation/cubits/user_settings/user_settings_cubit.dart';

import 'package:talkbridge/features/voice_record/presentation/cubits/voice_record/voice_record_cubit.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('language_box');
  await Hive.openBox('user_settings');

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (_) => runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LanguagePickerCubit(
              LanguagePickerRepository(
                languagePickerLocalDataSource: LanguagePickerLocalDataSource(),
              ),
            )..setSavedLanguages(),
          ),
          BlocProvider(
            create: (context) => VoiceRecordCubit(),
          ),
          BlocProvider(
            create: (context) => UserSettingsCubit(
              userSettingsRepository: UserSettingsRepository(
                dataSource: UserSettingsLocalDataSource(),
              ),
            )..getUserSettings(),
          )
        ],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TalkBridge',
          home: HomeScreen(),
        ),
      ),
    ),
  );
}
