// lib/controllers/team_mode_controller/team_strategic_architect_controller.dart

import 'dart:developer'; 
import 'package:game_app/data/repositories/storage_repository.dart'; 
import 'package:game_app/data/repositories/strategy_repository.dart'; 
import 'package:game_app/utils/snackbar_helper.dart'; 
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:get/get.dart';
import 'create_team_controller.dart'; 

class TeamStrategicArchitectController extends GetxController {
  
  // Dependencies
  final StrategyRepository _strategyRepository = Get.find<StrategyRepository>();
  final StorageRepository _storageRepository = Get.find<StorageRepository>();

  // Initialized to reactive empty/zero values
  final RxInt score = 0.obs; 
  final RxList<String> badges = <String>[].obs; 
  final RxList<String> titles = <String>[].obs; 
  final RxString trophy = "".obs; 

  final RxInt points = 0.obs; 
  final RxInt totalPoints = 0.obs; 
  final RxList<Map<String, dynamic>> breakdownItems = <Map<String, dynamic>>[].obs;

  final RxList<String> achievements = <String>[].obs; 

  final RxBool showJourneyDetails = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Only load current user's score if not loading a specific user
    if (!_isLoadingSpecificUser) {
      _loadIndividualGameResults(); 
    }
  }
  
  // Observables for error handling
  final RxBool isLoadingResults = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool hasError = false.obs;
  int _retryCount = 0;
  static const int maxRetries = 2;
  bool _isLoadingSpecificUser = false; // Flag to prevent onInit from loading when loading specific user

  // Method to fetch and set individual score data from API
  Future<void> _loadIndividualGameResults({String? userId}) async {
    final teamId = Get.find<CreateTeamController>().createdTeamId.value;
    final targetUserId = userId ?? _storageRepository.getUser()?.id;

    if (teamId == null || targetUserId == null) {
        log('Team ID or User ID missing for individual score fetch.');
        hasError.value = true;
        errorMessage.value = 'Missing game context. Cannot load results.';
        SnackbarHelper.error(errorMessage.value);
        return;
    }
    
    await _fetchUserScoreWithRetry(teamId, targetUserId);
  }

  /// Public method to load a specific user's score
  Future<void> loadUserScore(String userId) async {
    _isLoadingSpecificUser = true;
    _retryCount = 0; // Reset retry count for new user
    await _loadIndividualGameResults(userId: userId);
    _isLoadingSpecificUser = false;
  }

  /// Fetch user score with retry logic
  Future<void> _fetchUserScoreWithRetry(int teamId, String userId) async {
    // Prevent multiple simultaneous calls
    if (isLoadingResults.value) {
      log('Already loading user score, skipping duplicate request');
      return;
    }
    
    while (_retryCount <= maxRetries) {
      try {
        isLoadingResults.value = true;
        hasError.value = false;
        errorMessage.value = '';

        // Log request
        log('🔵 USER FINAL SCORE REQUEST:');
        log('URL: GET /final-team-score/$teamId/user/$userId/score');

        // API Call: GET /final-team-score/{teamId}/user/{userId}/score
        final result = await _strategyRepository.getUserFinalScoreInTeam(teamId, userId)
            .timeout(
              const Duration(seconds: 30),
              onTimeout: () {
                throw Exception('Request timeout');
              },
            );

        // Log response
        log('🟢 USER FINAL SCORE RESPONSE:');
        log('RESPONSE: $result');

        // Validate response has required fields
        if (result.isEmpty) {
          throw Exception('Empty response from server');
        }

        // Map data from API response - handle both userScore and individual score
        final userScore = result['userScore'] ?? result['individualScore'] ?? result['score'];
        if (userScore == null) {
          throw Exception('Incomplete data from server - missing score');
        }

        score.value = (userScore as num).toInt();
        
        // Check for breakdown in nested object first, then root level
        final breakdown = result['breakdown'] as Map<String, dynamic>?;
        
        // Extract points from breakdown object or root level
        final alignmentPoints = breakdown != null 
            ? (breakdown['alignmentStrategy'] ?? breakdown['alignmentPoints'] ?? 0) as num?
            : (result['alignmentPoints'] as num? ?? 0);
        final objectivePoints = breakdown != null
            ? (breakdown['objectiveClarity'] ?? breakdown['objectivePoints'] ?? 0) as num?
            : (result['objectivePoints'] as num? ?? 0);
        final keyResultPoints = breakdown != null
            ? (breakdown['keyResultQuality'] ?? breakdown['keyResultPoints'] ?? 0) as num?
            : (result['keyResultPoints'] as num? ?? 0);
        final initiativePoints = breakdown != null
            ? (breakdown['initiativeRelevance'] ?? breakdown['initiativePoints'] ?? 0) as num?
            : (result['initiativePoints'] as num? ?? 0);
        final challengePoints = breakdown != null
            ? (breakdown['challengeAdoption'] ?? breakdown['challengePoints'] ?? 0) as num?
            : (result['challengePoints'] as num? ?? 0);
        final totalPointsValue = breakdown != null
            ? (breakdown['totalPointsPossible'] ?? breakdown['totalPoints'] ?? 10) as num?
            : (result['totalPoints'] as num? ?? 10);
        
        // Calculate total points achieved
        final totalPointsAchieved = (alignmentPoints?.toInt() ?? 0) + 
                                   (objectivePoints?.toInt() ?? 0) + 
                                   (keyResultPoints?.toInt() ?? 0) + 
                                   (initiativePoints?.toInt() ?? 0) + 
                                   (challengePoints?.toInt() ?? 0);
        
        if (totalPointsAchieved > 0 || totalPointsValue != null) {
            points.value = totalPointsAchieved;
            // Total points should be 10 (2 points per category * 5 categories)
            // API's totalPoints is the achieved total, but we need max possible (10)
            totalPoints.value = 10;

            // Map breakdown details - format as "X/2" based on API response structure
            breakdownItems.assignAll([
                {"title": "Strategy Selection", "score": "${alignmentPoints?.toInt() ?? 0}/2", "success": (alignmentPoints?.toInt() ?? 0) > 0},
                {"title": "Objective Alignment", "score": "${objectivePoints?.toInt() ?? 0}/2", "success": (objectivePoints?.toInt() ?? 0) > 0},
                {"title": "Key Results Quality", "score": "${keyResultPoints?.toInt() ?? 0}/2", "success": (keyResultPoints?.toInt() ?? 0) > 0},
                {"title": "Initiative Relevance", "score": "${initiativePoints?.toInt() ?? 0}/2", "success": (initiativePoints?.toInt() ?? 0) > 0},
                {"title": "Challenge Adaptation", "score": "${challengePoints?.toInt() ?? 0}/2", "success": (challengePoints?.toInt() ?? 0) > 0},
            ]);
        } else {
            _initializeBreakdownStructure();
        }

        // Rewards and Achievements
        // Note: Only use data from API - no fallback
        if (result['achievements'] != null) {
          achievements.assignAll(
            (result['achievements'] as List<dynamic>).map((e) => e.toString()).toList()
          );
        }
        if (result['badge'] != null) {
          badges.assignAll([result['badge'].toString()]);
        }
        if (result['title'] != null) {
          titles.assignAll([result['title'].toString()]);
        }
        if (result['trophy'] != null) {
          trophy.value = result['trophy'].toString();
        }
        
        log('Individual game results loaded successfully.');
        _retryCount = maxRetries + 1; // Exit retry loop on success
        return; // Success - exit retry loop

      } catch (e, s) {
        log('🔴 USER FINAL SCORE ERROR: $e');
        log('STACK TRACE: $s');
        
        // Don't retry on 4xx errors
        if (e.toString().contains('400') || e.toString().contains('401') || e.toString().contains('404')) {
          hasError.value = true;
          errorMessage.value = e.toString();
          SnackbarHelper.error('Failed to load results: ${e.toString()}');
          isLoadingResults.value = false;
          return;
        }

        // Retry on network/timeout errors
        if (_retryCount < maxRetries) {
          _retryCount++;
          final delay = Duration(milliseconds: 1000 * (1 << (_retryCount - 1)));
          log('⚠️ Retry attempt $_retryCount/$maxRetries after ${delay.inMilliseconds}ms');
          await Future.delayed(delay);
          continue;
        } else {
          // Max retries reached
          hasError.value = true;
          errorMessage.value = 'Failed to load results after $maxRetries retries. Please check your connection.';
          SnackbarHelper.error(errorMessage.value);
        }
      } finally {
        if (_retryCount > maxRetries || !hasError.value) {
          isLoadingResults.value = false;
        }
      }
    }
  }

  /// Retry loading user score
  Future<void> retryLoadResults() async {
    _retryCount = 0;
    final teamId = Get.find<CreateTeamController>().createdTeamId.value;
    final userId = _storageRepository.getUser()?.id;
    if (teamId != null && userId != null) {
      await _fetchUserScoreWithRetry(teamId, userId);
    }
  }

  // REMOVED: _useFallbackData() - No fallback data should be shown
  // If API fails, show error message and allow retry

  void _initializeBreakdownStructure() {
      // Only initialize if breakdown exists in API response
      // This should not be called with fallback data
      breakdownItems.clear();
  }

  void toggleJourneyDetails() =>
      showJourneyDetails.value = !showJourneyDetails.value;

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

    // Navigate to home screen
    Get.offAllNamed(AppRoutes.home);
  }

  void viewBadges() {
    // navigate to badges screen
  }

  void shareScore() {
    // share logic
  }

  void viewJourney() {
    Get.toNamed(AppRoutes.teamStrategicJourneyScreen);
  }

  static TeamStrategicArchitectController getOrPut() {
    return Get.isRegistered<TeamStrategicArchitectController>()
        ? Get.find<TeamStrategicArchitectController>()
        : Get.put(TeamStrategicArchitectController(), permanent: true);
  }
}