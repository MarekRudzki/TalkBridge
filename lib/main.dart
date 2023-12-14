// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Project imports:
import 'package:talkbridge/constants/enums.dart';
import 'package:talkbridge/features/home_screen/home_screen.dart';
import 'package:talkbridge/features/language_picker/presentation/cubit/language_picker/language_picker_cubit.dart';
import 'package:talkbridge/features/user_settings/presentation/cubits/user_settings/user_settings_cubit.dart';
import 'package:talkbridge/features/voice_record/presentation/cubits/voice_record/voice_record_cubit.dart';
import 'package:talkbridge/utils/di.dart';
import 'package:talkbridge/utils/l10n/translations/translation.dart';

void main() async {
  configureDependencies();
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
            create: (context) =>
                getIt<LanguagePickerCubit>()..setSavedLanguages(),
          ),
          BlocProvider(
            create: (context) => getIt<VoiceRecordCubit>(),
          ),
          BlocProvider(
            create: (context) => getIt<UserSettingsCubit>()..getUserSettings(),
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
