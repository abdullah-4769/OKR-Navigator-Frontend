import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalizationService extends GetxService {
  final _storage = GetStorage();
  final String _langKey = "language";

  // Supported locales
  final List<Locale> supportedLocales = const [
    Locale('en'),
    Locale('fr'),
    Locale('de'),
    Locale('it'),
    Locale('af'),
    Locale('es'),
    Locale('ur'),
  ];

  // Reactive locale for UI updates
  final Rx<Locale> _locale = const Locale('en').obs;
  Locale get currentLocale => _locale.value;

  Future<LocalizationService> init() async {
    await GetStorage.init();

    final savedLang = _storage.read(_langKey);
    if (savedLang != null) {
      _locale.value = Locale(savedLang);
    }

    Get.updateLocale(_locale.value);
    return this;
  }

  void changeLocale(String langCode) {
    final newLocale = Locale(langCode);
    _locale.value = newLocale;
    _storage.write(_langKey, langCode);
    Get.updateLocale(newLocale);
  }

  bool isCurrentLocale(String langCode) {
    return _locale.value.languageCode == langCode;
  }

  String get currentLanguageCode => _locale.value.languageCode;
}