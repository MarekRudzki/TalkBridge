import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkbridge/constants/enums.dart';
import 'package:talkbridge/constants/extensions.dart';
import 'package:translator_plus/translator_plus.dart';

part 'voice_record_state.dart';

class VoiceRecordCubit extends Cubit<VoiceRecordState> {
  VoiceRecordCubit()
      : super(const VoiceRecordInitial(recordingUser: RecordingUser.none));

  void setRecordingStatus({required RecordingUser recordingUser}) {
    emit(
      VoiceRecordInitial(recordingUser: recordingUser),
    );
  }

  void startLoading() {
    emit(VoiceRecordLoading());
  }

  void setInitialState() {
    emit(
      const VoiceRecordInitial(recordingUser: RecordingUser.none),
    );
  }

  Future<void> displayErrorMessage({
    required String sourceLanguage,
    required User userSpeaking,
  }) async {
    final translator = GoogleTranslator();
    var errorMessage = await translator.translate(
      'Speech detection failed.',
      from: 'en',
      to: sourceLanguage,
    );

    emit(
      VoiceRecordInitial(
        speechText: errorMessage.text,
        recordingUser: RecordingUser.none,
        userSpeaking: userSpeaking,
      ),
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
        recordingUser: RecordingUser.none,
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
        recordingUser: RecordingUser.none,
        speechText: translation,
        translation: speechText,
      ),
    );
  }
}
