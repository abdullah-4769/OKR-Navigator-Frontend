// lib/data/repositories/evaluate_initiative_repo.dart

import 'package:dio/dio.dart';
import 'package:game_app/generated/models/responses/key_results/key_results_response.dart';
import '../../generated/models/responses/evaluate_initiative/evaluate_initiative_model.dart';
import '../../generated/network.dart' as DioClient;
import '../response/api_response.dart';
import '../response/status.dart';

class EvaluateInitiativeRepository {
  final Dio _dio = DioClient.dio;

  Future<ApiResponse<EvaluateInitiativeModel>> evaluateInitiatives({
    required String strategy,
    required String objective,
    required List<String> initiatives,
    required List<KeyResult> keyResults,
    required String language,
  }) async {
    try {
      final response = await _dio.post(
        '/evaluate-initiatives',
        data: {
          'strategy': strategy,
          'objective': objective,
          'initiatives': initiatives,
          'key_results': keyResults.map((kr) => kr.toJson()).toList(),
          'language': language,
        },
        options: Options(contentType: 'application/json'),
      );

      print('API Response Status Code: ${response.statusCode}');
      print('API Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse<EvaluateInitiativeModel>.completed(
          EvaluateInitiativeModel.fromJson(response.data),
        );
      } else {
        return ApiResponse<EvaluateInitiativeModel>.error(
          response.statusMessage ?? 'Failed to evaluate initiatives',
        );
      }
    } catch (e) {
      print('API Error: $e');
      return ApiResponse<EvaluateInitiativeModel>.error(
        e.toString(),
      );
    }
  }
}