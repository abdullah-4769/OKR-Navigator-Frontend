// lib/controllers/personal_dashboard_controller.dart
import 'package:get/get.dart';

import '../presentation/routes/app_routes.dart';

class PersonalDashboardController extends GetxController {
  // Numeric / progress state
  final RxInt successRate = 85.obs; // percent
  final RxInt badgesCount = 12.obs;
  final RxInt trophiesCount = 16.obs;
  final RxInt cardsCount = 8.obs;

  // Achievements list (key used for translation)
  final RxList<Map<String, dynamic>> achievements = <Map<String, dynamic>>[
    {"key": "strategic_thinker", "done": true},
    {"key": "goal_master", "done": true},
    {"key": "innovation_expert", "done": true},
    {"key": "challenge_solver", "done": true},
  ].obs;

  // Recent games list (titleKey, dateString, scoreString)
  final RxList<Map<String, String>> recentGames = <Map<String, String>>[
    {
      "titleKey": "solo_campaign_level_1",
      "date": "Jan 15, 2025",
      "score": "85%"
    },
    {
      "titleKey": "team_challenge",
      "date": "Jan 12, 2025",
      "score": "92%"
    },
  ].obs;

  // Actions
  void scheduleAsyncGame() {
    // TODO: navigation / open scheduler
    // For now just a debug print or snackbar (use your SnackbarHelper)
    // SnackbarHelper.info('Schedule Async Game pressed');
  }

  void invitePlayer() {
    // TODO: implement invite flow
  }

  void launchChallenge() {
    Get.offAllNamed(AppRoutes.joinChallengeScreen);
  }

  // Helper: get progress as 0..1 double
  double progressValue() => (successRate.value.clamp(0, 100)) / 100.0;
}