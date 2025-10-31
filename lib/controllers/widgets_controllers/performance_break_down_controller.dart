import 'package:get/get.dart';

class GameCompleteController extends GetxController {
  // Final score
  final RxInt score = 78.obs;

  // Rewards & Achievements
  final RxList<String> badges = <String>["strategic_thinker".tr].obs;
  final RxList<String> titles = <String>["master_adapter".tr].obs;
  final RxString trophy = "silver".tr.obs;

  // Performance breakdown
  final RxInt points = 9.obs;
  final RxInt totalPoints = 10.obs;
  final RxList<Map<String, dynamic>> breakdownItems = <Map<String, dynamic>>[
    {"title": "strategy_selection".tr, "score": "2/2", "success": true},
    {"title": "objective_alignment".tr, "score": "2/2", "success": true},
    {"title": "key_results_quality".tr, "score": "1/2", "success": false},
    {"title": "initiative_relevance".tr, "score": "2/2", "success": true},
    {"title": "challenge_adaptation".tr, "score": "2/2", "success": true},
  ].obs;

  // Achievements
  final RxList<String> achievements = <String>[
    "completed_strategic_cycle".tr,
    "adapted_market_challenge".tr,
    "demonstrated_thinking_excellence".tr,
    "earned_strategic_architect".tr,
  ].obs;

  // Journey
  final RxDouble progress = 0.6.obs;
  final RxList<String> steps = <String>[
    "Strategy",
    "Objective",
    "Challenge",
  ].obs;
  final RxList<int> completedSteps = <int>[0, 1].obs;
  final RxBool showDetails = false.obs;

  void toggleJourneyDetails() => showDetails.value = !showDetails.value;

  // Actions
  void playAgain() {}
  void viewBadges() {}
  void shareScore() {}
  void viewJourney() {}
}
