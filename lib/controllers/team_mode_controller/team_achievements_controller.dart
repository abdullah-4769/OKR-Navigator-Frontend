import 'dart:developer';
import 'package:get/get.dart';
import 'package:game_app/controllers/team_mode_controller/create_team_controller.dart';
import 'package:game_app/data/repositories/strategy_repository.dart';
import 'package:game_app/utils/snackbar_helper.dart';

class TeamAchievementsController extends GetxController {
  // ----------------------
  // Observables
  // ----------------------
  final teamName = "Loading Team...".obs;
  final teamLevel = 5.obs;
  final points = 0.obs;

  final badges = 0.obs;
  final trophies = 0.obs;
  final games = 0.obs;

  final recentAchievements = <String>[].obs;
  final recentGames = <Map<String, String>>[].obs;
  
  // Dependencies (used to pull core team data)
  final CreateTeamController _createTeamController = Get.find<CreateTeamController>();
  final StrategyRepository _strategyRepository = Get.find<StrategyRepository>();


  @override
  void onInit() {
    super.onInit();
    _loadAchievements();
  }

  /// Loads dynamic team name and fetches real stats from API.
  void _loadAchievements() async {
    final teamId = _createTeamController.createdTeamId.value;

    if (teamId == null) {
      teamName.value = "Team Data Missing";
      // // SnackbarHelper.error("Cannot load achievements: Team not found.");
      // _useFallbackData();
      return;
    }

    try {
        // 1. Dynamically set Team Name
        teamName.value = _createTeamController.teamNameController.text.isNotEmpty
            ? _createTeamController.teamNameController.text
            : "Team Alpha (ID: $teamId)";

        // 2. API Call: GET /final-team-score/team/{teamId}/rewards-summary
        final rewardsData = await _strategyRepository.getTeamRewardsSummary(teamId);
        
        // 3. Update Observables with Real API Data
        points.value = (rewardsData['totalPoints'] as num? ?? 0).toInt();
        badges.value = (rewardsData['totalBadges'] as num? ?? 0).toInt();
        trophies.value = (rewardsData['totalTrophies'] as num? ?? 0).toInt();
        games.value = (rewardsData['gamesPlayed'] as num? ?? 0).toInt();
        teamLevel.value = (rewardsData['teamLevel'] as num? ?? 1).toInt();
        
        // Map recent achievements from API response
        final achievementsList = rewardsData['recentAchievements'] as List? ?? [];
        recentAchievements.assignAll(achievementsList.map((e) => e.toString()).toList());
        
        // Map recent games from API response
        final gamesList = rewardsData['recentGames'] as List? ?? [];
        recentGames.assignAll(gamesList.map((game) {
          if (game is Map<String, dynamic>) {
            return {
              'title': game['title']?.toString() ?? 'Team Game',
              'date': game['date']?.toString() ?? 'Recent',
              'score': '${game['score']?.toString() ?? '0'}%',
            };
          }
          return {'title': 'Team Game', 'date': 'Recent', 'score': '0%'};
        }).toList());
        
        log('Team achievements loaded successfully from API.');
        
    } catch (e) {
        log('Error loading team achievements: $e');
        SnackbarHelper.error('Failed to load achievements.');
        _useFallbackData();
    }
  }
  
  void _useFallbackData() {
    // Reverts to minimal data on initialization error
    teamName.value = "Team Alpha";
    points.value = 0;
    badges.value = 0;
    trophies.value = 0;
    games.value = 0;
    recentAchievements.clear();
    recentGames.clear();
  }
}