// lib/view_model/game_complete_view_model.dart

import 'dart:convert';

import 'package:get/get.dart';
import '../../data/repositories/game_complete_repo.dart';
import '../../generated/models/responses/game_complete_model/game_complete_model.dart';
import '../../presentation/widgets/game_complete_widgets/performance_breakdown.dart';


class GameCompleteViewModel extends GetxController {
  final GameCompleteRepository _repository = GameCompleteRepository();

  var isLoading = false.obs;
  var gameCompleteData = Rxn<GameCompleteModel>();
  var errorMessage = ''.obs;
// lib/view_model/game_complete/game_complete_view_model.dart
// Update the fetchLatestGameScore method:

  Future<void> fetchLatestGameScore(String userId) async {
    try {
      isLoading(true);
      errorMessage('');

      final response = await _repository.getLatestGameScore(userId);

      // ✅ FIXED: Handle different response types
      if (response is Map<String, dynamic>) {
        // If response is already a Map (JSON)
        final gameData = GameCompleteModel.fromJson(response);
        gameCompleteData.value = gameData;
      } else if (response is String) {
        // If response is a String, try to parse it as JSON
        try {
          final parsedJson = jsonDecode(response) as Map<String, dynamic>;
          final gameData = GameCompleteModel.fromJson(parsedJson);
          gameCompleteData.value = gameData;
        } catch (e) {
          throw Exception('Failed to parse response: $e');
        }
      } else {
        throw Exception('Unexpected response type: ${response.runtimeType}');
      }

    } catch (e) {
      errorMessage(e.toString());
      print('❌ Error fetching game score: $e');
    } finally {
      isLoading(false);
    }
   }
     void clearData() {
    gameCompleteData.value = null;
    errorMessage.value = '';
    }

  // Helper methods to convert API data to UI format
  List<BreakdownItem> getBreakdownItems() {
    final data = gameCompleteData.value;
    if (data?.breakdown == null) return [];

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
    if (score >= 90) return "strategic_master".tr;
    if (score >= 80) return "strategic_architect".tr;
    if (score >= 70) return "strategic_thinker".tr;
    return "emerging_strategist".tr;
  }

  String getScoreDescription() {
    final score = gameCompleteData.value?.score ?? 0;
    if (score >= 90) return "strategic_master_desc".tr;
    if (score >= 80) return "strategic_architect_desc".tr;
    if (score >= 70) return "strategic_thinker_desc".tr;
    return "emerging_strategist_desc".tr;
  }
}