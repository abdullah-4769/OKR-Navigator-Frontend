import 'dart:convert';
import 'dart:developer';

import 'package:game_app/controllers/language_controller.dart';
import 'package:game_app/controllers/strategy_selection_controller.dart';
import 'package:game_app/data/repositories/objective_repository.dart';
import 'package:game_app/utils/snackbar_helper.dart';
import 'package:get/get.dart';

import '../generated/models/responses/objectives/objectives_response.dart';

class KeyObjectiveController extends GetxController {
  // Observables
  final RxBool loading = false.obs;
  final RxList<Objective> objectives = RxList<Objective>();
  final ObjectiveRepository repo = Get.find<ObjectiveRepository>();
  final Rxn<Objective> selectedObjective = Rxn<Objective>();

  @override
  void onInit() {
    super.onInit();
    // Ensure dependencies are available
    _validateDependencies();
  }
  // Add this method to clear all data
  void clearAllData() {
    objectives.clear();
    selectedObjective.value = null;
    loading.value = false;
    print('🧹 KeyObjectiveController - all data cleared');
  }

  // Your existing clearSelection method
  void clearSelection() {
    selectedObjective.value = null;
    log('🧹 Objective selection cleared');
  }
  // Validate that required controllers are registered
  void _validateDependencies() {
    try {
      Get.find<StrategySelectionController>();
      Get.find<LanguageController>();
    } catch (e) {
      log('Required controllers not found: $e');
      SnackbarHelper.error('Application error: Required dependencies missing.');
    }
  }

  Future<void> getObjectives(
      Map<String, dynamic> role,
      Map<String, dynamic> industry,
      ) async {
    try {
      loading.value = true;
      final strategy = Get.find<StrategySelectionController>().selectedStrategy.value;
      if (strategy == null) {
        throw Exception('No strategy selected');
      }

      // ✅ Handle both campaign mode (organization) and solo mode (industry)
      final industryOrOrganization = industry['titleKey']?.toString() ?? '';

      // Log the data for debugging
      log('🎯 Fetching objectives with:');
      log('   Strategy: ${strategy.title}');
      log('   Role: ${role['title']}');
      log('   Industry/Organization: $industryOrOrganization');
      log('   Is Campaign Mode: ${industryOrOrganization.contains('organization')}');

      final response = await repo.generateObjectives(
        strategyId: strategy.strategyId!,
        strategy: strategy.title!,
        role: role['title']?.toString() ?? '',
        industry: industryOrOrganization,
        language: Get.find<LanguageController>().selectedLanguage.value.name.toLowerCase(),
      );

      objectives.assignAll(response); // Replace existing objectives
      log('✅ Successfully loaded ${objectives.length} objectives');

    } catch (e, s) {
      log('❌ Error fetching objectives: $e', stackTrace: s);
      SnackbarHelper.error('Failed to load objectives. Using fallback data.');

      // Fallback to static data
      objectives.assignAll([
        Objective(
          title: 'expand_product_line',
          description: 'introduce_new_products',
        ),
        Objective(
          title: 'improve_customer_experience',
          description: 'enhance_satisfaction',
        ),
        Objective(
          title: 'increase_market_share',
          description: 'gain_significant_presence',
        ),
      ]);
      log('🔄 Using fallback objectives: ${objectives.length} items');
    } finally {
      loading.value = false;
    }
  }

  // Toggle objective selection
  void selectObjective(Objective objective) {
    if (selectedObjective.value == objective) {
      selectedObjective.value = null; // Deselect if clicked again
      log('🔴 Objective deselected: ${objective.title}');
    } else {
      selectedObjective.value = objective; // Select new objective
      log('🟢 Objective selected: ${objective.title}');
    }
  }

  // Check if objective is selected
  bool isSelected(Objective objective) => selectedObjective.value == objective;

  // Button enabled only when something is selected
  bool get isButtonEnabled => selectedObjective.value != null;

  // Get selected objective title key
  String get selectedTitleKey => selectedObjective.value?.title ?? '';

  // ✅ Additional method to handle campaign mode specifically
  Future<void> getObjectivesForCampaign(
      Map<String, dynamic> role,
      Map<String, dynamic> organization,
      ) async {
    log('🎮 Campaign mode: Fetching objectives for organization');
    await getObjectives(role, organization);
  }

  // // ✅ Clear selection (useful when navigating back)
  // void clearSelection() {
  //   selectedObjective.value = null;
  //   log('🧹 Objective selection cleared');
  // }
}









// import 'dart:developer';
//
// import 'package:game_app/controllers/language_controller.dart';
// import 'package:game_app/controllers/strategy_selection_controller.dart';
// import 'package:game_app/data/repositories/objective_repository.dart';
// import 'package:game_app/utils/snackbar_helper.dart';
// import 'package:get/get.dart';
//
// import '../generated/models/responses/objectives/objectives_response.dart';
//
// class KeyObjectiveController extends GetxController {
//   // Observables
//   final RxBool loading = false.obs;
//   final RxList<Objective> objectives = RxList<Objective>();
//   final ObjectiveRepository repo = Get.find<ObjectiveRepository>();
//   final Rxn<Objective> selectedObjective = Rxn<Objective>();
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Ensure dependencies are available
//     _validateDependencies();
//   }
//
//   // Validate that required controllers are registered
//   void _validateDependencies() {
//     try {
//       Get.find<StrategySelectionController>();
//       Get.find<LanguageController>();
//     } catch (e) {
//       log('Required controllers not found: $e');
//       SnackbarHelper.error('Application error: Required dependencies missing.');
//     }
//   }
//
//   Future<void> getObjectives(
//       Map<String, dynamic> role,
//       Map<String, dynamic> industry,
//       ) async {
//     try {
//       loading.value = true;
//       final strategy = Get.find<StrategySelectionController>().selectedStrategy.value;
//       if (strategy == null) {
//         throw Exception('No strategy selected');
//       }
//       final response = await repo.generateObjectives(
//         strategyId: strategy.strategyId!,
//         strategy: strategy.title!,
//         role: role['title']?.toString() ?? '',
//         industry: industry['titleKey']?.toString() ?? '',
//         language: Get.find<LanguageController>().selectedLanguage.value.name.toLowerCase(),
//       );
//       objectives.assignAll(response); // Replace existing objectives
//     } catch (e, s) {
//       log('Error fetching objectives: $e', stackTrace: s);
//       SnackbarHelper.error('Failed to load objectives. Using fallback data.');
//       // Fallback to static data
//       objectives.assignAll([
//         Objective(
//           title: 'expand_product_line',
//           description: 'introduce_new_products',
//         ),
//         Objective(
//           title: 'improve_customer_experience',
//           description: 'enhance_satisfaction',
//         ),
//         Objective(
//           title: 'increase_market_share',
//           description: 'gain_significant_presence',
//         ),
//       ]);
//     } finally {
//       loading.value = false;
//     }
//   }
//
//   // Toggle objective selection
//   void selectObjective(Objective objective) {
//     if (selectedObjective.value == objective) {
//       selectedObjective.value = null; // Deselect if clicked again
//     } else {
//       selectedObjective.value = objective; // Select new objective
//     }
//   }
//
//   // Check if objective is selected
//   bool isSelected(Objective objective) => selectedObjective.value == objective;
//
//   // Button enabled only when something is selected
//   bool get isButtonEnabled => selectedObjective.value != null;
//
//   // Get selected objective title key
//   String get selectedTitleKey => selectedObjective.value?.title ?? '';
// }