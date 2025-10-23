import 'package:get/get.dart';

class TeamStrategyJourneyController extends GetxController {
  final RxList<Map<String, dynamic>> strengths = <Map<String, dynamic>>[
    {
      "title": "strategic_alignment",
      "subtitle": "excellent_connection_between_strategy_and_objectives",
      "success": true
    },
    {
      "title": "creative_problem_solving",
      "subtitle": "innovative_approach_to_challenge_adaptation",
      "success": true
    },
    {
      "title": "initiative_quality",
      "subtitle": "well_defined_and_actionable_initiatives",
      "success": true
    },
  ].obs;

  final RxList<Map<String, dynamic>> growthOpportunities =
      <Map<String, dynamic>>[
        {
          "title": "metrics_precision",
          "subtitle": "consider_more_specific_and_measurable_key_results",
          "success": true
        },
        {
          "title": "timeline_awareness",
          "subtitle": "factor_in_realistic_timeframes_for_implementation",
          "success": true
        },
      ].obs;

  final RxList<String> achievements = <String>[
    "completed_strategic_cycle",
    "adapted_market_challenge",
    "demonstrated_thinking_excellence",
    "earned_strategic_architect",
  ].obs;

  void resetJourney() {
    // If you want to reset anything in future, you can do here
  }

  static TeamStrategyJourneyController getOrPut() {
    return Get.isRegistered<TeamStrategyJourneyController>()
        ? Get.find<TeamStrategyJourneyController>()
        : Get.put(TeamStrategyJourneyController(), permanent: true);
  }
}
