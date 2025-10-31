import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../core/api_constants.dart';
import '../../generated/models/requests/campaign_mode/certificate_evaluation_request.dart';
import '../../generated/models/responses/campaign/certification_evaluation_response.dart';


class CertificationApiService extends GetxService {
  final String baseUrl = ApiConstants.baseUrl;

  Future<CertificationEvaluationResponse> submitFinalEvaluation(
      CertificationEvaluationRequest request) async {
    try {
      final url = Uri.parse('$baseUrl/campaign/certification/final-evaluation');

      print('🚀 Sending final evaluation request to: $url');
      print('📦 Request body: ${request.toJson()}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return CertificationEvaluationResponse.fromJson(responseData);
      } else {
        throw Exception(
            'Failed to submit evaluation: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Error in submitFinalEvaluation: $e');
      rethrow;
    }
  }

  // Helper method to submit evaluation directly from SharedPreferences
  Future<CertificationEvaluationResponse> submitEvaluationFromSharedPrefs() async {
    final request = CertificationEvaluationRequest.fromSharedPrefs();
    return await submitFinalEvaluation(request);
  }
}