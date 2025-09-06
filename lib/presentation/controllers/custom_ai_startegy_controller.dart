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
    "AI has analyzed your initiatives and found them highly relevant! 🚀";
    isAnalysisDone.value = true;

    isLoading.value = false;
  }

  void resetAnalysis() {
    feedback.value = '';
    isAnalysisDone.value = false;
  }
}





// import 'package:get/get.dart';
//
// class AIStrategyController extends GetxController {
//   // ✅ To track whether analysis is done
//   RxBool isAnalysisDone = false.obs;
//
//   // ✅ Store AI feedback text
//   RxString feedback = "".obs;
//
//   // ✅ Store dynamic threshold value (default 80)
//   RxInt threshold = 80.obs;
//
//   // ✅ Simulate AI Analysis Submission
//   Future<void> submitForAnalysis() async {
//     // Start fake loading (optional, if you want progress later)
//     await Future.delayed(const Duration(seconds: 2));
//
//     // After processing, update feedback & mark analysis as done
//     feedback.value = "Your initiatives align perfectly with AI strategic insights. ✅";
//     isAnalysisDone.value = true;
//   }
//
//   // ✅ Reset state (optional)
//   void resetAnalysis() {
//     feedback.value = "";
//     isAnalysisDone.value = false;
//   }
// }
