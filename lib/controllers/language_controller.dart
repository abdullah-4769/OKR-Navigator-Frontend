import 'package:game_app/generated/models/enums/language_enum.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/localization/localization_services.dart';

class LanguageController extends GetxController {
  final LocalizationService _localizationService =
      Get.find<LocalizationService>();

  final _storage = GetStorage();
  static const String _storageKey = 'langCode';

  /// Reactive selected language code
  final Rx<SupportedLanguage> selectedLanguage = SupportedLanguage.en.obs;

  @override
  void onInit() {
    super.onInit();
    final currentLanguage =
        _storage.read(_storageKey) ?? _localizationService.currentLanguageCode;
    // Load saved or fallback language
    selectedLanguage.value = SupportedLanguage.values.byName(currentLanguage);

    // Apply language immediately
    _localizationService.changeLocale(selectedLanguage.value.code);
  }

  /// Change the app language dynamically
  void changeLanguage(SupportedLanguage supportedLang) {
    if (selectedLanguage.value == supportedLang) return;

    selectedLanguage.value = supportedLang;
    _localizationService.changeLocale(supportedLang.code);

    // Persist in storage
    _storage.write(_storageKey, supportedLang.code);
  }

  SupportedLanguage get currentLanguage => selectedLanguage.value;

  /// Get language details
  // Map<String, String>? getLanguageByCode(String code) =>
  //     supportedLanguages.firstWhere(
  //       (lang) => lang['code'] == code,
  //       orElse: () => supportedLanguages.first,
  //     );
}
