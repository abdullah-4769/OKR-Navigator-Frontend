enum SupportedLanguage {
  en(code: 'en', name: 'English', nativeName: 'English', flag: '🇬🇧'),
  fr(code: 'fr', name: 'French', nativeName: 'Français', flag: '🇫🇷'),
  // de(code: 'de', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪'),
  // it(code: 'it', name: 'Italian', nativeName: 'Italiano', flag: '🇮🇹'),
  // za(code: 'za', name: 'South African', nativeName: 'Afrikaans', flag: '🇿🇦'),
  es(code: 'es', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸');

  final String code;
  final String name;
  final String nativeName;
  final String flag;

  const SupportedLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });
}
