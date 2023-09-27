import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talkbridge/features/home_screen/home_screen.dart';
import 'package:talkbridge/features/home_screen/data/datasources/language_local_data_source.dart';
import 'package:talkbridge/features/home_screen/domain/repositories/language_repository.dart';
import 'package:talkbridge/features/home_screen/presentation/cubits/language/language_cubit.dart';
import 'package:talkbridge/features/home_screen/presentation/cubits/voice_record/voice_record_cubit.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('language_box');

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (_) => runApp(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LanguageCubit(
              LanguageRepository(
                localDataSource: LanguageLocalDataSource(),
              ),
            )..setSavedLanguages(),
          ),
          BlocProvider(
            create: (context) => VoiceRecordCubit(),
          ),
        ],
        child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        ),
      ),
    ),
  );
}
