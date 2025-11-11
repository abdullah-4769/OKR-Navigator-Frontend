// lib/repositories/final_okr_evaluation_repository.dart

import 'package:get/get.dart';

import '../../generated/models/responses/final_okr/final_okr.dart';
import '../../generated/network.dart';
import '../datasources/final_okr_api.dart';


class FinalOkrEvaluationRepository {
  final FinalOkrEvaluationApi _evaluationApi = FinalOkrEvaluationApi(dio);

  Future<FinalOkrEvaluationResponse> submitFinalOkrEvaluation(
      FinalOkrEvaluationRequest request) async {
    try {
      final response = await _evaluationApi.submitFinalOkrEvaluation(request);

      if (response.statusCode != 200 || response.statusCode ==201) {
        throw Exception(response.message ?? 'Failed to submit OKR evaluation');
      }

      return response;
    } catch (e) {
      throw Exception('Failed to submit final OKR evaluation: $e');
    }
  }
}