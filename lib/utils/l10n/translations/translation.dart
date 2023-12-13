import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'translation_en.dart';
import 'translation_pl.dart';

/// Callers can lookup localized strings with an instance of TextTranslations
/// returned by `TextTranslations.of(context)`.
///
/// Applications need to include `TextTranslations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'translations/translation.dart';
///
/// return MaterialApp(
///   localizationsDelegates: TextTranslations.localizationsDelegates,
///   supportedLocales: TextTranslations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the TextTranslations.supportedLocales
/// property.
abstract class TextTranslations {
  TextTranslations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static TextTranslations? of(BuildContext context) {
    return Localizations.of<TextTranslations>(context, TextTranslations);
  }

  static const LocalizationsDelegate<TextTranslations> delegate = _TextTranslationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl')
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get fontSize;

  /// No description provided for @autoPlay.
  ///
  /// In en, this message translates to:
  /// **'Auto play'**
  String get autoPlay;

  /// No description provided for @interfaceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Interface language'**
  String get interfaceLanguage;

  /// No description provided for @noNetworkInfo.
  ///
  /// In en, this message translates to:
  /// **'No network connection'**
  String get noNetworkInfo;

  /// No description provided for @noNetworkMessage.
  ///
  /// In en, this message translates to:
  /// **'Please turn on Internet and application will refresh'**
  String get noNetworkMessage;

  /// No description provided for @sourceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Source language'**
  String get sourceLanguage;

  /// No description provided for @targetLanguage.
  ///
  /// In en, this message translates to:
  /// **'Target language'**
  String get targetLanguage;

  /// No description provided for @lngArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get lngArabic;

  /// No description provided for @lngBulgarian.
  ///
  /// In en, this message translates to:
  /// **'Bulgarian'**
  String get lngBulgarian;

  /// No description provided for @lngCroatian.
  ///
  /// In en, this message translates to:
  /// **'Croatian'**
  String get lngCroatian;

  /// No description provided for @lngCzech.
  ///
  /// In en, this message translates to:
  /// **'Czech'**
  String get lngCzech;

  /// No description provided for @lngDanish.
  ///
  /// In en, this message translates to:
  /// **'Danish'**
  String get lngDanish;

  /// No description provided for @lngDutchNetherlands.
  ///
  /// In en, this message translates to:
  /// **'Dutch (Netherlands)'**
  String get lngDutchNetherlands;

  /// No description provided for @lngEnglishAustralia.
  ///
  /// In en, this message translates to:
  /// **'English (Australia)'**
  String get lngEnglishAustralia;

  /// No description provided for @lngEnglishCanada.
  ///
  /// In en, this message translates to:
  /// **'English (Canada)'**
  String get lngEnglishCanada;

  /// No description provided for @lngEnglishIndia.
  ///
  /// In en, this message translates to:
  /// **'English (India)'**
  String get lngEnglishIndia;

  /// No description provided for @lngEnglishUK.
  ///
  /// In en, this message translates to:
  /// **'English (United Kingdom)'**
  String get lngEnglishUK;

  /// No description provided for @lngEnglishUS.
  ///
  /// In en, this message translates to:
  /// **'English (United States)'**
  String get lngEnglishUS;

  /// No description provided for @lngEstonian.
  ///
  /// In en, this message translates to:
  /// **'Estonian'**
  String get lngEstonian;

  /// No description provided for @lngFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get lngFrench;

  /// No description provided for @lngGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get lngGerman;

  /// No description provided for @lngGreek.
  ///
  /// In en, this message translates to:
  /// **'Greek'**
  String get lngGreek;

  /// No description provided for @lngItalian.
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get lngItalian;

  /// No description provided for @lngLatvian.
  ///
  /// In en, this message translates to:
  /// **'Latvian'**
  String get lngLatvian;

  /// No description provided for @lngLithuanian.
  ///
  /// In en, this message translates to:
  /// **'Lithuanian'**
  String get lngLithuanian;

  /// No description provided for @lngPolish.
  ///
  /// In en, this message translates to:
  /// **'Polish'**
  String get lngPolish;

  /// No description provided for @lngPortuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get lngPortuguese;

  /// No description provided for @lngRomanian.
  ///
  /// In en, this message translates to:
  /// **'Romanian'**
  String get lngRomanian;

  /// No description provided for @lngRussian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get lngRussian;

  /// No description provided for @lngSlovak.
  ///
  /// In en, this message translates to:
  /// **'Slovak'**
  String get lngSlovak;

  /// No description provided for @lngSlovenian.
  ///
  /// In en, this message translates to:
  /// **'Slovenian'**
  String get lngSlovenian;

  /// No description provided for @lngSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get lngSpanish;

  /// No description provided for @lngTurkish.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get lngTurkish;

  /// No description provided for @lngUkrainian.
  ///
  /// In en, this message translates to:
  /// **'Ukrainian'**
  String get lngUkrainian;
}

class _TextTranslationsDelegate extends LocalizationsDelegate<TextTranslations> {
  const _TextTranslationsDelegate();

  @override
  Future<TextTranslations> load(Locale locale) {
    return SynchronousFuture<TextTranslations>(lookupTextTranslations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_TextTranslationsDelegate old) => false;
}

TextTranslations lookupTextTranslations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return TextTranslationsEn();
    case 'pl': return TextTranslationsPl();
  }

  throw FlutterError(
    'TextTranslations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
