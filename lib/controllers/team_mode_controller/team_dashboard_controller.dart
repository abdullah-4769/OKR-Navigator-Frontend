import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:game_app/controllers/team_mode_controller/create_team_controller.dart';
import 'package:game_app/data/repositories/strategy_repository.dart'; // Import StrategyRepo
import 'package:game_app/utils/snackbar_helper.dart'; // To show messages

class TeamDashboardController extends GetxController {
  // ----------------------
  // Observables (Dynamic Data)
  // ----------------------
  var teamName = "Loading Team...".obs;
  var teamId = Rxn<int>();
  var teamLevel = 0.obs; // Changed from 5 to 0
  var successRate = 0.obs; // Will be set dynamically
  var isLoading = false.obs;

  var badges = 0.obs;
  var trophies = 0.obs;
  var games = 0.obs;

  // Mocked/Static data structures (ready for dynamic replacement)
  var achievements = <Map<String, dynamic>>[].obs;
  var feedbackList = <Map<String, dynamic>>[].obs;
  var recentGames = <Map<String, dynamic>>[].obs;

  // Dependencies
  final StrategyRepository _strategyRepository = Get.find<StrategyRepository>();
  
  @override
  void onInit() {
    super.onInit();
    _loadDashboardData();
  }

  /// Fetches and initializes all dashboard metrics from the rewards summary endpoint
  Future<void> _loadDashboardData() async {
    isLoading.value = true;
    try {
      final createTeamController = Get.find<CreateTeamController>();
      final currentTeamId = createTeamController.createdTeamId.value;
      
      if (currentTeamId == null) {
        // throw Exception("Team ID not found. Cannot load dashboard.");
        return;
      }

      teamId.value = currentTeamId;
      
      // 1. API Call: GET /final-team-score/successrate/{teamId}
      Map<String, dynamic> apiResponse;
      try {
        apiResponse = await _strategyRepository.getTeamSuccessRate(currentTeamId);
      } catch (e) {
        // Handle 404 error - team hasn't completed games yet
        if (e.toString().contains('404') || e.toString().contains('Not Found')) {
          log('Team has no success rate data yet. Showing default dashboard.');
          _showEmptyDashboard();
          return;
        }
        rethrow; // Re-throw if it's a different error
      }
      
      // 2. Map API Response Data from new endpoint structure
      // Response structure: {teamId, teamName, averageScore, averageRemainingTime, totalPoints, trophyCount, budgetCount, playerAchievements, level, successRate}
      successRate.value = (apiResponse['successRate'] as num? ?? 0).toInt(); 
      teamLevel.value = (apiResponse['level'] as num? ?? 0).toInt(); 

      // Map budgetCount to badges and trophyCount to trophies
      badges.value = (apiResponse['budgetCount'] as num? ?? 0).toInt();
      trophies.value = (apiResponse['trophyCount'] as num? ?? 0).toInt();
      
      // Use totalPoints for games count (or could be used for total points earned)
      games.value = (apiResponse['totalPoints'] as num? ?? 0).toInt(); 

      // Update name using API teamName or CreateTeamController
      teamName.value = apiResponse['teamName']?.toString() ?? 
          (createTeamController.teamNameController.text.isNotEmpty
              ? createTeamController.teamNameController.text
              : "Team ${currentTeamId}");
      
      // Map Achievements from playerAchievements array
      final playerAchievements = apiResponse['playerAchievements'] as List? ?? [];
      achievements.assignAll(playerAchievements
          .map((e) => e is String 
              ? {'key': e, 'done': true, 'icon': Icons.emoji_events} 
              : {'key': e.toString(), 'done': true, 'icon': Icons.emoji_events})
          .toList().cast<Map<String, dynamic>>());
      
      // Clear feedback and recent games as they're not in the new API response
      feedbackList.clear();
      recentGames.clear();
      
      log('Team Dashboard data loaded for Team ID: $currentTeamId');

    } catch (e) {
      SnackbarHelper.error('Failed to load dashboard data: ${e.toString()}');
      log('Dashboard load error: $e');
      _useFallbackData();
    } finally {
      isLoading.value = false;
    }
  }

  void _useFallbackData() {
    // Minimal fallback data on error - no mock achievements or games
    teamName.value = "Team Data Unavailable";
    teamLevel.value = 0;
    successRate.value = 0;
    badges.value = 0;
    trophies.value = 0;
    games.value = 0;
    
    // Clear all lists - no mock data
    achievements.clear();
    feedbackList.clear();
    recentGames.clear();
  }

  void _showEmptyDashboard() {
    // Show empty dashboard when team has no completed games
    final createTeamController = Get.find<CreateTeamController>();
    teamName.value = createTeamController.teamNameController.text.isNotEmpty
        ? createTeamController.teamNameController.text
        : "New Team";
    teamLevel.value = 1;
    successRate.value = 0;
    badges.value = 0;
    trophies.value = 0;
    games.value = 0;
    
    achievements.clear();
    feedbackList.clear();
    recentGames.clear();
  }

  double progressValue() => successRate.value / 100;
}
