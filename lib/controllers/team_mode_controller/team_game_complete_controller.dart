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
    score.value = 91;

    badges.assignAll(["Strategic Thinker", "Team Player"]);
    titles.assignAll(["Master Adapter", "Collaboration Expert"]);
    trophy.value = "Silver";

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
      "Completed strategic planning cycle as a team",
      "Successfully adapted to market challenge collaboratively",
      "Demonstrated excellent team coordination",
      "Earned 'Strategic Architect' certification as a team",
    ]);
  }

  // ----------------------
  // Actions
  // ----------------------

  void toggleJourneyDetails() {
    showJourneyDetails.value = !showJourneyDetails.value;
  }

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
    showJourneyDetails.value = true;

    // Navigate to new game screen
    // Get.offAllNamed(AppRoutes.teamGameSetupScreen);
  }

  void viewBadges() {
    // Get.toNamed(AppRoutes.teamAchievementScreen);
  }

  void shareScore() {
    // Example: implement sharing via share_plus
    // Share.share("Our team scored ${score.value}% in the strategy game!");
  }

  void viewJourney() {
    Get.toNamed(AppRoutes.teamScoreboardSelectScreen);
  }
}