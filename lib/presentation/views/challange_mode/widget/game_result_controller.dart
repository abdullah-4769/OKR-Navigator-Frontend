import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GameResultController extends GetxController {
  var isLoading = true.obs;
  var error = ''.obs;

  var player1Name = ''.obs;
  var player1Score = 0.obs;
  var player2Name = ''.obs;
  var player2Score = 0.obs;

  var matchType = ''.obs;
  var duration = ''.obs;
  var difficulty = ''.obs;

  var pointsBreakdown = <Map<String, dynamic>>[].obs;
  var feedbackItems = <Map<String, dynamic>>[].obs;

  Future<void> fetchGameResult(String challengeId, String userId) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await http.get(
        Uri.parse("https://okr-navigator-backend.onrender.com/challenge-mode-score?challenge=$challengeId&userId=$userId"),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // Parse your actual backend response here
        player1Name.value = data['opponent']['name'] ?? 'Opponent';
        player1Score.value = data['opponent']['score'] ?? 0;

        player2Name.value = data['user']['name'] ?? 'You';
        player2Score.value = data['user']['score'] ?? 0;

        matchType.value = data['match']['type'] ?? 'N/A';
        duration.value = data['match']['duration'] ?? 'N/A';
        difficulty.value = data['match']['difficulty'] ?? 'N/A';

        pointsBreakdown.assignAll(List<Map<String, dynamic>>.from(data['pointsBreakdown'] ?? []));
        feedbackItems.assignAll(List<Map<String, dynamic>>.from(data['feedback'] ?? []));
      } else {
        error.value = "Failed to fetch game result: ${response.statusCode}";
      }
    } catch (e) {
      error.value = "Error: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
