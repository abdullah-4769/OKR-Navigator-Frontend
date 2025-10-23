// lib/data/repositories/strategy_repository.dart

import 'package:get/get.dart';
import 'package:game_app/generated/models/requests/generate_initiatives_request.dart';
import 'package:game_app/generated/models/responses/key_results/key_results_response.dart';
import 'package:game_app/generated/models/responses/strategy/generate_intiatives_response.dart';
import '../../generated/models/responses/strategy/strategy_response.dart';
import '../../generated/network.dart';
import '../datasources/strategy_api.dart';

class StrategyRepository extends GetxService {
  late final StrategyApi _strategyApi;

  StrategyRepository() {
    final dioClient = Get.find<DioClient>();
    _strategyApi = StrategyApi(dioClient.dio);
  }

  /// ✅ Fetch random strategy image
  Future<StrategyResponse> getStrategyImage() async {
    try {
      final response = await _strategyApi.getRandomStrategy();
      return response;
    } catch (e) {
      throw Exception('Failed to fetch strategy image: $e');
    }
  }

  /// ✅ Fetch key results for a given strategy
  Future<List<KeyResult>> getKeyResultsByStrategy(int strategyId) async {
    try {
      final response = await _strategyApi.getKeyResultsByStrategy(strategyId);
      final List<KeyResult> keyResults = [];

      for (final res in response) {
        for (final text in res.text ?? <Text>[]) {
          keyResults.addAll(text.keyResults ?? []);
        }
      }

      return keyResults;
    } catch (e) {
      throw Exception('Failed to fetch key results: $e');
    }
  }

  /// ✅ Submit initiatives to backend for AI evaluation
  Future<GenerateInitiativesResponse> submitInitiatives({
    required String strategy,
    required String objective,
    required List<String> initiatives,
    required List<KeyResult> keyResults,
    required String language,
  }) async {
    try {
      final request = GenerateInitiativesRequest(
        strategy: strategy,
        objective: objective,
        initiatives: initiatives,
        keyResult: keyResults
            .map((keyResult) => '${keyResult.title} ${keyResult.description}')
            .join(','),
        language: language,
      );

      final response = await _strategyApi.evaluateInitiatives(request);

      if (response.statusCode != null && response.statusCode != 200) {
        throw Exception(response.message ?? 'Could not submit initiatives');
      }

      return response;
    } catch (e) {
      throw Exception('Failed to submit initiatives: $e');
    }
  }
}
// import 'package:game_app/generated/models/requests/generate_initiatives_request.dart';
// import 'package:game_app/generated/models/responses/key_results/key_results_response.dart';
// import 'package:game_app/generated/models/responses/strategy/generate_intiatives_response.dart';
// import '../../generated/models/responses/strategy/strategy_response.dart';
// import '../../generated/network.dart';
// import '../datasources/strategy_api.dart';
//
// class StrategyRepository {
//   final _strategyApi = StrategyApi(dio);
//
//   /// ✅ Fetch random strategy image
//   Future<StrategyResponse> getStrategyImage() async {
//     final response = await _strategyApi.getRandomStrategy();
//     return response;
//   }
//
//   /// ✅ Fetch key results for a given strategy
//   Future<List<KeyResult>> getKeyResultsByStrategy(int strategyId) async {
//     final response = await _strategyApi.getKeyResultsByStrategy(strategyId);
//     final List<KeyResult> keyResults = [];
//
//     for (final res in response) {
//       for (final text in res.text ?? <Text>[]) {
//         keyResults.addAll(text.keyResults ?? []);
//       }
//     }
//
//     return keyResults;
//   }
//
//   /// ✅ Submit initiatives to backend for AI evaluation
//   Future<GenerateInitiativesResponse> submitInitiatives({
//     required String strategy,
//     required String objective,
//     required List<String> initiatives,
//     required List<KeyResult> keyResults,
//     required String language,
//   }) async {
//     final request = GenerateInitiativesRequest(
//       strategy: strategy,
//       objective: objective,
//       initiatives: initiatives,
//       keyResult: keyResults
//           .map((keyResult) => '${keyResult.title} ${keyResult.description}')
//           .join(','),
//       language: language,
//     );
//
//     final response = await _strategyApi.evaluateInitiatives(request);
//
//     if (response.statusCode != null && response.statusCode != 200) {
//       throw Exception(response.message ?? 'Could not submit initiatives');
//     }
//
//     return response;
//   }
// }

// import 'package:game_app/generated/models/requests/generate_initiatives_request.dart';
// import 'package:game_app/generated/models/responses/key_results/key_results_response.dart';
// import 'package:game_app/generated/models/responses/strategy/generate_intiatives_response.dart';
//
// import '../../generated/models/responses/strategy/strategy_response.dart';
// import '../../generated/network.dart';
// import '../datasources/strategy_api.dart';
//
// class StrategyRepository {
//   final _strategyApi = StrategyApi(dio);
//
//   Future<StrategyResponse> getStrategyImage() async {
//     final response = await _strategyApi.getRandomStrategy();
//     // if (response.fileUrl == null) {
//     //   throw Exception(response.message ?? 'Could not fetch strategy');
//     // }
//     return response;
//   }
//
//   Future<List<KeyResult>> getKeyResultsByStrategy(int strategyId) async {
//     final response = await _strategyApi.getKeyResultsByStrategy(strategyId);
//     final List<KeyResult> keyResults = [];
//     for (final res in response) {
//       for (final text in res.text ?? <Text>[]) {
//         keyResults.addAll(text.keyResults ?? []);
//       }
//     }
//     return keyResults;
//   }
//
//   Future<GenerateInitiativesResponse> submitInitiatives({
//     required String strategy,
//     required String objective,
//     required List<String> initiatives,
//
//     required List<KeyResult> keyResults,
//     required String language,
//   }) async {
//     final response = await _strategyApi.evaluateInitiatives(
//       GenerateInitiativesRequest(
//         strategy: strategy,
//         objective: objective,
//         initiatives: initiatives,
//         keyResult: keyResults
//             .map((keyResult) => '${keyResult.title} ${keyResult.description}')
//             .join(','),
//         language: language,
//       ),
//     );
//     if (response.statusCode != null && response.statusCode != 200) {
//       throw Exception(response.message ?? 'Could not submit initiatives');
//     }
//     return response;
//   }
// }
