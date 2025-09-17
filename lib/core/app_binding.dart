import 'package:get/get.dart';
import '../../controllers/login_controller.dart';
import '../../controllers/register_controller.dart';
import '../../controllers/journey_controller.dart';
import '../../controllers/language_controller.dart';
import '../../controllers/strategy_selection_controller.dart';
import 'localization/localization_services.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Keep essential controllers permanent
    Get.put(LocalizationService(), permanent: true);
    Get.put(LanguageController(), permanent: true);
    Get.put(JourneyController(), permanent: true);
    Get.put(StrategySelectionController(), permanent: true);

    // Lazy load controllers when needed
    Get.lazyPut(() => RegisterController());
    Get.lazyPut(() => LoginController());
  }
}
