import 'package:flutter/material.dart';
import 'package:game_app/controllers/key_objective_controller.dart';
import 'package:game_app/controllers/language_controller.dart';
import 'package:game_app/controllers/strategy_selection_controller.dart';
import 'package:game_app/generated/models/responses/key_results/key_results_response.dart';
import 'package:game_app/generated/models/responses/evaluate_initiative/evaluate_initiative_model.dart';
import 'package:get/get.dart';
import '../../../../core/app_colors.dart';
import '../../../../data/repositories/evaluate_initiative_repo.dart';
import '../../../../data/response/api_response.dart';
import '../../../../data/response/status.dart';
import '../../../../presentation/routes/app_routes.dart';
import '../../../../services/shared_preference.dart';

class SuggestionInitiativesViewModel extends GetxController {
  final firstInitiativeTitle = TextEditingController();
  final firstInitiativeDesc = TextEditingController();
  final secondInitiativeTitle = TextEditingController();
  final secondInitiativeDesc = TextEditingController();

  final EvaluateInitiativeRepository _repository = EvaluateInitiativeRepository();
  var isSubmitting = false.obs;
  var apiResponse = Rx<ApiResponse<EvaluateInitiativeModel>>(ApiResponse.loading());
  var isCampaignMode = false.obs;

  // ✅ Track source
  final bool _isModifyFromContextual = Get.parameters['source'] == 'contextual_challenge';
  final bool _isNormalFlow = !Get.parameters.containsKey('source');

  @override
  void onInit() {
    super.onInit();
    _checkGameMode();
    _loadSavedInitiatives(); // Load saved initiatives when view model initializes
    _setupAutoSave(); // Set up auto-save listeners

    print('🎯 Initiatives ViewModel Source:');
    print('   - Modify from Contextual: $_isModifyFromContextual');
    print('   - Normal Flow: $_isNormalFlow');
  }

  Future<void> _checkGameMode() async {
    final savedMode = await SharedPrefs.getGameMode();
    isCampaignMode.value = savedMode == 'campaign';
    print('🎮 SuggestionInitiativesViewModel - Game Mode: $savedMode, Is Campaign: ${isCampaignMode.value}');
  }

  // 🔹 LOAD SAVED INITIATIVES FROM SHAREDPREFERENCES
  void _loadSavedInitiatives() {
    final savedInitiatives = SharedPrefs.getInitiatives();

    firstInitiativeTitle.text = savedInitiatives['firstTitle'] ?? '';
    firstInitiativeDesc.text = savedInitiatives['firstDesc'] ?? '';
    secondInitiativeTitle.text = savedInitiatives['secondTitle'] ?? '';
    secondInitiativeDesc.text = savedInitiatives['secondDesc'] ?? '';

    print('📝 Loaded saved initiatives from SharedPreferences');
    print('First Initiative: ${firstInitiativeTitle.text} - ${firstInitiativeDesc.text}');
    print('Second Initiative: ${secondInitiativeTitle.text} - ${secondInitiativeDesc.text}');
  }

  // 🔹 SET UP AUTO-SAVE LISTENERS
  void _setupAutoSave() {
    firstInitiativeTitle.addListener(_saveInitiatives);
    firstInitiativeDesc.addListener(_saveInitiatives);
    secondInitiativeTitle.addListener(_saveInitiatives);
    secondInitiativeDesc.addListener(_saveInitiatives);
    print('🔔 Auto-save listeners set up for initiatives');
  }

  // 🔹 SAVE INITIATIVES TO SHAREDPREFERENCES
  void _saveInitiatives() {
    SharedPrefs.saveInitiatives(
      firstTitle: firstInitiativeTitle.text.trim(),
      firstDesc: firstInitiativeDesc.text.trim(),
      secondTitle: secondInitiativeTitle.text.trim(),
      secondDesc: secondInitiativeDesc.text.trim(),
    );
    print('💾 Auto-saved initiatives to SharedPreferences');
  }

  // 🔹 MANUALLY SAVE INITIATIVES (can be called from UI if needed)
  Future<void> saveInitiativesToStorage() async {
    await SharedPrefs.saveInitiatives(
      firstTitle: firstInitiativeTitle.text.trim(),
      firstDesc: firstInitiativeDesc.text.trim(),
      secondTitle: secondInitiativeTitle.text.trim(),
      secondDesc: secondInitiativeDesc.text.trim(),
    );
    print('💾 Manually saved initiatives to SharedPreferences');
  }

