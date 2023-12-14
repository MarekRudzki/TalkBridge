import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:talkbridge/constants/enums.dart';
import 'package:talkbridge/features/voice_record/presentation/cubits/voice_record/voice_record_cubit.dart';
import 'package:translator_plus/translator_plus.dart';

part 'home_screen_cubit_state.dart';

@injectable
class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit() : super(HomeScreenInitial());

  String getTextToSpeak({
    required VoiceRecordInitial voiceRecordState,
    required User userScreen,
  }) {
    final User userSpeaking = voiceRecordState.userSpeaking;
    if ((userScreen == User.host && userSpeaking == User.host) ||
        (userScreen == User.guest && userSpeaking == User.guest)) {
      return voiceRecordState.speechText;
    } else {
      return voiceRecordState.translation;
    }
  }

  String getInitialText({
    required User userScreenType,
    required User userSpeaking,
    required String speechText,
    required String translation,
  }) {
    if (userScreenType == User.host) {
      if (userSpeaking == User.host) {
        return speechText.isEmpty ? '' : speechText;
      } else {
        return translation.isEmpty ? '' : translation;
      }
    } else {
      if (userSpeaking == User.guest) {
        return speechText.isEmpty ? '' : speechText;
      } else {
        return translation.isEmpty ? '' : translation;
      }
    }
  }

  Future<String> displayHintText({
    required String sourceLanguage,
    required String targetLanguage,
    required User userScreenType,
    required GoogleTranslator translator,
  }) async {
    if (userScreenType == User.host) {
      final translation = await translator.translate(
        'Start typing or use microphone',
        from: 'en',
        to: sourceLanguage,
      );
      return translation.text;
    } else {
      final translation = await translator.translate(
        'Use microphone',
        from: 'en',
        to: targetLanguage,
      );
      return translation.text;
    }
  }
}
