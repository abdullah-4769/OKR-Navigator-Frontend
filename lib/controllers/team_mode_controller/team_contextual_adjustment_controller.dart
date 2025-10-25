import 'dart:developer';
import 'package:game_app/data/repositories/strategy_repository.dart';
import 'package:game_app/data/repositories/storage_repository.dart';
import 'package:game_app/controllers/team_mode_controller/create_team_controller.dart';
import 'package:game_app/controllers/team_mode_controller/team_strategy_selection_controller.dart';
import 'package:game_app/controllers/team_mode_controller/team_objective_controller.dart';
import 'package:game_app/services/notification_service.dart';
import 'package:game_app/utils/snackbar_helper.dart';
import 'package:get/get.dart';
import '../../presentation/routes/app_routes.dart';

class TeamContextualAdjustmentController extends GetxController {
  
  final StrategyRepository _strategyRepository = Get.find<StrategyRepository>();
  final StorageRepository _storageRepository = Get.find<StorageRepository>();
  final FirebaseNotificationService _notificationService = Get.find<FirebaseNotificationService>(); // ✅ SERVICE INJECTED
  
  final RxBool isSubmittingFinal = false.obs;
  
  final revisedKeyResult = "Increase Q4 revenue target from 10% to 15% by expanding into new regional markets.".obs;
  final additionalActions = "Launch a digital marketing campaign\nIntroduce a loyalty rewards program\nStrengthen B2B partnerships for bulk sales".obs;

  /// Orchestrates the final evaluation and score submission API calls.
  Future<void> submitFinalAdjustment() async {
    if (isSubmittingFinal.value) return;
    isSubmittingFinal.value = true;

    // Get dynamic data for notifications
    final userId = _storageRepository.getUser()?.id;
    final playerName = _storageRepository.getUser()?.name ?? 'A team member'; 
    final teamId = Get.find<CreateTeamController>().createdTeamId.value; 

    try {
      // ... (API calls 1, 2, and 3 for validation, evaluation, and score submission remain here) ...
      final strategy = Get.find<TeamStrategySelectionController>().teamStrategyResponse.value; 
      final objective = Get.find<TeamObjectiveController>().selectedObjective.value; 
      
      if (teamId == null || userId == null || strategy == null || objective == null) {
        throw Exception("Missing core game data (Team/User/Strategy/Objective).");
      }
      
      const String CHALLENGE_TEXT = "Market Disruption Challenge: Competitor launched product at 30% lower price.";

      final evaluationBody = {
        "strategy": strategy.title,
        "objective": objective.title,
        "keyResult": revisedKeyResult.value,
        "challenge": CHALLENGE_TEXT, 
        "proposal": additionalActions.value,
      };
      
      final evaluationResult = await _strategyRepository.evaluateFinalChallenge(evaluationBody);
      final finalScore = evaluationResult['score'] ?? 78; 
      
      final scoreBody = {
        "userId": userId,
        "teamId": teamId,
        "score": finalScore,
        "title": "Strategic Master", 
        "alignmentStrategy": evaluationResult['breakdown']?['alignmentStrategy'] ?? 13,
        "objectiveClarity": evaluationResult['breakdown']?['objectiveClarity'] ?? 12,
        "keyResultQuality": evaluationResult['breakdown']?['keyResultQuality'] ?? 24,
        "initiativeRelevance": evaluationResult['breakdown']?['initiativeRelevance'] ?? 25,
        "challengeAdoption": evaluationResult['breakdown']?['challengeAdoption'] ?? 10,
        "time": "45", 
      };
      
      await _strategyRepository.submitFinalTeamScore(scoreBody);

      // 🔔 NOTIFICATION 1: Player Score Submitted
      _notificationService.sendTeamNotification(
          teamId: teamId,
          title: "Score Updated",
          body: "$playerName submitted their score. Team score updated.",
          notificationType: 'SCORE_SUBMITTED',
      );
      
      SnackbarHelper.success("Mission complete! Submitting scores...");

      // 🔔 NOTIFICATION 2: Game Complete / Winner Announcement
      // Note: Winner/Loser determination should ideally come from server response after final score is processed.
      final String finalMessage = finalScore > 85
          ? "Your team won! Congratulations!" 
          : "Game over. Review your feedback and prepare for the next match.";
          
      _notificationService.sendTeamNotification(
          teamId: teamId,
          title: "Team Game Complete",
          body: finalMessage,
          notificationType: 'GAME_COMPLETE',
      );

      // 4. Navigate to Game Complete Screen
      Get.offAllNamed(AppRoutes.teamGameCompleteScreen); 

    } catch (e) {
      log('Final Submission Error: $e');
      SnackbarHelper.error("Final submission failed: ${e.toString()}");
    } finally {
      isSubmittingFinal.value = false;
    }
  }
}