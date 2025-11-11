import 'package:game_app/generated/models/requests/generate_initiatives_request.dart';
import 'package:game_app/generated/models/responses/key_results/key_results_response.dart';
import 'package:game_app/generated/models/responses/strategy/generate_intiatives_response.dart';
import 'package:game_app/generated/models/responses/team_mode/final_evalution_response.dart';
import 'package:game_app/generated/models/responses/team_mode/strategy_response.dart';
import '../../generated/models/responses/strategy/strategy_response.dart' hide GetTeamStrategyRequest;
import '../../generated/network.dart';
import '../datasources/strategy_api.dart';

// NEW IMPORTS for Challenge and Scoring Integration
import '../../generated/models/responses/contexual_challenge/contextual_challenge_model.dart';

class StrategyRepository {
  final _strategyApi = StrategyApi(dio);

  /// Fetch random strategy image
  Future<StrategyResponse> getStrategyImage() async {
    final response = await _strategyApi.getRandomStrategy();
    return response;
  }

  // -----------------------------------------------------------
  // TEAM CHALLENGE & SCORING ENDPOINTS
  // -----------------------------------------------------------
  
  /// ✅ 1. Generate challenge (POST /challenge)
  Future<ChallengeResponse> getChallenge({
    required String strategy,
    required String objective,
    required String keyResult,
    required int previousAttempts,
    required String language,
  }) async {
    final response = await _strategyApi.getChallenge({
      "strategy": strategy,
      "objective": objective,
      "keyResult": keyResult,
      "previousAttempts": previousAttempts,
      "language": language,
    });
    // Simple check: throw if both expected fields are null/empty
    if (response.title == null && response.text == null) {
        throw Exception('Failed to generate challenge: Empty response.');
    }
    return response;
  }
  
  /// ✅ 2. Final Challenge OKR Evaluation (POST /team-challenges/evaluation)
  Future<FinalEvaluationResponse> evaluateFinalChallenge(Map<String, dynamic> body) async {
    final response = await _strategyApi.evaluateFinalChallenge(body);
    if (response.score == null) {
      throw Exception('Final evaluation failed or returned no score.');
    }
    return response;
  }

  /// ✅ 3. Submit Final Team Score (POST /final-team-score)
  Future<Map<String, dynamic>> submitFinalTeamScore(Map<String, dynamic> body) async {
    final response = await _strategyApi.submitFinalTeamScore(body);
    // Check for success message or score presence
    if (response['score'] == null && response['message']?.contains('successfully') != true) {
      throw Exception(response['message'] ?? 'Score submission failed.');
    }
    return response;
  }
  
  /// ✅ 4. Get Final Team Score Summary (GET /final-team-score/{teamId}/summary)
  Future<Map<String, dynamic>> getFinalTeamScoreSummary(int teamId) async {
      final response = await _strategyApi.getFinalTeamScoreSummary(teamId);
      if (response['teamId'] == null && response['score'] == null) {
          throw Exception(response['message'] ?? 'Failed to get team summary.');
      }
      return response;
  }
  
  /// ✅ 5. Get User Final Score in Team (GET /final-team-score/{teamId}/user/{userId}/score)
  Future<Map<String, dynamic>> getUserFinalScoreInTeam(int teamId, String userId) async {
      final response = await _strategyApi.getUserFinalScoreInTeam(teamId, userId);
      if (response['score'] == null && response['userId'] == null) {
          throw Exception(response['message'] ?? 'Failed to get user score.');
      }
      return response;
  }

  /// ✅ 6. Get Team Success Rate (GET /final-team-score/successrate/{teamId})
  Future<Map<String, dynamic>> getTeamSuccessRate(int teamId) async {
      final response = await _strategyApi.getTeamSuccessRate(teamId);
      if (response['successRate'] == null && response['level'] == null) {
          throw Exception(response['message'] ?? 'Failed to get team success rate.');
      }
      return response;
  }
  
  // -----------------------------------------------------------
  // EXISTING CORE METHODS (Ensuring they still work)
  // -----------------------------------------------------------

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
    
    if (response is List<KeyResultResponse>) {
      for (final KeyResultResponse item in response) {
        keyResults.addAll(item.topLevelKeyResults ?? []);
        for (final text in item.text ?? <Text>[]) {
            keyResults.addAll(text.keyResults ?? []);
        }
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
    
    if (response.statusCode != null && response.statusCode != 200) {
      throw Exception(response.message ?? 'Failed to fetch team strategy');
    }

    return response;
  }

  /// Evaluate Key Results
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

  /// Add Innovative Ideas
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

  /// Fetch Innovative Ideas by Strategy
  Future<InnovativeIdeasResponse> fetchInnovativeIdeas(int strategyId) async {
    final response = await _strategyApi.fetchInnovativeIdeas(strategyId);
    return response;
  }
}