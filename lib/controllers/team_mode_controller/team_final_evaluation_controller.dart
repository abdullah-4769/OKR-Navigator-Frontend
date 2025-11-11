// lib/controllers/team_mode_controller/team_final_evaluation_controller.dart

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:game_app/data/repositories/strategy_repository.dart';
import 'package:game_app/data/repositories/storage_repository.dart';
import 'package:game_app/generated/models/responses/team_mode/final_evalution_response.dart';
import 'package:game_app/utils/snackbar_helper.dart';
import 'package:get/get.dart';

/// Controller for Final Evaluation Results Screen
/// Handles POST /team-challenges/evaluation API call
class TeamFinalEvaluationController extends GetxController {
  final StrategyRepository _strategyRepository = Get.find<StrategyRepository>();

  // Observables
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool hasError = false.obs;
  final RxBool hasRetried = false.obs;

  // Evaluation Result Data (from API only - no fallback)
  final Rx<FinalEvaluationResponse?> evaluationResult = Rx<FinalEvaluationResponse?>(null);
  
  // Breakdown scores for display
  final RxMap<String, String> breakdownScores = <String, String>{}.obs;
  final RxInt totalScore = 0.obs;
  final RxString weightedScore = ''.obs;
  final RxString feedback = ''.obs;
  final RxString badgeHint = ''.obs;
  final RxString visualFeedback = ''.obs;

  // Retry configuration
  static const int maxRetries = 2;
  static const Duration initialRetryDelay = Duration(seconds: 1);
  int _retryCount = 0;

  @override
  void onInit() {
    super.onInit();
    // Don't auto-load - wait for explicit evaluation call
  }

  /// Submit evaluation request to API
  /// POST /team-challenges/evaluation
  Future<void> evaluateOKRSubmission({
    required String strategy,
    required String objective,
    required String keyResult,
    required String challenge,
    required String proposal,
  }) async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      _retryCount = 0;

      final requestBody = {
        "strategy": strategy,
        "objective": objective,
        "keyResult": keyResult,
        "challenge": challenge,
        "proposal": proposal,
      };

      // Log request
      log('🔵 FINAL EVALUATION REQUEST:');
      log('URL: POST /team-challenges/evaluation');
      log('REQUEST: $requestBody');

      final result = await _executeWithRetry(() async {
        return await _strategyRepository.evaluateFinalChallenge(requestBody);
      });

      // Log successful response
      log('🟢 FINAL EVALUATION RESPONSE:');
      log('Score: ${result.score}');
      log('Weighted Score: ${result.weightedScore}');
      log('Feedback: ${result.feedback}');
      log('Breakdown: ${result.breakdown?.toString()}');
      log('Gamification: ${result.gamification?.toString()}');

      // Process and store result
      _processEvaluationResult(result);

