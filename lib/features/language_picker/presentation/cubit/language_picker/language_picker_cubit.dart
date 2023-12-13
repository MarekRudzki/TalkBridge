// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkbridge/constants/enums.dart';

// Project imports:
import 'package:talkbridge/features/language_picker/domain/models/language_model.dart';
import 'package:talkbridge/features/language_picker/domain/repositories/language_picker_repository.dart';
import 'package:talkbridge/utils/l10n/localization.dart';

part 'language_picker_state.dart';

class LanguagePickerCubit extends Cubit<LanguagePickerState> {
  final LanguagePickerRepository repository;
  LanguagePickerCubit(this.repository) : super(LanguagePickerInitial());

  Future<void> setSourceLanguage({required String language}) async {
    final LanguageModel languageModel = await repository.getSavedLanguages();
    await repository.setSourceLanguage(language: language);
    emit(
      LanguagesSelected(
        sourceLanguage: language,
        targetLanguage: languageModel.targetLanguage,
      ),
    );
  }

  Future<void> setTargetLanguage({required String language}) async {
    final LanguageModel languageModel = await repository.getSavedLanguages();
    await repository.setTargetLanguage(language: language);
    emit(
      LanguagesSelected(
        targetLanguage: language,
        sourceLanguage: languageModel.sourceLanguage,
      ),
    );
  }

  Future<void> setSavedLanguages() async {
    final LanguageModel languageModel = await repository.getSavedLanguages();
    setSourceLanguage(language: languageModel.sourceLanguage);
    setTargetLanguage(language: languageModel.targetLanguage);
  }

  Future<void> reverseLanguages() async {
    final LanguageModel languageModel = await repository.getSavedLanguages();

    await repository.setTargetLanguage(language: languageModel.sourceLanguage);
    await repository.setSourceLanguage(language: languageModel.targetLanguage);
    emit(
      LanguagesSelected(
        sourceLanguage: languageModel.targetLanguage,
        targetLanguage: languageModel.sourceLanguage,
      ),
    );
  }

  Map<String, String> getLanguageList({
    required BuildContext context,
    required SelectedInterfaceLanguage currentInterfaceLanguage,
  }) {
    if (currentInterfaceLanguage == SelectedInterfaceLanguage.english) {
      return {
        context.l10n.lngArabic: 'ar_EG',
        context.l10n.lngBulgarian: 'bg_BG',
        context.l10n.lngCroatian: 'hr_HR',
        context.l10n.lngCzech: 'cs_CZ',
        context.l10n.lngDanish: 'da_DK',
        context.l10n.lngDutchNetherlands: 'nl_NL',
        context.l10n.lngEnglishAustralia: 'en_AU',
        context.l10n.lngEnglishCanada: 'en_CA',
        context.l10n.lngEnglishIndia: 'en_IN',
        context.l10n.lngEnglishUK: 'en_GB',
        context.l10n.lngEnglishUS: 'en_US',
        context.l10n.lngEstonian: 'et_EE',
        context.l10n.lngFrench: 'fr_FR',
        context.l10n.lngGerman: 'de_DE',
        context.l10n.lngGreek: 'el_GR',
        context.l10n.lngItalian: 'it_IT',
        context.l10n.lngLatvian: 'lv_LV',
        context.l10n.lngLithuanian: 'lt_LT',
        context.l10n.lngPolish: 'pl_PL',
        context.l10n.lngPortuguese: 'pt_PT',
        context.l10n.lngRomanian: 'ro_RO',
        context.l10n.lngRussian: 'ru_RU',
        context.l10n.lngSlovak: 'sk_SK',
        context.l10n.lngSlovenian: 'sl_SI',
        context.l10n.lngSpanish: 'es_ES',
        context.l10n.lngTurkish: 'tr_TR',
        context.l10n.lngUkrainian: 'uk_UA',
      };
    } else {
      return {
        context.l10n.lngEnglishUS: 'en_US',
        context.l10n.lngEnglishAustralia: 'en_AU',
        context.l10n.lngEnglishUK: 'en_GB',
        context.l10n.lngEnglishCanada: 'en_CA',
        context.l10n.lngEnglishIndia: 'en_IN',
        context.l10n.lngArabic: 'ar_EG',
        context.l10n.lngBulgarian: 'bg_BG',
        context.l10n.lngCroatian: 'hr_HR',
        context.l10n.lngCzech: 'cs_CZ',
        context.l10n.lngDanish: 'da_DK',
        context.l10n.lngDutchNetherlands: 'nl_NL',
        context.l10n.lngEstonian: 'et_EE',
        context.l10n.lngFrench: 'fr_FR',
        context.l10n.lngGreek: 'el_GR',
        context.l10n.lngSpanish: 'es_ES',
        context.l10n.lngLithuanian: 'lt_LT',
        context.l10n.lngLatvian: 'lv_LV',
        context.l10n.lngGerman: 'de_DE',
        context.l10n.lngPolish: 'pl_PL',
        context.l10n.lngPortuguese: 'pt_PT',
        context.l10n.lngRussian: 'ru_RU',
        context.l10n.lngRomanian: 'ro_RO',
        context.l10n.lngSlovak: 'sk_SK',
        context.l10n.lngSlovenian: 'sl_SI',
        context.l10n.lngTurkish: 'tr_TR',
        context.l10n.lngUkrainian: 'uk_UA',
        context.l10n.lngItalian: 'it_IT',
      };
    }
  }
}
