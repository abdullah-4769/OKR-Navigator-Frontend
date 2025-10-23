// lib/view_model/final_okr_evaluation_view_model.dart

import 'package:get/get.dart';

import '../../data/repositories/final_okr_repo.dart';
import '../../generated/models/responses/final_okr/final_okr.dart';


class FinalOkrEvaluationViewModel extends GetxController {
  final FinalOkrEvaluationRepository _repository = FinalOkrEvaluationRepository();

  var isLoading = false.obs;
  var evaluationData = Rxn<EvaluationData>();
  var errorMessage = ''.obs;

  Future<void> submitFinalOkrEvaluation({
    required String strategy,
    required String objective,
    required String keyResult,
    required String challenge,
    required String proposal,
    required List<Initiative> initiatives,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      evaluationData.value = null;

      final request = FinalOkrEvaluationRequest(
        strategy: strategy,
        objective: objective,
        keyResult: keyResult,
        challenge: challenge,
        proposal: proposal,
        initiatives: initiatives,
      );

      final response = await _repository.submitFinalOkrEvaluation(request);

      if (response.data != null) {
        evaluationData.value = response.data!;
        Get.snackbar(
          'Success',
          'OKR evaluation submitted successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        throw Exception('No evaluation data received');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to submit OKR evaluation',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearEvaluation() {
    evaluationData.value = null;
    errorMessage.value = '';
  }
}