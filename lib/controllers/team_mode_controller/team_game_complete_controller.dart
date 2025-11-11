// lib/controllers/team_mode_controller/team_game_complete_controller.dart

import 'dart:developer'; // Import for log()
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:game_app/data/repositories/strategy_repository.dart';
import 'package:game_app/controllers/team_mode_controller/create_team_controller.dart';
import 'package:game_app/controllers/team_mode_controller/team_lobby_controller.dart';
import 'package:game_app/controllers/team_mode_controller/team_strategy_journey_controller.dart';
import 'package:game_app/data/repositories/storage_repository.dart';
import 'package:game_app/services/notification_service.dart';
import 'package:game_app/utils/snackbar_helper.dart';
import 'package:get/get.dart';
import '../../presentation/routes/app_routes.dart';
import 'team_strategy_selection_controller.dart';
import 'team_objective_controller.dart';
import 'team_key_results_controller.dart';
import 'team_suggestion_initiative_controller.dart';
import 'team_contextual_challange_controller.dart';
import 'team_contextual_adjustment_controller.dart';
import 'team_strategic_architect_controller.dart';
import 'team_final_evaluation_controller.dart'; 

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

  // Flag to track if initial score data was set from POST response
  bool _hasInitialScoreData = false;

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
  }
  
  @override
  void onReady() {
    super.onReady();
    // Deferred loading until the binding and context are fully ready
    // Only load from API if initial data wasn't set
    if (!_hasInitialScoreData) {
      _loadGameResults(); 
    }
    _loadTeamMemberStatus(); 
  }

  // ----------------------
  // Private Methods
  // ----------------------
  
  /// Helper to robustly extract breakdown values from the API response.
  List<Map<String, dynamic>> _extractBreakdownValues(Map<String, dynamic> summaryResult) {
      // 1. Try to use the nested 'breakdown' object (preferred structure)
      final nestedBreakdown = summaryResult['breakdown'] as Map<String, dynamic>?;
      
      // 2. Fallback: Use flat keys from the root response (observed in submission logs)
      // Check for 'challengeAdoption' in log.
      final flatAlignment = summaryResult['alignmentStrategy'] ?? summaryResult['alignmentPoints'] ?? 0;
      final flatObjective = summaryResult['objectiveClarity'] ?? summaryResult['objectivePoints'] ?? 0;
      final flatKeyResult = summaryResult['keyResultQuality'] ?? summaryResult['keyResultPoints'] ?? 0;
      final flatInitiative = summaryResult['initiativeRelevance'] ?? summaryResult['initiativePoints'] ?? 0;
      final flatChallenge = summaryResult['challengeAdoption'] ?? summaryResult['challengePoints'] ?? 0;

      // Determine points for the main metric totals
      final totalPointsAchieved = (summaryResult['totalPointsAchieved'] ?? flatAlignment + flatObjective + flatKeyResult + flatInitiative + flatChallenge);
      
      // Update overall observable points
      points.value = (totalPointsAchieved as num).toInt();
      totalPoints.value = summaryResult['totalPointsPossible'] ?? 100;

      return [
          // Use nested structure if available, otherwise use flat keys. 
          {"title": "Strategy Selection", "score": "${nestedBreakdown?['alignmentStrategy'] ?? flatAlignment}/15", "success": (nestedBreakdown?['alignmentStrategy']??flatAlignment) > 0},
          {"title": "Objective Alignment", "score": "${nestedBreakdown?['objectiveClarity'] ?? flatObjective}/15", "success": (nestedBreakdown?['objectiveClarity']??flatObjective) > 0},
          {"title": "Key Results Quality", "score": "${nestedBreakdown?['keyResultQuality'] ?? flatKeyResult}/25", "success": (nestedBreakdown?['keyResultQuality']??flatKeyResult) > 0},
          {"title": "Initiative Relevance", "score": "${nestedBreakdown?['initiativeRelevance'] ?? flatInitiative}/25", "success": (nestedBreakdown?['initiativeRelevance']??flatInitiative) > 0},
          {"title": "Challenge Adaptation", "score": "${nestedBreakdown?['challengeAdoption'] ?? flatChallenge}/20", "success": (nestedBreakdown?['challengeAdoption']??flatChallenge) > 0},
      ];
  }


  /// Set initial score data from POST response (called before navigation)
  void setInitialScoreData({
    required int score,
    required String title,
    String badge = "",
    String trophy = "",
    required int alignmentPoints,
    required int objectivePoints,
    required int keyResultPoints,
    required int initiativePoints,
    required int challengePoints,
    required int totalPoints,
  }) {
    _hasInitialScoreData = true;
    
    // Set score immediately
    this.score.value = score;
    
    // Set points
    this.points.value = alignmentPoints + objectivePoints + keyResultPoints + initiativePoints + challengePoints;
    this.totalPoints.value = totalPoints > 0 ? totalPoints : 100;
    
    // Set breakdown items from the points
    breakdownItems.assignAll([
      {"title": "Strategy Selection", "score": "$alignmentPoints/15", "success": alignmentPoints > 0},
      {"title": "Objective Alignment", "score": "$objectivePoints/15", "success": objectivePoints > 0},
      {"title": "Key Results Quality", "score": "$keyResultPoints/25", "success": keyResultPoints > 0},
      {"title": "Initiative Relevance", "score": "$initiativePoints/25", "success": initiativePoints > 0},
      {"title": "Challenge Adaptation", "score": "$challengePoints/20", "success": challengePoints > 0},
    ]);
    
    // Set rewards if provided
    if (badge.isNotEmpty) {
      badges.assignAll([badge]);
    }
    if (trophy.isNotEmpty) {
      this.trophy.value = trophy;
    }
    if (title.isNotEmpty) {
      titles.assignAll([title]);
    }
    
    achievements.assignAll(["Completed strategic cycle".tr]);
    
    log('Initial score data set. Score: ${this.score.value}');
    
    // Still load from API in background to get any additional data (like member scores)
    _loadGameResults();
  }

  /// Fetches game results from the final score API endpoint
  void _loadGameResults() async {
    // Get dependencies
    final teamId = Get.find<CreateTeamController>().createdTeamId.value; 
    final userId = _storageRepository.getUser()?.id; 

    // FALLBACK CONSTANTS for empty breakdown items (to fix UI display issue)
    final defaultBreakdownStructure = [
        {"title": "Strategy Selection", "score": "0/15", "success": false},
        {"title": "Objective Alignment", "score": "0/15", "success": false},
        {"title": "Key Results Quality", "score": "0/25", "success": false},
        {"title": "Initiative Relevance", "score": "0/25", "success": false},
        {"title": "Challenge Adaptation", "score": "0/20", "success": false},
    ];

    if (teamId == null || userId == null) {
        log('Team ID or User ID missing for final score fetch.');
        if (!_hasInitialScoreData) {
          _useFallbackData(); // Use default breakdown structure only if no initial data
        }
        return;
    }
    
    try {
      // API Call: GET /final-team-score/{teamId}/summary 
      final summaryResult = await _strategyRepository.getFinalTeamScoreSummary(teamId); 
      log('Team Final Score Summary API Response: $summaryResult');

      // ✅ NEW: Parse the new API response structure
      // Response structure: {teamId, teamAverage: {...}, userAverage: [...]}
      final teamAverage = summaryResult['teamAverage'] as Map<String, dynamic>?;
      final userAverage = summaryResult['userAverage'] as List<dynamic>?;

      if (teamAverage != null) {
        // 1. Score from teamAverage
        if (!_hasInitialScoreData) {
          score.value = (teamAverage['score'] as num? 
              ?? teamAverage['avgPercentage'] as num? 
              ?? 0).toInt();
        } else {
          // Even if initial data exists, try to get a better score from API if available
          final apiScore = (teamAverage['score'] as num? 
              ?? teamAverage['avgPercentage'] as num?);
          if (apiScore != null && apiScore.toInt() > 0 && apiScore.toInt() != score.value) {
            log('Updating score from API: ${score.value} -> ${apiScore.toInt()}');
            score.value = apiScore.toInt();
          }
        }
        
        // 2. Breakdown from teamAverage points
        if (!_hasInitialScoreData) {
          final alignmentPoints = (teamAverage['alignmentPoints'] as num? ?? 0).toInt();
          final objectivePoints = (teamAverage['objectivePoints'] as num? ?? 0).toInt();
          final keyResultPoints = (teamAverage['keyResultPoints'] as num? ?? 0).toInt();
          final initiativePoints = (teamAverage['initiativePoints'] as num? ?? 0).toInt();
          final challengePoints = (teamAverage['challengePoints'] as num? ?? 0).toInt();
          final totalPointsValue = (teamAverage['totalPoints'] as num? ?? 6).toInt();

          // Update points
          points.value = alignmentPoints + objectivePoints + keyResultPoints + initiativePoints + challengePoints;
          // Total points should be 10 (2 points per category * 5 categories)
          // API's totalPoints is the achieved total, but we need max possible (10)
          totalPoints.value = 10;

          // Create breakdown items - format as "X/2" based on API response structure
          breakdownItems.assignAll([
            {"title": "Strategy Selection", "score": "$alignmentPoints/2", "success": alignmentPoints > 0},
            {"title": "Objective Alignment", "score": "$objectivePoints/2", "success": objectivePoints > 0},
            {"title": "Key Results Quality", "score": "$keyResultPoints/2", "success": keyResultPoints > 0},
            {"title": "Initiative Relevance", "score": "$initiativePoints/2", "success": initiativePoints > 0},
            {"title": "Challenge Adaptation", "score": "$challengePoints/2", "success": challengePoints > 0},
          ]);
        }
        
        // 3. Rewards & Achievements from teamAverage
        if (badges.isEmpty && teamAverage['badge'] != null) {
          badges.assignAll([teamAverage['badge'].toString()]);
        }
        if (trophy.value.isEmpty && teamAverage['trophy'] != null) {
          trophy.value = teamAverage['trophy'].toString();
        }
        if (titles.isEmpty && teamAverage['title'] != null) {
          titles.assignAll([teamAverage['title'].toString()]);
        }
      } else {
        // Fallback to old structure if teamAverage is not available
        if (!_hasInitialScoreData) {
          score.value = (summaryResult['score'] as num? 
              ?? summaryResult['teamScore'] as num? 
              ?? summaryResult['avgPercentage'] as num? 
              ?? 0).toInt();
        }
        
        if (!_hasInitialScoreData) {
          final mappedBreakdown = _extractBreakdownValues(summaryResult);
          if (mappedBreakdown.isNotEmpty && mappedBreakdown.any((item) => item['score'] != null)) {
              breakdownItems.assignAll(mappedBreakdown);
          } else {
              breakdownItems.assignAll(defaultBreakdownStructure);
          }
        }
        
        if (badges.isEmpty && summaryResult['badge'] != null) {
          badges.assignAll([summaryResult['badge'].toString()]);
        }
        if (trophy.value.isEmpty && summaryResult['trophy'] != null) {
          trophy.value = summaryResult['trophy'].toString();
        }
      }

      // ✅ NEW: Parse userAverage array for member data
      if (userAverage != null && userAverage.isNotEmpty) {
        final List<Map<String, dynamic>> memberScores = [];
        final currentUserId = _storageRepository.getUser()?.id;
        
        // Get team avatar as fallback
        String? teamAvatarPath;
        try {
          final createTeamController = Get.find<CreateTeamController>();
          // Ensure TeamLobbyController is initialized before use
          if (!Get.isRegistered<TeamLobbyController>()) {
            Get.put(TeamLobbyController());
          }
          final teamLobbyController = Get.find<TeamLobbyController>();
          final teamData = teamLobbyController.teamData.value;
          final avatarId = int.tryParse(teamData?.teamavatorid ?? '0') ?? 0;
          if (createTeamController.avatars.isNotEmpty) {
            teamAvatarPath = createTeamController.avatars[avatarId.clamp(0, createTeamController.avatars.length - 1)];
          }
        } catch (e) {
          log('Error getting team avatar: $e');
        }
        
        for (final user in userAverage) {
          if (user is Map<String, dynamic>) {
            final userId = user['userid']?.toString() ?? user['userId']?.toString();
            if (userId == null) continue;
            
            // Use user avatar if available, otherwise fall back to team avatar
            final userAvatar = user['avatar']?.toString();
            final avatarToUse = (userAvatar != null && userAvatar.isNotEmpty) 
                ? userAvatar 
                : teamAvatarPath;
            
            memberScores.add({
              'userId': userId,
              'name': user['name']?.toString() ?? 'Unknown',
              'role': user['role']?.toString() ?? 'Player',
              'level': 1, // Default level if not provided
              'points': 0, // Default points if not provided
              'score': (user['score'] as num? ?? 0).toInt(),
              'badge': '', // Default badge if not provided
              'trophy': '', // Default trophy if not provided
              'title': '', // Default title if not provided
              'status': (user['score'] as num? ?? 0) > 0 ? 'View' : 'Working...',
              'isCurrentUser': userId == currentUserId,
              'avatar': avatarToUse, // Store avatar path (user avatar or team avatar as fallback)
            });
          }
        }
        
        memberData.assignAll(memberScores);
        
        // Send team game complete notifications after member data is loaded
        if (memberScores.isNotEmpty) {
          _sendTeamGameCompleteNotifications(memberScores);
        }
      }

      log('Team game results loaded successfully. Score: ${score.value}');

    } catch (e, s) {
      log('Error fetching team final score: $e', stackTrace: s);
      // Only show error and use fallback if initial data wasn't set
      if (!_hasInitialScoreData) {
        SnackbarHelper.error('Failed to load team results. Using fallback data.');
        _useFallbackData();
      } else {
        // If initial data exists, just log the error but don't overwrite the score
        log('API call failed but initial score data is available. Continuing with initial data.');
      }
    }
  }

  /// Load team member status and scores (now handled in _loadGameResults via userAverage)
  void _loadTeamMemberStatus() async {
    // This method is now redundant as member data is loaded from userAverage in _loadGameResults
    // Keeping it for backward compatibility but it's effectively a no-op
    // The actual member data loading is now in _loadGameResults()
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
    // FIXED: Default score to 0 on failure to reflect missing results
    score.value = 0; 
    points.value = 0;
    totalPoints.value = 0;
    
    badges.assignAll(["Strategic Thinker".tr]);
    titles.assignAll(["Master Adapter".tr]);
    trophy.value = "Silver".tr;

    // Fixed breakdown structure to fix missing UI elements
    breakdownItems.assignAll([
      {"title": "Strategy Selection", "score": "0/15", "success": false},
      {"title": "Objective Alignment", "score": "0/15", "success": false},
      {"title": "Key Results Quality", "score": "0/25", "success": false},
      {"title": "Initiative Relevance", "score": "0/25", "success": false},
      {"title": "Challenge Adaptation", "score": "0/20", "success": false},
    ]);

    achievements.assignAll([
      "Completed strategic cycle".tr,
      "Adapted market challenge".tr,
      "Demonstrated thinking excellence".tr,
      "Earned strategic architect".tr,
    ]);

    // Do not add fake member data - keep empty to show loading/empty state clearly
    memberData.clear();
  }

  // ----------------------
  // Actions
  // ----------------------

  /// Play again - reset and start new game
  /// Clears ALL team controllers for fresh game start
  void playAgain() {
    // Reset this controller's data
    score.value = 0;
    points.value = 0;
    totalPoints.value = 0;
    badges.clear();
    titles.clear();
    trophy.value = "";
    breakdownItems.clear();
    achievements.clear();
    memberData.clear();
    _hasInitialScoreData = false;

    // Clear all team mode controllers
    _clearAllTeamControllers();

    // Navigate to home screen
    Get.offAllNamed(AppRoutes.home);
  }

  /// Clear all team mode controllers for fresh game start
  void _clearAllTeamControllers() {
    try {
      // Clear Team Strategy Selection
      if (Get.isRegistered<TeamStrategySelectionController>()) {
        final strategyController = Get.find<TeamStrategySelectionController>();
        strategyController.selectedCardIndex.value = -1;
        strategyController.isCardRevealed.value = false;
        strategyController.selectedStrategy.value = '';
        strategyController.teamStrategyResponse.value = null;
      }

      // Clear Team Objective
      if (Get.isRegistered<TeamObjectiveController>()) {
        final objectiveController = Get.find<TeamObjectiveController>();
        objectiveController.objectives.clear();
        objectiveController.selectedObjective.value = null;
      }

      // Clear Team Key Results
      if (Get.isRegistered<TeamKeyResultsController>()) {
        final keyResultsController = Get.find<TeamKeyResultsController>();
        keyResultsController.keyResults.clear();
        keyResultsController.selectedIndexes.clear();
        keyResultsController.selectedCount.value = 0;
        keyResultsController.hasFetched.value = false;
      }

      // Clear Team Suggestion Initiatives
      if (Get.isRegistered<TeamSuggestionInitiativesController>()) {
        final initiativesController = Get.find<TeamSuggestionInitiativesController>();
        initiativesController.firstInitiativeTitle.clear();
        initiativesController.firstInitiativeDesc.clear();
        initiativesController.secondInitiativeTitle.clear();
        initiativesController.secondInitiativeDesc.clear();
        initiativesController.aiFeedback.value = '';
        initiativesController.isChallengeMode.value = false;
        initiativesController.attempts.value = 0;
      }

      // Clear Team Contextual Challenge
      if (Get.isRegistered<TeamContextualChallengeController>()) {
        final challengeController = Get.find<TeamContextualChallengeController>();
        challengeController.finalInitiatives.clear();
        challengeController.challengeTitle.value = '';
        challengeController.challengeDescription.value = '';
        challengeController.previousAttempts.value = 1;
      }

      // Clear Team Contextual Adjustment
      if (Get.isRegistered<TeamContextualAdjustmentController>()) {
        final adjustmentController = Get.find<TeamContextualAdjustmentController>();
        adjustmentController.additionalActions.clear();
        adjustmentController.revisedKeyResult.value = "";
      }

      // Clear Team Strategic Architect
      if (Get.isRegistered<TeamStrategicArchitectController>()) {
        final architectController = Get.find<TeamStrategicArchitectController>();
        architectController.score.value = 0;
        architectController.points.value = 0;
        architectController.totalPoints.value = 0;
        architectController.badges.clear();
        architectController.titles.clear();
        architectController.trophy.value = "";
        architectController.breakdownItems.clear();
        architectController.achievements.clear();
      }

      // Clear Team Strategy Journey
      if (Get.isRegistered<TeamStrategyJourneyController>()) {
        final journeyController = Get.find<TeamStrategyJourneyController>();
        journeyController.strengths.clear();
        journeyController.growthOpportunities.clear();
        journeyController.achievements.clear();
      }

      // Clear Team Final Evaluation
      if (Get.isRegistered<TeamFinalEvaluationController>()) {
        final evaluationController = Get.find<TeamFinalEvaluationController>();
        evaluationController.reset();
      }

      log('All team controllers cleared for new game');
    } catch (e) {
      log('Error clearing team controllers: $e');
    }
  }

  /// View badges - Navigate to Team Achievements Screen
  void viewBadges() {
    Get.toNamed(AppRoutes.teamAchievementsScreen);
  }

  /// Share score - Take screenshot and share via WhatsApp/Facebook
  /// Requires: share_plus package
  Future<void> shareScore() async {
    try {
      final context = Get.context;
      if (context == null) {
        SnackbarHelper.error('Cannot share - context unavailable');
        return;
      }

      SnackbarHelper.info('Preparing screenshot for sharing...');
      
      // Get the screenshot key from the screen
      // Note: The screen has RepaintBoundary with key _screenshotKey
      // We'll capture it using the RenderRepaintBoundary approach
      await _captureAndShareScreenshot(context);
      
    } catch (e) {
      log('Error sharing score: $e');
      // Fallback to text sharing
      _shareScoreAsText();
    }
  }

  /// Capture screenshot and share
  Future<void> _captureAndShareScreenshot(BuildContext context) async {
    try {
      // Find RepaintBoundary in the widget tree
      final RenderRepaintBoundary? boundary = 
          context.findAncestorRenderObjectOfType<RenderRepaintBoundary>();
      
      if (boundary == null) {
        log('RepaintBoundary not found, using text share');
        _shareScoreAsText();
        return;
      }

      // Capture the widget as image
      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      
      if (byteData == null) {
        log('Failed to capture image, using text share');
        _shareScoreAsText();
        return;
      }

      final imageBytes = byteData.buffer.asUint8List();
      
      // Save to temp directory and share
      await _saveAndShareImage(imageBytes);
      
    } catch (e) {
      log('Screenshot capture error: $e');
      _shareScoreAsText();
    }
  }

  /// Save image and share via share_plus
  Future<void> _saveAndShareImage(Uint8List imageBytes) async {
    try {
      // Note: Requires path_provider and share_plus packages
      // Add to pubspec.yaml:
      //   path_provider: ^2.1.1
      //   share_plus: ^7.2.1
      
      /*
      import 'package:path_provider/path_provider.dart';
      import 'package:share_plus/share_plus.dart';
      import 'dart:io';
      
      final tempDir = await getTemporaryDirectory();
      final fileName = 'team_score_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(imageBytes);
      
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Check out our team score: ${score.value}%! 🎉\n\n${_getScoreText()}',
      );
      
      SnackbarHelper.success('Score shared successfully!');
      */
      
      // For now, share as text since packages may not be available
      _shareScoreAsText();
      
    } catch (e) {
      log('Error saving/sharing image: $e');
      _shareScoreAsText();
    }
  }

  /// Get score text for sharing
  String _getScoreText() {
    return '''
Final Score: ${score.value}%
Title: ${titles.isNotEmpty ? titles.first : 'Strategic Master'}
Badge: ${badges.isNotEmpty ? badges.first : 'N/A'}
Trophy: ${trophy.value.isNotEmpty ? trophy.value : 'N/A'}

Performance Breakdown:
${breakdownItems.map((item) => '• ${item['title']}: ${item['score']}').join('\n')}

Achievements:
${achievements.map((a) => '✓ $a').join('\n')}
''';
  }

  /// Share score as text (fallback)
  void _shareScoreAsText() {
    final scoreText = '''
🎉 Team Game Complete! 🎉

${_getScoreText()}

#OKRNavigator #TeamGame
''';

    // Try to use share_plus if available
    try {
      // Share.share(scoreText);
      // If share_plus is not available, show in snackbar for now
      SnackbarHelper.info('Score ready to share: ${score.value}%');
      log('Share text: $scoreText');
      
      // On mobile, you can copy to clipboard as alternative
      // Clipboard.setData(ClipboardData(text: scoreText));
      // SnackbarHelper.success('Score copied to clipboard!');
      
    } catch (e) {
      log('Share error: $e');
      SnackbarHelper.info('Share feature requires share_plus package');
    }
  }

  /// View journey
  void viewJourney() {
    Get.put(TeamStrategyJourneyController.getOrPut());
    Get.toNamed(AppRoutes.teamStrategicJourneyScreen);
  }

  /// View individual score for a specific member
  void viewMemberScore(String userId) {
    try {
      // Initialize or get the TeamStrategicArchitectController
      final architectController = TeamStrategicArchitectController.getOrPut();
      
      // Load the specific user's score
      architectController.loadUserScore(userId).then((_) {
        // Navigate to the individual score screen
        Get.toNamed(AppRoutes.teamStrategicArchitectScreen2);
      }).catchError((error) {
        log('Error loading member score: $error');
        SnackbarHelper.error('Failed to load member score');
      });
    } catch (e) {
      log('Error navigating to member score: $e');
      SnackbarHelper.error('Failed to view member score');
    }
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
}