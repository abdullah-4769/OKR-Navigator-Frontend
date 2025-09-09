import 'package:get/get.dart';

class AIStrategyController extends GetxController {
  var threshold = 80.obs;
  var feedback = ''.obs;
  var isAnalysisDone = false.obs;
  var isLoading = false.obs;

  Future<void> submitForAnalysis() async {
    if (isLoading.value) return;

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));

    feedback.value =
        'AI has analyzed your initiatives and found them highly relevant! 🚀'.tr;
    isAnalysisDone.value = true;

    isLoading.value = false;
  }

  void resetAnalysis() {
    feedback.value = '';
    isAnalysisDone.value = false;
  }
}
