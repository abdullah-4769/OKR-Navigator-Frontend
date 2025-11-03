// test/controllers/team_final_evaluation_controller_test.dart

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart' hide Response;
import 'package:game_app/controllers/team_mode_controller/team_final_evaluation_controller.dart';
import 'package:game_app/data/repositories/strategy_repository.dart';
import 'package:game_app/generated/models/responses/team_mode/final_evaluation_response.dart';

// Mock StrategyRepository for testing
class MockStrategyRepository extends StrategyRepository {
  FinalEvaluationResponse? mockResponse;
  Exception? mockError;
  
  @override
  Future<FinalEvaluationResponse> evaluateFinalChallenge(Map<String, dynamic> body) async {
    if (mockError != null) {
      throw mockError!;
    }
    if (mockResponse != null) {
      return mockResponse!;
    }
    throw Exception('Mock not configured');
  }
}

void main() {
  late TeamFinalEvaluationController controller;
  late MockStrategyRepository mockRepository;

  setUp(() {
    Get.testMode = true;
    Get.reset();
    
    mockRepository = MockStrategyRepository();
    Get.put<StrategyRepository>(mockRepository);
    
    controller = TeamFinalEvaluationController();
  });

  tearDown(() {
    Get.reset();
  });

  group('TeamFinalEvaluationController', () {
    test('evaluateOKRSubmission - Happy Path', () async {
      // Arrange
      mockRepository.mockResponse = FinalEvaluationResponse(
        score: 88,
        weightedScore: '32/40',
        feedback: 'Excellent strategy alignment',
        breakdown: EvaluationBreakdown(
          strategyRelevance: '14/15',
          objectiveQuality: '14/15',
          keyResultsQuality: '26/30',
          initiativesQuality: '24/30',
          overallCoherence: '10/10',
        ),
        gamification: GamificationHint(
          badgeHint: 'Aligned Leader',
          visualFeedback: '▲',
        ),
      );

      // Act
      await controller.evaluateOKRSubmission(
        strategy: 'Growth Strategy',
        objective: 'Increase Revenue',
        keyResult: 'Achieve 5M Revenue',
        challenge: 'Market Competition',
        proposal: 'Introduce AI chatbots',
      );

      // Assert
      expect(controller.totalScore.value, 88);
      expect(controller.weightedScore.value, '32/40');
      expect(controller.feedback.value, 'Excellent strategy alignment');
      expect(controller.badgeHint.value, 'Aligned Leader');
      expect(controller.visualFeedback.value, '▲');
      expect(controller.hasError.value, false);
      expect(controller.isLoading.value, false);
      expect(controller.evaluationResult.value, isNotNull);
      expect(controller.breakdownScores.length, 5);
    });

    test('evaluateOKRSubmission - Error Path (500)', () async {
      // Arrange
      mockRepository.mockError = DioException(
        requestOptions: RequestOptions(path: '/team-challenges/evaluation'),
        response: Response(
          requestOptions: RequestOptions(path: '/team-challenges/evaluation'),
          statusCode: 500,
          data: {'message': 'Internal server error'},
        ),
        type: DioExceptionType.badResponse,
      );

      // Act
      await controller.evaluateOKRSubmission(
        strategy: 'Test Strategy',
        objective: 'Test Objective',
        keyResult: 'Test KR',
        challenge: 'Test Challenge',
        proposal: 'Test Proposal',
      );

      // Assert
      expect(controller.hasError.value, true);
      expect(controller.errorMessage.value, contains('Server error'));
      expect(controller.isLoading.value, false);
      expect(controller.evaluationResult.value, isNull);
    });

    test('evaluateOKRSubmission - Network Error with Retry', () async {
      // Arrange
      var callCount = 0;
      mockRepository.mockError = DioException(
        requestOptions: RequestOptions(path: '/team-challenges/evaluation'),
        type: DioExceptionType.connectionError,
      );

      // Mock to succeed on second attempt
      final successResponse = FinalEvaluationResponse(
        score: 85,
        weightedScore: '30/40',
        feedback: 'Good',
      );

    });

    test('evaluateOKRSubmission - Timeout Error', () async {
      // Arrange
      mockRepository.mockError = DioException(
        requestOptions: RequestOptions(path: '/team-challenges/evaluation'),
        type: DioExceptionType.connectionTimeout,
      );

      // Act
      await controller.evaluateOKRSubmission(
        strategy: 'Test',
        objective: 'Test',
        keyResult: 'Test',
        challenge: 'Test',
        proposal: 'Test',
      );

      // Assert
      expect(controller.hasError.value, true);
      expect(controller.errorMessage.value, contains('timeout'));
    });

    test('evaluateOKRSubmission - 401 Unauthorized', () async {
      // Arrange
      mockRepository.mockError = DioException(
        requestOptions: RequestOptions(path: '/team-challenges/evaluation'),
        response: Response(
          requestOptions: RequestOptions(path: '/team-challenges/evaluation'),
          statusCode: 401,
        ),
        type: DioExceptionType.badResponse,
      );

      // Act
      await controller.evaluateOKRSubmission(
        strategy: 'Test',
        objective: 'Test',
        keyResult: 'Test',
        challenge: 'Test',
        proposal: 'Test',
      );

      // Assert
      expect(controller.hasError.value, true);
      expect(controller.errorMessage.value, contains('Unauthorized'));
    });

    test('evaluateOKRSubmission - Incomplete Data', () async {
      // Arrange
      mockRepository.mockResponse = FinalEvaluationResponse(
        score: null,
        weightedScore: null,
        feedback: null,
        breakdown: null,
        gamification: null,
      );

      // Act
      await controller.evaluateOKRSubmission(
        strategy: 'Test',
        objective: 'Test',
        keyResult: 'Test',
        challenge: 'Test',
        proposal: 'Test',
      );

      // Assert
      expect(controller.hasError.value, true);
      expect(controller.errorMessage.value, contains('Incomplete data'));
    });

    test('retryEvaluation - Resets State', () async {
      // Arrange
      mockRepository.mockResponse = FinalEvaluationResponse(
        score: 90,
        weightedScore: '35/40',
        feedback: 'Excellent',
      );

      // Act
      await controller.retryEvaluation(
        strategy: 'Test',
        objective: 'Test',
        keyResult: 'Test',
        challenge: 'Test',
        proposal: 'Test',
      );

      // Assert
      expect(controller.hasRetried.value, false);
      expect(controller.totalScore.value, 90);
    });

    test('reset - Clears All State', () {
      // Arrange
      controller.totalScore.value = 85;
      controller.hasError.value = true;
      controller.isLoading.value = true;

      // Act
      controller.reset();

      // Assert
      expect(controller.totalScore.value, 0);
      expect(controller.hasError.value, false);
      expect(controller.isLoading.value, false);
      expect(controller.evaluationResult.value, isNull);
    });
  });
}

