part of 'voice_record_cubit.dart';

class VoiceRecordState extends Equatable {
  const VoiceRecordState();

  @override
  List<Object> get props => [];
}

class VoiceRecordInitial extends VoiceRecordState {
  final bool isRecording;
  final String speechText;
  final String translation;
  final User userSpeaking;

  const VoiceRecordInitial({
    required this.isRecording,
    this.speechText = '',
    this.translation = '',
    this.userSpeaking = User.host,
  });

  @override
  List<Object> get props => [
        isRecording,
        speechText,
        translation,
        userSpeaking,
      ];
}

class VoiceRecordLoading extends VoiceRecordState {}
