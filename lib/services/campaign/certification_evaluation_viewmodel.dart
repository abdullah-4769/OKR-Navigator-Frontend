import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../generated/models/responses/campaign/certification_evaluation_response.dart';
import '../../repository/campaign_mode/certification_evaluation_repo.dart';
import '../shared_preference.dart';

class CertificationEvaluationViewModel extends GetxController {
  final CertificationRepository _repository = Get.find<CertificationRepository>();

  final Rx<CertificationEvaluationResponse?> _evaluationResult = Rx<CertificationEvaluationResponse?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  CertificationEvaluationResponse? get evaluationResult => _evaluationResult.value;

  Future<void> submitFinalEvaluation() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('📍 Starting final evaluation submission...');

      // Verify we have all required data
      final hasAllData = await SharedPrefs.verifyAllCertificateData();
      if (!hasAllData) {
        throw Exception('Incomplete certification data. Please fill all sections.');
      }

      // Submit evaluation
      final result = await _repository.submitEvaluationFromSharedPrefs();
      _evaluationResult.value = result;

      print('✅ Evaluation submitted successfully! Score: ${result.score}');

      // Save the result to SharedPreferences for later use
      await _saveEvaluationResult(result);

    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ Error in submitFinalEvaluation: $e');
      Get.snackbar(
        'Evaluation Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> _saveEvaluationResult(CertificationEvaluationResponse result) async {
    try {
      await SharedPrefs.saveEvaluationSummary(
        score: result.score,
        decision: result.certificateLevel,
        explanation: _buildEvaluationExplanation(result),
      );

      // Save the full result for display
      await SharedPrefs.saveFinalOkrEvaluationResult(result.toJson());
      await SharedPrefs.saveCertificationEvaluationResult(result.toJson());

      print('💾 Saved evaluation result to SharedPreferences');
    } catch (e) {
      print('❌ Error saving evaluation result: $e');
    }
  }

  String _buildEvaluationExplanation(CertificationEvaluationResponse result) {
    final breakdown = result.breakdown;
    final feedback = result.feedback;

    return '''
Score: ${result.score}/100
Certificate Level: ${result.certificateLevel}

Breakdown:
- Strategy: ${breakdown.strategyScore}/15
- Objective: ${breakdown.objectiveScore}/15  
- Key Results: ${breakdown.keyResultScore}/30
- Initiatives: ${breakdown.initiativeScore}/20
- Coherence: ${breakdown.coherenceScore}/20

Strengths:
${feedback.strengths.map((s) => '• $s').join('\n')}

Areas for Improvement:
${feedback.areasForImprovement.map((a) => '• $a').join('\n')}
''';
  }

  void clearResults() {
    _evaluationResult.value = null;
    errorMessage.value = '';
  }

  bool get hasResults => _evaluationResult.value != null;
}