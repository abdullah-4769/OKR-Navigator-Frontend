// lib/controllers/team_mode_controller/team_game_complete_controller.dart
import 'dart:developer';
import 'package:game_app/data/repositories/strategy_repository.dart';
import 'package:game_app/controllers/team_mode_controller/create_team_controller.dart';
import 'package:game_app/controllers/team_mode_controller/team_strategy_journey_controller.dart';
import 'package:game_app/data/repositories/storage_repository.dart';
import 'package:game_app/services/notification_service.dart';
import 'package:game_app/utils/snackbar_helper.dart';
import 'package:get/get.dart';
import '../../presentation/routes/app_routes.dart'; 

class TeamGameCompleteController extends GetxController {
  
  // ----------------------
  // Observables
  // ----------------------

  /// Final score
  final RxInt score = 0.obs;

  /// Rewards & Achievements
  final RxList<String> badges = <String>[].obs;
  final RxList<String> titles = <String>[].obs;
  final RxString trophy = "".obs;

  /// Performance breakdown
  final RxInt points = 0.obs;
  final RxInt totalPoints = 0.obs;
  final RxList<Map<String, dynamic>> breakdownItems = <Map<String, dynamic>>[].obs;

  /// Achievements
  final RxList<String> achievements = <String>[].obs;

  /// Journey Map state
  final RxBool showJourneyDetails = true.obs;
  
  // ADDED: List to hold member data for TeamMemberCard widgets
  final RxList<Map<String, dynamic>> memberData = <Map<String, dynamic>>[].obs; 

  // Dependencies
  final StrategyRepository _strategyRepository = Get.find<StrategyRepository>();
  final StorageRepository _storageRepository = Get.find<StorageRepository>();
  final FirebaseNotificationService _notificationService = Get.find<FirebaseNotificationService>();
  

  // ----------------------
  // Lifecycle
  // ----------------------

  @override
  void onInit() {
    super.onInit();
    // Removed synchronous calls to prevent "null check" errors in Get.snackbar
    // _loadGameResults(); 
    // _loadTeamMemberStatus(); 
  }
  
  @override
  void onReady() {
    super.onReady();
    // Deferred loading until the binding and context are fully ready
    _loadGameResults(); 
    _loadTeamMemberStatus(); 
  }

  // ----------------------
  // Private Methods
  // ----------------------

  /// Fetches game results from the final score API endpoint
  void _loadGameResults() async {
    // Get dependencies
    final teamId = Get.find<CreateTeamController>().createdTeamId.value; 
    final userId = _storageRepository.getUser()?.id; 
 
    // FIX: Suppress error if not logged in (e.g., during Splash/Login screens)
    if (teamId == null || userId == null) {
        // log('Team ID or User ID missing for final score fetch. Using fallback.');
        // SnackbarHelper.error('Cannot load game results. Missing game context.');
        // _useFallbackData();
        return;
    }
    
    try {
      // API Call: GET /final-team-score/{teamId}/summary 
      final summaryResult = await _strategyRepository.getFinalTeamScoreSummary(teamId); 

      // Extract and map data
      score.value = summaryResult['teamScore'] ?? 0;
      
      final breakdown = summaryResult['breakdown'] as Map<String, dynamic>?;
      if (breakdown != null) {
          points.value = breakdown['totalPointsAchieved'] ?? 0;
          totalPoints.value = breakdown['totalPointsPossible'] ?? 0;

          // Map breakdown details
          breakdownItems.assignAll([
              {"title": "Strategy Selection", "score": "${breakdown['alignmentStrategy']}/15", "success": (breakdown['alignmentStrategy']??0) > 0},
              {"title": "Objective Alignment", "score": "${breakdown['objectiveClarity']}/15", "success": (breakdown['objectiveClarity']??0) > 0},
              {"title": "Key Results Quality", "score": "${breakdown['keyResultQuality']}/25", "success": (breakdown['keyResultQuality']??0) > 0},
              {"title": "Initiative Relevance", "score": "${breakdown['initiativeRelevance']}/25", "success": (breakdown['initiativeRelevance']??0) > 0},
              {"title": "Challenge Adaptation", "score": "${breakdown['challengeAdoption']}/20", "success": (breakdown['challengeAdoption']??0) > 0},
          ]);
      }
      
      achievements.assignAll(summaryResult['achievements']?.map((e) => e.toString())?.toList() ?? ["Completed strategic cycle".tr]);
      
      // Load team badge and trophy
      if (summaryResult['teamBadge'] != null) {
        badges.assignAll([summaryResult['teamBadge'].toString()]);
      }
      if (summaryResult['teamTrophy'] != null) {
        trophy.value = summaryResult['teamTrophy'].toString();
      }
      
      log('Team game results loaded successfully.');

    } catch (e, s) {
      log('Error fetching team final score: $e', stackTrace: s);
        SnackbarHelper.error('Failed to load team results. Using fallback data.');
      _useFallbackData();
    }
  }

