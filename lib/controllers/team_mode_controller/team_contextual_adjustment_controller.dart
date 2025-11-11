// lib/controllers/team_mode_controller/team_contextual_adjustment_controller.dart

import 'dart:developer';
import 'dart:math'; 
import 'package:flutter/material.dart'; 
import 'package:game_app/data/repositories/strategy_repository.dart';
import 'package:game_app/data/repositories/storage_repository.dart';
import 'package:game_app/controllers/team_mode_controller/create_team_controller.dart';
import 'package:game_app/controllers/team_mode_controller/team_strategy_selection_controller.dart';
import 'package:game_app/controllers/team_mode_controller/team_objective_controller.dart';
import 'package:game_app/controllers/team_mode_controller/team_key_results_controller.dart'; 
import 'package:game_app/controllers/team_mode_controller/team_contextual_challange_controller.dart';
import 'package:game_app/data/repositories/team_repository.dart';
import 'package:game_app/services/notification_service.dart';
import 'package:game_app/utils/snackbar_helper.dart';
import 'package:get/get.dart';
import '../../presentation/routes/app_routes.dart';
import 'team_game_complete_controller.dart';

class TeamContextualAdjustmentController extends GetxController {
  
  final StrategyRepository _strategyRepository = Get.find<StrategyRepository>();
  final StorageRepository _storageRepository = Get.find<StorageRepository>();
  final FirebaseNotificationService _notificationService = Get.find<FirebaseNotificationService>(); 
  final TeamKeyResultsController _keyResultsController = Get.find<TeamKeyResultsController>(); 
  final TeamContextualChallengeController _challengeController = Get.find<TeamContextualChallengeController>();
  
  final RxBool isSubmittingFinal = false.obs;
  
  final RxString revisedKeyResult = "".obs; 
  final additionalActions = TextEditingController(); 

  @override
  void onInit() {
    super.onInit();
    _selectRandomKeyResult();
  }
  
  @override
  void onClose() {
    additionalActions.dispose(); 
    super.onClose();
  }

  void _selectRandomKeyResult() {
    final selectedKRs = _keyResultsController.getSelectedKeyResults();

    if (selectedKRs.isNotEmpty) {
      final random = Random();
      final randomKr = selectedKRs[random.nextInt(selectedKRs.length)];
      
      // Format the key result for display/submission (use raw text)
      revisedKeyResult.value = "${randomKr.title ?? 'Achieve Goal'} - ${randomKr.description ?? 'Update Metrics'}";
    } else {
      revisedKeyResult.value = "No Key Results were selected. Please restart the process.".tr;
    }
  }

