import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkbridge/constants/enums.dart';
import 'package:talkbridge/features/home_screen/presentation/widgets/lower_part.dart';
import 'package:translator_plus/translator_plus.dart';

part 'voice_record_state.dart';

class VoiceRecordCubit extends Cubit<VoiceRecordState> {
  VoiceRecordCubit() : super(const VoiceRecordInitial(isRecording: false));

  void setRecordingStatus({required bool isRecording}) {
    emit(VoiceRecordInitial(isRecording: isRecording));
  }

  void startLoading() {
    emit(VoiceRecordLoading());
  }

  Future<void> updateSpeechText({
    required String text,
    required String languageSource,
    required String languageTarget,
    required User userSpeaking,
  }) async {
    final translator = GoogleTranslator();
    var translation = await translator.translate(
      text,
      from: languageSource,
      to: languageTarget,
    );

    emit(VoiceRecordInitial(
      speechText: text.capitalize(),
      isRecording: false,
      translation: translation.text.capitalize(),
      userSpeaking: userSpeaking,
    ));
  }
}
