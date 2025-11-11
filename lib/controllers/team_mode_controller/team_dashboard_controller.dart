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
      
      // 1. API Call: GET /final-team-score/team/{teamId}/rewards-summary
      Map<String, dynamic> apiResponse;
      try {
        apiResponse = await _strategyRepository.getTeamRewardsSummary(currentTeamId);
      } catch (e) {
        // Handle 404 error - team hasn't completed games yet
        if (e.toString().contains('404') || e.toString().contains('Not Found')) {
          log('Team has no rewards data yet. Showing default dashboard.');
          _showEmptyDashboard();
          return;
        }
        rethrow; // Re-throw if it's a different error
      }
      
      // 2. Map API Response Data
      successRate.value = (apiResponse['successRate'] as num? ?? 0).toInt(); 
      teamLevel.value = (apiResponse['teamLevel'] as num? ?? 0).toInt(); 

      badges.value = (apiResponse['totalBadges'] as num? ?? 0).toInt();
      trophies.value = (apiResponse['totalTrophies'] as num? ?? 0).toInt();
      games.value = (apiResponse['gamesPlayed'] as num? ?? 0).toInt(); 

      // Update name using data from CreateTeamController (as it holds current context)
      teamName.value = createTeamController.teamNameController.text.isNotEmpty
          ? createTeamController.teamNameController.text
          : apiResponse['teamName']?.toString() ?? "Team ${currentTeamId}";
      
      // Map team members from the API response
      final membersData = apiResponse['members'] as List? ?? [];
      if (membersData.isNotEmpty) {
        // Store members data for future use if needed
        log('Team has ${membersData.length} members');
      }
      
      // Map Achievements (Assuming API returns list of achievement objects/strings)
      achievements.assignAll((apiResponse['achievements'] as List? ?? [])
          .map((e) => e is String ? {'key': e, 'done': true, 'icon': Icons.emoji_events} : e)
          .toList().cast<Map<String, dynamic>>());
      
      // Map Feedback List from API response
      final feedbackData = apiResponse['feedback'] as List? ?? [];
      feedbackList.assignAll(feedbackData.map((feedback) {
        if (feedback is Map<String, dynamic>) {
          return {
            'name': feedback['name']?.toString() ?? 'Team Member',
            'role': feedback['role']?.toString() ?? 'Player',
            'level': (feedback['level'] as num? ?? 1).toInt(),
            'avatar': feedback['avatar']?.toString() ?? 'assets/images/solop.png',
            'message': feedback['message']?.toString() ?? 'Great teamwork!',
            'rating': (feedback['rating'] as num? ?? 4).toInt(),
          };
        }
        return {
          'name': 'Team Member',
          'role': 'Player',
          'level': 1,
          'avatar': 'assets/images/solop.png',
          'message': 'Great teamwork!',
          'rating': 4,
        };
      }).toList());

      // Map Recent Games from API response
      final gamesData = apiResponse['recentGames'] as List? ?? [];
      recentGames.assignAll(gamesData.map((game) {
        if (game is Map<String, dynamic>) {
          return {
            'title': game['title']?.toString() ?? 'Team Game',
            'date': game['date']?.toString() ?? 'Recent',
            'score': (game['score'] as num? ?? 0).toInt(),
          };
        }
        return {
          'title': 'Team Game',
          'date': 'Recent',
          'score': 0,
        };
      }).toList());
      
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
