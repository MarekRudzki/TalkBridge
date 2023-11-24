// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:talkbridge/utils/l10n/translations/translation.dart';

export 'package:talkbridge/utils/l10n/translations/translation.dart';

extension LocalizationContext on BuildContext {
  TextTranslations get l10n => TextTranslations.of(this)!;
}
