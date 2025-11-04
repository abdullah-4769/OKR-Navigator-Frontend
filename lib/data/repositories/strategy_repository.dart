import 'package:game_app/generated/models/requests/generate_initiatives_request.dart';
import 'package:game_app/generated/models/responses/key_results/key_results_response.dart';
import 'package:game_app/generated/models/responses/strategy/generate_intiatives_response.dart';
import 'package:game_app/generated/models/responses/team_mode/final_evaluation_response.dart';
import 'package:game_app/generated/models/responses/team_mode/strategy_response.dart';
import '../../generated/models/responses/strategy/strategy_response.dart' hide GetTeamStrategyRequest;
import '../../generated/network.dart';
import '../datasources/strategy_api.dart';

// Import challenge model
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

  /// ✅ 6. Get Team Rewards Summary (GET /final-team-score/team/{teamId}/rewards-summary)
  Future<Map<String, dynamic>> getTeamRewardsSummary(int teamId) async {
    final response = await _strategyApi.getTeamRewardsSummary(teamId);
    if (response['teamLevel'] == null && response['successRate'] == null) {
      throw Exception(response['message'] ?? 'Failed to get team rewards summary.');
    }
    return response;
  }

  // -----------------------------------------------------------
  // EXISTING CORE METHODS (Fixed version)
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
        // FIXED: Use the correct class KeyResultResponse {
        //   final int? id;
        //   final int? objectiveId;
        //   final int? strategyId;
        //   final List<Text>? text;
        //   final DateTime? expiresAt;
        //   final List<KeyResult>? topLevelKeyResults;
        //   final List<KeyResult>? keyResults; // Alternative field name
        //
        //   KeyResultResponse({
        //     this.id,
        //     this.objectiveId,
        //     this.strategyId,
        //     this.text,
        //     this.expiresAt,
        //     this.topLevelKeyResults,
        //     this.keyResults,
        //   });
        //
        //   factory KeyResultResponse.fromJson(Map<String, dynamic> json) =>
        //       KeyResultResponse(
        //         id: json['id'],
        //         objectiveId: json['objectiveId'],
        //         strategyId: json['strategyId'],
        //         text: json['text'] == null
        //             ? []
        //             : List<Text>.from(json['text']!.map((x) => Text.fromJson(x))),
        //         expiresAt: json['expiresAt'] == null
        //             ? null
        //             : DateTime.parse(json['expiresAt']),
        //         // Handle both field names - topLevelKeyResults and keyResults
        //         topLevelKeyResults: json['topLevelKeyResults'] == null
        //             ? (json['keyResults'] == null
        //                 ? []
        //                 : List<KeyResult>.from(
        //                     json['keyResults']!.map((x) => KeyResult.fromJson(x)),
        //                   ))
        //             : List<KeyResult>.from(
        //                 json['topLevelKeyResults']!.map((x) => KeyResult.fromJson(x)),
        //               ),
        //         keyResults: json['keyResults'] == null
        //             ? []
        //             : List<KeyResult>.from(
        //                 json['keyResults']!.map((x) => KeyResult.fromJson(x)),
        //               ),
        //       );
        //
        //   Map<String, dynamic> toJson() => {
        //         'id': id,
        //         'objectiveId': objectiveId,
        //         'strategyId': strategyId,
        //         'text': text == null
        //             ? []
        //             : List<dynamic>.from(text!.map((x) => x.toJson())),
        //         'expiresAt': expiresAt?.toIso8601String(),
        //         'topLevelKeyResults': topLevelKeyResults == null
        //             ? []
        //             : List<dynamic>.from(topLevelKeyResults!.map((x) => x.toJson())),
        //         'keyResults': keyResults == null
        //             ? []
        //             : List<dynamic>.from(keyResults!.map((x) => x.toJson())),
        //       };
        //
        //   // Helper method to get all key results regardless of source
        //   List<KeyResult> getAllKeyResults() {
        //     final List<KeyResult> allResults = [];
        //
        //     // Add key results from text field
        //     for (final t in text ?? []) {
        //       allResults.addAll(t.keyResults ?? []);
        //     }
        //
        //     // Add top level key results if available
        //     if (topLevelKeyResults != null && topLevelKeyResults!.isNotEmpty) {
        //       allResults.addAll(topLevelKeyResults!);
        //     }
        //
        //     // Add alternative key results field if available
        //     if (keyResults != null && keyResults!.isNotEmpty) {
        //       allResults.addAll(keyResults!);
        //     }
        //
        //     return allResults;
        //   }
        // }
        //
        // class Text {
        //   final String? role;
        //   final String? strategy;
        //   final String? objective;
        //   final List<KeyResult>? keyResults;
        //
        //   Text({this.role, this.strategy, this.objective, this.keyResults});
        //
        //   factory Text.fromJson(Map<String, dynamic> json) => Text(
        //         role: json['role'],
        //         strategy: json['strategy'],
        //         objective: json['objective'],
        //         keyResults: json['keyResults'] == null
        //             ? []
        //             : List<KeyResult>.from(
        //                 json['keyResults']!.map((x) => KeyResult.fromJson(x)),
        //               ),
        //       );
        //
        //   Map<String, dynamic> toJson() => {
        //         'role': role,
        //         'strategy': strategy,
        //         'objective': objective,
        //         'keyResults': keyResults == null
        //             ? []
        //             : List<dynamic>.from(keyResults!.map((x) => x.toJson())),
        //       };
        // }
        //
        // class KeyResult {
        //   final int? id;
        //   final String? title;
        //   final String? description;
        //
        //   KeyResult({this.id, this.title, this.description});
        //
        //   factory KeyResult.fromJson(Map<String, dynamic> json) => KeyResult(
        //         id: json['id'],
        //         title: json['title'],
        //         description: json['description'],
        //       );
        //
        //   Map<String, dynamic> toJson() => {
        //         'id': id,
        //         'title': title,
        //         'description': description,
        //       };
        // }
        //
        // // Keep other response classes the same as they work fine
        // class EvaluateKeyResultsResponse {
        //   final double? normalizedScore;
        //   final String? explanation;
        //
        //   EvaluateKeyResultsResponse({this.normalizedScore, this.explanation});
        //
        //   factory EvaluateKeyResultsResponse.fromJson(Map<String, dynamic> json) =>
        //       EvaluateKeyResultsResponse(
        //         normalizedScore: json['normalizedScore']?.toDouble(),
        //         explanation: json['explanation'],
        //       );
        //
        //   Map<String, dynamic> toJson() => {
        //         'normalizedScore': normalizedScore,
        //         'explanation': explanation,
        //       };
        // }
        //
        // class AddInnovativeResponse {
        //   final bool? success;
        //   final String? message;
        //
        //   AddInnovativeResponse({this.success, this.message});
        //
        //   factory AddInnovativeResponse.fromJson(Map<String, dynamic> json) =>
        //       AddInnovativeResponse(
        //         success: json['success'],
        //         message: json['message'],
        //       );
        //
        //   Map<String, dynamic> toJson() => {
        //         'success': success,
        //         'message': message,
        //       };
        // }
        //
        // class InnovativeIdea {
        //   final String? title;
        //   final String? description;
        //
        //   InnovativeIdea({this.title, this.description});
        //
        //   factory InnovativeIdea.fromJson(Map<String, dynamic> json) =>
        //       InnovativeIdea(
        //         title: json['title'],
        //         description: json['description'],
        //       );
        //
        //   Map<String, dynamic> toJson() => {
        //         'title': title,
        //         'description': description,
        //       };
        // }
        //
        // class InnovativeIdeasResponse {
        //   final List<InnovativeIdea>? ideas;
        //
        //   InnovativeIdeasResponse({this.ideas});
        //
        //   factory InnovativeIdeasResponse.fromJson(Map<String, dynamic> json) =>
        //       InnovativeIdeasResponse(
        //         ideas: json['ideas'] == null
        //             ? []
        //             : List<InnovativeIdea>.from(
        //                 json['ideas'].map((x) => InnovativeIdea.fromJson(x)),
        //               ),
        //       );
        //
        //   Map<String, dynamic> toJson() => {
        //         'ideas': ideas?.map((x) => x.toJson()).toList(),
        //       };
        // }field name based on your model
        // If topLevelKeyResults doesn't exist, use the standard approach
        for (final text in item.text ?? <Text>[]) {
          keyResults.addAll(text.keyResults ?? []);
        }
        // Alternative: if key results are directly in the response
        if (item.keyResults != null) {
          keyResults.addAll(item.keyResults!);
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