// lib/services/api_service.dart
import 'dart:developer';
import 'package:dio/dio.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  String baseUrl = 'http://54.145.244.15:3000';

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors for logging and error handling
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => log(obj.toString()),
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        log('API Error: ${error.message}');
        log('Error Response: ${error.response?.data}');
        handler.next(error);
      },
    ));
  }

  // ============================================================================
  // TEAM STRATEGY APIs
  // ============================================================================

  /// Get Team Strategy
  /// POST /game/team-strategy
  Future<Map<String, dynamic>> getTeamStrategy({
    required int teamId,
    required String role,
  }) async {
    try {
      final response = await _dio.post(
        '/game/team-strategy',
        data: {
          'teamId': teamId,
          'role': role,
        },
      );
      return response.data;
    } catch (e) {
      log('Error getting team strategy: $e');
      rethrow;
    }
  }

  // ============================================================================
  // OBJECTIVES APIs
  // ============================================================================

  /// Generate Objectives
  /// POST /objectives/generate
  Future<List<Map<String, dynamic>>> generateObjectives({
    required int strategyId,
    required String strategy,
    required String role,
    required String industry,
    required String language,
  }) async {
    try {
      final response = await _dio.post(
        '/objectives/generate',
        data: {
          'strategyId': strategyId,
          'strategy': strategy,
          'role': role,
          'industry': industry,
          'language': language,
        },
      );
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      log('Error generating objectives: $e');
      rethrow;
    }
  }

  /// Fetch Objectives by Strategy ID
  /// GET /objectives/fetch-strategy-id-based?strategyId=2
  Future<Map<String, dynamic>> fetchObjectivesByStrategyId(int strategyId) async {
    try {
      final response = await _dio.get(
        '/objectives/fetch-strategy-id-based',
        queryParameters: {'strategyId': strategyId},
      );
      return response.data;
    } catch (e) {
      log('Error fetching objectives: $e');
      rethrow;
    }
  }

  /// Fetch Objectives for Challenge
  /// GET /objectives/fetch-objective-for-challenge?strategyId=2
  Future<Map<String, dynamic>> fetchObjectivesForChallenge(int strategyId) async {
    try {
      final response = await _dio.get(
        '/objectives/fetch-objective-for-challenge',
        queryParameters: {'strategyId': strategyId},
      );
      return response.data;
    } catch (e) {
      log('Error fetching challenge objectives: $e');
      rethrow;
    }
  }

  // ============================================================================
  // KEY RESULTS APIs
  // ============================================================================

  /// Create Batch Key Results
  /// POST /key-result/batch
  Future<Map<String, dynamic>> createBatchKeyResults({
    required String strategy,
    required List<String> objectives,
    required String role,
    required String language,
  }) async {
    try {
      final response = await _dio.post(
        '/key-result/batch',
        data: {
          'strategy': strategy,
          'objectives': objectives,
          'role': role,
          'language': language,
        },
      );
      return response.data;
    } catch (e) {
      log('Error creating batch key results: $e');
      rethrow;
    }
  }

  /// Fetch Key Results by Strategy
  /// GET /key-result/by-strategy?strategyId=5
  Future<Map<String, dynamic>> fetchKeyResultsByStrategy(int strategyId) async {
    try {
      final response = await _dio.get(
        '/key-result/by-strategy',
        queryParameters: {'strategyId': strategyId},
      );
      return response.data;
    } catch (e) {
      log('Error fetching key results: $e');
      rethrow;
    }
  }

  // ============================================================================
  // AI EVALUATION APIs
  // ============================================================================

  /// Evaluate AI Suggestion
  /// POST /team/keyresuts/evaluate
  Future<Map<String, dynamic>> evaluateAISuggestion({
    required String strategy,
    required String role,
    required String industry,
    required String objective,
    required String keyResults,
    required String language,
  }) async {
    try {
      final response = await _dio.post(
        '/team/keyresuts/evaluate',
        data: {
          'strategy': strategy,
          'role': role,
          'industry': industry,
          'objective': objective,
          'keyResults': keyResults,
          'language': language,
        },
      );
      return response.data;
    } catch (e) {
      log('Error evaluating AI suggestion: $e');
      rethrow;
    }
  }

  // ============================================================================
  // INNOVATIVE IDEAS APIs
  // ============================================================================

  /// Add Innovative Ideas to Key Result
  /// POST /keywordbase-innovative
  Future<void> addInnovativeIdeas({
    required int strategyId,
    required String keyResult,
    required Map<String, dynamic> firstInnovative,
    required Map<String, dynamic> secondInnovative,
    Map<String, dynamic>? thirdInnovative,
  }) async {
    try {
      await _dio.post(
        '/keywordbase-innovative',
        data: {
          'strategyid': strategyId,
          'keyresult': keyResult,
          'firstinnovative': firstInnovative,
          'secondinnovative': secondInnovative,
          if (thirdInnovative != null) 'thirdinnovative': thirdInnovative,
        },
      );
    } catch (e) {
      log('Error adding innovative ideas: $e');
      rethrow;
    }
  }

  /// Fetch Innovative Ideas by Strategy
  /// GET /keywordbase-innovative/strategy/4
  Future<List<Map<String, dynamic>>> fetchInnovativeIdeasByStrategy(int strategyId) async {
    try {
      final response = await _dio.get(
        '/keywordbase-innovative/strategy/$strategyId',
      );
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      log('Error fetching innovative ideas: $e');
      rethrow;
    }
  }

  // ============================================================================
  // INITIATIVES APIs
  // ============================================================================

  /// Evaluate Initiatives
  /// POST /team/evaluate-initiatives
  Future<Map<String, dynamic>> evaluateInitiatives({
    required String strategy,
    required String objective,
    required String keyResult,
    required List<String> initiatives,
    required String language,
  }) async {
    try {
      final response = await _dio.post(
        '/team/evaluate-initiatives',
        data: {
          'strategy': strategy,
          'objective': objective,
          'keyResult': keyResult,
          'initiatives': initiatives,
          'language': language,
        },
      );
      return response.data;
    } catch (e) {
      log('Error evaluating initiatives: $e');
      rethrow;
    }
  }

  // ============================================================================
  // CHALLENGE APIs
  // ============================================================================

  /// Generate Challenge
  /// POST /challenge
  Future<Map<String, dynamic>> generateChallenge({
    required String strategy,
    required String objective,
    required String keyResult,
    required int previousAttempts,
    required String language,
  }) async {
    try {
      final response = await _dio.post(
        '/challenge',
        data: {
          'strategy': strategy,
          'objective': objective,
          'keyResult': keyResult,
          'previousAttempts': previousAttempts,
          'language': language,
        },
      );
      return response.data;
    } catch (e) {
      log('Error generating challenge: $e');
      rethrow;
    }
  }

  /// Final Challenge OKR Evaluation
  /// POST /team-challenges/evaluation
  Future<Map<String, dynamic>> evaluateFinalChallenge({
    required String strategy,
    required String objective,
    required String keyResult,
    required String challenge,
    required String proposal,
  }) async {
    try {
      final response = await _dio.post(
        '/team-challenges/evaluation',
        data: {
          'strategy': strategy,
          'objective': objective,
          'keyResult': keyResult,
          'challenge': challenge,
          'proposal': proposal,
        },
      );
      return response.data;
    } catch (e) {
      log('Error evaluating final challenge: $e');
      rethrow;
    }
  }

  // ============================================================================
  // TEAM SCORING APIs
  // ============================================================================

  /// Submit Final Team Score
  /// POST /final-team-score
  Future<void> submitFinalTeamScore({
    required String userId,
    required int teamId,
    required int score,
    required String title,
    required int alignmentStrategy,
    required int objectiveClarity,
    required int keyResultQuality,
    required int initiativeRelevance,
    required int challengeAdoption,
    required String time,
  }) async {
    try {
      await _dio.post(
        '/final-team-score',
        data: {
          'userId': userId,
          'teamId': teamId,
          'score': score,
          'title': title,
          'alignmentStrategy': alignmentStrategy,
          'objectiveClarity': objectiveClarity,
          'keyResultQuality': keyResultQuality,
          'initiativeRelevance': initiativeRelevance,
          'challengeAdoption': challengeAdoption,
          'time': time,
        },
      );
    } catch (e) {
      log('Error submitting team score: $e');
      rethrow;
    }
  }

  /// Get Final Team Score
  /// GET /final-team-score/7/summary
  Future<Map<String, dynamic>> getFinalTeamScore(int teamId) async {
    try {
      final response = await _dio.get(
        '/final-team-score/$teamId/summary',
      );
      return response.data;
    } catch (e) {
      log('Error getting final team score: $e');
      rethrow;
    }
  }

  /// Get User Final Score in Team
  /// GET /final-team-score/7/user/userId/score
  Future<Map<String, dynamic>> getUserFinalScoreInTeam(int teamId, String userId) async {
    try {
      final response = await _dio.get(
        '/final-team-score/$teamId/user/$userId/score',
      );
      return response.data;
    } catch (e) {
      log('Error getting user final score: $e');
      rethrow;
    }
  }

  /// Get Team Rewards Summary
  /// GET /final-team-score/team/2/rewards-summary
  Future<Map<String, dynamic>> getTeamRewardsSummary(int teamId) async {
    try {
      final response = await _dio.get(
        '/final-team-score/team/$teamId/rewards-summary',
      );
      return response.data;
    } catch (e) {
      log('Error getting team rewards summary: $e');
      rethrow;
    }
  }

  // ============================================================================
  // TEAM MANAGEMENT APIs
  // ============================================================================

  /// Get Team Details
  /// GET /team/{id}/details
  Future<Map<String, dynamic>> getTeamDetails(int teamId) async {
    try {
      final response = await _dio.get(
        '/team/$teamId/details',
      );
      return response.data;
    } catch (e) {
      log('Error getting team details: $e');
      rethrow;
    }
  }

  /// Get Team Members
  /// GET /team/{teamId}/members
  Future<List<Map<String, dynamic>>> getTeamMembers(int teamId) async {
    try {
      final response = await _dio.get(
        '/team/$teamId/members',
      );
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      log('Error getting team members: $e');
      rethrow;
    }
  }

  // ============================================================================
  // WEBSOCKET APIs
  // ============================================================================

  /// Send WS Invite
  /// POST /ws/invite
  Future<void> sendWsInvite(String teamToken) async {
    try {
      await _dio.post(
        '/ws/invite',
        data: {'teamToken': teamToken},
      );
    } catch (e) {
      log('Error sending WS invite: $e');
      rethrow;
    }
  }

  /// Join WS Team
  /// POST /ws/join-team
  Future<void> joinWsTeam(String teamToken, String userId) async {
    try {
      await _dio.post(
        '/ws/join-team',
        data: {
          'teamToken': teamToken,
          'userId': userId,
        },
      );
    } catch (e) {
      log('Error joining WS team: $e');
      rethrow;
    }
  }

  /// Send WS Message
  /// POST /ws/message
  Future<void> sendWsMessage(String teamToken, String message) async {
    try {
      await _dio.post(
        '/ws/message',
        data: {
          'teamToken': teamToken,
          'message': message,
        },
      );
    } catch (e) {
      log('Error sending WS message: $e');
      rethrow;
    }
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Update base URL
  void updateBaseUrl(String newUrl) {
    baseUrl = newUrl;
    _dio.options.baseUrl = newUrl;
  }

  /// Get current base URL
  String get currentBaseUrl => baseUrl;

  /// Add authentication header
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Remove authentication header
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Add custom header
  void addHeader(String key, String value) {
    _dio.options.headers[key] = value;
  }

  /// Remove custom header
  void removeHeader(String key) {
    _dio.options.headers.remove(key);
  }
}
