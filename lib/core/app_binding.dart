import 'package:game_app/data/repositories/auth_repository.dart';
import 'package:game_app/data/repositories/storage_repository.dart';
import 'package:game_app/data/repositories/strategy_repository.dart';
import 'package:game_app/data/repositories/objective_repository.dart';
import 'package:get/get.dart';

import '../../controllers/journey_controller.dart';
import '../../controllers/language_controller.dart';
import '../../controllers/login_controller.dart';
import '../../controllers/register_controller.dart';
import '../../controllers/strategy_selection_controller.dart';
import '../../controllers/key_objective_controller.dart';
import '../controllers/okr_constellation_controller.dart';
import '../data/repositories/innovative_repo.dart';
import '../view_model/challenge_view_model/innovative_view_model.dart';
import '../view_model/key_results_view_model/key_results_view_model.dart';
import 'localization/localization_services.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // ✅ CORE SERVICES - Always available (permanent)
    Get.put(LocalizationService(), permanent: true);
    Get.put(LanguageController(), permanent: true);
    Get.put(StorageRepository(), permanent: true);

    // ✅ REPOSITORIES - Always available (permanent)
    Get.put(StrategyRepository(), permanent: true);
    Get.put(ObjectiveRepository(), permanent: true);
    Get.lazyPut(() => AuthRepository());

    // ✅ GAME FLOW CONTROLLERS - Needed across multiple screens (permanent)
    Get.put(JourneyController(), permanent: true);
    Get.put(StrategySelectionController(), permanent: true);
    Get.put(KeyObjectiveController(), permanent: true); // ✅ Changed to permanent

    // ✅ LAZY CONTROLLERS - Load when needed (fenix: true for reuse)
    Get.lazyPut<KeyResultsViewModel>(() => KeyResultsViewModel(), fenix: true);
    Get.lazyPut<OKRConstellationController>(
          () => OKRConstellationController(),
      fenix: true,
    );

    // ✅ AUTH CONTROLLERS - Only when login/register screen opens
    Get.lazyPut(() => RegisterController());
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => AuthRepository());
    // contextual challenge ...........
    Get.lazyPut(() => InnovativeStrategiesRepository());
    Get.lazyPut(() => InnovativeStrategiesViewModel());

  }
}