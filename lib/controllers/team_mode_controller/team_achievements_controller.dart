import 'package:get/get.dart';

class TeamAchievementsController extends GetxController {
  final teamName = "Team Alpha".obs;
  final teamLevel = 5.obs;
  final points = 110.obs;

  final badges = 12.obs;
  final trophies = 16.obs;
  final games = 3.obs;

  final recentAchievements = <String>[
    "Strategic Thinker",
    "Goal Master",
    "Innovation Expert",
    "Challenge Solver"
  ].obs;

  final recentGames = <Map<String, String>>[
    {
      "title": "Team Campaign - Level 1",
      "date": "Jan 15, 2025",
      "score": "85%"
    },
    {
      "title": "Team Challenge",
      "date": "Jan 12, 2025",
      "score": "92%"
    },
  ].obs;
}
