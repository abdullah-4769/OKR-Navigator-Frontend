import 'package:get/get.dart';
import 'package:game_app/utils/snackbar_helper.dart'; 
import 'dart:developer';
import 'package:game_app/data/repositories/strategy_repository.dart';
import 'package:game_app/controllers/team_mode_controller/create_team_controller.dart'; 

class TeamScoreboardController extends GetxController {
  final RxString selectedTimeFrame = 'Today'.obs;
  final List<String> timeFrames = ['Today', 'This Week', 'This Month'];

  final RxList<Map<String, dynamic>> leaderboard = <Map<String, dynamic>>[].obs;
  
  // Dependencies
  final StrategyRepository _strategyRepository = Get.find<StrategyRepository>();
  final CreateTeamController _createTeamController = Get.find<CreateTeamController>();

  @override
  void onInit() {
    super.onInit();
    // Load leaderboard data for the initial timeframe
    fetchLeaderboard(); 
  }
  
  // Method to fetch real leaderboard data from API
  Future<void> fetchLeaderboard() async {
    try {
      log('Fetching leaderboard for: ${selectedTimeFrame.value}');
      
      final teamId = _createTeamController.createdTeamId.value;
      if (teamId == null) {
        // SnackbarHelper.error('Team ID not found. Cannot load leaderboard.');
        // leaderboard.clear();
        return;
      }
      
      // API Call: GET /final-team-score/successrate/{teamId}
      // This endpoint returns team success rate data
      final leaderboardData = await _strategyRepository.getTeamSuccessRate(teamId);
      
      // Map API response to leaderboard format
      final teamsData = leaderboardData['teams'] as List? ?? [];
      final mappedLeaderboard = teamsData.asMap().entries.map((entry) {
        final index = entry.key;
        final team = entry.value;
        if (team is Map<String, dynamic>) {
          return {
            'rank': index + 1,
            'name': team['teamName']?.toString() ?? 'Team ${index + 1}',
            'level': (team['teamLevel'] as num? ?? 1).toInt(),
            'points': (team['totalPoints'] as num? ?? 0).toInt(),
            'score': (team['averageScore'] as num? ?? 0).toInt(),
            'highlighted': team['isCurrentTeam'] as bool? ?? false,
          };
        }
        return {
          'rank': index + 1,
          'name': 'Team ${index + 1}',
          'level': 1,
          'points': 0,
          'score': 0,
          'highlighted': false,
        };
      }).toList();
      
      leaderboard.assignAll(mappedLeaderboard);
      SnackbarHelper.success('Team Leaderboard loaded for ${selectedTimeFrame.value}!');
      
    } catch (e) {
      log('Leaderboard fetch error: $e');
      SnackbarHelper.error('Failed to load leaderboard data.');
      leaderboard.clear();
    }
  }

  void changeTimeFrame(String timeframe) {
    selectedTimeFrame.value = timeframe;
    fetchLeaderboard(); // Refetch data based on the new timeframe
  }
}
