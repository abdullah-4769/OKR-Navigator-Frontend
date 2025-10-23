// lib/data/repositories/contextual_challenge_repo.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../generated/models/responses/contexual_challenge/contextual_challenge_model.dart';
import '../../generated/network.dart';
import 'package:game_app/data/response/api_response.dart';
import 'package:game_app/data/response/status.dart'; // Status import add karo

class ChallengeRepository {
  final Dio _dio = dio;

  Future<ApiResponse<ChallengeResponse>> getChallenge({
    required String strategy,
    required String objective,
    required String keyResult,
    required int previousAttempts,
    required String language,
  }) async {
    try {
      final request = {
        "strategy": strategy,
        "objective": objective,
        "keyResult": keyResult,
        "previousAttempts": previousAttempts,
        "language": language,
      };

      debugPrint('📤 Sending request: $request');
      final response = await _dio.post('/challenge', data: request);
      debugPrint('📥 Challenge API Response: ${response.data}');

      if (response.statusCode == 200 || response.statusCode== 201) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          final challengeResponse = ChallengeResponse.fromJson(response.data);
          debugPrint('✅ Challenge parsed successfully: ${challengeResponse.title}');
          return ApiResponse.completed(challengeResponse); // Ye properly return hoga
        } else {
          debugPrint('❌ Invalid response format: ${response.data.runtimeType}');
          return ApiResponse.error('Invalid response format');
        }
      } else {
        debugPrint('❌ HTTP ${response.statusCode}: ${response.data}');
        return ApiResponse.error('Server returned ${response.statusCode}');
      }
    } on DioException catch (e) {
      debugPrint('🌐 DioException: ${e.response?.data}');
      return ApiResponse.error(e.response?.data?['message'] ?? e.message ?? 'Network error');
    } catch (e, stackTrace) {
      debugPrint('❌ Unexpected error: $e');
      debugPrintStack(stackTrace: stackTrace);
      return ApiResponse.error('Unexpected error: $e');
    }
  }
}