  // 🔹 CLEAR SAVED INITIATIVES (useful when starting new session)
  Future<void> clearSavedInitiatives() async {
    await SharedPrefs.clearInitiatives();
    firstInitiativeTitle.clear();
    firstInitiativeDesc.clear();
    secondInitiativeTitle.clear();
    secondInitiativeDesc.clear();
    print('🗑️ Cleared saved initiatives from SharedPreferences');
  }

  Future<void> submitInitiatives(List<KeyResult> selectedKeyResults) async {
    print('Submitting initiatives...');
    print('Selected Key Results: $selectedKeyResults');
    print('Is Campaign Mode: ${isCampaignMode.value}');
    print('Source - Modify from Contextual: $_isModifyFromContextual');

    // Input validation
    if (firstInitiativeTitle.text.trim().isEmpty ||
        firstInitiativeDesc.text.trim().isEmpty ||
        secondInitiativeTitle.text.trim().isEmpty ||
        secondInitiativeDesc.text.trim().isEmpty) {
      print('Validation failed: One or more input fields are empty');
      Get.snackbar(
        'error'.tr,
        'fill_initiatives'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    try {
      isSubmitting.value = true;
      apiResponse.value = ApiResponse.loading();

      // 🔹 SAVE INITIATIVES BEFORE SUBMISSION (final save)
      await saveInitiativesToStorage();

      // Fetch controller data
      final strategyController = Get.find<StrategySelectionController>();
      final objectiveController = Get.find<KeyObjectiveController>();
      final languageController = Get.find<LanguageController>();

      final strategyTitle = strategyController.selectedStrategy.value?.title;
      final objectiveTitle = objectiveController.selectedObjective.value?.title;
      final language = languageController.selectedLanguage.value.name;

      print('Strategy Title: $strategyTitle');
      print('Objective Title: $objectiveTitle');
      print('Language: $language');

      if (strategyTitle == null || objectiveTitle == null) {
        print('Validation failed: Strategy or Objective is null');
        apiResponse.value = ApiResponse.error('Required data not found');
        Get.snackbar(
          'error'.tr,
          'Required data not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      // ✅ Handle Campaign Mode - Get organization data
      String industryOrOrganization = '';
      if (isCampaignMode.value) {
        final organizationData = SharedPrefs.getSelectedIndustry();
        if (organizationData != null) {
          industryOrOrganization = organizationData['titleKey']?.toString() ?? 'organization_a';
          print('🎯 Campaign Mode: Using organization - $industryOrOrganization');
        } else {
          print('⚠️ Campaign Mode: No organization data found, using default');
          industryOrOrganization = 'organization_a';
        }
      } else {
        // Solo Mode - Get industry data from arguments
        final args = Get.arguments as Map<String, dynamic>?;
        final selectedIndustry = args?['selectedIndustry'] as Map<String, dynamic>?;
        industryOrOrganization = selectedIndustry?['titleKey']?.toString() ?? '';
        print('🎯 Solo Mode: Using industry - $industryOrOrganization');
      }

      final initiatives = [
        '${firstInitiativeTitle.text.trim()} - ${firstInitiativeDesc.text.trim()}',
        '${secondInitiativeTitle.text.trim()} - ${secondInitiativeDesc.text.trim()}',
      ];

      print('Initiatives: $initiatives');
      print('Industry/Organization: $industryOrOrganization');

      // API call
      final response = await _repository.evaluateInitiatives(
        strategy: strategyTitle,
        objective: objectiveTitle,
        initiatives: initiatives,
        keyResults: selectedKeyResults,
        language: language,
        industry: industryOrOrganization, // ✅ Pass industry/organization to API
      );

      print('API Response Status: ${response.status}');
      print('API Response Data: ${response.data?.toJson()}');
      print('API Response Message: ${response.message}');

      // Check status
      print('Is Status.completed: ${response.status == Status.completed}');
      print('Is Data Not Null: ${response.data != null}');

      apiResponse.value = response;

      // Compare with Status.completed
      if (response.status == Status.completed && response.data != null) {
        print('Success: API response received successfully');

        // 🔹 OPTIONAL: Clear initiatives after successful submission
        // Uncomment the line below if you want to clear initiatives after successful submission
        // await clearSavedInitiatives();

        Get.snackbar(
          'success'.tr,
          'Initiatives evaluated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        await Future.delayed(const Duration(milliseconds: 500));

        // ✅ DIFFERENT NAVIGATION BASED ON SOURCE
        if (_isModifyFromContextual) {
          // Return to contextual challenge screen after successful submission
          print('🔄 Returning to Contextual Challenge screen');
          Get.back(); // Go back to contextual challenge
          Get.snackbar(
            'Success',
            'Initiatives revised successfully',
            backgroundColor: AppColors.primaryGreen,
            colorText: Colors.white,
          );
          //Get.back();
        } else {
          // Normal flow - go to analysis screen
          print('➡️ Navigating to AI Analysis screen');
          Get.toNamed(
            AppRoutes.aiAnalysisShowScreen,
            arguments: response.data,
          );
        }
      } else {
        print('Error: API response validation failed');
        print('Status: ${response.status}, Data: ${response.data}, Message: ${response.message}');
        Get.snackbar(
          'error'.tr,
          response.message ?? 'Failed to process API response',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('Exception caught: $e');
      apiResponse.value = ApiResponse.error(e.toString());
      Get.snackbar(
        'error'.tr,
        'Error: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isSubmitting.value = false;
      print('isSubmitting reset to: ${isSubmitting.value}');
    }
  }

  EvaluateInitiativeModel? get evaluationResult => apiResponse.value.data;

  // Use Status.completed
  bool get hasData => apiResponse.value.status == Status.completed;

  // ✅ Get source information (useful for UI)
  bool get isModifyFromContextual => _isModifyFromContextual;
  bool get isNormalFlow => _isNormalFlow;

  @override
  void onClose() {
    // Remove listeners to prevent memory leaks
    firstInitiativeTitle.removeListener(_saveInitiatives);
    firstInitiativeDesc.removeListener(_saveInitiatives);
    secondInitiativeTitle.removeListener(_saveInitiatives);
    secondInitiativeDesc.removeListener(_saveInitiatives);

    firstInitiativeTitle.dispose();
    firstInitiativeDesc.dispose();
    secondInitiativeTitle.dispose();
    secondInitiativeDesc.dispose();
    super.onClose();
  }
}









// import 'package:flutter/material.dart';
// import 'package:game_app/controllers/key_objective_controller.dart';
// import 'package:game_app/controllers/language_controller.dart';
// import 'package:game_app/controllers/strategy_selection_controller.dart';
// import 'package:game_app/generated/models/responses/key_results/key_results_response.dart';
// import 'package:game_app/generated/models/responses/evaluate_initiative/evaluate_initiative_model.dart';
// import 'package:get/get.dart';
// import '../../../../data/repositories/evaluate_initiative_repo.dart';
// import '../../../../data/response/api_response.dart';
// import '../../../../data/response/status.dart';
// import '../../../../presentation/routes/app_routes.dart';
// import '../../../../services/shared_preference.dart';
//
// class SuggestionInitiativesViewModel extends GetxController {
//   final firstInitiativeTitle = TextEditingController();
//   final firstInitiativeDesc = TextEditingController();
//   final secondInitiativeTitle = TextEditingController();
//   final secondInitiativeDesc = TextEditingController();
//
//   final EvaluateInitiativeRepository _repository = EvaluateInitiativeRepository();
//   var isSubmitting = false.obs;
//   var apiResponse = Rx<ApiResponse<EvaluateInitiativeModel>>(ApiResponse.loading());
//   var isCampaignMode = false.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _checkGameMode();
//     _loadSavedInitiatives(); // Load saved initiatives when view model initializes
//     _setupAutoSave(); // Set up auto-save listeners
//     firstInitiativeTitle;
//     firstInitiativeDesc;
//     secondInitiativeTitle;
//     secondInitiativeDesc;
//   }
//
//   Future<void> _checkGameMode() async {
//     final savedMode = await SharedPrefs.getGameMode();
//     isCampaignMode.value = savedMode == 'campaign';
//     print('🎮 SuggestionInitiativesViewModel - Game Mode: $savedMode, Is Campaign: ${isCampaignMode.value}');
//   }
//
//   // 🔹 LOAD SAVED INITIATIVES FROM SHAREDPREFERENCES
//   void _loadSavedInitiatives() {
//     final savedInitiatives = SharedPrefs.getInitiatives();
//
//     firstInitiativeTitle.text = savedInitiatives['firstTitle'] ?? '';
//     firstInitiativeDesc.text = savedInitiatives['firstDesc'] ?? '';
//     secondInitiativeTitle.text = savedInitiatives['secondTitle'] ?? '';
//     secondInitiativeDesc.text = savedInitiatives['secondDesc'] ?? '';
//
//     print('📝 Loaded saved initiatives from SharedPreferences');
//     print('First Initiative: ${firstInitiativeTitle.text} - ${firstInitiativeDesc.text}');
//     print('Second Initiative: ${secondInitiativeTitle.text} - ${secondInitiativeDesc.text}');
//   }
//
//   // 🔹 SET UP AUTO-SAVE LISTENERS
//   void _setupAutoSave() {
//     firstInitiativeTitle.addListener(_saveInitiatives);
//     firstInitiativeDesc.addListener(_saveInitiatives);
//     secondInitiativeTitle.addListener(_saveInitiatives);
//     secondInitiativeDesc.addListener(_saveInitiatives);
//     print('🔔 Auto-save listeners set up for initiatives');
//   }
//
//   // 🔹 SAVE INITIATIVES TO SHAREDPREFERENCES
//   void _saveInitiatives() {
//     SharedPrefs.saveInitiatives(
//       firstTitle: firstInitiativeTitle.text.trim(),
//       firstDesc: firstInitiativeDesc.text.trim(),
//       secondTitle: secondInitiativeTitle.text.trim(),
//       secondDesc: secondInitiativeDesc.text.trim(),
//     );
//     print('💾 Auto-saved initiatives to SharedPreferences');
//   }
//
//   // 🔹 MANUALLY SAVE INITIATIVES (can be called from UI if needed)
//   Future<void> saveInitiativesToStorage() async {
//     await SharedPrefs.saveInitiatives(
//       firstTitle: firstInitiativeTitle.text.trim(),
//       firstDesc: firstInitiativeDesc.text.trim(),
//       secondTitle: secondInitiativeTitle.text.trim(),
//       secondDesc: secondInitiativeDesc.text.trim(),
//     );
//     print('💾 Manually saved initiatives to SharedPreferences');
//   }
//
//   // 🔹 CLEAR SAVED INITIATIVES (useful when starting new session)
//   Future<void> clearSavedInitiatives() async {
//     await SharedPrefs.clearInitiatives();
//     firstInitiativeTitle.clear();
//     firstInitiativeDesc.clear();
//     secondInitiativeTitle.clear();
//     secondInitiativeDesc.clear();
//     print('🗑️ Cleared saved initiatives from SharedPreferences');
//   }
//
//   Future<void> submitInitiatives(List<KeyResult> selectedKeyResults) async {
//     print('Submitting initiatives...');
//     print('Selected Key Results: $selectedKeyResults');
//     print('Is Campaign Mode: ${isCampaignMode.value}');
//
//     // Input validation
//     if (firstInitiativeTitle.text.trim().isEmpty ||
//         firstInitiativeDesc.text.trim().isEmpty ||
//         secondInitiativeTitle.text.trim().isEmpty ||
//         secondInitiativeDesc.text.trim().isEmpty) {
//       print('Validation failed: One or more input fields are empty');
//       Get.snackbar(
//         'error'.tr,
//         'fill_initiatives'.tr,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 3),
//       );
//       return;
//     }
//
//     try {
//       isSubmitting.value = true;
//       apiResponse.value = ApiResponse.loading();
//
//       // 🔹 SAVE INITIATIVES BEFORE SUBMISSION (final save)
//       await saveInitiativesToStorage();
//
//       // Fetch controller data
//       final strategyController = Get.find<StrategySelectionController>();
//       final objectiveController = Get.find<KeyObjectiveController>();
//       final languageController = Get.find<LanguageController>();
//
//       final strategyTitle = strategyController.selectedStrategy.value?.title;
//       final objectiveTitle = objectiveController.selectedObjective.value?.title;
//       final language = languageController.selectedLanguage.value.name;
//
//       print('Strategy Title: $strategyTitle');
//       print('Objective Title: $objectiveTitle');
//       print('Language: $language');
//
//       if (strategyTitle == null || objectiveTitle == null) {
//         print('Validation failed: Strategy or Objective is null');
//         apiResponse.value = ApiResponse.error('Required data not found');
//         Get.snackbar(
//           'error'.tr,
//           'Required data not found',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//           duration: const Duration(seconds: 3),
//         );
//         return;
//       }
//
//       // ✅ Handle Campaign Mode - Get organization data
//       String industryOrOrganization = '';
//       if (isCampaignMode.value) {
//         final organizationData = SharedPrefs.getSelectedIndustry();
//         if (organizationData != null) {
//           industryOrOrganization = organizationData['titleKey']?.toString() ?? 'organization_a';
//           print('🎯 Campaign Mode: Using organization - $industryOrOrganization');
//         } else {
//           print('⚠️ Campaign Mode: No organization data found, using default');
//           industryOrOrganization = 'organization_a';
//         }
//       } else {
//         // Solo Mode - Get industry data from arguments
//         final args = Get.arguments as Map<String, dynamic>?;
//         final selectedIndustry = args?['selectedIndustry'] as Map<String, dynamic>?;
//         industryOrOrganization = selectedIndustry?['titleKey']?.toString() ?? '';
//         print('🎯 Solo Mode: Using industry - $industryOrOrganization');
//       }
//
//       final initiatives = [
//         '${firstInitiativeTitle.text.trim()} - ${firstInitiativeDesc.text.trim()}',
//         '${secondInitiativeTitle.text.trim()} - ${secondInitiativeDesc.text.trim()}',
//       ];
//
//       print('Initiatives: $initiatives');
//       print('Industry/Organization: $industryOrOrganization');
//
//       // API call
//       final response = await _repository.evaluateInitiatives(
//         strategy: strategyTitle,
//         objective: objectiveTitle,
//         initiatives: initiatives,
//         keyResults: selectedKeyResults,
//         language: language,
//         industry: industryOrOrganization, // ✅ Pass industry/organization to API
//       );
//
//       print('API Response Status: ${response.status}');
//       print('API Response Data: ${response.data?.toJson()}');
//       print('API Response Message: ${response.message}');
//
//       // Check status
//       print('Is Status.completed: ${response.status == Status.completed}');
//       print('Is Data Not Null: ${response.data != null}');
//
//       apiResponse.value = response;
//
//       // Compare with Status.completed
//       if (response.status == Status.completed && response.data != null) {
//         print('Success: Navigating to AIAnalysisShowScreen with data: ${response.data?.toJson()}');
//
//         // 🔹 OPTIONAL: Clear initiatives after successful submission
//         // Uncomment the line below if you want to clear initiatives after successful submission
//         // await clearSavedInitiatives();
//
//         Get.snackbar(
//           'success'.tr,
//           'Initiatives evaluated successfully',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//           duration: const Duration(seconds: 2),
//         );
//
//         await Future.delayed(const Duration(milliseconds: 500));
//         Get.toNamed(
//           AppRoutes.aiAnalysisShowScreen,
//           arguments: response.data,
//         );
//       } else {
//         print('Error: API response validation failed');
//         print('Status: ${response.status}, Data: ${response.data}, Message: ${response.message}');
//         Get.snackbar(
//           'error'.tr,
//           response.message ?? 'Failed to process API response',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//           duration: const Duration(seconds: 3),
//         );
//       }
//     } catch (e) {
//       print('Exception caught: $e');
//       apiResponse.value = ApiResponse.error(e.toString());
//       Get.snackbar(
//         'error'.tr,
//         'Error: ${e.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 3),
//       );
//     } finally {
//       isSubmitting.value = false;
//       print('isSubmitting reset to: ${isSubmitting.value}');
//     }
//   }
//
//   EvaluateInitiativeModel? get evaluationResult => apiResponse.value.data;
//
//   // Use Status.completed
//   bool get hasData => apiResponse.value.status == Status.completed;
//
//   @override
//   void onClose() {
//     // Remove listeners to prevent memory leaks
//     firstInitiativeTitle.removeListener(_saveInitiatives);
//     firstInitiativeDesc.removeListener(_saveInitiatives);
//     secondInitiativeTitle.removeListener(_saveInitiatives);
//     secondInitiativeDesc.removeListener(_saveInitiatives);
//
//     firstInitiativeTitle.dispose();
//     firstInitiativeDesc.dispose();
//     secondInitiativeTitle.dispose();
//     secondInitiativeDesc.dispose();
//     super.onClose();
//   }
// }
//
//
//
//
// // import 'package:flutter/material.dart';
// // import 'package:game_app/controllers/key_objective_controller.dart';
// // import 'package:game_app/controllers/language_controller.dart';
// // import 'package:game_app/controllers/strategy_selection_controller.dart';
// // import 'package:game_app/generated/models/responses/key_results/key_results_response.dart';
// // import 'package:game_app/generated/models/responses/evaluate_initiative/evaluate_initiative_model.dart';
// // import 'package:get/get.dart';
// // import '../../../../data/repositories/evaluate_initiative_repo.dart';
// // import '../../../../data/response/api_response.dart';
// // import '../../../../data/response/status.dart';
// // import '../../../../presentation/routes/app_routes.dart';
// // import '../../../../services/shared_preference.dart';
// //
// // class SuggestionInitiativesViewModel extends GetxController {
// //   final firstInitiativeTitle = TextEditingController();
// //   final firstInitiativeDesc = TextEditingController();
// //   final secondInitiativeTitle = TextEditingController();
// //   final secondInitiativeDesc = TextEditingController();
// //
// //   final EvaluateInitiativeRepository _repository = EvaluateInitiativeRepository();
// //   var isSubmitting = false.obs;
// //   var apiResponse = Rx<ApiResponse<EvaluateInitiativeModel>>(ApiResponse.loading());
// //   var isCampaignMode = false.obs;
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     _checkGameMode();
// //     _loadSavedInitiatives(); // Load saved initiatives when view model initializes
// //     _setupAutoSave(); // Set up auto-save listeners
// //     firstInitiativeTitle;
// //     firstInitiativeDesc;
// //     secondInitiativeTitle;
// //     secondInitiativeDesc;
// //   }
// //
// //   Future<void> _checkGameMode() async {
// //     final savedMode = await SharedPrefs.getGameMode();
// //     isCampaignMode.value = savedMode == 'campaign';
// //     print('🎮 SuggestionInitiativesViewModel - Game Mode: $savedMode, Is Campaign: ${isCampaignMode.value}');
// //   }
// //
// //   // 🔹 LOAD SAVED INITIATIVES FROM SHAREDPREFERENCES
// //   void _loadSavedInitiatives() {
// //     final savedInitiatives = SharedPrefs.getInitiatives();
// //
// //     firstInitiativeTitle.text = savedInitiatives['firstTitle'] ?? '';
// //     firstInitiativeDesc.text = savedInitiatives['firstDesc'] ?? '';
// //     secondInitiativeTitle.text = savedInitiatives['secondTitle'] ?? '';
// //     secondInitiativeDesc.text = savedInitiatives['secondDesc'] ?? '';
// //
// //     print('📝 Loaded saved initiatives from SharedPreferences');
// //     print('First Initiative: ${firstInitiativeTitle.text} - ${firstInitiativeDesc.text}');
// //     print('Second Initiative: ${secondInitiativeTitle.text} - ${secondInitiativeDesc.text}');
// //   }
// //
// //   // 🔹 SET UP AUTO-SAVE LISTENERS
// //   void _setupAutoSave() {
// //     firstInitiativeTitle.addListener(_saveInitiatives);
// //     firstInitiativeDesc.addListener(_saveInitiatives);
// //     secondInitiativeTitle.addListener(_saveInitiatives);
// //     secondInitiativeDesc.addListener(_saveInitiatives);
// //     print('🔔 Auto-save listeners set up for initiatives');
// //   }
// //
// //   // 🔹 SAVE INITIATIVES TO SHAREDPREFERENCES
// //   void _saveInitiatives() {
// //     SharedPrefs.saveInitiatives(
// //       firstTitle: firstInitiativeTitle.text.trim(),
// //       firstDesc: firstInitiativeDesc.text.trim(),
// //       secondTitle: secondInitiativeTitle.text.trim(),
// //       secondDesc: secondInitiativeDesc.text.trim(),
// //     );
// //     print('💾 Auto-saved initiatives to SharedPreferences');
// //   }
// //
// //   // 🔹 MANUALLY SAVE INITIATIVES (can be called from UI if needed)
// //   Future<void> saveInitiativesToStorage() async {
// //     await SharedPrefs.saveInitiatives(
// //       firstTitle: firstInitiativeTitle.text.trim(),
// //       firstDesc: firstInitiativeDesc.text.trim(),
// //       secondTitle: secondInitiativeTitle.text.trim(),
// //       secondDesc: secondInitiativeDesc.text.trim(),
// //     );
// //     print('💾 Manually saved initiatives to SharedPreferences');
// //   }
// //
// //   // 🔹 CLEAR SAVED INITIATIVES (useful when starting new session)
// //   Future<void> clearSavedInitiatives() async {
// //     await SharedPrefs.clearInitiatives();
// //     firstInitiativeTitle.clear();
// //     firstInitiativeDesc.clear();
// //     secondInitiativeTitle.clear();
// //     secondInitiativeDesc.clear();
// //     print('🗑️ Cleared saved initiatives from SharedPreferences');
// //   }
// //
// //   Future<void> submitInitiatives(List<KeyResult> selectedKeyResults) async {
// //     print('Submitting initiatives...');
// //     print('Selected Key Results: $selectedKeyResults');
// //     print('Is Campaign Mode: ${isCampaignMode.value}');
// //
// //     // Input validation
// //     if (firstInitiativeTitle.text.trim().isEmpty ||
// //         firstInitiativeDesc.text.trim().isEmpty ||
// //         secondInitiativeTitle.text.trim().isEmpty ||
// //         secondInitiativeDesc.text.trim().isEmpty) {
// //       print('Validation failed: One or more input fields are empty');
// //       Get.snackbar(
// //         'error'.tr,
// //         'fill_initiatives'.tr,
// //         snackPosition: SnackPosition.BOTTOM,
// //         backgroundColor: Colors.red,
// //         colorText: Colors.white,
// //         duration: const Duration(seconds: 3),
// //       );
// //       return;
// //     }
// //
// //     try {
// //       isSubmitting.value = true;
// //       apiResponse.value = ApiResponse.loading();
// //
// //       // 🔹 SAVE INITIATIVES BEFORE SUBMISSION (final save)
// //       await saveInitiativesToStorage();
// //
// //       // Fetch controller data
// //       final strategyController = Get.find<StrategySelectionController>();
// //       final objectiveController = Get.find<KeyObjectiveController>();
// //       final languageController = Get.find<LanguageController>();
// //
// //       final strategyTitle = strategyController.selectedStrategy.value?.title;
// //       final objectiveTitle = objectiveController.selectedObjective.value?.title;
// //       final language = languageController.selectedLanguage.value.name;
// //
// //       print('Strategy Title: $strategyTitle');
// //       print('Objective Title: $objectiveTitle');
// //       print('Language: $language');
// //
// //       if (strategyTitle == null || objectiveTitle == null) {
// //         print('Validation failed: Strategy or Objective is null');
// //         apiResponse.value = ApiResponse.error('Required data not found');
// //         Get.snackbar(
// //           'error'.tr,
// //           'Required data not found',
// //           snackPosition: SnackPosition.BOTTOM,
// //           backgroundColor: Colors.red,
// //           colorText: Colors.white,
// //           duration: const Duration(seconds: 3),
// //         );
// //         return;
// //       }
// //
// //       // ✅ Handle Campaign Mode - Get organization data
// //       String industryOrOrganization = '';
// //       if (isCampaignMode.value) {
// //         final organizationData = SharedPrefs.getSelectedIndustry();
// //         if (organizationData != null) {
// //           industryOrOrganization = organizationData['titleKey']?.toString() ?? 'organization_a';
// //           print('🎯 Campaign Mode: Using organization - $industryOrOrganization');
// //         } else {
// //           print('⚠️ Campaign Mode: No organization data found, using default');
// //           industryOrOrganization = 'organization_a';
// //         }
// //       } else {
// //         // Solo Mode - Get industry data from arguments
// //         final args = Get.arguments as Map<String, dynamic>?;
// //         final selectedIndustry = args?['selectedIndustry'] as Map<String, dynamic>?;
// //         industryOrOrganization = selectedIndustry?['titleKey']?.toString() ?? '';
// //         print('🎯 Solo Mode: Using industry - $industryOrOrganization');
// //       }
// //
// //       final initiatives = [
// //         '${firstInitiativeTitle.text.trim()} - ${firstInitiativeDesc.text.trim()}',
// //         '${secondInitiativeTitle.text.trim()} - ${secondInitiativeDesc.text.trim()}',
// //       ];
// //
// //       print('Initiatives: $initiatives');
// //       print('Industry/Organization: $industryOrOrganization');
// //
// //       // API call
// //       final response = await _repository.evaluateInitiatives(
// //         strategy: strategyTitle,
// //         objective: objectiveTitle,
// //         initiatives: initiatives,
// //         keyResults: selectedKeyResults,
// //         language: language,
// //         industry: industryOrOrganization, // ✅ Pass industry/organization to API
// //       );
// //
// //       print('API Response Status: ${response.status}');
// //       print('API Response Data: ${response.data?.toJson()}');
// //       print('API Response Message: ${response.message}');
// //
// //       // Check status
// //       print('Is Status.completed: ${response.status == Status.completed}');
// //       print('Is Data Not Null: ${response.data != null}');
// //
// //       apiResponse.value = response;
// //
// //       // Compare with Status.completed
// //       if (response.status == Status.completed && response.data != null) {
// //         print('Success: Navigating to AIAnalysisShowScreen with data: ${response.data?.toJson()}');
// //
// //         // 🔹 OPTIONAL: Clear initiatives after successful submission
// //         // Uncomment the line below if you want to clear initiatives after successful submission
// //         // await clearSavedInitiatives();
// //
// //         Get.snackbar(
// //           'success'.tr,
// //           'Initiatives evaluated successfully',
// //           snackPosition: SnackPosition.BOTTOM,
// //           backgroundColor: Colors.green,
// //           colorText: Colors.white,
// //           duration: const Duration(seconds: 2),
// //         );
// //
// //         await Future.delayed(const Duration(milliseconds: 500));
// //         Get.toNamed(
// //           AppRoutes.aiAnalysisShowScreen,
// //           arguments: response.data,
// //         );
// //       } else {
// //         print('Error: API response validation failed');
// //         print('Status: ${response.status}, Data: ${response.data}, Message: ${response.message}');
// //         Get.snackbar(
// //           'error'.tr,
// //           response.message ?? 'Failed to process API response',
// //           snackPosition: SnackPosition.BOTTOM,
// //           backgroundColor: Colors.red,
// //           colorText: Colors.white,
// //           duration: const Duration(seconds: 3),
// //         );
// //       }
// //     } catch (e) {
// //       print('Exception caught: $e');
// //       apiResponse.value = ApiResponse.error(e.toString());
// //       Get.snackbar(
// //         'error'.tr,
// //         'Error: ${e.toString()}',
// //         snackPosition: SnackPosition.BOTTOM,
// //         backgroundColor: Colors.red,
// //         colorText: Colors.white,
// //         duration: const Duration(seconds: 3),
// //       );
// //     } finally {
// //       isSubmitting.value = false;
// //       print('isSubmitting reset to: ${isSubmitting.value}');
// //     }
// //   }
// //
// //   EvaluateInitiativeModel? get evaluationResult => apiResponse.value.data;
// //
// //   // Use Status.completed
// //   bool get hasData => apiResponse.value.status == Status.completed;
// //
// //   @override
// //   void onClose() {
// //     // Remove listeners to prevent memory leaks
// //     firstInitiativeTitle.removeListener(_saveInitiatives);
// //     firstInitiativeDesc.removeListener(_saveInitiatives);
// //     secondInitiativeTitle.removeListener(_saveInitiatives);
// //     secondInitiativeDesc.removeListener(_saveInitiatives);
// //
// //     firstInitiativeTitle.dispose();
// //     firstInitiativeDesc.dispose();
// //     secondInitiativeTitle.dispose();
// //     secondInitiativeDesc.dispose();
// //     super.onClose();
// //   }
// // }
