// lib/controllers/dashboard_controller.dart
import 'dart:developer';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../core/api_constants.dart';
import '../data/repositories/storage_repository.dart';
import '../services/notification_service.dart';
import '../utils/snackbar_helper.dart';
import 'team_mode_controller/create_team_controller.dart';

class DashboardController extends GetxController {
  final StorageRepository _storageRepository = Get.find<StorageRepository>();
  final FirebaseNotificationService _notificationService = Get.find<FirebaseNotificationService>();
  final Dio _dio = Dio();

  // Observable variables for Personal Dashboard
  final RxInt successRate = 85.obs;
  final RxInt badgesCount = 12.obs;
  final RxInt trophiesCount = 16.obs;
  final RxInt cardsCount = 8.obs;
  final RxString teamName = 'Team Alpha'.obs;
  final RxInt teamLevel = 5.obs;
  final RxInt personalPoints = 110.obs;

  // Observable variables for Team Rewards Summary
  final RxInt totalBadges = 0.obs;
  final RxInt totalTrophies = 0.obs;
  final RxDouble teamSuccessRate = 0.0.obs;
  final RxInt teamLevelFromAPI = 0.obs;
  final RxList<Map<String, dynamic>> teamMembers = <Map<String, dynamic>>[].obs;

  // Observable variables for Scoreboard
  final RxList<Map<String, dynamic>> teams = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> leaderboard = <Map<String, dynamic>>[].obs;
  final RxString selectedTeamId = ''.obs;
  final RxString personalRanking = ''.obs;

  // Observable variables for Game Complete
  final RxInt finalScore = 0.obs;
  final RxString badge = ''.obs;
  final RxString trophy = ''.obs;
  final RxString title = ''.obs;
  final RxList<Map<String, dynamic>> breakdownItems = <Map<String, dynamic>>[].obs;
  final RxList<String> achievements = <String>[].obs;
  final RxList<Map<String, dynamic>> memberScores = <Map<String, dynamic>>[].obs;

