// import 'package:game_app/data/repositories/auth_repository.dart';
// import 'package:game_app/data/repositories/storage_repository.dart';
// import 'package:game_app/data/repositories/strategy_repository.dart';
// import 'package:game_app/data/repositories/objective_repository.dart';
// import 'package:get/get.dart';
//
// import '../../controllers/journey_controller.dart';
// import '../../controllers/language_controller.dart';
// import '../../controllers/login_controller.dart';
// import '../../controllers/register_controller.dart';
// import '../../controllers/strategy_selection_controller.dart';
// import '../../controllers/key_objective_controller.dart';
// import '../controllers/okr_constellation_controller.dart';
// import '../data/repositories/innovative_repo.dart';
// import '../view_model/challenge_view_model/innovative_view_model.dart';
// import '../view_model/key_results_view_model/key_results_view_model.dart';
// import 'localization/localization_services.dart';
//
// class AppBindings extends Bindings {
//   @override
//   void dependencies() {
//     // ✅ CORE SERVICES - Always available (permanent)
//     Get.put(LocalizationService(), permanent: true);
//     Get.put(LanguageController(), permanent: true);
//     Get.put(StorageRepository(), permanent: true);
//
//     // ✅ REPOSITORIES - Always available (permanent)
//     Get.put(StrategyRepository(), permanent: true);
//     Get.put(ObjectiveRepository(), permanent: true);
//     Get.lazyPut(() => AuthRepository());
//
//     // ✅ GAME FLOW CONTROLLERS - Needed across multiple screens (permanent)
//     Get.put(JourneyController(), permanent: true);
//     Get.put(StrategySelectionController(), permanent: true);
//     Get.put(KeyObjectiveController(), permanent: true); // ✅ Changed to permanent
//
//     // ✅ LAZY CONTROLLERS - Load when needed (fenix: true for reuse)
//     Get.lazyPut<KeyResultsViewModel>(() => KeyResultsViewModel(), fenix: true);
//     Get.lazyPut<OKRConstellationController>(
//           () => OKRConstellationController(),
//       fenix: true,
//     );
//
//     // ✅ AUTH CONTROLLERS - Only when login/register screen opens
//     Get.lazyPut(() => RegisterController());
//     Get.lazyPut(() => LoginController());
//     Get.lazyPut(() => AuthRepository());
//     // contextual challenge ...........
//     Get.lazyPut(() => InnovativeStrategiesRepository());
//     Get.lazyPut(() => InnovativeStrategiesViewModel());
//
//   }
// }
// lib/core/app_bindings.dart

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
import '../controllers/dashboard_controller.dart';
import '../controllers/home_navbar_controller.dart';
import '../controllers/key_results_controller.dart';
import '../controllers/okr_constellation_controller.dart';
import '../controllers/team_mode_controller/create_team_controller.dart';
import '../controllers/team_mode_controller/team_chat_controller.dart';
import '../controllers/team_mode_controller/team_contextual_challange_controller.dart';
import '../controllers/team_mode_controller/team_game_complete_controller.dart';
import '../controllers/team_mode_controller/team_game_controller.dart';
import '../controllers/team_mode_controller/team_key_results_controller.dart';
import '../controllers/team_mode_controller/team_objective_controller.dart';
import '../controllers/team_mode_controller/team_strategy_controller.dart';
import '../controllers/team_mode_controller/team_strategy_selection_controller.dart';
import '../data/repositories/innovative_repo.dart';
import '../data/repositories/innovative_strategy_repo.dart';
import '../data/repositories/key_results_repo.dart';
import '../data/repositories/team_repo.dart';
import '../data/repositories/team_repository.dart';
import '../generated/network.dart';
import '../repository/campaign_mode/certification_evaluation_repo.dart';
import '../repository/campaign_mode/certification_repository.dart';

import '../services/campaign/certificate_evaluation_service.dart';
import '../services/campaign/certification_api_service.dart';
import '../services/campaign/certification_evaluation_viewmodel.dart';
import '../services/key_result/key_results.dart';
import '../services/notification_service.dart';
import '../view_model/campaign_mode/certification_info_model.dart';
import '../view_model/challenge_view_model/innovative_view_model.dart';
import '../view_model/key_result_latest_view_model.dart';
import '../view_model/key_results_view_mode.dart' hide KeyResultsLatestViewModel;
import '../view_model/key_results_view_model/key_results_view_model.dart';

