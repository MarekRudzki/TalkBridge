import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:talkbridge/features/home_screen/presentation/cubits/voice_record/voice_record_cubit.dart';

void main() {
  late VoiceRecordCubit voiceRecordCubit;

  setUp(() {
    voiceRecordCubit = VoiceRecordCubit();
  });

  group(
    'Voice record cubit',
    () {
      blocTest<VoiceRecordCubit, VoiceRecordState>(
        'emits [VoiceRecordInitial] with isRecording true value when toggleRecording is triggered.',
        build: () => voiceRecordCubit,
        act: (cubit) => cubit.setRecordingStatus(isRecording: true),
        expect: () => [const VoiceRecordInitial(isRecording: true)],
      );

      blocTest<VoiceRecordCubit, VoiceRecordState>(
        'emits [VoiceRecordInitial] with isRecording false value when toggleRecording is triggered.',
        build: () => voiceRecordCubit,
        act: (cubit) => cubit.setRecordingStatus(isRecording: false),
        expect: () => [const VoiceRecordInitial(isRecording: false)],
      );

      blocTest<VoiceRecordCubit, VoiceRecordState>(
        'emits [VoiceRecordInitial] with correct data when updateSpeechText is triggered.',
        build: () => voiceRecordCubit,
        act: (cubit) =>
            cubit.updateSpeechText(isRecording: false, text: 'FooBar'),
        expect: () => [
          const VoiceRecordInitial(isRecording: false, speechText: 'FooBar')
        ],
      );
    },
  );
}