      // Clear any previous errors
      hasError.value = false;
      errorMessage.value = '';

    } on DioException catch (e) {
      await _handleDioError(e);
    } catch (e, stackTrace) {
      log('🔴 FINAL EVALUATION UNEXPECTED ERROR: $e');
      log('ERROR TYPE: ${e.runtimeType}');
      log('STACK TRACE: $stackTrace');
      
      hasError.value = true;
      errorMessage.value = 'An unexpected error occurred. Please try again.';
      SnackbarHelper.error(errorMessage.value);
      
      // Clear result data on error
      _clearResult();
    } finally {
      isLoading.value = false;
    }
  }

  /// Execute API call with exponential backoff retry
  Future<FinalEvaluationResponse> _executeWithRetry(
    Future<FinalEvaluationResponse> Function() apiCall,
  ) async {
    while (_retryCount <= maxRetries) {
      try {
        return await apiCall().timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            throw DioException(
              requestOptions: RequestOptions(path: '/team-challenges/evaluation'),
              type: DioExceptionType.connectionTimeout,
              error: 'Request timeout',
            );
          },
        );
      } on DioException catch (e) {
        // Don't retry on 4xx errors (client errors)
        if (e.response?.statusCode != null && 
            e.response!.statusCode! >= 400 && 
            e.response!.statusCode! < 500) {
          rethrow;
        }

        // Retry on network/timeout errors
        if (_retryCount < maxRetries) {
          _retryCount++;
          hasRetried.value = true;
          final delay = Duration(milliseconds: initialRetryDelay.inMilliseconds * (1 << (_retryCount - 1)));
          log('⚠️ Retry attempt $_retryCount/$maxRetries after ${delay.inMilliseconds}ms');
          await Future.delayed(delay);
        } else {
          rethrow;
        }
      }
    }
    throw Exception('Max retries exceeded');
  }

  /// Handle DioException errors
  Future<void> _handleDioError(DioException e) async {
    log('🔴 FINAL EVALUATION DIO ERROR:');
    log('STATUS CODE: ${e.response?.statusCode}');
    log('ERROR RESPONSE: ${e.response?.data}');
    log('ERROR TYPE: ${e.type}');

    hasError.value = true;
    _clearResult();

    // Handle specific error types
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage.value = 'Request timeout. Please check your connection and try again.';
        break;
      
      case DioExceptionType.connectionError:
        errorMessage.value = 'Network error. Please check your internet connection.';
        break;
      
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          errorMessage.value = 'Unauthorized. Please login again.';
          // Navigate to login
          // Get.offAllNamed(AppRoutes.login);
        } else if (statusCode == 400) {
          final errorData = e.response?.data;
          errorMessage.value = errorData is Map && errorData['message'] != null
              ? errorData['message'].toString()
              : 'Invalid request. Please check your input.';
        } else if (statusCode == 500) {
          errorMessage.value = 'Server error. Please try again later.';
        } else {
          errorMessage.value = 'Failed to evaluate submission. Status: $statusCode';
        }
        break;
      
      default:
        errorMessage.value = 'Network error. Please try again.';
    }

    SnackbarHelper.error(errorMessage.value);
  }

  /// Process evaluation result from API
  void _processEvaluationResult(FinalEvaluationResponse result) {
    evaluationResult.value = result;

    // Extract scores
    totalScore.value = result.score ?? 0;
    weightedScore.value = result.weightedScore ?? '0/0';
    feedback.value = result.feedback ?? 'No feedback available';
    badgeHint.value = result.gamification?.badgeHint ?? '';
    visualFeedback.value = result.gamification?.visualFeedback ?? '';

    // Extract breakdown scores
    final breakdown = result.breakdown;
    if (breakdown != null) {
      breakdownScores.assignAll({
        'Strategy Relevance': breakdown.strategyRelevance ?? '0/0',
        'Objective Quality': breakdown.objectiveQuality ?? '0/0',
        'Key Results Quality': breakdown.keyResultsQuality ?? '0/0',
        'Initiatives Quality': breakdown.initiativesQuality ?? '0/0',
        'Overall Coherence': breakdown.overallCoherence ?? '0/0',
      });
    } else {
      breakdownScores.clear();
    }

    // Validate data completeness
    if (totalScore.value == 0 && weightedScore.value == '0/0' && breakdownScores.isEmpty) {
      hasError.value = true;
      errorMessage.value = 'Incomplete data from server. Please retry.';
      SnackbarHelper.error(errorMessage.value);
      _clearResult();
    }
  }

  /// Clear result data
  void _clearResult() {
    evaluationResult.value = null;
    totalScore.value = 0;
    weightedScore.value = '';
    feedback.value = '';
    badgeHint.value = '';
    visualFeedback.value = '';
    breakdownScores.clear();
  }

  /// Retry evaluation
  Future<void> retryEvaluation({
    required String strategy,
    required String objective,
    required String keyResult,
    required String challenge,
    required String proposal,
  }) async {
    _retryCount = 0;
    hasRetried.value = false;
    await evaluateOKRSubmission(
      strategy: strategy,
      objective: objective,
      keyResult: keyResult,
      challenge: challenge,
      proposal: proposal,
    );
  }

  /// Reset controller state
  void reset() {
    _clearResult();
    isLoading.value = false;
    hasError.value = false;
    errorMessage.value = '';
    hasRetried.value = false;
    _retryCount = 0;
  }
}

