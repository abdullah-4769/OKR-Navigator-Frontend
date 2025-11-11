// lib/controllers/team_mode_controller/team_strategy_controller.dart
import 'dart:developer';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../data/repositories/storage_repository.dart';
import '../../services/notification_service.dart';
import '../../utils/snackbar_helper.dart';
import 'create_team_controller.dart';

class TeamStrategyController extends GetxController {
  final StorageRepository _storageRepository = Get.find<StorageRepository>();
  final FirebaseNotificationService _notificationService = Get.find<FirebaseNotificationService>();
  final Dio _dio = Dio();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxString selectedStrategy = ''.obs;
  final RxString strategyTitle = ''.obs;
  final RxString fileUrl = ''.obs;
  final RxInt strategyId = 0.obs;
  final RxInt teamId = 0.obs;
  final RxString role = 'HOST'.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeTeamData();
  }

  void _initializeTeamData() {
    // Get team ID from CreateTeamController
    if (Get.isRegistered<CreateTeamController>()) {
      final createTeamController = Get.find<CreateTeamController>();
      teamId.value = createTeamController.createdTeamId.value ?? 0;
    }
  }

  /// Get Team Strategy
  /// POST /game/team-strategy
  Future<void> getTeamStrategy() async {
    if (teamId.value == 0) {
      SnackbarHelper.error('Team ID not found');
      return;
    }

    try {
      isLoading.value = true;
      
      final response = await _dio.post(
        '${_getBaseUrl()}/game/team-strategy',
        data: {
          'teamId': teamId.value,
          'role': role.value,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        strategyId.value = data['strategyId'] ?? 0;
        strategyTitle.value = data['title'] ?? '';
        fileUrl.value = data['fileUrl'] ?? '';
        selectedStrategy.value = strategyTitle.value;
        
        SnackbarHelper.success('Strategy loaded successfully');
        
        // Send notification about strategy selection
        _sendStrategyNotification();
      }
    } catch (e) {
      log('Error getting team strategy: $e');
      SnackbarHelper.error('Failed to load team strategy');
    } finally {
      isLoading.value = false;
    }
  }

  /// Generate Objectives
  /// POST /objectives/generate
  Future<List<Map<String, dynamic>>> generateObjectives({
    required String role,
    required String industry,
    required String language,
  }) async {
    try {
      isLoading.value = true;
      
      final response = await _dio.post(
        '${_getBaseUrl()}/objectives/generate',
        data: {
          'strategyId': strategyId.value,
          'strategy': strategyTitle.value,
          'role': role,
          'industry': industry,
          'language': language,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> objectives = response.data;
        return objectives.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      log('Error generating objectives: $e');
      SnackbarHelper.error('Failed to generate objectives');
    } finally {
      isLoading.value = false;
    }
    return [];
  }

  /// Fetch Objectives by Strategy ID
  /// GET /objectives/fetch-strategy-id-based?strategyId=2
  Future<Map<String, dynamic>> fetchObjectivesByStrategyId() async {
    try {
      isLoading.value = true;
      
      final response = await _dio.get(
        '${_getBaseUrl()}/objectives/fetch-strategy-id-based',
        queryParameters: {'strategyId': strategyId.value},
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      log('Error fetching objectives: $e');
      SnackbarHelper.error('Failed to fetch objectives');
    } finally {
      isLoading.value = false;
    }
    return {};
  }

  /// Fetch Objectives for Challenge
  /// GET /objectives/fetch-objective-for-challenge?strategyId=2
  Future<Map<String, dynamic>> fetchObjectivesForChallenge() async {
    try {
      isLoading.value = true;
      
      final response = await _dio.get(
        '${_getBaseUrl()}/objectives/fetch-objective-for-challenge',
        queryParameters: {'strategyId': strategyId.value},
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      log('Error fetching challenge objectives: $e');
      SnackbarHelper.error('Failed to fetch challenge objectives');
    } finally {
      isLoading.value = false;
    }
    return {};
  }

  /// Create Batch Key Results
  /// POST /key-result/batch
  Future<Map<String, dynamic>> createBatchKeyResults({
    required List<String> objectives,
    required String role,
    required String language,
  }) async {
    try {
      isLoading.value = true;
      
      final response = await _dio.post(
        '${_getBaseUrl()}/key-result/batch',
        data: {
          'strategy': strategyTitle.value,
          'objectives': objectives,
          'role': role,
          'language': language,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      log('Error creating batch key results: $e');
      SnackbarHelper.error('Failed to create key results');
    } finally {
      isLoading.value = false;
    }
    return {};
  }

  /// Fetch Key Results by Strategy
  /// GET /key-result/by-strategy?strategyId=5
  Future<Map<String, dynamic>> fetchKeyResultsByStrategy() async {
    try {
      isLoading.value = true;
      
      final response = await _dio.get(
        '${_getBaseUrl()}/key-result/by-strategy',
        queryParameters: {'strategyId': strategyId.value},
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      log('Error fetching key results: $e');
      SnackbarHelper.error('Failed to fetch key results');
    } finally {
      isLoading.value = false;
    }
    return {};
  }

  /// Evaluate AI Suggestion
  /// POST /team/keyresuts/evaluate
  Future<Map<String, dynamic>> evaluateAISuggestion({
    required String role,
    required String industry,
    required String objective,
    required String keyResults,
    required String language,
  }) async {
    try {
      isLoading.value = true;
      
      final response = await _dio.post(
        '${_getBaseUrl()}/team/keyresuts/evaluate',
        data: {
          'strategy': strategyTitle.value,
          'role': role,
          'industry': industry,
          'objective': objective,
          'keyResults': keyResults,
          'language': language,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      log('Error evaluating AI suggestion: $e');
      SnackbarHelper.error('Failed to evaluate suggestion');
    } finally {
      isLoading.value = false;
    }
    return {};
  }

  /// Add Innovative Ideas to Key Result
  /// POST /keywordbase-innovative
  Future<void> addInnovativeIdeas({
    required String keyResult,
    required Map<String, dynamic> firstInnovative,
    required Map<String, dynamic> secondInnovative,
    Map<String, dynamic>? thirdInnovative,
  }) async {
    try {
      isLoading.value = true;
      
      final response = await _dio.post(
        '${_getBaseUrl()}/keywordbase-innovative',
        data: {
          'strategyid': strategyId.value,
          'keyresult': keyResult,
          'firstinnovative': firstInnovative,
          'secondinnovative': secondInnovative,
          if (thirdInnovative != null) 'thirdinnovative': thirdInnovative,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        SnackbarHelper.success('Innovative ideas added successfully');
      }
    } catch (e) {
      log('Error adding innovative ideas: $e');
      SnackbarHelper.error('Failed to add innovative ideas');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch Innovative Ideas by Strategy
  /// GET /keywordbase-innovative/strategy/4
  Future<List<Map<String, dynamic>>> fetchInnovativeIdeasByStrategy() async {
    try {
      isLoading.value = true;
      
      final response = await _dio.get(
        '${_getBaseUrl()}/keywordbase-innovative/strategy/${strategyId.value}',
      );

      if (response.statusCode == 200) {
        final List<dynamic> ideas = response.data;
        return ideas.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      log('Error fetching innovative ideas: $e');
      SnackbarHelper.error('Failed to fetch innovative ideas');
    } finally {
      isLoading.value = false;
    }
    return [];
  }

  /// Evaluate Initiatives
  /// POST /team/evaluate-initiatives
  Future<Map<String, dynamic>> evaluateInitiatives({
    required String objective,
    required String keyResult,
    required List<String> initiatives,
    required String language,
  }) async {
    try {
      isLoading.value = true;
      
      final response = await _dio.post(
        '${_getBaseUrl()}/team/evaluate-initiatives',
        data: {
          'strategy': strategyTitle.value,
          'objective': objective,
          'keyResult': keyResult,
          'initiatives': initiatives,
          'language': language,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      log('Error evaluating initiatives: $e');
      SnackbarHelper.error('Failed to evaluate initiatives');
    } finally {
      isLoading.value = false;
    }
    return {};
  }

  /// Generate Challenge
  /// POST /challenge
  Future<Map<String, dynamic>> generateChallenge({
    required String objective,
    required String keyResult,
    required int previousAttempts,
    required String language,
  }) async {
    try {
      isLoading.value = true;
      
      final response = await _dio.post(
        '${_getBaseUrl()}/challenge',
        data: {
          'strategy': strategyTitle.value,
          'objective': objective,
          'keyResult': keyResult,
          'previousAttempts': previousAttempts,
          'language': language,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      log('Error generating challenge: $e');
      SnackbarHelper.error('Failed to generate challenge');
    } finally {
      isLoading.value = false;
    }
    return {};
  }

  /// Final Challenge OKR Evaluation
  /// POST /team-challenges/evaluation
  Future<Map<String, dynamic>> evaluateFinalChallenge({
    required String objective,
    required String keyResult,
    required String challenge,
    required String proposal,
  }) async {
    try {
      isLoading.value = true;
      
      final response = await _dio.post(
        '${_getBaseUrl()}/team-challenges/evaluation',
        data: {
          'strategy': strategyTitle.value,
          'objective': objective,
          'keyResult': keyResult,
          'challenge': challenge,
          'proposal': proposal,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      log('Error evaluating final challenge: $e');
      SnackbarHelper.error('Failed to evaluate final challenge');
    } finally {
      isLoading.value = false;
    }
    return {};
  }

  /// Submit Final Team Score
  /// POST /final-team-score
  Future<void> submitFinalTeamScore({
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
      isLoading.value = true;
      
      final user = _storageRepository.getUser();
      if (user == null) {
        SnackbarHelper.error('User not found');
        return;
      }
      
      final response = await _dio.post(
        '${_getBaseUrl()}/final-team-score',
        data: {
          'userId': user.id,
          'teamId': teamId.value,
          'score': score,
          'title': title,
          'alignmentStrategy': alignmentStrategy,
          'objectiveClarity': objectiveClarity,
          'keyResultQuality': keyResultQuality,
          'initiativeRelevance': initiativeRelevance,
          'challengeAdoption': challengeAdoption,
          'time': time,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        SnackbarHelper.success('Team score submitted successfully');
        
        // Send notification about score submission
        _sendScoreSubmissionNotification(score);
      }
    } catch (e) {
      log('Error submitting team score: $e');
      SnackbarHelper.error('Failed to submit team score');
    } finally {
      isLoading.value = false;
    }
  }

  /// Get Final Team Score
  /// GET /final-team-score/7/summary
  Future<Map<String, dynamic>> getFinalTeamScore() async {
    try {
      isLoading.value = true;
      
      final response = await _dio.get(
        '${_getBaseUrl()}/final-team-score/${teamId.value}/summary',
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      log('Error getting final team score: $e');
      SnackbarHelper.error('Failed to get team score');
    } finally {
      isLoading.value = false;
    }
    return {};
  }

  /// Get User Final Score in Team
  /// GET /final-team-score/7/user/userId/score
  Future<Map<String, dynamic>> getUserFinalScoreInTeam(String userId) async {
    try {
      isLoading.value = true;
      
      final response = await _dio.get(
        '${_getBaseUrl()}/final-team-score/${teamId.value}/user/$userId/score',
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      log('Error getting user final score: $e');
      SnackbarHelper.error('Failed to get user score');
    } finally {
      isLoading.value = false;
    }
    return {};
  }

  /// Get Team Success Rate
  /// GET /final-team-score/successrate/{teamId}
  Future<Map<String, dynamic>> getTeamSuccessRate() async {
    try {
      isLoading.value = true;
      
      final response = await _dio.get(
        '${_getBaseUrl()}/final-team-score/successrate/${teamId.value}',
      );

      if (response.statusCode == 200) {
        return response.data;
      }
    } catch (e) {
      log('Error getting team rewards summary: $e');
      SnackbarHelper.error('Failed to get team rewards');
    } finally {
      isLoading.value = false;
    }
    return {};
  }

  // Helper methods
  String _getBaseUrl() {
    // Replace with your actual API base URL
    return 'http://54.145.244.15:3000';
  }

  void _sendStrategyNotification() {
    final user = _storageRepository.getUser();
    if (user != null && teamId.value != 0) {
      _notificationService.sendTeamPlayerProgress(
        playerName: user.name ?? 'Team Member',
        teamId: teamId.value,
        otherTeamMemberUserIds: [], // Will be populated with actual team members
      );
    }
  }

  void _sendScoreSubmissionNotification(int score) {
    final user = _storageRepository.getUser();
    if (user != null && teamId.value != 0) {
      _notificationService.sendTeamScoreUpdated(
        playerName: user.name ?? 'Team Member',
        teamId: teamId.value,
        otherTeamMemberUserIds: [], // Will be populated with actual team members
      );
    }
  }
}
