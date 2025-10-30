// // lib/controllers/team_mode_controller/team_suggestion_initiative_controller.dart
//
// lib/controllers/team_mode_controller/team_suggestion_initiative_controller.dart

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:game_app/controllers/team_mode_controller/team_contextual_challange_controller.dart';
import 'package:get/get.dart';
import 'package:game_app/controllers/team_mode_controller/team_objective_controller.dart';
import 'package:game_app/controllers/team_mode_controller/team_strategy_selection_controller.dart';
import 'package:game_app/controllers/language_controller.dart';
import 'package:game_app/data/repositories/strategy_repository.dart';
import 'package:game_app/generated/models/responses/key_results/key_results_response.dart';
import '../../presentation/routes/app_routes.dart';
import '../../utils/snackbar_helper.dart';

class TeamSuggestionInitiativesController extends GetxController {
// Fix: The core data list
  final List<KeyResult> keyResults;

// New: Flag for conditional navigation
  final RxBool isChallengeMode = false.obs;

// UI mapping (Industries/Context)
  final RxList<Map<String, dynamic>> industries = <Map<String, dynamic>>[].obs;
  final RxInt selectedIndustry = 0.obs;

// Constructor
  TeamSuggestionInitiativesController({required this.keyResults});

  final firstInitiativeTitle = TextEditingController();
  final firstInitiativeDesc = TextEditingController();
  final secondInitiativeTitle = TextEditingController();
  final secondInitiativeDesc = TextEditingController();

  var aiFeedback = ''.obs;
  final RxBool isSubmitting = false.obs;

// NEW: Reactive property to track if all fields are filled
  final RxBool isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    log('TeamSuggestionInitiativesController: onInit called.');

    final args = Get.arguments as Map<String, dynamic>?;
    isChallengeMode.value = args?['isChallengeMode'] ?? false;

// ✅ FIX 1: Reset submitting state when screen is initialized to handle stuck state
    isSubmitting.value = false;
    log('TeamSuggestionInitiativesController: isSubmitting set to ${isSubmitting.value}');

    _loadDataOrClearFormFields();

    _loadIndustries();

// Initialize listeners for all text fields
    _addFormListeners();
  }
  void _loadDataOrClearFormFields() {
    if (isChallengeMode.value && Get.isRegistered<TeamContextualChallengeController>()) {
      final challengeController = Get.find<TeamContextualChallengeController>();
      final existingInitiatives = challengeController.finalInitiatives;

      if (existingInitiatives.length >= 2) {
        // Load existing initiatives for revision
        final init1Parts = existingInitiatives[0].split(' - ');
        final init2Parts = existingInitiatives[1].split(' - ');

        firstInitiativeTitle.text = init1Parts.isNotEmpty ? init1Parts[0].trim() : '';
        firstInitiativeDesc.text = init1Parts.length > 1 ? init1Parts[1].trim() : '';

        secondInitiativeTitle.text = init2Parts.isNotEmpty ? init2Parts[0].trim() : '';
        secondInitiativeDesc.text = init2Parts.length > 1 ? init2Parts[1].trim() : '';

        log('TeamSuggestionInitiativesController: Initiatives pre-filled.');

        // ✅ FIX: Manually update validation after pre-filling
        _updateFormValidStatus();
        return;
      }
    }

    // Normal flow or no existing data: clear fields
    firstInitiativeTitle.clear();
    firstInitiativeDesc.clear();
    secondInitiativeTitle.clear();
    secondInitiativeDesc.clear();
    isFormValid.value = false;
    log('TeamSuggestionInitiativesController: Initiatives cleared.');
  }

// Helper function to add listeners and update status
  void _addFormListeners() {
    [firstInitiativeTitle, firstInitiativeDesc, secondInitiativeTitle, secondInitiativeDesc].forEach((controller) {
      controller.addListener(_updateFormValidStatus);
    });
    _updateFormValidStatus(); // Initial check
  }

// Helper function to calculate form validity
  void _updateFormValidStatus() {
    isFormValid.value =
        firstInitiativeTitle.text.trim().isNotEmpty &&
            firstInitiativeDesc.text.trim().isNotEmpty &&
            secondInitiativeTitle.text.trim().isNotEmpty &&
            secondInitiativeDesc.text.trim().isNotEmpty;
// Log the current state for debugging the button status
    log('TeamSuggestionInitiativesController: Initiative Form Valid: ${isFormValid.value}');
  }

