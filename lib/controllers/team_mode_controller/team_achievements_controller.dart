import 'dart:developer';
import 'package:get/get.dart';
import 'package:game_app/controllers/team_mode_controller/create_team_controller.dart';
import 'package:game_app/controllers/team_mode_controller/team_dashboard_controller.dart';
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
  // You might also pull some shared stats from TeamDashboardController if available
  final TeamDashboardController _dashboardController = Get.find<TeamDashboardController>();


  @override
  void onInit() {
    super.onInit();
    _loadAchievements();
  }

  /// Loads dynamic team name and simulates fetching stats.
  void _loadAchievements() async {
    final teamId = _createTeamController.createdTeamId.value;

    if (teamId == null) {
      teamName.value = "Team Data Missing";
      SnackbarHelper.error("Cannot load achievements: Team not found.");
      _useFallbackData();
      return;
    }

    try {
        // 1. Dynamically set Team Name
        teamName.value = _createTeamController.teamNameController.text.isNotEmpty
            ? _createTeamController.teamNameController.text
            : "Team Alpha (ID: $teamId)";

        // 2. Simulate API Call to fetch Achievements (using dashboard controller's values as mock)
        // In a real app, this would be a dedicated API call: 
        // final stats = await _achievementRepository.fetchTeamStats(teamId);
        
        await Future.delayed(const Duration(milliseconds: 300));

        // 3. Update Observables with Fetched Data (using mock data structure for now)
        points.value = 110;
        badges.value = 12;
        trophies.value = 16;
        games.value = 3;
        
        recentAchievements.assignAll([
            "Strategic Thinker",
            "Goal Master",
            "Innovation Expert",
            "Challenge Solver"
        ]);
        
        recentGames.assignAll([
            {
              "title": "Team Campaign - Level 1",
              "date": "Jan 15, 2025",
              "score": "85%"
            },
            {
              "title": "Team Challenge",
              "date": "Jan 12, 2025",
              "score": "92%"
            },
        ]);
        
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