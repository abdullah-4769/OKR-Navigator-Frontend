import 'package:get/get.dart';

import '../../generated/models/requests/campaign_mode/certificate_evaluation_request.dart';
import '../../generated/models/responses/campaign/certification_evaluation_response.dart';
import '../../services/campaign/certificate_evaluation_service.dart';

class CertificationRepository {
  final CertificationApiService _apiService = Get.find<CertificationApiService>();

  Future<CertificationEvaluationResponse> submitFinalEvaluation(
      CertificationEvaluationRequest request) async {
    try {
      return await _apiService.submitFinalEvaluation(request);
    } catch (e) {
      print('❌ Repository error: $e');
      rethrow;
    }
  }

  Future<CertificationEvaluationResponse> submitEvaluationFromSharedPrefs() async {
    try {
      return await _apiService.submitEvaluationFromSharedPrefs();
    } catch (e) {
      print('❌ Repository error (from shared prefs): $e');
      rethrow;
    }
  }
}