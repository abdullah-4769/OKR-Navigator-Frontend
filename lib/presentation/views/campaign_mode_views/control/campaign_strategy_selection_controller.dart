// // lib/controllers/campaign_strategy_selection_controller.dart
// import 'package:get/get.dart';
// import 'package:game_app/services/shared_preference.dart';
// import '../../../../generated/models/responses/objectives/objectives_response.dart';
// import '../../../../services/key_results_service.dart';
//
// class CampaignStrategySelectionController extends GetxController {
//   final ApiService _apiService = ApiService();
//
//   var loading = false.obs;
//   var objectives = <Objective>[].obs;
//   var selectedObjective = Rxn<Objective>();
//
//   // ✅ Use organization from campaign instead of industry
//   Future<void> getObjectives(Map<String, dynamic> selectedRole) async {
//     try {
//       loading.value = true;
//
//       // ✅ Get the organization from campaign (stored in mission description)
//       final organizationDescription = await SharedPrefs.getMissionDescription();
//       final organizationName = await SharedPrefs.getCampaignSuggestionName();
//
//       print('🎯 Campaign Strategy Selection - Using Organization:');
//       print('   Name: $organizationName');
//       print('   Description: $organizationDescription');
//
//       if (organizationName == null || organizationDescription == null) {
//         throw Exception('No organization found for campaign mode');
//       }
//
//       // ✅ For campaign mode, we use organization instead of industry
//       // You'll need to modify your API to accept organization instead of industry
//       final response = await _apiService.getObjectivesForCampaign(
//         role: selectedRole['role'] ?? selectedRole['title'],
//         organization: organizationName,
//         organizationDescription: organizationDescription,
//       );
//
//       objectives.assignAll(response);
//       loading.value = false;
//
//     } catch (e) {
//       loading.value = false;
//       print('❌ Error fetching campaign objectives: $e');
//       Get.snackbar(
//         'Error'.tr,
//         'Failed to load objectives: $e',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }
//
//   void selectObjective(Objective objective) {
//     if (selectedObjective.value == objective) {
//       selectedObjective.value = null;
//     } else {
//       selectedObjective.value = objective;
//     }
//   }
//
//   bool isSelected(Objective objective) {
//     return selectedObjective.value == objective;
//   }
//
//   bool get isButtonEnabled => selectedObjective.value != null;
// }