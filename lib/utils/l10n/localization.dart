import 'package:flutter/material.dart';
import 'package:talkbridge/utils/l10n/translations/translation.dart';
export 'package:talkbridge/utils/l10n/translations/translation.dart';

extension LocalizationContext on BuildContext {
  TextTranslations get l10n => TextTranslations.of(this)!;
}