import 'localization/localization_services.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeNavBarController(), permanent: true);
    // CORE SERVICES - Must be initialized in order
    // These are initialized in main.dart before app starts
    Get.lazyPut(() => CertificationInfoApiService(), fenix: true);
    Get.lazyPut(() => CertificationInfoRepository(), fenix: true);
    Get.lazyPut(() => CertificationInfoViewModel(), fenix: true);
    //  REPOSITORIES - Always available (permanent)
    Get.lazyPut(() => StrategyRepository(), fenix: true);
    Get.lazyPut(() => ObjectiveRepository(), fenix: true);
    Get.lazyPut(() => AuthRepository(), fenix: true);
    Get.lazyPut(() => InnovativeStrategiesRepository(), fenix: true);
    Get.lazyPut(() => CertificationApiService(), fenix: true);
    Get.lazyPut(() => CertificationRepository(), fenix: true);
    Get.lazyPut(() => CertificationEvaluationViewModel(), fenix: true);
    //  CONTROLLERS - Always available
    Get.lazyPut(()=>FirebaseNotificationService());
    Get.lazyPut(()=>TeamGameTimerController());
    Get.put(LocalizationService(), permanent: true);
    Get.put(LanguageController(), permanent: true);
    Get.put(JourneyController(), permanent: true);
    Get.put(StrategySelectionController(), permanent: true);
    Get.put(KeyObjectiveController(), permanent: true);

    //  LAZY CONTROLLERS - Load when needed (fenix: true for reuse)
    // Get.lazyPut<KeyResultsViewModel>(() => KeyResultsViewModel(), fenix: true);
    Get.lazyPut<OKRConstellationController>(
          () => OKRConstellationController(),
      fenix: true,
    );
    Get.lazyPut(() => InnovativeStrategiesViewModel(), fenix: true);

    //  AUTH CONTROLLERS - Only when login/register screen opens
    Get.lazyPut(() => RegisterController());
    Get.lazyPut(() => LoginController());



//// after add in from team mode ano

    //  CORE SERVICES - Always available (permanent)
    Get.put(LocalizationService(), permanent: true);
    Get.put(LanguageController(), permanent: true);
    Get.put(StorageRepository(), permanent: true);

    //  REPOSITORIES - Always available (permanent)
    Get.put(StrategyRepository(), permanent: true);
    Get.put(TeamRepository(), permanent: true);

    Get.put(ObjectiveRepository(), permanent: true);
    Get.lazyPut(() => AuthRepository());

    //  GAME FLOW CONTROLLERS - Needed across multiple screens (permanent)
    Get.put(JourneyController(), permanent: true);
    Get.put(TeamObjectiveController(), permanent: true);

    Get.put(StrategySelectionController(), permanent: true);
    Get.put(TeamStrategySelectionController(), permanent: true);
    Get.put(TeamKeyResultsController(), permanent: true);

    Get.put(TeamContextualChallengeController (), permanent: true);

    Get.put(CreateTeamController(), permanent: true);


    Get.put(KeyObjectiveController(), permanent: true); //  Changed to permanent

    //  LAZY CONTROLLERS - Load when needed (fenix: true for reuse)
    // Get.lazyPut<KeyResultsViewModel>(() => KeyResultsViewModel(), fenix: true);
    Get.lazyPut<OKRConstellationController>(
          () => OKRConstellationController(),
      fenix: true,
    );

    //  AUTH CONTROLLERS - Only when login/register screen opens
    Get.lazyPut(() => RegisterController());
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => AuthRepository());
    // contextual challenge ...........
    Get.lazyPut(() => InnovativeStrategiesRepository());

    Get.lazyPut(() => InnovativeStrategiesViewModel());



    Get.put(TeamGameTimerController(), permanent: true);

    Get.put(FirebaseNotificationService(),permanent:true);


    //  NEW COMPREHENSIVE CONTROLLERS
    Get.put(TeamStrategyController(), permanent: true);
    Get.put(TeamChatController(), permanent: true);
    Get.put(TeamGameCompleteController(), permanent: true);
    Get.put(DashboardController(), permanent: true);

    Get.put(KeyObjectiveController(), permanent: true); //  Changed to permanent
    Get.put(StrategySelectionController(), permanent: true);
    Get.put(AuthRepository(), permanent: true);
    //  LAZY CONTROLLERS - Load when needed (fenix: true for reuse)
    Get.lazyPut<KeyResultsLatestViewModel>(() => KeyResultsLatestViewModel(), fenix: true);
    Get.lazyPut<OKRConstellationController>(
          () => OKRConstellationController(),
      fenix: true,
    );

    //  AUTH CONTROLLERS - Only when login/register screen opens
    Get.lazyPut(() => RegisterController());
    Get.lazyPut(() => LoginController());
    // contextual challenge ...........
    Get.lazyPut(() => InnovativeStrategiesRepository());

    Get.lazyPut(() => InnovativeStrategiesViewModel());
    // ........... Key Results   ...........
    Get.lazyPut<KeyResultService>(() => KeyResultService());

    // Register repositories
    Get.lazyPut<KeyResultRepository>(() => KeyResultRepository());

    // Register controllers
    Get.lazyPut<KeyResultsController>(() => KeyResultsController());

  }
}