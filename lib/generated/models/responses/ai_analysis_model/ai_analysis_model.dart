// lib/view_models/ai_analysis_view_model.dart

import 'package:game_app/generated/models/responses/ai_analysis_model/suggetive_initiative_viewmodel.dart';
import 'package:get/get.dart';

import '../../../../data/response/status.dart';
import '../evaluate_initiative/evaluate_initiative_model.dart';

class AIAnalysisViewModel extends GetxController {
  var evaluationData = Rxn<EvaluateInitiativeModel>();
  var isAnalysisDone = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadEvaluationData();
  }

  void _loadEvaluationData() {
    try {
      // Get data from SuggestionInitiativesViewModel
      if (Get.isRegistered<SuggestionInitiativesViewModel>()) {
        final viewModel = Get.find<SuggestionInitiativesViewModel>();

        if (viewModel.apiResponse.value.status == Status.COMPLETED &&
            viewModel.evaluationResult != null) {
          evaluationData.value = viewModel.evaluationResult;
          isAnalysisDone.value = true;
        } else {
          isAnalysisDone.value = false;
        }
      } else {
        isAnalysisDone.value = false;
      }
    } catch (e) {
      isAnalysisDone.value = false;
      print('Error loading evaluation data: $e');
    }
  }

  // Helper getters for UI
  String get score => evaluationData.value?.score?.toString() ?? '0';

  String get decision => evaluationData.value?.decision ?? 'Pending';

  String get explanation =>
      evaluationData.value?.explanation ?? 'No analysis available';

  bool get isAccepted =>
      evaluationData.value?.decision?.toLowerCase() == 'accepted';

  bool get isRejected =>
      evaluationData.value?.decision?.toLowerCase() == 'rejected';

  // Score color based on value
  int get scoreValue => evaluationData.value?.score ?? 0;

  bool get isHighScore => scoreValue >= 80;
  bool get isMediumScore => scoreValue >= 50 && scoreValue < 80;
  bool get isLowScore => scoreValue < 50;
}