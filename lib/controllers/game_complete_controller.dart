import 'package:get/get.dart';
import '../presentation/routes/app_routes.dart';

class GameCompleteController extends GetxController {
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
  final RxList<Map<String, dynamic>> breakdownItems =
      <Map<String, dynamic>>[].obs;

  /// Achievements
  final RxList<String> achievements = <String>[].obs;

  // ----------------------
  // Lifecycle
  // ----------------------

  @override
  void onInit() {
    super.onInit();
    _loadGameResults();
  }

  // ----------------------
  // Private Methods
  // ----------------------

  /// Simulates loading data (from API, DB, or local service)
  void _loadGameResults() {
    // These could later be fetched dynamically
    score.value = 78;

    badges.assignAll(["strategic_thinker".tr]);
    titles.assignAll(["master_adapter".tr]);
    trophy.value = "silver".tr;

    points.value = 9;
    totalPoints.value = 10;

    breakdownItems.assignAll([
      {"title": "strategy_selection".tr, "score": "2/2", "success": true},
      {"title": "objective_alignment".tr, "score": "2/2", "success": true},
      {"title": "key_results_quality".tr, "score": "1/2", "success": false},
      {"title": "initiative_relevance".tr, "score": "2/2", "success": true},
      {"title": "challenge_adaptation".tr, "score": "2/2", "success": true},
    ]);

    achievements.assignAll([
      "completed_strategic_cycle".tr,
      "adapted_market_challenge".tr,
      "demonstrated_thinking_excellence".tr,
      "earned_strategic_architect".tr,
    ]);
  }

  // ----------------------
  // Actions
  // ----------------------

  void playAgain() {
    // Reset game flow here
    score.value = 0;
    points.value = 0;
    totalPoints.value = 0;
    badges.clear();
    titles.clear();
    trophy.value = "";
    breakdownItems.clear();
    achievements.clear();

    // Navigate to new game screen
    Get.offAllNamed(AppRoutes.aiAnalysisShowScreen);
  }

  void viewBadges() {
    //we will add
  }

  void shareScore() {
    // Example: implement sharing via share_plus
    // Share.share("I scored ${score.value}% in the strategy game!");
  }

  void viewJourney() {
    //we will add
  }
}
