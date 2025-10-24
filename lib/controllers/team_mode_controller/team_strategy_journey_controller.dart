import 'package:get/get.dart';
import 'package:game_app/utils/snackbar_helper.dart';
import 'team_game_complete_controller.dart'; // Dependency on the screen that fetched final data

class TeamStrategyJourneyController extends GetxController {

  // Dependency injected to access live game results
  // Note: We use lazyPut in AppBindings, so we must manually ensure it's loaded if relying on it.
  // In this flow, TeamGameCompleteController should already be initialized.
  TeamGameCompleteController get _completeController => Get.find<TeamGameCompleteController>();

  // Reactive list structure, populated dynamically
  final RxList<Map<String, dynamic>> strengths = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> growthOpportunities = <Map<String, dynamic>>[].obs;
  final RxList<String> achievements = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Use future to allow data in _completeController to settle after its API call
    _loadJourneyData(); 
  }

  void _loadJourneyData() async {
    // Awaiting a brief moment ensures the asynchronous data loading in TeamGameCompleteController has likely finished.
    // In production, robust architecture would use listeners or state management signals.
    await 100.milliseconds; 
    
    // Check if the source controller has processed the API response (score > 0 implies data load attempted)
    if (_completeController.score.value == 0 && _completeController.breakdownItems.isEmpty) {
        // Fallback or wait for data. Use a placeholder message for now.
        _useFallbackData();
        return;
    }

    // --- Data Mapping from TeamGameCompleteController's API results ---
    
    // 1. Map Achievements (which already came from the API/fallback in TCC)
    achievements.assignAll(_completeController.achievements);

    // 2. Map Strengths and Opportunities based on the Performance Breakdown
    _mapFeedbackFromBreakdown(_completeController.breakdownItems);
  }

  void _mapFeedbackFromBreakdown(List<Map<String, dynamic>> breakdown) {
      // Clear previous static data
      strengths.clear();
      growthOpportunities.clear();

      // Simple heuristic: If score/max is > 50%, treat as a strength. Otherwise, it's an opportunity.
      for (var item in breakdown) {
          final title = item['title'].toString().tr; // Use translated title key
          final success = item['success'] as bool;
          
          final Map<String, dynamic> feedbackItem = {
              "title": title,
              "subtitle": success ? "excellent_connection_between_strategy_and_objectives".tr : "consider_more_specific_and_measurable_key_results".tr,
              "success": success
          };

          if (success) {
              strengths.add(feedbackItem);
          } else {
              growthOpportunities.add(feedbackItem);
          }
      }
      
      // Fallback if the breakdown items were empty for some reason
      if (strengths.isEmpty && growthOpportunities.isEmpty) {
          _useFallbackData();
      }
  }

  void _useFallbackData() {
    // Reverts to static placeholder data on API failure or empty results
    strengths.assignAll([
      {
        "title": "strategic_alignment".tr,
        "subtitle": "excellent_connection_between_strategy_and_objectives".tr,
        "success": true
      },
      {
        "title": "initiative_quality".tr,
        "subtitle": "well_defined_and_actionable_initiatives".tr,
        "success": true
      },
    ]);

    growthOpportunities.assignAll([
      {
        "title": "metrics_precision".tr,
        "subtitle": "consider_more_specific_and_measurable_key_results".tr,
        "success": true
      },
    ]);

    achievements.assignAll([
      "completed_strategic_cycle".tr,
      "adapted_market_challenge".tr,
    ]);
  }

  void resetJourney() {
    // Placeholder for reset logic
  }

  static TeamStrategyJourneyController getOrPut() {
    return Get.isRegistered<TeamStrategyJourneyController>()
        ? Get.find<TeamStrategyJourneyController>()
        : Get.put(TeamStrategyJourneyController(), permanent: true);
  }
}
