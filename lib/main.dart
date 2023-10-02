import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talkbridge/constants/enums.dart';
import 'package:talkbridge/features/home_screen/home_screen.dart';
import 'package:talkbridge/features/language_picker/data/datasources/language_picker_local_data_source.dart';
import 'package:talkbridge/features/language_picker/domain/repositories/language_picker_repository.dart';
import 'package:talkbridge/features/language_picker/presentation/cubit/language_picker/language_picker_cubit.dart';
import 'package:talkbridge/features/user_settings/data/datasources/user_settings_local_data_source.dart';
import 'package:talkbridge/features/user_settings/domain/repositories/user_settings_repository.dart';
import 'package:talkbridge/features/user_settings/presentation/cubits/user_settings/user_settings_cubit.dart';

import 'package:talkbridge/features/voice_record/presentation/cubits/voice_record/voice_record_cubit.dart';
import 'package:talkbridge/utils/l10n/translations/translation.dart';

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
        child: BlocBuilder<UserSettingsCubit, UserSettingsState>(
          builder: (context, state) {
            return MaterialApp(
              localizationsDelegates: const [
                TextTranslations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate
              ],
              locale: (state as UserSettingsInitial).interfaceLanguage ==
                      SelectedInterfaceLanguage.english
                  ? const Locale('en', 'EN')
                  : const Locale('pl', 'PL'),
              supportedLocales: const [
                Locale('en', ''),
                Locale('pl', ''),
              ],
              debugShowCheckedModeBanner: false,
              title: 'TalkBridge',
              home: const HomeScreen(),
            );
          },
        ),
      ),
    ),
  );
}
