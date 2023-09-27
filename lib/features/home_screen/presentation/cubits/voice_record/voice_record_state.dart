part of 'voice_record_cubit.dart';

class VoiceRecordState extends Equatable {
  const VoiceRecordState();

  @override
  List<Object> get props => [];
}

final class VoiceRecordInitial extends VoiceRecordState {
  final bool isRecording;
  final String speechText;

  const VoiceRecordInitial({required this.isRecording, this.speechText = ''});

  @override
  List<Object> get props => [isRecording, speechText];
}
