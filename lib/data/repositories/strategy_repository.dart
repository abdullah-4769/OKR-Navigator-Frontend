import 'package:game_app/generated/models/requests/generate_initiatives_request.dart';
import 'package:game_app/generated/models/responses/key_results/key_results_response.dart';
import 'package:game_app/generated/models/responses/strategy/generate_intiatives_response.dart';
import 'package:game_app/generated/models/responses/team_mode/strategy_response.dart';
import '../../generated/models/responses/strategy/strategy_response.dart' hide GetTeamStrategyRequest;
import '../../generated/network.dart';
import '../datasources/strategy_api.dart';


class StrategyRepository {
  final _strategyApi = StrategyApi(dio);

  /// Fetch random strategy image
  Future<StrategyResponse> getStrategyImage() async {
    final response = await _strategyApi.getRandomStrategy();
    return response;
  }

  /// Fetch key results for a given strategy
  Future<List<KeyResult>> getKeyResultsByStrategy(int strategyId) async {
    final response = await _strategyApi.getKeyResultsByStrategy(strategyId);
    final List<KeyResult> keyResults = [];
    for (final res in response) {
      for (final text in res.text ?? <Text>[]) {
        keyResults.addAll(text.keyResults ?? []);
      }
    }
    return keyResults;
  }

  /// Submit initiatives to backend for AI evaluation
  Future<GenerateInitiativesResponse> submitInitiatives({
    required String strategy,
    required String objective,
    required List<String> initiatives,
    required List<KeyResult> keyResults,
    required String language,
  }) async {
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
  }

  /// Get team strategy
  Future<TeamStrategyResponse> getTeamStrategy({
    required int teamId,
    String role = 'HOST',
  }) async {
    final request = GetTeamStrategyRequest(teamId: teamId, role: role);
    final response = await _strategyApi.getTeamStrategy(request);
    print("REQYEST STRTEGY");
    print(request);
    print(response);
    if (response.statusCode != null && response.statusCode != 200) {
      throw Exception(response.message ?? 'Failed to fetch team strategy');
    }

    return response;
  }

  /// ✅ Evaluate Key Results
  Future<EvaluateKeyResultsResponse> evaluateKeyResults({
    required String strategy,
    required String role,
    required String industry,
    required String objective,
    required String keyResults,
    required String language,
  }) async {
    final response = await _strategyApi.evaluateKeyResults({
      'strategy': strategy,
      'role': role,
      'industry': industry,
      'objective': objective,
      'keyResults': keyResults,
      'language': language,
    });

    return response;
  }
  
Future<List<KeyResult>> createBatchKeyResults({
    required String strategy,
    required List<String> objectives,
    required String role,
    required String language,
  }) async {
    final response = await _strategyApi.createBatchKeyResults({
      'strategy': strategy,
      'objectives': objectives,
      'role': role,
      'language': language,
    });
    
    final List<KeyResult> keyResults = [];
    
    // --- FIX: Extracting from both possible paths ---
    if (response is List<KeyResultResponse>) {
      for (final KeyResultResponse item in response) {
        // 1. Extract from the new topLevelKeyResults field (for the current API bug)
        keyResults.addAll(item.topLevelKeyResults ?? []);
        
        // 2. Fallback check for the old nested structure (for robustness)
        for (final text in item.text ?? <Text>[]) {
            keyResults.addAll(text.keyResults ?? []);
        }
      }
    }

    // Since the API response contains multiple items (one per objective), 
    // the list 'keyResults' will contain ALL key results generated.
    return keyResults;
  }

  /// ✅ Add Innovative Ideas
  Future<AddInnovativeResponse> addInnovativeIdea({
    required int strategyId,
    required String keyResult,
    required Map<String, String> firstInnovative,
    Map<String, String>? secondInnovative,
    Map<String, String>? thirdInnovative,
  }) async {
    final body = {
      'strategyid': strategyId,
      'keyresult': keyResult,
      'firstinnovative': firstInnovative,
      if (secondInnovative != null) 'secondinnovative': secondInnovative,
      if (thirdInnovative != null) 'thirdinnovative': thirdInnovative,
    };

    final response = await _strategyApi.addInnovativeIdea(body);
    return response;
  }

  /// ✅ Fetch Innovative Ideas by Strategy
  Future<InnovativeIdeasResponse> fetchInnovativeIdeas(int strategyId) async {
    final response = await _strategyApi.fetchInnovativeIdeas(strategyId);
    return response;
  }

  // ✅ NEW: Final Challenge OKR Evaluation (POST /team-challenges/evaluation)
    Future<Map<String, dynamic>> evaluateFinalChallenge(Map<String, dynamic> body) async {
        final response = await dio.post('/team-challenges/evaluation', data: body);
        if (response.statusCode != 200 && response.statusCode != 201) {
             throw Exception(response.data['message'] ?? 'Final evaluation failed.');
        }
        return response.data;
    }

    // ✅ NEW: Submit Final Team Score (POST /final-team-score)
    Future<Map<String, dynamic>> submitFinalTeamScore(Map<String, dynamic> body) async {
        final response = await dio.post('/final-team-score', data: body);
        if (response.statusCode != 200 && response.statusCode != 201) {
             throw Exception(response.data['message'] ?? 'Score submission failed.');
        }
        return response.data;
    }
    
    // ✅ NEW: Get Final Team Score Summary (GET /final-team-score/{teamId}/summary)
    Future<Map<String, dynamic>> getFinalTeamScoreSummary(int teamId) async {
        final response = await dio.get('/final-team-score/$teamId/summary');
        if (response.statusCode != 200 && response.statusCode != 201) {
             throw Exception(response.data['message'] ?? 'Failed to get team summary.');
        }
        return response.data;
    }
    
    // ✅ NEW: Get User Final Score in Team (GET /final-team-score/{teamId}/user/{userId}/score)
    Future<Map<String, dynamic>> getUserFinalScoreInTeam(int teamId, String userId) async {
        final response = await dio.get('/final-team-score/$teamId/user/$userId/score');
        if (response.statusCode != 200 && response.statusCode != 201) {
             throw Exception(response.data['message'] ?? 'Failed to get user score.');
        }
        return response.data;
    }

    // ✅ NEW: Get Team Rewards Summary (GET /final-team-score/team/{teamId}/rewards-summary)
    Future<Map<String, dynamic>> getTeamRewardsSummary(int teamId) async {
        final response = await dio.get('/final-team-score/team/$teamId/rewards-summary');
        if (response.statusCode != 200 && response.statusCode != 201) {
             throw Exception(response.data['message'] ?? 'Failed to get team rewards summary.');
        }
        return response.data;
    }
}


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
