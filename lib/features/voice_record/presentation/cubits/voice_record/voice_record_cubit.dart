import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkbridge/constants/enums.dart';
import 'package:talkbridge/constants/extensions.dart';
import 'package:translator_plus/translator_plus.dart';

part 'voice_record_state.dart';

class VoiceRecordCubit extends Cubit<VoiceRecordState> {
  VoiceRecordCubit() : super(const VoiceRecordInitial(isRecording: false));

  void setRecordingStatus({required bool isRecording}) {
    emit(
      VoiceRecordInitial(isRecording: isRecording),
    );
  }

  void startLoading() {
    emit(VoiceRecordLoading());
  }

  void setInitialState() {
    emit(
      const VoiceRecordInitial(isRecording: false),
    );
  }

  Future<void> updateSpeechText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
    required User userSpeaking,
  }) async {
    emit(VoiceRecordLoading());
    final translator = GoogleTranslator();
    var translation = await translator.translate(
      text,
      from: sourceLanguage,
      to: targetLanguage,
    );

    emit(
      VoiceRecordInitial(
        speechText: text.capitalize(),
        isRecording: false,
        translation: translation.text.capitalize(),
        userSpeaking: userSpeaking,
      ),
    );
  }

  void reverseTranslations({
    required String speechText,
    required String translation,
  }) {
    emit(
      VoiceRecordInitial(
        isRecording: false,
        speechText: translation,
        translation: speechText,
      ),
    );
  }
}
