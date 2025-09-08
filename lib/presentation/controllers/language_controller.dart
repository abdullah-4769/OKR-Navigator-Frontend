import 'package:get/get.dart';
import '../../core/localization/localization_services.dart';

class LanguageController extends GetxController {
  final LocalizationService _localizationService = Get.find<LocalizationService>();

  var selectedLanguage = "en".obs;

  final List<Map<String, String>> supportedLanguages = const [
    {"code": "en", "name": "English", "nativeName": "English", "flag": "🇬🇧"},
    {"code": "fr", "name": "French", "nativeName": "Français", "flag": "🇫🇷"},
    {"code": "de", "name": "German", "nativeName": "Deutsch", "flag": "🇩🇪"},
    {"code": "it", "name": "Italian", "nativeName": "Italiano", "flag": "🇮🇹"},
    {"code": "af", "name": "Afrikaans", "nativeName": "Afrikaans", "flag": "🇿🇦"},
    {"code": "es", "name": "Spanish", "nativeName": "Español", "flag": "🇪🇸"},
    {"code": "ur", "name": "Urdu", "nativeName": "اردو", "flag": "🇵🇰"},
  ];

  @override
  void onInit() {
    super.onInit();
    selectedLanguage.value = _localizationService.currentLanguageCode;
  }

  void changeLanguage(String langCode) {
    if (selectedLanguage.value == langCode) return;
    selectedLanguage.value = langCode;
    _localizationService.changeLocale(langCode);
  }

  String get currentLanguage => selectedLanguage.value;

  Map<String, String>? getLanguageByCode(String code) {
    return supportedLanguages.firstWhere(
          (lang) => lang['code'] == code,
      orElse: () => supportedLanguages.first,
    );
  }
}