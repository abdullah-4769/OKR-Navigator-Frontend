// lib/controllers/team_mode_controller/team_strategic_architect_controller.dart

import 'dart:developer'; 
import 'package:game_app/data/repositories/storage_repository.dart'; 
import 'package:game_app/data/repositories/strategy_repository.dart'; 
import 'package:game_app/utils/snackbar_helper.dart'; 
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:get/get.dart';
import 'create_team_controller.dart'; 

class TeamStrategicArchitectController extends GetxController {
  
  // Dependencies
  final StrategyRepository _strategyRepository = Get.find<StrategyRepository>();
  final StorageRepository _storageRepository = Get.find<StorageRepository>();

  // Initialized to reactive empty/zero values
  final RxInt score = 0.obs; 
  final RxList<String> badges = <String>[].obs; 
  final RxList<String> titles = <String>[].obs; 
  final RxString trophy = "".obs; 

  final RxInt points = 0.obs; 
  final RxInt totalPoints = 0.obs; 
  final RxList<Map<String, dynamic>> breakdownItems = <Map<String, dynamic>>[].obs;

  final RxList<String> achievements = <String>[].obs; 

  final RxBool showJourneyDetails = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadIndividualGameResults(); 
  }
  
  // Method to fetch and set individual score data from API
  Future<void> _loadIndividualGameResults() async {
    final teamId = Get.find<CreateTeamController>().createdTeamId.value;
    final userId = _storageRepository.getUser()?.id;

    if (teamId == null || userId == null) {
        // log('Team ID or User ID missing for individual score fetch. Using fallback.');
        // SnackbarHelper.error('Cannot load individual results. Missing game context.');
        // _useFallbackData();
        return;
    }
    
    try {
        // API Call: GET /final-team-score/{teamId}/user/{userId}/score
        final result = await _strategyRepository.getUserFinalScoreInTeam(teamId, userId);

        // Map data from API response - handle both userScore and individual score
        score.value = result['userScore'] ?? result['individualScore'] ?? result['score'] ?? 0;
        
        final breakdown = result['breakdown'] as Map<String, dynamic>?;
        if (breakdown != null) {
            points.value = breakdown['totalPointsAchieved'] ?? breakdown['points'] ?? 0;
            totalPoints.value = breakdown['totalPointsPossible'] ?? 100;

            // Map breakdown details - adjust scores and max points to match expected UI strings
            breakdownItems.assignAll([
                {"title": "Strategy Selection", "score": "${breakdown['alignmentStrategy'] ?? 0}/15", "success": (breakdown['alignmentStrategy'] ?? 0) > 0},
                {"title": "Objective Alignment", "score": "${breakdown['objectiveClarity'] ?? 0}/15", "success": (breakdown['objectiveClarity'] ?? 0) > 0},
                {"title": "Key Results Quality", "score": "${breakdown['keyResultQuality'] ?? 0}/25", "success": (breakdown['keyResultQuality'] ?? 0) > 0},
                {"title": "Initiative Relevance", "score": "${breakdown['initiativeRelevance'] ?? 0}/25", "success": (breakdown['initiativeRelevance'] ?? 0) > 0},
                {"title": "Challenge Adaptation", "score": "${breakdown['challengeAdoption'] ?? 0}/20", "success": (breakdown['challengeAdoption'] ?? 0) > 0},
            ]);
        } else {
            _initializeBreakdownStructure();
        }

        // Rewards and Achievements
        // Note: Translation keys are used for consistency with other parts of the app.
        achievements.assignAll(
          (result['achievements'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? 
          ["completed_strategic_cycle".tr]
        );
        badges.assignAll(
          (result['badge'] != null ? [result['badge'].toString()] : null) ?? ["Strategic Thinker".tr]
        );
        titles.assignAll(
          (result['title'] != null ? [result['title'].toString()] : null) ?? ["Master Adapter".tr]
        );
        trophy.value = result['trophy']?.toString() ?? "Bronze".tr; 
        
        log('Individual game results loaded successfully.');

    } catch (e, s) {
        log('Error fetching individual final score: $e', stackTrace: s);
        SnackbarHelper.error('Failed to load individual results: ${e.toString()}');
        _useFallbackData();
    }
  }

  void _useFallbackData() {
    // Minimal fallback data for failure state
    score.value = 78;
    points.value = 9;
    totalPoints.value = 10;
    badges.assignAll(["Strategic Thinker".tr]);
    titles.assignAll(["Master Adapter".tr]);
    trophy.value = "Silver".tr;
    achievements.assignAll(["completed_strategic_cycle".tr]);
    _initializeBreakdownStructure();
  }

  void _initializeBreakdownStructure() {
      // Structure matching old mock data, but without using observable updates
      breakdownItems.assignAll([
          {"title": "Strategy Selection", "score": "2/2", "success": true},
          {"title": "Objective Alignment", "score": "2/2", "success": true},
          {"title": "Key Results Quality", "score": "1/2", "success": false},
          {"title": "Initiative Relevance", "score": "2/2", "success": true},
          {"title": "Challenge Adaptation", "score": "2/2", "success": true},
      ]);
  }

  void toggleJourneyDetails() =>
      showJourneyDetails.value = !showJourneyDetails.value;

  void playAgain() {
    // Reset all data
    score.value = 0;
    points.value = 0;
    totalPoints.value = 0;
    badges.clear();
    titles.clear();
    trophy.value = "";
    breakdownItems.clear();
    achievements.clear();

    // Navigate to home screen
    Get.offAllNamed(AppRoutes.home);
  }

  void viewBadges() {
    // navigate to badges screen
  }

  void shareScore() {
    // share logic
  }

  void viewJourney() {
    Get.toNamed(AppRoutes.teamStrategicJourneyScreen);
  }

  static TeamStrategicArchitectController getOrPut() {
    return Get.isRegistered<TeamStrategicArchitectController>()
        ? Get.find<TeamStrategicArchitectController>()
        : Get.put(TeamStrategicArchitectController(), permanent: true);
  }
}