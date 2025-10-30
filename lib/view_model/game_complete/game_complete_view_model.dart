// lib/view_model/game_complete_view_model.dart

import 'dart:convert';
import 'package:get/get.dart';
import '../../data/repositories/game_complete_repo.dart';
import '../../generated/models/responses/game_complete_model/game_complete_model.dart';
import '../../presentation/widgets/game_complete_widgets/performance_breakdown.dart';
import '../../services/shared_preference.dart';

class GameCompleteViewModel extends GetxController {
  final GameCompleteRepository _repository = GameCompleteRepository();

  var isLoading = false.obs;
  var gameCompleteData = Rxn<GameCompleteModel>();
  var errorMessage = ''.obs;
  var apiDebugInfo = ''.obs; // For debugging API responses

  @override
  void onInit() {
    super.onInit();
    // Auto-fetch game data when ViewModel is initialized
    final String? userId = SharedPrefs.getUserId();
    if (userId != null && userId.isNotEmpty) {
      print('🚀 GameCompleteViewModel initialized - Auto-fetching data for user: $userId');
      fetchLatestGameScore(userId);
    } else {
      print('⚠️ GameCompleteViewModel initialized but no userId found');
    }
  }

  Future<void> fetchLatestGameScore(String userId) async {
    try {
      print('🔄 [ViewModel] Fetching game score for user: $userId');
      isLoading(true);
      errorMessage('');
      apiDebugInfo('');

      final response = await _repository.getLatestGameScore(userId);
      print('📥 [ViewModel] Raw API Response: $response');
      print('📥 [ViewModel] Response type: ${response.runtimeType}');

      // Store debug info for display
      apiDebugInfo.value = 'Raw Response: ${jsonEncode(response)}';

      if (response == null) {
        throw Exception('Null response from server');
      }

      // Check if response is just a success flag without data
      if (response is Map<String, dynamic>) {
        if (response.containsKey('success') && response.length == 1) {
          throw Exception('API returned success flag but no game data. This means no game score exists for this user yet. Please complete a game first.');
        }

        // Check if response has actual game data fields
        final hasGameData = response.containsKey('score') ||
            response.containsKey('badge') ||
            response.containsKey('trophy');

        if (!hasGameData) {
          throw Exception('API response missing game data fields. Response: ${jsonEncode(response)}');
        }
      }

      GameCompleteModel gameData;

      if (response is Map<String, dynamic>) {
        gameData = GameCompleteModel.fromJson(response);
      } else if (response is String) {
        if (response.isEmpty) {
          throw Exception('Empty response string');
        }
        final parsedJson = jsonDecode(response) as Map<String, dynamic>;
        gameData = GameCompleteModel.fromJson(parsedJson);
      } else {
        throw Exception('Unexpected response type: ${response.runtimeType}');
      }

      print('✅ [ViewModel] Parsed Game Data:');
      print('   - Score: ${gameData.score}');
      print('   - Badge: ${gameData.badge}');
      print('   - Trophy: ${gameData.trophy}');
      print('   - Total Points: ${gameData.totalPoints}');
      print('   - Breakdown: ${gameData.breakdown != null ? "Available" : "Missing"}');

      // Validate that we actually got meaningful data
      if (gameData.score == null && gameData.badge == null && gameData.trophy == null) {
        throw Exception('All game data fields are null. The user may not have completed any games yet.');
      }

      gameCompleteData.value = gameData;

    } catch (e) {
      print('❌ [ViewModel] Error: $e');
      errorMessage(e.toString());

      // Don't use fallback data - show the actual error to help debug
      // Comment this out to see real errors instead of mock data
      // _createFallbackData();
    } finally {
      isLoading(false);
    }
  }

  // Fallback data for testing - only use when explicitly needed
  void _createFallbackData() {
    print('🛠 [ViewModel] Creating fallback data for testing');
    gameCompleteData.value = GameCompleteModel(
      score: 85,
      scor: "Great strategic thinking!",
      totalPoints: '8/10',
      badge: "Strategic Thinker",
      trophy: "Silver Trophy",
      breakdown: Breakdown(
        alignmentStrategy: "2/2",
        objectiveClarity: "2/2",
        keyresultQuality: "2/2",
        initiativeRelevance: "1/2",
        challengeAdoption: "1/2",
      ),
    );
  }

  // Manual method to load mock data for testing UI
  void loadMockDataForTesting() {
    print('🧪 [ViewModel] Loading mock data for UI testing');
    _createFallbackData();
  }

  void clearData() {
    gameCompleteData.value = null;
    errorMessage.value = '';
    apiDebugInfo.value = '';
  }

  List<BreakdownItem> getBreakdownItems() {
    final data = gameCompleteData.value;
    if (data?.breakdown == null) {
      print('⚠️ [ViewModel] No breakdown data available');
      return [];
    }

    print('📊 [ViewModel] Building breakdown items');
    return [
      BreakdownItem(
        "strategy_selection".tr,
        data!.breakdown!.alignmentStrategy ?? "0/2",
        _isBreakdownComplete(data.breakdown!.alignmentStrategy),
      ),
      BreakdownItem(
        "objective_alignment".tr,
        data.breakdown!.objectiveClarity ?? "0/2",
        _isBreakdownComplete(data.breakdown!.objectiveClarity),
      ),
      BreakdownItem(
        "key_results_quality".tr,
        data.breakdown!.keyresultQuality ?? "0/2",
        _isBreakdownComplete(data.breakdown!.keyresultQuality),
      ),
      BreakdownItem(
        "initiative_relevance".tr,
        data.breakdown!.initiativeRelevance ?? "0/2",
        _isBreakdownComplete(data.breakdown!.initiativeRelevance),
      ),
      BreakdownItem(
        "challenge_adaptation".tr,
        data.breakdown!.challengeAdoption ?? "0/2",
        _isBreakdownComplete(data.breakdown!.challengeAdoption),
      ),
    ];
  }

  bool _isBreakdownComplete(String? score) {
    if (score == null) return false;
    final parts = score.split('/');
    if (parts.length != 2) return false;
    return parts[0] == parts[1];
  }

  String getScoreTitle() {
    final score = gameCompleteData.value?.score ?? 0;
    print('🎯 [ViewModel] Getting score title for score: $score');
    if (score >= 90) return "strategic_master".tr;
    if (score >= 80) return "strategic_architect".tr;
    if (score >= 70) return "strategic_thinker".tr;
    return "emerging_strategist".tr;
  }
}