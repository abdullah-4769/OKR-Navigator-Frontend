import 'dart:developer';
import 'package:game_app/data/repositories/strategy_repository.dart';
import 'package:game_app/controllers/team_mode_controller/create_team_controller.dart';
import 'package:game_app/data/repositories/storage_repository.dart';
import 'package:game_app/utils/snackbar_helper.dart';
import 'package:get/get.dart';
import '../../presentation/routes/app_routes.dart';
import 'team_lobby_controller.dart'; 
import '../../generated/models/responses/team_mode/team_lobby_response.dart'; 

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
  
  TeamLobbyController get _lobbyController => Get.isRegistered<TeamLobbyController>() 
      ? Get.find<TeamLobbyController>() 
      : Get.put(TeamLobbyController());

  // ----------------------
  // Lifecycle
  // ----------------------

  @override
  void onInit() {
    super.onInit();
    _loadGameResults(); 
    _loadTeamMemberStatus(); // Load member data after API calls
  }

  // ----------------------
  // Private Methods
  // ----------------------

  /// Fetches game results from the final score API endpoint
  void _loadGameResults() async {
    // Get dependencies
    final teamId = Get.find<CreateTeamController>().createdTeamId.value; 
    final userId = _storageRepository.getUser()?.id; 

    if (teamId == null || userId == null) {
        log('Team ID or User ID missing for final score fetch. Using fallback.');
        SnackbarHelper.error('Cannot load game results. Missing game context.');
        _useFallbackData();
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
      badges.assignAll(summaryResult['badges']?.map((e) => e.toString())?.toList() ?? ["Strategic Thinker".tr]);
      titles.assignAll(summaryResult['titles']?.map((e) => e.toString())?.toList() ?? ["Master Adapter".tr]);
      trophy.value = summaryResult['teamTrophy'] ?? "Bronze".tr; 
      
      log('Team game results loaded successfully.');

    } catch (e, s) {
      log('Error fetching team final score: $e', stackTrace: s);
      SnackbarHelper.error('Failed to load final results: ${e.toString()}'); 
      _useFallbackData();
    }
  }

  /// Loads member details (name, role, score) by combining lobby data and mock/default scores.
  void _loadTeamMemberStatus() async {
    final currentUser = _storageRepository.getUser();
    
    // Ensure lobby data is fetched if necessary
    if (_lobbyController.teamData.value == null) {
        await _lobbyController.fetchTeamDetails();
    }

    final List<Members> members = _lobbyController.teamData.value?.members ?? [];
    
    final List<Map<String, dynamic>> generatedMembers = [];

    // Use fetched data to populate the list
    for (int i = 0; i < members.length; i++) {
      final member = members[i];
      final isCurrentUser = member.userId == currentUser?.id;
      
      // Use logic similar to TeamStrategicArchitectController to fetch/mock score
      // NOTE: For simplicity, scores for other members are currently mocked until a bulk score endpoint is used.
      final memberScore = isCurrentUser ? (score.value > 0 ? score.value : 87) : (100 - i * 5).clamp(0, 95);
      final memberStatus = memberScore > 0 ? "View" : "Working...";

      generatedMembers.add({
        "name": isCurrentUser ? "You" : (member.user?.name ?? "Unknown"),
        "role": member.role ?? "Player",
        "level": 5, // Static for now
        "score": memberScore,
        "isCurrentUser": isCurrentUser,
        "status": memberStatus,
      });
    }

    // Fallback if the fetched list is too short or empty for demo
    if (generatedMembers.length < 3) {
      generatedMembers.assignAll([
        {"name": "You", "role": "CEO Role", "level": 5, "score": 87, "isCurrentUser": true, "status": "View"},
        {"name": "Johnson", "role": "Strategist", "level": 5, "score": 0, "isCurrentUser": false, "status": "Working..."},
        {"name": "Tasha", "role": "HR Manager", "level": 5, "score": 0, "isCurrentUser": false, "status": "Working..."},
      ]);
    }
    
    memberData.assignAll(generatedMembers);
  }

  void _useFallbackData() {
    // ... (Fallback data implementation) ...
    score.value = 91;
    badges.assignAll(["Strategic Thinker".tr, "Team Player".tr]);
    titles.assignAll(["Master Adapter".tr, "Collaboration Expert".tr]);
    trophy.value = "Silver".tr;
    points.value = 9;
    totalPoints.value = 10;
    breakdownItems.assignAll([
      {"title": "Strategy Selection", "score": "2/2", "success": true},
      {"title": "Objective Alignment", "score": "2/2", "success": true},
      {"title": "Key Results Quality", "score": "1/2", "success": false},
      {"title": "Initiative Relevance", "score": "2/2", "success": true},
      {"title": "Challenge Adaptation", "score": "2/2", "success": true},
    ]);
    achievements.assignAll([
      "Completed strategic planning cycle as a team".tr,
      "Successfully adapted to market challenge collaboratively".tr,
      "Demonstrated excellent team coordination".tr,
      "Earned 'Strategic Architect' certification as a team".tr,
    ]);
  }
  
  // ... (existing action methods) ...
  void toggleJourneyDetails() => showJourneyDetails.value = !showJourneyDetails.value;
  void playAgain() => Get.offAllNamed(AppRoutes.gameMode);
  void viewBadges() => Get.toNamed(AppRoutes.teamAchievementsScreen);
  void shareScore() => SnackbarHelper.info("Sharing team score of ${score.value}%...");
  void viewJourney() => Get.toNamed(AppRoutes.teamStrategicJourneyScreen);
}