  /// Load team member status and scores
  void _loadTeamMemberStatus() async {
    final teamId = Get.find<CreateTeamController>().createdTeamId.value;
    if (teamId == null) return;

    try {
      // Get team details to get member list from the summary response
      final summaryResult = await _strategyRepository.getFinalTeamScoreSummary(teamId);
      
      // Check if members exist in the summary response
      final members = summaryResult['members'] as List<dynamic>? ?? [];
      
      if (members.isNotEmpty) {
        final List<Map<String, dynamic>> memberScores = [];
        final currentUserId = _storageRepository.getUser()?.id;
        
        for (final member in members) {
          try {
            // Get individual score for each member
            final userId = member['userId']?.toString() ?? member['id']?.toString();
            if (userId == null) continue;
            
            final userScoreData = await _strategyRepository.getUserFinalScoreInTeam(teamId, userId);
            
            memberScores.add({
              'userId': userId,
              'name': member['name']?.toString() ?? member['user']?['name']?.toString() ?? 'Unknown',
              'role': member['role']?.toString() ?? member['user']?['role']?.toString() ?? 'Player',
              'level': (userScoreData['level'] as num? ?? 1).toInt(),
              'points': (userScoreData['points'] as num? ?? 0).toInt(),
              'score': (userScoreData['score'] as num? ?? 0).toInt(),
              'badge': userScoreData['badge']?.toString() ?? '',
              'trophy': userScoreData['trophy']?.toString() ?? '',
              'title': userScoreData['title']?.toString() ?? '',
              'status': (userScoreData['score'] as num? ?? 0) > 0 ? 'Completed' : 'Pending',
              'isCurrentUser': userId == currentUserId,
          });
        } catch (e) {
            // If individual score fetch fails, use default values
            final userId = member['userId']?.toString() ?? member['id']?.toString() ?? 'unknown';
            memberScores.add({
              'userId': userId,
              'name': member['name']?.toString() ?? member['user']?['name']?.toString() ?? 'Unknown',
              'role': member['role']?.toString() ?? member['user']?['role']?.toString() ?? 'Player',
              'level': 1,
              'points': 0,
              'score': 0,
              'badge': '',
              'trophy': '',
              'title': '',
              'status': 'Pending',
              'isCurrentUser': userId == currentUserId,
          });
        }
      }
      
        memberData.assignAll(memberScores);
        
        // Send team game complete notifications
        if (memberScores.isNotEmpty) {
          _sendTeamGameCompleteNotifications(memberScores);
        }
      }
      
    } catch (e) {
      log('Error loading team member status: $e');
      SnackbarHelper.error('Failed to load team member status');
    }
  }

  /// Send team game complete notifications
  void _sendTeamGameCompleteNotifications(List<Map<String, dynamic>> memberScores) {
    final teamId = Get.find<CreateTeamController>().createdTeamId.value;
    if (teamId == null) return;

    final user = _storageRepository.getUser();
    if (user == null) return;

    // Determine if team won (score > 85)
    final isWinner = score.value > 85;

    // Send notifications to all team members
    for (final member in memberScores) {
      final memberUserId = member['userId'] as String?;
      if (memberUserId != null && memberUserId != user.id) {
        _notificationService.sendTeamGameComplete(
          playerName: user.name ?? 'Team Member',
          recipientUserId: memberUserId,
          teamId: teamId,
          isWinner: isWinner,
        );
      }
    }
  }

