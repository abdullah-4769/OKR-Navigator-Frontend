// lib/data/repositories/feedback_evaluation_repository.dart
import 'package:dio/dio.dart';
import 'package:game_app/generated/network.dart' as DioClient;
import '../../core/api_constants.dart';
import '../../data/response/api_response.dart';
import '../../generated/models/requests/campaign_mode/feedback_evaluation_model.dart';


class FeedbackEvaluationRepository {
  final Dio _dio = DioClient.dio;

  Future<ApiResponse<FeedbackEvaluationModel>> evaluateOKR({
    required String strategy,
    required String role,
    required String industry,
    required String objective,
    required String keyResults,
    required String language,
  }) async {
    try {
      print('🚀 API Call - Evaluate OKR:');
      print('   Strategy: $strategy');
      print('   Role: $role');
      print('   Industry: $industry');
      print('   Objective: $objective');
      print('   Key Results: $keyResults');
      print('   Language: $language');

      final response = await _dio.post(
        ApiConstants.evaluatefeedbackInitiatives,
        data: {
          'strategy': strategy,
          'role': role,
          'industry': industry,
          'objective': objective,
          'keyResults': keyResults,
          'language': language,
        },
        options: Options(contentType: 'application/json'),
      );

      print('✅ API Response Status Code: ${response.statusCode}');
      print('📦 API Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse<FeedbackEvaluationModel>.completed(
          FeedbackEvaluationModel.fromJson(response.data),
        );
      } else {
        return ApiResponse<FeedbackEvaluationModel>.error(
          response.statusMessage ?? 'Failed to evaluate OKR',
        );
      }
    } catch (e) {
      print('❌ API Error: $e');
      return ApiResponse<FeedbackEvaluationModel>.error(
        e.toString(),
      );
    }
  }
}