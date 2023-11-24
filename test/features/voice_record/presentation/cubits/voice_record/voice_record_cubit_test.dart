// Package imports:
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:talkbridge/constants/enums.dart';
import 'package:talkbridge/features/voice_record/presentation/cubits/voice_record/voice_record_cubit.dart';

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
        act: (cubit) =>
            cubit.setRecordingStatus(recordingUser: RecordingUser.host),
        expect: () => [
          const VoiceRecordInitial(recordingUser: RecordingUser.host),
        ],
      );

      blocTest<VoiceRecordCubit, VoiceRecordState>(
        'emits [VoiceRecordInitial] with isRecording false value when toggleRecording is triggered.',
        build: () => voiceRecordCubit,
        act: (cubit) =>
            cubit.setRecordingStatus(recordingUser: RecordingUser.none),
        expect: () =>
            [const VoiceRecordInitial(recordingUser: RecordingUser.none)],
      );

      blocTest<VoiceRecordCubit, VoiceRecordState>(
        'emits [VoiceRecordInitial] with correct data when updateSpeechText is triggered.',
        build: () => voiceRecordCubit,
        act: (cubit) => cubit.updateSpeechText(
            text: 'Ball',
            sourceLanguage: 'en',
            targetLanguage: 'pl',
            userSpeaking: User.host),
        expect: () => [
          VoiceRecordLoading(),
          const VoiceRecordInitial(
            recordingUser: RecordingUser.none,
            speechText: 'Ball',
            translation: 'Piłka',
          )
        ],
      );

      blocTest<VoiceRecordCubit, VoiceRecordState>(
        'emits [VoiceRecordLoading] when startLoading is triggered.',
        build: () => voiceRecordCubit,
        act: (cubit) => cubit.startLoading(),
        expect: () => [
          VoiceRecordLoading(),
        ],
      );

      blocTest<VoiceRecordCubit, VoiceRecordState>(
        'emits [VoiceRecordInitial] when setInitialState is triggered.',
        build: () => voiceRecordCubit,
        act: (cubit) => cubit.setInitialState(),
        expect: () => [
          const VoiceRecordInitial(recordingUser: RecordingUser.none),
        ],
      );

      blocTest<VoiceRecordCubit, VoiceRecordState>(
        'emits [VoiceRecordInitial] when reverseTranslations is triggered.',
        build: () => voiceRecordCubit,
        act: (cubit) => cubit.reverseTranslations(
          speechText: 'Testing',
          translation: 'Testowanie',
        ),
        expect: () => [
          const VoiceRecordInitial(
            recordingUser: RecordingUser.none,
            speechText: 'Testowanie',
            translation: 'Testing',
          ),
        ],
      );

      blocTest<VoiceRecordCubit, VoiceRecordState>(
        'emits [VoiceRecordInitial] when displayErrorMessage is triggered.',
        build: () => voiceRecordCubit,
        act: (cubit) => cubit.displayErrorMessage(
          sourceLanguage: 'pl',
          userSpeaking: User.host,
        ),
        expect: () => [
          const VoiceRecordInitial(
            recordingUser: RecordingUser.none,
            speechText: 'Wykrywanie mowy nie powiodło się.',
          ),
        ],
      );
    },
  );
}
