import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'voice_record_state.dart';

class VoiceRecordCubit extends Cubit<VoiceRecordState> {
  VoiceRecordCubit() : super(const VoiceRecordInitial(isRecording: false));

  void setRecordingStatus({required bool isRecording}) {
    emit(VoiceRecordInitial(isRecording: isRecording));
  }

  void updateSpeechText({required String text, required bool isRecording}) {
    emit(VoiceRecordInitial(speechText: text, isRecording: isRecording));
  }
}