  /// Orchestrates the final evaluation and score submission API calls.
  Future<void> submitFinalAdjustment() async {
    if (isSubmittingFinal.value) return;
    
    if (additionalActions.text.trim().isEmpty) {
        SnackbarHelper.warning("Please describe your additional strategic actions.".tr);
        return;
    }

    isSubmittingFinal.value = true;

    // Get dynamic data for API calls and notifications
    final userId = _storageRepository.getUser()?.id;
    final playerName = _storageRepository.getUser()?.name ?? 'A team member'; 
    final teamId = Get.find<CreateTeamController>().createdTeamId.value; 

    try {
      final strategy = Get.find<TeamStrategySelectionController>().teamStrategyResponse.value; 
      final objective = Get.find<TeamObjectiveController>().selectedObjective.value; 
      final challengeTitle = _challengeController.challengeTitle.value;
      
      if (teamId == null || userId == null || strategy == null || objective == null) {
        throw Exception("Missing core game data (Team/User/Strategy/Objective).");
      }

      // 1. Final Challenge OKR Evaluation (POST /team-challenges/evaluation)
      final evaluationBody = {
        "strategy": strategy.title,
        "objective": objective.title,
        "keyResult": revisedKeyResult.value, 
        "challenge": challengeTitle, 
        "proposal": additionalActions.text.trim(), 
      };
      
      final evaluationResult = await _strategyRepository.evaluateFinalChallenge(evaluationBody);
      final challengeScore = evaluationResult.score ?? 0;
      final breakdown = evaluationResult.breakdown;
      
      // NOTE on Score Calculation: The prompt implies a sum of weighted scores.
      // Since we only have *one* breakdown result here, we use the values from this breakdown.
      final int finalScore = challengeScore;
      final String timeSpent = "45"; // Placeholder for time from controller/timer

      // Extract breakdown values safely (assuming they are returned as integers or "X/Y" string components)
      final int alignScore = int.tryParse(breakdown?.strategyRelevance?.split('/').first ?? '13') ?? 13;
      final int objectiveScore = int.tryParse(breakdown?.objectiveQuality?.split('/').first ?? '12') ?? 12;
      final int krScore = int.tryParse(breakdown?.keyResultsQuality?.split('/').first ?? '24') ?? 24;
      final int initiativeScore = int.tryParse(breakdown?.initiativesQuality?.split('/').first ?? '25') ?? 25;
      final int challengeAdoptScore = int.tryParse(breakdown?.overallCoherence?.split('/').first ?? '10') ?? 10;


      // 2. Submit Final Team Score (POST /final-team-score)
      final scoreBody = {
        "userId": userId,
        "teamId": teamId,
        "score": finalScore,
        "title": evaluationResult.gamification?.badgeHint ?? "Strategic Master", 
        "alignmentStrategy": alignScore,
        "objectiveClarity": objectiveScore,
        "keyResultQuality": krScore,
        "initiativeRelevance": initiativeScore,
        "challengeAdoption": challengeAdoptScore,
        "time": timeSpent, 
      };
      
      final scoreResponse = await _strategyRepository.submitFinalTeamScore(scoreBody);

      // 3. Notifications and Navigation
      final List<String> teamMembers = await _getTeamMemberUserIds(teamId);
      final List<String> otherTeamMembers = teamMembers.where((id) => id != userId).toList();
      
      _notificationService.sendTeamScoreUpdated(
        playerName: playerName,
        teamId: teamId,
        otherTeamMemberUserIds: otherTeamMembers,
      );
      
      SnackbarHelper.success("Mission complete! Submitting scores...".tr);

      final bool isWinner = finalScore > 85;
      
      for (final memberId in teamMembers) {
        _notificationService.sendTeamGameComplete(
          playerName: playerName,
          recipientUserId: memberId,
          teamId: teamId,
          isWinner: isWinner,
        );
      }

      // Initialize the game complete controller and set the score from POST response
      final gameCompleteController = Get.put(TeamGameCompleteController());
      // Use score from POST response if available, otherwise use calculated score
      final responseScore = (scoreResponse['score'] as num?)?.toInt() ?? 
                           (scoreResponse['avgPercentage'] as num?)?.toInt() ?? 
                           finalScore;
      gameCompleteController.setInitialScoreData(
        score: responseScore,
        title: scoreResponse['title']?.toString() ?? evaluationResult.gamification?.badgeHint ?? "Strategic Master",
        badge: scoreResponse['badge']?.toString() ?? "",
        trophy: scoreResponse['trophy']?.toString() ?? "",
        alignmentPoints: alignScore,
        objectivePoints: objectiveScore,
        keyResultPoints: krScore,
        initiativePoints: initiativeScore,
        challengePoints: challengeAdoptScore,
        totalPoints: scoreResponse['totalPoints'] as int? ?? 5,
      );

      Get.offAllNamed(AppRoutes.teamGameCompleteScreen); 

    } catch (e) {
      SnackbarHelper.error("Final submission failed: ${e.toString()}".tr);
    } finally {
      isSubmittingFinal.value = false;
    }
  }

  Future<List<String>> _getTeamMemberUserIds(int teamId) async {
    try {
      final teamLobbyResponse = await Get.find<TeamRepository>().getTeamDetails(teamId);
      return teamLobbyResponse.members?.map((m) => m.userId!).toList() ?? [];
    } catch (e) {
      return [];
    }
  }
}