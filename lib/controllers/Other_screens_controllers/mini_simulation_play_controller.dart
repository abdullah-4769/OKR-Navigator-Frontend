import 'package:get/get.dart';
import '../key_results_controller.dart';

class MiniSimulationPlayController extends GetxController {
  // Step tracking
  RxInt currentStep = 0.obs;

  // Timer (5 min = 300 sec)
  RxInt remainingSeconds = 300.obs;

  @override
  void onInit() {
    super.onInit();

    // Lazily initialize KeyResultsController so it’s always available
    Get.lazyPut<KeyResultsController>(() => KeyResultsController());

    // Example: start a countdown
    ever(remainingSeconds, (time) {
      if (remainingSeconds.value <= 0) {
        // Handle time over
      }
    });
  }

  void nextStep() {
    if (currentStep.value < 3) {
      currentStep.value++;
    }
  }

  void prevStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }
}