  // Loading states
  final RxBool isLoadingPersonalDashboard = false.obs;
  final RxBool isLoadingTeamRewards = false.obs;
  final RxBool isLoadingScoreboard = false.obs;
  final RxBool isLoadingGameComplete = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPersonalDashboard();
    _loadTeamRewardsSummary();
    _loadScoreboard();
  }

  // ============================================================================
  // PERSONAL DASHBOARD METHODS
  // ============================================================================

  /// Load personal dashboard data
  Future<void> _loadPersonalDashboard() async {
    try {
      isLoadingPersonalDashboard.value = true;
      
      // Load user data from storage
      final user = _storageRepository.getUser();
      if (user != null) {
        // Update personal data
        personalPoints.value = 110; // This would come from API
        teamName.value = 'Team Alpha'; // This would come from API
        teamLevel.value = 5; // This would come from API
        
        // Load achievements
        _loadPersonalAchievements();
        _loadRecentGames();
      }
    } catch (e) {
      log('Error loading personal dashboard: $e');
      SnackbarHelper.error('Failed to load personal dashboard');
    } finally {
      isLoadingPersonalDashboard.value = false;
    }
  }

  /// Load personal achievements
  void _loadPersonalAchievements() {
    achievements.assignAll([
      'Strategic Thinker',
      'Goal Master',
      'Innovation Expert',
      'Challenge Solver',
    ]);
  }

  /// Load recent games
  void _loadRecentGames() {
    // This would typically come from API
    // For now, using static data
  }

  /// Schedule async game
  void scheduleAsyncGame() {
    SnackbarHelper.info('Schedule Async Game feature coming soon');
  }

  /// Invite player
  void invitePlayer() {
    // Send challenge invitation notification
    final user = _storageRepository.getUser();
    if (user != null) {
      _notificationService.sendChallengeInvitation(
        hostName: user.name ?? 'Player',
        recipientName: 'New Player',
        recipientUserId: 'new_player_id',
        isReceived: false,
      );
    }
    SnackbarHelper.info('Player invitation sent');
  }

  /// Launch challenge
  void launchChallenge() {
    // Send challenge started notification
    final user = _storageRepository.getUser();
    if (user != null) {
      _notificationService.sendChallengeStarted(
        hostName: user.name ?? 'Player',
        participantUserIds: ['player1', 'player2'],
      );
    }
    Get.toNamed('/contextual-challenge');
  }

  // ============================================================================
  // TEAM REWARDS SUMMARY METHODS
  // ============================================================================

  /// Load team rewards summary
  Future<void> _loadTeamRewardsSummary() async {
    try {
      isLoadingTeamRewards.value = true;
      
      // Get team ID from CreateTeamController
      int? teamId;
      if (Get.isRegistered<CreateTeamController>()) {
        final createTeamController = Get.find<CreateTeamController>();
        teamId = createTeamController.createdTeamId.value;
      }
      
      if (teamId != null) {
        final response = await _dio.get(
          '${_getBaseUrl()}/final-team-score/team/$teamId/rewards-summary',
        );

        if (response.statusCode == 200) {
          final data = response.data;
          totalBadges.value = data['totalBadges'] ?? 0;
          totalTrophies.value = data['totalTrophies'] ?? 0;
          teamSuccessRate.value = (data['successRate'] ?? 0).toDouble();
          teamLevelFromAPI.value = data['teamLevel'] ?? 0;
          
          // Load team members
          if (data['members'] != null) {
            final List<dynamic> members = data['members'];
            teamMembers.assignAll(members.cast<Map<String, dynamic>>());
          }
        }
      }
    } catch (e) {
      log('Error loading team rewards summary: $e');
      SnackbarHelper.error('Failed to load team rewards');
    } finally {
      isLoadingTeamRewards.value = false;
    }
  }

  /// Refresh team rewards
  Future<void> refreshTeamRewards() async {
    await _loadTeamRewardsSummary();
  }

  // ============================================================================
  // SCOREBOARD METHODS
  // ============================================================================

  /// Load scoreboard data
  Future<void> _loadScoreboard() async {
    try {
      isLoadingScoreboard.value = true;
      
      // Load teams
      await _loadTeams();
      
      // Load leaderboard
      await _loadLeaderboard();
      
    } catch (e) {
      log('Error loading scoreboard: $e');
      SnackbarHelper.error('Failed to load scoreboard');
    } finally {
      isLoadingScoreboard.value = false;
    }
  }

  /// Load teams for selection
  Future<void> _loadTeams() async {
    try {
      // This would typically come from API
      // For now, using static data based on the UI
      teams.assignAll([
        {
          'id': '1',
          'name': 'Team Alpha',
          'avatar': 'assets/images/team_alpha.png',
          'level': 5,
        },
        {
          'id': '2',
          'name': 'Team Mavericks',
          'avatar': 'assets/images/team_mavericks.png',
          'level': 4,
        },
        {
          'id': '3',
          'name': 'Team Warriors',
          'avatar': 'assets/images/team_warriors.png',
          'level': 3,
        },
        {
          'id': '4',
          'name': 'Team Innovation',
          'avatar': 'assets/images/team_innovation.png',
          'level': 2,
        },
      ]);
    } catch (e) {
      log('Error loading teams: $e');
    }
  }

  /// Load leaderboard data
  Future<void> _loadLeaderboard() async {
    try {
      // This would typically come from API
      // For now, using static data based on the UI
      leaderboard.assignAll([
        {
          'rank': 1,
          'teamName': 'You (Team Alpha)',
          'points': 110,
          'isCurrentUser': true,
        },
        {
          'rank': 4,
          'teamName': 'Team Quora',
          'points': 570,
          'isCurrentUser': false,
        },
        {
          'rank': 5,
          'teamName': 'Team Titans',
          'points': 450,
          'isCurrentUser': false,
        },
        {
          'rank': 7,
          'teamName': 'Team Mavericks',
          'points': 300,
          'isCurrentUser': false,
        },
        {
          'rank': 8,
          'teamName': 'Team Warriors',
          'points': 292,
          'isCurrentUser': false,
        },
        {
          'rank': 9,
          'teamName': 'Team Legends',
          'points': 254,
          'isCurrentUser': false,
        },
        {
          'rank': 10,
          'teamName': 'Team Pioneers',
          'points': 180,
          'isCurrentUser': false,
        },
      ]);
      
      // Set personal ranking
      personalRanking.value = "I'm ranked #3 in Strategic Agility this week!";
    } catch (e) {
      log('Error loading leaderboard: $e');
    }
  }

  /// Select team for scoreboard
  void selectTeam(String teamId) {
    selectedTeamId.value = teamId;
    SnackbarHelper.success('Team selected: $teamId');
  }

  /// Continue with selected team
  void continueWithSelectedTeam() {
    if (selectedTeamId.value.isEmpty) {
      SnackbarHelper.warning('Please select a team first');
      return;
    }
    
    // Navigate to team scoreboard or perform action
    SnackbarHelper.success('Continuing with team: ${selectedTeamId.value}');
  }

  // ============================================================================
  // GAME COMPLETE METHODS
  // ============================================================================

  /// Load game complete data
  Future<void> loadGameCompleteData() async {
    try {
      isLoadingGameComplete.value = true;
      
      // Get team ID
      int? teamId;
      if (Get.isRegistered<CreateTeamController>()) {
        final createTeamController = Get.find<CreateTeamController>();
        teamId = createTeamController.createdTeamId.value;
      }
      
      if (teamId != null) {
        // Load team score summary
        await _loadTeamScoreSummary(teamId);
        
        // Load individual scores
        await _loadIndividualScores(teamId);
      }
    } catch (e) {
      log('Error loading game complete data: $e');
      SnackbarHelper.error('Failed to load game complete data');
    } finally {
      isLoadingGameComplete.value = false;
    }
  }

  /// Load team score summary
  Future<void> _loadTeamScoreSummary(int teamId) async {
    try {
      final response = await _dio.get(
        '${_getBaseUrl()}/final-team-score/$teamId/summary',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        finalScore.value = data['teamScore'] ?? 0;
        
        // Load breakdown
        if (data['breakdown'] != null) {
          final breakdown = data['breakdown'];
          breakdownItems.assignAll([
            {
              'title': 'Strategy Selection',
              'score': '${breakdown['alignmentStrategy']}/15',
              'success': (breakdown['alignmentStrategy'] ?? 0) > 0,
            },
            {
              'title': 'Objective Alignment',
              'score': '${breakdown['objectiveClarity']}/15',
              'success': (breakdown['objectiveClarity'] ?? 0) > 0,
            },
            {
              'title': 'Key Results Quality',
              'score': '${breakdown['keyResultQuality']}/25',
              'success': (breakdown['keyResultQuality'] ?? 0) > 0,
            },
            {
              'title': 'Initiative Relevance',
              'score': '${breakdown['initiativeRelevance']}/25',
              'success': (breakdown['initiativeRelevance'] ?? 0) > 0,
            },
            {
              'title': 'Challenge Adaptation',
              'score': '${breakdown['challengeAdoption']}/20',
              'success': (breakdown['challengeAdoption'] ?? 0) > 0,
            },
          ]);
        }
        
        // Load achievements
        if (data['achievements'] != null) {
          achievements.assignAll(data['achievements'].cast<String>());
        }
      }
    } catch (e) {
      log('Error loading team score summary: $e');
    }
  }

  /// Load individual scores
  Future<void> _loadIndividualScores(int teamId) async {
    try {
      final user = _storageRepository.getUser();
      if (user != null) {
        final response = await _dio.get(
          '${_getBaseUrl()}/final-team-score/$teamId/user/${user.id}/score',
        );

        if (response.statusCode == 200) {
          final data = response.data;
          badge.value = data['badge'] ?? '';
          trophy.value = data['trophy'] ?? '';
          title.value = data['title'] ?? '';
        }
      }
    } catch (e) {
      log('Error loading individual scores: $e');
    }
  }

  /// Play again
  void playAgain() {
    // Reset game data
    finalScore.value = 0;
    badge.value = '';
    trophy.value = '';
    title.value = '';
    breakdownItems.clear();
    achievements.clear();
    memberScores.clear();
    
    // Navigate to new game
    Get.offAllNamed('/ai-analysis-show-screen');
  }

  /// View badges
  void viewBadges() {
    SnackbarHelper.info('View badges feature coming soon');
  }

  /// Share score
  void shareScore() {
    SnackbarHelper.info('Share score feature coming soon');
  }

  /// View journey
  void viewJourney() {
    SnackbarHelper.info('View journey feature coming soon');
  }

  /// View individual score
  void viewIndividualScore() {
    SnackbarHelper.info('View individual score feature coming soon');
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================


  String _getBaseUrl() {
    return ApiConstants.baseUrl;
  }


  /// Get progress as 0..1 double
  double getProgressValue() => (successRate.value.clamp(0, 100)) / 100.0;

  /// Refresh all dashboard data
  Future<void> refreshAllData() async {
    await Future.wait([
      _loadPersonalDashboard(),
      _loadTeamRewardsSummary(),
      _loadScoreboard(),
    ]);
  }

  /// Get team by ID
  Map<String, dynamic>? getTeamById(String teamId) {
    try {
      return teams.firstWhere((team) => team['id'] == teamId);
    } catch (e) {
      return null;
    }
  }

  /// Get current user's team
  Map<String, dynamic>? getCurrentUserTeam() {
    return getTeamById(selectedTeamId.value);
  }

  /// Check if user is in a team
  bool get isInTeam => selectedTeamId.value.isNotEmpty;

  /// Get team level progress
  double getTeamLevelProgress() {
    return (teamLevel.value.clamp(1, 5) - 1) / 4.0;
  }
}
