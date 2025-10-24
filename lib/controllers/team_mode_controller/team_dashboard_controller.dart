import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:game_app/controllers/team_mode_controller/create_team_controller.dart';
import 'package:game_app/data/repositories/storage_repository.dart';
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
  final StorageRepository _storageRepository = Get.find<StorageRepository>();
  
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
        throw Exception("Team ID not found. Cannot load dashboard.");
      }

      teamId.value = currentTeamId;
      
      // 1. API Call: GET /final-team-score/team/{teamId}/rewards-summary
      final apiResponse = await _strategyRepository.getTeamRewardsSummary(currentTeamId);
      
      // 2. Map API Response Data
      successRate.value = (apiResponse['successRate'] as num? ?? 0).toInt(); 
      teamLevel.value = (apiResponse['teamLevel'] as num? ?? 0).toInt(); 

      badges.value = (apiResponse['totalBadges'] as num? ?? 0).toInt();
      trophies.value = (apiResponse['totalTrophies'] as num? ?? 0).toInt();
      games.value = (apiResponse['gamesPlayed'] as num? ?? 0).toInt(); // Assuming gamesPlayed exists

      // Update name using data from CreateTeamController (as it holds current context)
      teamName.value = createTeamController.teamNameController.text.isNotEmpty
          ? createTeamController.teamNameController.text
          : "Team ${currentTeamId}";
      
      // Map Achievements (Assuming API returns list of achievement objects/strings)
      achievements.assignAll((apiResponse['achievements'] as List? ?? [])
          .map((e) => e is String ? {'key': e, 'done': true, 'icon': Icons.emoji_events} : e)
          .toList().cast<Map<String, dynamic>>());
      
      // Map Feedback List (Assuming API returns a list of members with feedback)
      // The actual feedback structure is complex, using a mock structure with fetched user names
      feedbackList.assignAll([
        {
          'name': 'Johnson',
          'role': 'Strategist',
          'level': 5,
          'avatar': 'assets/images/solop.png',
          'message': 'Nice! I drew "Digital Transformation Initiative". These strategies complement each other well!',
          'rating': 4
        },
        // Populate more feedback from API if provided in 'apiResponse'
      ]);

      // Map Recent Games (Assuming API returns list of recent game objects)
      recentGames.assignAll([
        {'title': 'Solo Campaign - Level 1', 'date': 'Jan 15, 2025', 'score': 85},
        {'title': 'Team Challenge', 'date': 'Jan 12, 2025', 'score': 92},
      ]);
      
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
    // Reverts to comprehensive defaults on error
    teamName.value = "Fallback Team";
    teamLevel.value = 1;
    successRate.value = 85;
    badges.value = 12;
    trophies.value = 16;
    games.value = 8;
    
    achievements.assignAll([
      {'key': 'strategic_thinker'.tr, 'done': true, 'icon': Icons.emoji_events},
      {'key': 'goal_master'.tr, 'done': true, 'icon': Icons.emoji_events},
      {'key': 'innovation_expert'.tr, 'done': true, 'icon': Icons.emoji_events},
      {'key': 'challenge_solver'.tr, 'done': true, 'icon': Icons.emoji_events},
    ]);
    
    feedbackList.assignAll([
      {
        'name': 'Tasha',
        'role': 'Strategist',
        'level': 5,
        'avatar': 'assets/images/solop.png',
        'message': "Strategic thinking rocks! Good job solving the challenge.",
        'rating': 5
      },
    ]);

    recentGames.assignAll([
      {'title': 'Solo Campaign - Level 1', 'date': 'Jan 15, 2025', 'score': 85},
      {'title': 'Team Challenge', 'date': 'Jan 12, 2025', 'score': 92},
    ]);
  }

  double progressValue() => successRate.value / 100;
}
