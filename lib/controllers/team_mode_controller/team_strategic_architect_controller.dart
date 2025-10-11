import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:get/get.dart';

class TeamStrategicArchitectController extends GetxController {
  final RxInt score = 78.obs;

  final RxList<String> badges = <String>["Strategic Thinker"].obs;
  final RxList<String> titles = <String>["Master Adapter"].obs;
  final RxString trophy = "Silver".obs;

  final RxInt points = 9.obs;
  final RxInt totalPoints = 10.obs;

  final RxList<Map<String, dynamic>> breakdownItems = <Map<String, dynamic>>[
    {"title": "Strategy Selection", "score": "2/2", "success": true},
    {"title": "Objective Alignment", "score": "2/2", "success": true},
    {"title": "Key Results Quality", "score": "1/2", "success": false},
    {"title": "Initiative Relevance", "score": "2/2", "success": true},
    {"title": "Challenge Adaptation", "score": "2/2", "success": true},
  ].obs;

  final RxList<String> achievements = <String>[
    "Completed strategic planning cycle",
    "Successfully adapted to market challenge",
    "Demonstrated strategic thinking excellence",
    "Earned 'Strategic Architect' certification"
  ].obs;

  final RxBool showJourneyDetails = true.obs;

  void toggleJourneyDetails() =>
      showJourneyDetails.value = !showJourneyDetails.value;

  void playAgain() {
    // logic to reset or start new game
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
