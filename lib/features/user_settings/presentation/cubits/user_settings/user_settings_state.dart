part of 'user_settings_cubit.dart';

class UserSettingsState extends Equatable {
  const UserSettingsState();

  @override
  List<Object> get props => [];
}

class UserSettingsInitial extends UserSettingsState {
  final SelectedFontSize fontSize;
  final bool isAutoPlay;
  final SelectedInterfaceLanguage interfaceLanguage;

  const UserSettingsInitial({
    this.fontSize = SelectedFontSize.medium,
    this.isAutoPlay = true,
    this.interfaceLanguage = SelectedInterfaceLanguage.english,
  });

  UserSettingsInitial copyWith({
    SelectedFontSize? fontSize,
    bool? isAutoPlay,
    SelectedInterfaceLanguage? interfaceLanguage,
  }) {
    return UserSettingsInitial(
      fontSize: fontSize ?? this.fontSize,
      isAutoPlay: isAutoPlay ?? this.isAutoPlay,
      interfaceLanguage: interfaceLanguage ?? this.interfaceLanguage,
    );
  }

  @override
  List<Object> get props => [
        fontSize,
        isAutoPlay,
        interfaceLanguage,
      ];
}
