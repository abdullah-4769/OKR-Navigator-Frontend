// lib/controllers/team_mode_controller/team_contextual_challange_controller.dart

import 'package:game_app/controllers/team_mode_controller/team_objective_controller.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:get/get.dart';
import 'team_key_results_controller.dart'; 

class TeamContextualChallengeController extends GetxController {
  
  // Dependencies: Find the Team-specific controllers (assumed to be registered in AppBindings)
  // Note: These need to be registered and active for the challenge to work.
  final TeamObjectiveController _objectiveController = Get.find<TeamObjectiveController>();
  final TeamKeyResultsController _keyResultsController = Get.find<TeamKeyResultsController>();

  /// State to hold the current Initiatives (updated upon revision from other screen)
  final RxList<String> finalInitiatives = <String>[].obs;

  var teamName = ''.obs;
  var challengeStatus = ''.obs;
  /// Propose adjustments for the team's strategy
  void proposeAdjustments() {
    Get.toNamed(AppRoutes.teamContextualAdjustmentScreen);
  }
  // --- Dynamic Getters for UI ---
  
  // Objective is from TeamObjectiveController
  String get currentObjectiveTitle => _objectiveController.selectedObjective.value?.title ?? 'expand_emerging_markets';
  String get currentObjectiveDescription => _objectiveController.selectedObjective.value?.description ?? 'objective_description';
  
  // Key Results are from TeamKeyResultsController
  List<Map<String, String>> get displayKeyResults {
      final selectedKR = _keyResultsController.getSelectedKeyResults();
      if(selectedKR.isEmpty) return []; 
      
      return selectedKR.map((kr) => {
          'title': kr.title ?? 'achieve_revenue_new_products', 
          'description': kr.description ?? 'generate_revenue_stream',
      }).toList();
  }

  // Initiatives are managed locally (finalInitiatives list)
  List<Map<String, String>> get displayInitiatives {
      if (finalInitiatives.isEmpty) return [];

      return finalInitiatives.map((i) {
          // Initiatives are stored as "Title - Description"
          final parts = i.split(' - ');
          return {
              'title': parts.length > 0 ? parts[0] : 'Initiative Title',
              'description': parts.length > 1 ? parts[1] : 'Initiative description missing.',
          };
      }).toList();
  }

  /// ✅ NEW: Navigates to Objective Selection Screen (Modify Objective)
  void modifyObjective() {
    // Navigate back to Objective selection screen
    // We use Get.offNamed to reset the view stack to the objective screen
      Get.toNamed(
              AppRoutes.teamObjectiveSelectionScreen,
              arguments: {'isChallengeMode': true}
          );
    
      }
  
  /// ✅ NEW: Navigates to Key Results Screen (Adjust Key Results)
  void adjustKeyResults() {
    // Navigate back to Key Results selection screen
     Get.toNamed(
              AppRoutes.teamKeyResultScreen,
              arguments: {'isChallengeMode': true}
          );
    
  }

  /// ✅ NEW: Navigates to Initiatives Suggestion Screen (Revise Initiatives)
  void reviseInitiatives() {
    // Navigate back to Initiatives screen
      Get.toNamed(
              AppRoutes.teamSuggestionInitiativeScreen,
              arguments: {'isChallengeMode': true}
          );
  }


  /// Load initial data for team
  void loadTeamChallengeData() {
    // TODO: Fetch challenge data for team from backend or local store
  }
}