  /// Use fallback data when API calls fail
  void _useFallbackData() {
    score.value = 78;
    points.value = 9;
    totalPoints.value = 10;
    
    badges.assignAll(["Strategic Thinker".tr]);
    titles.assignAll(["Master Adapter".tr]);
    trophy.value = "Silver".tr;

    breakdownItems.assignAll([
      {"title": "Strategy Selection", "score": "2/2", "success": true},
      {"title": "Objective Alignment", "score": "2/2", "success": true},
      {"title": "Key Results Quality", "score": "1/2", "success": false},
      {"title": "Initiative Relevance", "score": "2/2", "success": true},
      {"title": "Challenge Adaptation", "score": "2/2", "success": true},
    ]);

    achievements.assignAll([
      "Completed strategic cycle".tr,
      "Adapted market challenge".tr,
      "Demonstrated thinking excellence".tr,
      "Earned strategic architect".tr,
    ]);

    // Don't add fake member data - only show real data from API
    memberData.clear();
  }

  // ----------------------
  // Actions
  // ----------------------

  /// Play again - reset and start new game
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
    memberData.clear();

    // Navigate to home screen
    Get.offAllNamed(AppRoutes.home);
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
    Get.put(TeamStrategyJourneyController.getOrPut());
    Get.toNamed('/teamStrategicJourneyScreen');
  }

  /// View individual score
  void viewIndividualScore() {
    SnackbarHelper.info('View individual score feature coming soon');
  }

  /// Go to dashboard
  void goToDashboard() {
    Get.offAllNamed('/personal-dashboard');
  }

  /// Go to scoreboard
  void goToScoreboard() {
    Get.toNamed('/scoreboard');
  }

  /// Go to team lobby
  void goToTeamLobby() {
    Get.toNamed('/team-lobby');
  }

  /// Get current user's score
  int getCurrentUserScore() {
    final user = _storageRepository.getUser();
    if (user != null) {
      final member = memberData.firstWhereOrNull((m) => m['userId'] == user.id);
      return member?['score'] ?? 0;
    }
    return 0;
  }

  /// Get current user's status
  String getCurrentUserStatus() {
    final user = _storageRepository.getUser();
    if (user != null) {
      final member = memberData.firstWhereOrNull((m) => m['userId'] == user.id);
      return member?['status'] ?? 'Pending';
    }
    return 'Pending';
  }

  /// Check if team won
  bool get isTeamWinner => score.value > 85;

  /// Get team performance message
  String get teamPerformanceMessage {
    if (isTeamWinner) {
      return "Your team won! Congratulations!";
    } else {
      return "Game over. Review your feedback and prepare for the next match.";
    }
  }

  /// Get journey completion percentage
  double get journeyCompletionPercentage {
    if (totalPoints.value == 0) return 0.0;
    return (points.value / totalPoints.value).clamp(0.0, 1.0);
  }

  /// Get success rate percentage
  double get successRatePercentage {
    final successCount = breakdownItems.where((item) => item['success'] == true).length;
    if (breakdownItems.isEmpty) return 0.0;
    return (successCount / breakdownItems.length).clamp(0.0, 1.0);
  }

  /// Get team level based on score
  int get teamLevel {
    if (score.value >= 90) return 5;
    if (score.value >= 80) return 4;
    if (score.value >= 70) return 3;
    if (score.value >= 60) return 2;
    return 1;
  }

  /// Get team level name
  String get teamLevelName {
    switch (teamLevel) {
      case 5: return "Strategic Masters";
      case 4: return "Strategic Architects";
      case 3: return "Strategic Planners";
      case 2: return "Strategic Learners";
      default: return "Strategic Beginners";
    }
  }

  /// Get completion status for each category
  Map<String, bool> get categoryCompletionStatus {
    final Map<String, bool> status = {};
    for (final item in breakdownItems) {
      status[item['title']] = item['success'] ?? false;
    }
    return status;
  }

  /// Get total completed categories
  int get completedCategories {
    return breakdownItems.where((item) => item['success'] == true).length;
  }

  /// Get total categories
  int get totalCategories => breakdownItems.length;

  /// Check if all categories are completed
  bool get allCategoriesCompleted => completedCategories == totalCategories;

  /// Get achievement count
  int get achievementCount => achievements.length;

  /// Get badge count
  int get badgeCount => badges.length;

  /// Get title count
  int get titleCount => titles.length;

  /// Get member count
  int get memberCount => memberData.length;

  /// Get completed member count
  int get completedMemberCount {
    return memberData.where((member) => member['status'] == 'Completed').length;
  }

  /// Get pending member count
  int get pendingMemberCount {
    return memberData.where((member) => member['status'] == 'Pending').length;
  }

  /// Get team completion percentage
  double get teamCompletionPercentage {
    if (memberCount == 0) return 0.0;
    return (completedMemberCount / memberCount).clamp(0.0, 1.0);
  }
}