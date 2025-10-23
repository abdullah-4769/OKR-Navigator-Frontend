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
 
 // ✅ FIX 1: Retrieve Flag from arguments
 final args = Get.arguments as Map<String, dynamic>?;
 isChallengeMode.value = args?['isChallengeMode'] ?? false;
 
 _loadIndustries();

 // [FIX 2: ADD LISTENERS] Initialize listeners for all text fields
 _addFormListeners();
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
 log('Initiative Form Valid: ${isFormValid.value}');
}

// [FIX 3: REACTIVE BUTTON STATE] Getter to combine validity and loading state
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

/// ✅ Submit initiatives for AI evaluation (Team Version)
Future<void> submitInitiatives() async {
 final List<KeyResult> finalKeyResults = keyResults; 

 if (!isFormValid.value) {
 Get.snackbar('error'.tr, 'fill_initiatives'.tr, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
 return;
 }

 try {
 isSubmitting.value = true; // 1. SET TRUE AT START

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
Get.find<TeamContextualChallengeController>().finalInitiatives.assignAll(initiatives);
 
 aiFeedback.value = response.message ?? 'initiatives_submitted_successfully'.tr;

 // ✅ Conditional Navigation check
 if (isChallengeMode.value) {
  // CHALLENGE FLOW: Must reset flag BEFORE navigation
  isSubmitting.value = false; // <-- FIX: Explicit reset for challenge flow.
  Get.offNamed(AppRoutes.teamContextualChallengeScreen); //
       return; // Exit here
 } else {
  // NORMAL FLOW: Proceed to AI Analysis screen
  await Get.toNamed(
   AppRoutes.teamaiAnalysisScreen, //
   arguments:response, //
  );
 }
 } catch (e) {
 Get.snackbar(
  'error'.tr,
  e.toString(),
  snackPosition: SnackPosition.BOTTOM,
  backgroundColor: Colors.red,
  colorText: Colors.white,
 );
 } finally {
 // This handles errors in both modes and the successful end of the Normal flow.
  if (!isChallengeMode.value) { // Only reset here if not challenge mode (where it was already reset)
   isSubmitting.value = false;
  }
 }
}

@override
void onClose() {
 // [FIX 5: REMOVE LISTENERS] Prevent memory leaks
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