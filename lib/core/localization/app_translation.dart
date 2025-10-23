import 'package:get/get.dart';
import 'en.dart';
import 'fr.dart';
import 'de.dart';
import 'es.dart';
import 'it.dart';
import 'za.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': en,
    'fr': fr,
    'de': de,
    'es': es,
    'it': it,
    'za': za,
  };
}
