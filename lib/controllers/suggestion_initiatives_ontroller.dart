// //
import 'package:flutter/material.dart';
import 'package:game_app/controllers/key_objective_controller.dart';
import 'package:game_app/controllers/language_controller.dart';
import 'package:game_app/controllers/strategy_selection_controller.dart';
import 'package:game_app/generated/models/responses/key_results/key_results_response.dart' hide Text;
import 'package:get/get.dart';
import '../data/repositories/strategy_repository.dart';
import '../generated/models/responses/final_okr/final_okr.dart';
import '../view_model/final_okr_viewmodel/final_okr_viewmodel.dart';


class SuggestionInitiativesController extends GetxController {
  final firstInitiativeTitle = TextEditingController();
  final firstInitiativeDesc = TextEditingController();
  final secondInitiativeTitle = TextEditingController();
  final secondInitiativeDesc = TextEditingController();

  var aiFeedback = ''.obs;
  var isSubmitting = false.obs;

  // Add the evaluation view model
  final evaluationViewModel = Get.put(FinalOkrEvaluationViewModel());

  /// ✅ Submit initiatives for final OKR evaluation
  Future<void> submitInitiatives(List<KeyResult> selectedKeyResults) async {
    // ✅ Input validation
    if (firstInitiativeTitle.text.isEmpty ||
        firstInitiativeDesc.text.isEmpty ||
        secondInitiativeTitle.text.isEmpty ||
        secondInitiativeDesc.text.isEmpty) {
      Get.snackbar(
        'error'.tr,
        'fill_initiatives'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isSubmitting.value = true;

      // ✅ Prepare initiatives for the request
      final initiatives = <Initiative>[];

      if (firstInitiativeTitle.text.isNotEmpty && firstInitiativeDesc.text.isNotEmpty) {
        initiatives.add(Initiative(
          title: firstInitiativeTitle.text.trim(),
          description: firstInitiativeDesc.text.trim(),
        ));
      }

      if (secondInitiativeTitle.text.isNotEmpty && secondInitiativeDesc.text.isNotEmpty) {
        initiatives.add(Initiative(
          title: secondInitiativeTitle.text.trim(),
          description: secondInitiativeDesc.text.trim(),
        ));
      }

      // ✅ Get dynamic data from other controllers
      final strategyController = Get.find<StrategySelectionController>();
      final objectiveController = Get.find<KeyObjectiveController>();

      final strategy = strategyController.selectedStrategy.value?.title ??
          "Increase customer satisfaction in 2025";
      final objective = objectiveController.selectedObjective.value?.title ??
          "Improve customer support response time";

      // Use the first selected key result or a default
      final keyResult = selectedKeyResults.isNotEmpty
          ? selectedKeyResults.first.title
          : "Cut average response time from 24 hours to 6 hours";

      // You can make these dynamic based on your app's context
      final challenge = "Increase Support Team Efficiency by streamlining workflows";
      final proposal = "Introduce AI-powered chatbots to handle FAQs and reassign staff to focus on urgent cases";

      // ✅ Submit to final OKR evaluation API
      await evaluationViewModel.submitFinalOkrEvaluation(
        strategy: strategy,
        objective: objective,
        keyResult: "$keyResult",
        challenge: challenge,
        proposal: proposal,
        initiatives: initiatives,
      );

      // ✅ Show evaluation results if successful
      if (evaluationViewModel.evaluationData.value != null) {
        _showEvaluationResults();
        aiFeedback.value = 'initiatives_submitted_successfully'.tr;
      }

    } catch (e) {
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  /// 🎯 Show evaluation results in a dialog
  void _showEvaluationResults() {
    final evaluationData = evaluationViewModel.evaluationData.value;
    if (evaluationData == null) return;

    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.assessment, color: Colors.blue),
            SizedBox(width: 8),
            Text('OKR Evaluation Results'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Score Section
              _buildScoreSection(evaluationData),
              SizedBox(height: 16),

              // Feedback
              _buildFeedbackSection(evaluationData),
              const SizedBox(height: 16),

              // Breakdown
              _buildBreakdownSection(evaluationData),
              const SizedBox(height: 16),

              // Gamification
              _buildGamificationSection(evaluationData),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Navigate to next screen if needed
              // Get.toNamed(AppRoutes.nextScreen);
            },
            child: Text('Continue'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildScoreSection(EvaluationData data) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getScoreColor(data.score),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Overall Score',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '${data.score}/100',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            _getScoreMessage(data.score),
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackSection(EvaluationData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI Feedback',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            data.feedback,
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownSection(EvaluationData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed Breakdown',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              _buildBreakdownRow('Strategy Relevance', data.breakdown.strategyRelevance),
              _buildBreakdownRow('Objective Quality', data.breakdown.objectiveQuality),
              _buildBreakdownRow('Key Results Quality', data.breakdown.keyResultsQuality),
              _buildBreakdownRow('Initiatives Quality', data.breakdown.initiativesQuality),
              _buildBreakdownRow('Overall Coherence', data.breakdown.overallCoherence),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.blue[100]!),
              ),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGamificationSection(EvaluationData data) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber[300]!),
      ),
      child: Row(
        children: [
          Icon(Icons.emoji_events, color: Colors.amber[700], size: 32),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Achievement Unlocked!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Badge: ${data.gamification.badgeHint}',
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(height: 2),
                Text(
                  'Performance: ${data.gamification.visualFeedback}',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getScoreMessage(int score) {
    if (score >= 80) return 'Excellent! Your strategy is well-aligned';
    if (score >= 60) return 'Good! Some areas need improvement';
    return 'Needs work! Review your strategy';
  }

  /// 🧹 Clear all form fields
  void clearForm() {
    firstInitiativeTitle.clear();
    firstInitiativeDesc.clear();
    secondInitiativeTitle.clear();
    secondInitiativeDesc.clear();
    aiFeedback.value = '';
    evaluationViewModel.clearEvaluation();
  }

  @override
  void onClose() {
    firstInitiativeTitle.dispose();
    firstInitiativeDesc.dispose();
    secondInitiativeTitle.dispose();
    secondInitiativeDesc.dispose();
    super.onClose();
  }
}
// import 'package:flutter/material.dart';
// // import 'package:game_app/controllers/key_objective_controller.dart';
// // import 'package:game_app/controllers/language_controller.dart';
// // import 'package:game_app/controllers/strategy_selection_controller.dart';
// // import 'package:game_app/generated/models/responses/key_results/key_results_response.dart';
// // import 'package:get/get.dart';
// //
// // import '../data/repositories/strategy_repository.dart';
// //
// // class SuggestionInitiativesController extends GetxController {
// //   final firstInitiativeTitle = TextEditingController();
// //   final firstInitiativeDesc = TextEditingController();
// //   final secondInitiativeTitle = TextEditingController();
// //   final secondInitiativeDesc = TextEditingController();
// //
// //   var aiFeedback = ''.obs;
// //   var isSubmitting = false.obs;
// //
// //   /// ✅ Submit initiatives for AI analysis
// //   Future<void> submitInitiatives(List<KeyResult> selectedKeyResults) async {
// //     if (firstInitiativeTitle.text.isEmpty ||
// //         firstInitiativeDesc.text.isEmpty ||
// //         secondInitiativeTitle.text.isEmpty ||
// //         secondInitiativeDesc.text.isEmpty) {
// //       Get.snackbar(
// //         'error'.tr,
// //         'fill_initiatives'.tr,
// //         snackPosition: SnackPosition.BOTTOM,
// //         backgroundColor: Colors.red,
// //         colorText: Colors.white,
// //       );
// //       return;
// //     }
// //
// //     try {
// //       isSubmitting.value = true;
// //
// //       // 🔹 Future: Send data to backend / AI API
// //       // For now, just simulate processing delay
// //       final response = await Get.find<StrategyRepository>().submitInitiatives(
// //         strategy: Get.find<StrategySelectionController>()
// //             .selectedStrategy
// //             .value!
// //             .title!,
// //         initiatives: [
// //           firstInitiativeTitle.text.trim(),
// //           firstInitiativeDesc.text.trim(),
// //           secondInitiativeTitle.text.trim(),
// //           secondInitiativeDesc.text.trim(),
// //         ],
// //         keyResults: selectedKeyResults,
// //         objective:
// //             Get.find<KeyObjectiveController>().selectedObjective.value!.title!,
// //         language: Get.find<LanguageController>().selectedLanguage.value.name,
// //       );
// //
// //       aiFeedback.value = 'initiatives_submitted'.tr;
// //
// //       // ✅ Navigate to next screen after success
// //       // await Get.toNamed(
// //       //   AppRoutes.contextualChallenge,
// //       //   arguments: {
// //       //     'keyResults': keyResults,
// //       //     'initiatives': [
// //       //       {
// //       //         'title': firstInitiativeTitle.text,
// //       //         'description': firstInitiativeDesc.text,
// //       //       },
// //       //       {
// //       //         'title': secondInitiativeTitle.text,
// //       //         'description': secondInitiativeDesc.text,
// //       //       },
// //       //     ],
// //       //   },
// //       // );
// //     } finally {
// //       isSubmitting.value = false;
// //     }
// //   }
// //
// //   @override
// //   void onClose() {
// //     firstInitiativeTitle.dispose();
// //     firstInitiativeDesc.dispose();
// //     secondInitiativeTitle.dispose();
// //     secondInitiativeDesc.dispose();
// //     super.onClose();
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:game_app/controllers/key_objective_controller.dart';
// import 'package:game_app/controllers/language_controller.dart';
// import 'package:game_app/controllers/strategy_selection_controller.dart';
// import 'package:game_app/generated/models/responses/key_results/key_results_response.dart';
// import 'package:get/get.dart';
// import '../data/repositories/strategy_repository.dart';
//
// class SuggestionInitiativesController extends GetxController {
//   final firstInitiativeTitle = TextEditingController();
//   final firstInitiativeDesc = TextEditingController();
//   final secondInitiativeTitle = TextEditingController();
//   final secondInitiativeDesc = TextEditingController();
//
//   var aiFeedback = ''.obs;
//   var isSubmitting = false.obs;
//
//   /// ✅ Submit initiatives for AI evaluation
//   Future<void> submitInitiatives(List<KeyResult> selectedKeyResults) async {
//     // ✅ Input validation
//     if (firstInitiativeTitle.text.isEmpty ||
//         firstInitiativeDesc.text.isEmpty ||
//         secondInitiativeTitle.text.isEmpty ||
//         secondInitiativeDesc.text.isEmpty) {
//       Get.snackbar(
//         'error'.tr,
//         'fill_initiatives'.tr,
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//       return;
//     }
//
//     try {
//       isSubmitting.value = true;
//
//       // ✅ Fetch required data from other controllers
//       final strategyTitle = Get.find<StrategySelectionController>()
//           .selectedStrategy
//           .value!
//           .title!;
//       final objectiveTitle =
//       Get.find<KeyObjectiveController>().selectedObjective.value!.title!;
//       final language =
//           Get.find<LanguageController>().selectedLanguage.value.name;
//
//       // ✅ Convert to List<String> for backend
//       final initiatives = [
//         '${firstInitiativeTitle.text.trim()} - ${firstInitiativeDesc.text.trim()}',
//         '${secondInitiativeTitle.text.trim()} - ${secondInitiativeDesc.text.trim()}',
//       ];
//
//       // ✅ API call via StrategyRepository
//       final response = await Get.find<StrategyRepository>().submitInitiatives(
//         strategy: strategyTitle,
//         objective: objectiveTitle,
//         initiatives: initiatives,
//         keyResults: selectedKeyResults,
//         language: language,
//       );
//
//       // ✅ Handle success
//       aiFeedback.value =
//           response.message ?? 'initiatives_submitted_successfully'.tr;
//
//     } catch (e) {
//       Get.snackbar(
//         'error'.tr,
//         e.toString(),
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       isSubmitting.value = false;
//     }
//   }
//
//   @override
//   void onClose() {
//     firstInitiativeTitle.dispose();
//     firstInitiativeDesc.dispose();
//     secondInitiativeTitle.dispose();
//     secondInitiativeDesc.dispose();
//     super.onClose();
//   }
// }
//
//
//
