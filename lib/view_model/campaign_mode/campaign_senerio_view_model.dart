import 'package:get/get.dart';
import '../../data/response/api_response.dart';
import '../../data/response/status.dart';
import '../../repository/campaign_mode/campaign_senerio_repository.dart';

class NavigatorCertificationViewModel extends GetxController {
  final NavigatorCertificationRepository _repo = NavigatorCertificationRepository();

  var strategies = ApiResponse.loading().obs;
  var scenarioText = ''.obs;
  var correctStrategyId = 0.obs;

  Future<void> fetchStrategies() async {
    try {
      print('🚀 [ViewModel] Fetching AI scenario strategies...');
      strategies.value = ApiResponse.loading();
      scenarioText.value = '';
      correctStrategyId.value = 0;

      final response = await _repo.fetchAiScenarioStrategies();

      if (response != null && response is Map<String, dynamic>) {
        // Extract scenario from response
        final scenario = response['scenario'] ?? 'No scenario available';
        final strategiesList = response['strategies'] ?? [];
        final correctId = response['correct_strategy_id'] ?? 1;

        // Set the scenario text
        scenarioText.value = scenario;

        // Set the correct strategy ID
        correctStrategyId.value = correctId;

        // Set the strategies
        strategies.value = ApiResponse.completed(strategiesList);

        print('✅ [ViewModel] Scenario loaded: ${scenario.length} characters');
        print('✅ [ViewModel] Strategies loaded: ${strategiesList.length}');
        print('✅ [ViewModel] Correct strategy ID: $correctId');

        // Debug: Print strategy details
        for (var i = 0; i < strategiesList.length; i++) {
          final strategy = strategiesList[i];
          print('🎯 Strategy ${i + 1}: ${strategy['title']}');
          print('   Text: ${strategy['text']}');
        }
      } else {
        print('❌ [ViewModel] No data received or invalid format');
        strategies.value = ApiResponse.error('No data received or invalid format');
      }
    } catch (e, stack) {
      print('❌ [ViewModel] Error fetching strategies: $e');
      print('🧱 Stack trace:\n$stack');
      strategies.value = ApiResponse.error(e.toString());
    }
  }

  // Helper method to check if a strategy is correct
  bool isCorrectStrategy(int strategyId) {
    return strategyId == correctStrategyId.value;
  }

  // Get the correct strategy
  Map<String, dynamic>? getCorrectStrategy() {
    if (strategies.value.status == Status.completed) {
      final strategiesList = strategies.value.data as List<dynamic>? ?? [];
      return strategiesList.firstWhere(
            (strategy) => strategy['id'] == correctStrategyId.value,
        orElse: () => null,
      );
    }
    return null;
  }
}


//
//
//
//
// import 'package:get/get.dart';
// import '../../data/response/api_response.dart';
// import '../../repository/campaign_mode/campaign_senerio_repository.dart';
//
// class NavigatorCertificationViewModel extends GetxController {
//   final NavigatorCertificationRepository _repo = NavigatorCertificationRepository();
//   var strategies = ApiResponse.loading().obs;
//   //
//
// // In your NavigatorCertificationViewModel, ensure you're setting scenarioText:
//   Future<void> fetchStrategies() async {
//     try {
//       strategies.value = ApiResponse.loading();
//
//       final response = await repository.fetchAiScenarioStrategies();
//
//       if (response != null) {
//         // Extract scenario from response
//         final scenario = response['scenario'] ?? '';
//         final strategiesList = response['strategies'] ?? [];
//
//         // Set the scenario text
//         scenarioText.value = scenario;
//
//         // Set the strategies
//         strategies.value = ApiResponse.completed(strategiesList);
//
//         print('✅ Scenario loaded: ${scenario.length} characters');
//         print('✅ Strategies loaded: ${strategiesList.length}');
//       } else {
//         strategies.value = ApiResponse.error('No data received');
//       }
//     } catch (e) {
//       print('❌ Error fetching strategies: $e');
//       strategies.value = ApiResponse.error(e.toString());
//     }
//   }
//
//   // Future<void> fetchStrategies() async {
//   //   try {
//   //     print('🚀 [ViewModel] Fetching AI scenario strategies...');
//   //     strategies.value = ApiResponse.loading();
//   //
//   //     final result = await _repo.fetchStrategies();
//   //
//   //     print('✅ [ViewModel] Strategies loaded: ${result.length}');
//   //     strategies.value = ApiResponse.completed(result);
//   //   } catch (e, stack) {
//   //     print('❌ [ViewModel] Error fetching strategies: $e');
//   //     print('🧱 Stack trace:\n$stack');
//   //     strategies.value = ApiResponse.error(e.toString());
//   //   }
//   // }
// }
//
//