// Getter to combine validity and loading state
  bool get isButtonEnabled => isFormValid.value && !isSubmitting.value;

  /// Map KeyResult objects to the generic Map structure required by UI widgets
  void _loadIndustries() {
    if (keyResults.isNotEmpty) {
      industries.assignAll(keyResults.map((kr) => {
        'title': kr.title,
        'description': kr.description,
        'icon': Icons.star,
      }).toList());
    } else {
      industries.clear();
    }
  }

  /// Submit initiatives for AI evaluation (Team Version)
  Future<void> submitInitiatives() async {
    final List<KeyResult> finalKeyResults = keyResults;

    if (!isFormValid.value) {
      Get.snackbar('error'.tr, 'fill_initiatives'.tr, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isSubmitting.value = true; // 1. SET TRUE AT START
      log('TeamSuggestionInitiativesController: Submission started. isSubmitting=${isSubmitting.value}');

// Gather data for API call
      final strategyTitle = Get.find<TeamStrategySelectionController>().selectedStrategy.value;
      final objectiveTitle = Get.find<TeamObjectiveController>().selectedObjective.value!.title!;
      final language = Get.find<LanguageController>().selectedLanguage.value.name;

      final initiatives = [
        '${firstInitiativeTitle.text.trim()} - ${firstInitiativeDesc.text.trim()}',
        '${secondInitiativeTitle.text.trim()} - ${secondInitiativeDesc.text.trim()}',
      ];

// API Call: POST /evaluate-initiatives
      final response = await Get.find<StrategyRepository>().submitInitiatives( //
        strategy: strategyTitle,
        objective: objectiveTitle,
        initiatives: initiatives,
        keyResults: finalKeyResults,
        language: language,
      );

// Store initiatives in challenge controller for display
      Get.find<TeamContextualChallengeController>().finalInitiatives.assignAll(initiatives);

      aiFeedback.value = response.message ?? 'initiatives_submitted_successfully'.tr;
      SnackbarHelper.success(response.message ?? 'Initiatives submitted.');

// --- Navigation Logic ---
// --- Navigation Logic ---
      if (isChallengeMode.value) {
        log("TeamSuggestionInitiativesController: Challenge Mode detected. Navigating back to Contextual Challenge screen.");

        // Reset submitting flag
        isSubmitting.value = false;

        // Update the contextual challenge controller with the new initiatives
        final challengeController = Get.find<TeamContextualChallengeController>();
        challengeController.finalInitiatives.assignAll(initiatives);
        challengeController.update();

        // Small delay for smoother UX before navigation
        await Future.delayed(const Duration(milliseconds: 300));

        // ✅ Navigate back directly to Contextual Challenge Screen
        Get.offNamed(AppRoutes.teamContextualChallengeScreen, arguments: {'refreshed': true});
        return;
      }

      else {
        // NORMAL FLOW
        isSubmitting.value = false; // Reset for normal flow success
        await Get.toNamed(
          AppRoutes.teamaiAnalysisScreen,
          arguments:response,
        );
      }
    } catch (e) {
      log('TeamSuggestionInitiativesController: Submission failed: $e');
      // ✅ FIX 3: Guaranteed Reset on Error
      isSubmitting.value = false;
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
// Remove listeners to prevent memory leaks
    [firstInitiativeTitle, firstInitiativeDesc, secondInitiativeTitle, secondInitiativeDesc].forEach((controller) {
      controller.removeListener(_updateFormValidStatus);
    });

    firstInitiativeTitle.dispose();
    firstInitiativeDesc.dispose();
    secondInitiativeTitle.dispose();
    secondInitiativeDesc.dispose();
    super.onClose();
  }
}
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:game_app/controllers/team_mode_controller/team_contextual_challange_controller.dart';
// import 'package:get/get.dart';
// import 'package:game_app/controllers/team_mode_controller/team_objective_controller.dart';
// import 'package:game_app/controllers/team_mode_controller/team_strategy_selection_controller.dart';
// import 'package:game_app/controllers/language_controller.dart';
// import 'package:game_app/data/repositories/strategy_repository.dart';
// import 'package:game_app/generated/models/responses/key_results/key_results_response.dart';
// import '../../presentation/routes/app_routes.dart';
// import '../../utils/snackbar_helper.dart';
//
// class TeamSuggestionInitiativesController extends GetxController {
// // Fix: The core data list
// final List<KeyResult> keyResults;
//
// // New: Flag for conditional navigation
// final RxBool isChallengeMode = false.obs;
//
// // UI mapping (Industries/Context)
// final RxList<Map<String, dynamic>> industries = <Map<String, dynamic>>[].obs;
// final RxInt selectedIndustry = 0.obs;
//
// // Constructor
// TeamSuggestionInitiativesController({required this.keyResults});
//
// final firstInitiativeTitle = TextEditingController();
// final firstInitiativeDesc = TextEditingController();
// final secondInitiativeTitle = TextEditingController();
// final secondInitiativeDesc = TextEditingController();
//
// var aiFeedback = ''.obs;
// final RxBool isSubmitting = false.obs;
//
// // NEW: Reactive property to track if all fields are filled
// final RxBool isFormValid = false.obs;
//
// @override
// void onInit() {
// super.onInit();
//
// // ✅ FIX 1: Retrieve Flag from arguments (when navigating from Contextual Challenge)
// final args = Get.arguments as Map<String, dynamic>?;
// isChallengeMode.value = args?['isChallengeMode'] ?? false;
//
// // ✅ FIX 2: Reset submitting state when screen is initialized
// isSubmitting.value = false;
//
// // ✅ FIX 3: Clear form fields when navigating to screen
// _clearFormFields();
//
// _loadIndustries();
//
// // [FIX 3: ADD LISTENERS] Initialize listeners for all text fields
// _addFormListeners();
// }
//
// // Helper function to clear form fields
// void _clearFormFields() {
//   firstInitiativeTitle.clear();
//   firstInitiativeDesc.clear();
//   secondInitiativeTitle.clear();
//   secondInitiativeDesc.clear();
//   isFormValid.value = false;
// }
//
// // Helper function to add listeners and update status
// void _addFormListeners() {
// [firstInitiativeTitle, firstInitiativeDesc, secondInitiativeTitle, secondInitiativeDesc].forEach((controller) {
// controller.addListener(_updateFormValidStatus);
// });
// _updateFormValidStatus(); // Initial check
// }
//
// // Helper function to calculate form validity
// void _updateFormValidStatus() {
// isFormValid.value =
// firstInitiativeTitle.text.trim().isNotEmpty &&
// firstInitiativeDesc.text.trim().isNotEmpty &&
// secondInitiativeTitle.text.trim().isNotEmpty &&
// secondInitiativeDesc.text.trim().isNotEmpty;
// // Log the current state for debugging the button status
// log('Initiative Form Valid: ${isFormValid.value}');
// }
//
// // [FIX 3: REACTIVE BUTTON STATE] Getter to combine validity and loading state
// bool get isButtonEnabled => isFormValid.value && !isSubmitting.value;
//
// /// Map KeyResult objects to the generic Map structure required by UI widgets
// void _loadIndustries() {
// if (keyResults.isNotEmpty) {
// industries.assignAll(keyResults.map((kr) => {
//  'title': kr.title,
//  'description': kr.description,
//  'icon': Icons.star,
// }).toList());
// } else {
// industries.clear();
// }
// }
//
// /// ✅ Submit initiatives for AI evaluation (Team Version)
// Future<void> submitInitiatives() async {
// final List<KeyResult> finalKeyResults = keyResults;
//
// if (!isFormValid.value) {
// Get.snackbar('error'.tr, 'fill_initiatives'.tr, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
// return;
// }
//
// try {
// isSubmitting.value = true; // 1. SET TRUE AT START
//
// // Gather data for API call
// final strategyTitle = Get.find<TeamStrategySelectionController>().selectedStrategy.value;
// final objectiveTitle = Get.find<TeamObjectiveController>().selectedObjective.value!.title!;
// final language = Get.find<LanguageController>().selectedLanguage.value.name;
//
// final initiatives = [
//  '${firstInitiativeTitle.text.trim()} - ${firstInitiativeDesc.text.trim()}',
//  '${secondInitiativeTitle.text.trim()} - ${secondInitiativeDesc.text.trim()}',
// ];
//
// // API Call: POST /evaluate-initiatives
// final response = await Get.find<StrategyRepository>().submitInitiatives( //
//  strategy: strategyTitle,
//  objective: objectiveTitle,
//  initiatives: initiatives,
//  keyResults: finalKeyResults,
//  language: language,
// );
//
// // Store initiatives in challenge controller for display
// Get.find<TeamContextualChallengeController>().finalInitiatives.assignAll(initiatives);
//
// aiFeedback.value = response.message ?? 'initiatives_submitted_successfully'.tr;
// SnackbarHelper.success(response.message ?? 'Initiatives submitted.'); // Show success message
// if (isChallengeMode.value) {
//   log("Navigating back to Contextual Challenge Screen after initiative revision.");
//
//   // 1. Reset the submit button so it doesn't stay grey
//   isSubmitting.value = false;
//
//   // 2. Small delay to ensure UI updates
//   await Future.delayed(Duration(milliseconds: 200));
//
//   // 3. Go back to previous screen and send a result
//   Get.back(result: {'refreshed': true});
//
//   // 4. Stop further code execution in this function
//   return;
// }
//
// else {
//  // NORMAL FLOW: Proceed to AI Analysis screen
//  await Get.toNamed(
//  AppRoutes.teamaiAnalysisScreen, //
//  arguments:response, //
//  );
// }
// } catch (e) {
// Get.snackbar(
//  'error'.tr,
//  e.toString(),
//  snackPosition: SnackPosition.BOTTOM,
//  backgroundColor: Colors.red,
//  colorText: Colors.white,
// );
// } finally {
// // This block runs only if the normal flow finishes or an error occurs.
// // In CHALLENGE mode, it was explicitly reset and exited above.
//  if (!isChallengeMode.value) {
//  isSubmitting.value = false;
//  }
// }
// }
//
// @override
// void onClose() {
// // [FIX 5: REMOVE LISTENERS] Prevent memory leaks
// [firstInitiativeTitle, firstInitiativeDesc, secondInitiativeTitle, secondInitiativeDesc].forEach((controller) {
//  controller.removeListener(_updateFormValidStatus);
// });
//
// firstInitiativeTitle.dispose();
// firstInitiativeDesc.dispose();
// secondInitiativeTitle.dispose();
// secondInitiativeDesc.dispose();
// super.onClose();
// }
// }