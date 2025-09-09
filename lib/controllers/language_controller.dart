import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/localization/localization_services.dart';

class LanguageController extends GetxController {
  final LocalizationService _localizationService =
  Get.find<LocalizationService>();

  final _storage = GetStorage();
  static const String _storageKey = 'langCode';

  /// Currently selected language code
  var selectedLanguage = 'en'.obs;

  /// List of supported languages
  final List<Map<String, String>> supportedLanguages = const [
    {'code': 'en', 'name': 'English', 'nativeName': 'English', 'flag': '🇬🇧'},
    {'code': 'fr', 'name': 'French', 'nativeName': 'Français', 'flag': '🇫🇷'},
    {'code': 'de', 'name': 'German', 'nativeName': 'Deutsch', 'flag': '🇩🇪'},
    {'code': 'it', 'name': 'Italian', 'nativeName': 'Italiano', 'flag': '🇮🇹'},
    {'code': 'za', 'name': 'South African', 'nativeName': 'Afrikaans', 'flag': '🇿🇦'},
    {'code': 'es', 'name': 'Spanish', 'nativeName': 'Español', 'flag': '🇪🇸'},
  ];

  @override
  void onInit() {
    super.onInit();
    // Load saved language or fallback to current locale
    selectedLanguage.value = _storage.read(_storageKey) ??
        _localizationService.currentLanguageCode;

    // Apply the language immediately
    _localizationService.changeLocale(selectedLanguage.value);
  }

  /// Change the app language dynamically
  void changeLanguage(String langCode) {
    if (selectedLanguage.value == langCode) return;

    selectedLanguage.value = langCode;
    _localizationService.changeLocale(langCode);

    // Persist selection
    _storage.write(_storageKey, langCode);
  }

  /// Current selected language code
  String get currentLanguage => selectedLanguage.value;

  /// Get language info by its code
  Map<String, String>? getLanguageByCode(String code) =>
      supportedLanguages.firstWhere(
            (lang) => lang['code'] == code,
        orElse: () => supportedLanguages.first,
      );
}
