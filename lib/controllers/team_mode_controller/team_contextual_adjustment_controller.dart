import 'dart:developer';
import 'package:game_app/data/repositories/strategy_repository.dart';
import 'package:game_app/data/repositories/storage_repository.dart';
import 'package:game_app/controllers/team_mode_controller/create_team_controller.dart';
import 'package:game_app/controllers/team_mode_controller/team_strategy_selection_controller.dart';
import 'package:game_app/controllers/team_mode_controller/team_objective_controller.dart';
import 'package:game_app/utils/snackbar_helper.dart';
import 'package:get/get.dart';
import '../../presentation/routes/app_routes.dart';

class TeamContextualAdjustmentController extends GetxController {
  
  final StrategyRepository _strategyRepository = Get.find<StrategyRepository>();
  final StorageRepository _storageRepository = Get.find<StorageRepository>();
  
  final RxBool isSubmittingFinal = false.obs;
  
  // These variables represent the user's final revisions (typically from text fields)
  final revisedKeyResult = "Increase Q4 revenue target from 10% to 15% by expanding into new regional markets.".obs;
  final additionalActions = "Launch a digital marketing campaign\nIntroduce a loyalty rewards program\nStrengthen B2B partnerships for bulk sales".obs;

  /// Orchestrates the final evaluation and score submission API calls.
  Future<void> submitFinalAdjustment() async {
    if (isSubmittingFinal.value) return;
    isSubmittingFinal.value = true;

    try {
      // 1. Gather Required Game Data
      final teamId = Get.find<CreateTeamController>().createdTeamId.value; //
      final userId = _storageRepository.getUser()?.id; //
      final strategy = Get.find<TeamStrategySelectionController>().teamStrategyResponse.value; //
      final objective = Get.find<TeamObjectiveController>().selectedObjective.value; //
      
      if (teamId == null || userId == null || strategy == null || objective == null) {
        throw Exception("Missing core game data (Team/User/Strategy/Objective).");
      }
      
      // --- Constants/Placeholders ---
      const String CHALLENGE_TEXT = "Market Disruption Challenge: Competitor launched product at 30% lower price.";

      // 2. API Call 1: Final Challenge OKR Evaluation (POST /team-challenges/evaluation)
      final evaluationBody = {
        "strategy": strategy.title,
        "objective": objective.title,
        "keyResult": revisedKeyResult.value,
        "challenge": CHALLENGE_TEXT, 
        "proposal": additionalActions.value,
      };
      
      final evaluationResult = await _strategyRepository.evaluateFinalChallenge(evaluationBody); //
      final finalScore = evaluationResult['score'] ?? 78; // Extract score
      
      // 3. API Call 2: Submit Final Team Score (POST /final-team-score)
      final scoreBody = {
        "userId": userId,
        "teamId": teamId,
        "score": finalScore,
        "title": "Strategic Master", // Placeholder title
        // Breakdown points extracted from evaluationResult (mocked with defaults if missing)
        "alignmentStrategy": evaluationResult['breakdown']?['alignmentStrategy'] ?? 13,
        "objectiveClarity": evaluationResult['breakdown']?['objectiveClarity'] ?? 12,
        "keyResultQuality": evaluationResult['breakdown']?['keyResultQuality'] ?? 24,
        "initiativeRelevance": evaluationResult['breakdown']?['initiativeRelevance'] ?? 25,
        "challengeAdoption": evaluationResult['breakdown']?['challengeAdoption'] ?? 10,
        "time": "45", 
      };
      
      await _strategyRepository.submitFinalTeamScore(scoreBody); //

      SnackbarHelper.success("Mission complete! Submitting scores..."); //

      // 4. Navigate to Game Complete Screen
      Get.offAllNamed(AppRoutes.teamGameCompleteScreen); //

    } catch (e) {
      log('Final Submission Error: $e');
      SnackbarHelper.error("Final submission failed: ${e.toString()}"); //
    } finally {
      isSubmittingFinal.value = false;
    }
  }
}