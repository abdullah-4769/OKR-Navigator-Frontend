import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class LocalizationService extends GetxService {
  final Rx<Locale> _currentLocale = const Locale('en').obs;
  String get currentLanguageCode => _currentLocale.value.languageCode;

  Locale get currentLocale => _currentLocale.value;

  Future<void> init() async {
    await GetStorage.init();
    final box = GetStorage();
    final savedLang = box.read('selectedLanguage') as String?;
    _currentLocale.value = savedLang != null ? Locale(savedLang) : const Locale('en');
    Get.updateLocale(_currentLocale.value);
  }

  void changeLocale(String langCode) {
    _currentLocale.value = Locale(langCode);
    Get.updateLocale(_currentLocale.value);
    GetStorage().write('selectedLanguage', langCode);
  }
}

