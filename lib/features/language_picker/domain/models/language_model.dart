// Package imports:
import 'package:equatable/equatable.dart';

class LanguageModel extends Equatable {
  final String sourceLanguage;
  final String targetLanguage;

  const LanguageModel({
    required this.sourceLanguage,
    required this.targetLanguage,
  });

  @override
  List<Object> get props => [
        sourceLanguage,
        targetLanguage,
      ];
}
