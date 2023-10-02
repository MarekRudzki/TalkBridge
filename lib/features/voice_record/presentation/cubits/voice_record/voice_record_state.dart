part of 'voice_record_cubit.dart';

class VoiceRecordState extends Equatable {
  const VoiceRecordState();

  @override
  List<Object> get props => [];
}

class VoiceRecordInitial extends VoiceRecordState {
  final RecordingUser recordingUser;
  final String speechText;
  final String translation;
  final User userSpeaking;

  const VoiceRecordInitial({
    required this.recordingUser,
    this.speechText = '',
    this.translation = '',
    this.userSpeaking = User.host,
  });

  @override
  List<Object> get props => [
        recordingUser,
        speechText,
        translation,
        userSpeaking,
      ];
}

class VoiceRecordLoading extends VoiceRecordState {}
