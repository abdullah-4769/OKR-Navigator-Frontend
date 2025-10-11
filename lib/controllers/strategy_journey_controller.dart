import 'package:get/get.dart';

class StrategyJourneyController extends GetxController {
  /// progress is percentage 0..100
  final RxDouble progress = 100.0.obs;

  /// Steps labels used by CustomJourneyMap
  final RxList<String> steps = <String>[
    "strategy_selection",
    "objective_selection",
    "key_result_selection",
    "initiatives_suggestion",
    "result_performance",
  ].obs;

  /// completedSteps length must match steps
  final RxList<bool> completedSteps = <bool>[true, true, true, true, true].obs;

  /// toggle whether we display details in the journey map
  final RxBool showDetails = false.obs;

  /// Key Strengths items (title, subtitle, success)
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

  /// Growth opportunities
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

  /// Achievement summary lines
  final RxList<String> achievements = <String>[
    "completed_strategic_cycle",
    "adapted_market_challenge",
    "demonstrated_thinking_excellence",
    "earned_strategic_architect",
  ].obs;

  /// Toggle show/hide journey details
  void toggleJourneyDetails() => showDetails.value = !showDetails.value;

  /// Mark a step completed (index safety-checked) and recompute progress
  void completeStep(int index) {
    if (index >= 0 && index < completedSteps.length) {
      completedSteps[index] = true;
      _recomputeProgress();
    }
  }

  /// Mark a step incomplete
  void uncompleteStep(int index) {
    if (index >= 0 && index < completedSteps.length) {
      completedSteps[index] = false;
      _recomputeProgress();
    }
  }

  void _recomputeProgress() {
    final completed = completedSteps.where((e) => e).length;
    final percent = (completed / steps.length) * 100.0;
    progress.value = percent;
  }

  /// Reset everything (useful for "Play again")
  void resetJourney() {
    for (var i = 0; i < completedSteps.length; i++) {
      completedSteps[i] = false;
    }
    _recomputeProgress();
    showDetails.value = false;
  }

  /// Helper: safe initialization (call from main if you want)
  static StrategyJourneyController getOrPut() {
    return Get.isRegistered<StrategyJourneyController>()
        ? Get.find<StrategyJourneyController>()
        : Get.put(StrategyJourneyController(), permanent: true);
  }
}
