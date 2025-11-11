import 'dart:developer';
import 'package:get/get.dart';
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
    // Wait a brief moment to ensure TeamGameCompleteController has loaded data
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Check if the source controller has processed the API response
    // Only use real API data - no fallback
    if (_completeController.score.value == 0 && _completeController.breakdownItems.isEmpty) {
        // No data available yet - show empty state or wait
        log('Journey: Waiting for game complete data to load...');
        // Retry after delay
        Future.delayed(const Duration(seconds: 1), () {
          if (_completeController.score.value > 0 || _completeController.breakdownItems.isNotEmpty) {
            _loadJourneyData(); // Retry
          } else {
            log('Journey: No data available - showing empty state');
            strengths.clear();
            growthOpportunities.clear();
            achievements.clear();
          }
        });
        return;
    }

    // --- Data Mapping from TeamGameCompleteController's REAL API results ---
    
    // 1. Map Achievements from API (only if available)
    if (_completeController.achievements.isNotEmpty) {
      achievements.assignAll(_completeController.achievements);
    } else {
      achievements.clear();
    }

    // 2. Map Strengths and Opportunities based on REAL Performance Breakdown from API
    if (_completeController.breakdownItems.isNotEmpty) {
      _mapFeedbackFromBreakdown(_completeController.breakdownItems);
    } else {
      strengths.clear();
      growthOpportunities.clear();
    }

    log('Journey data loaded from API: ${strengths.length} strengths, ${growthOpportunities.length} opportunities');
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
      
      // If breakdown items were empty, lists remain empty (no fallback data)
      // This ensures we only show real API data
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
