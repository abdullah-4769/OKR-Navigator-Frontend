import 'package:get/get.dart';

import '../../presentation/routes/app_routes.dart';

class MiniSimulationController extends GetxController {
  var selectedScenario = (-1).obs;

  void selectScenario(int index) {
    selectedScenario.value = index;
  }

  void startChallenge() {
    Get.offAllNamed(AppRoutes.finalTestCertificationScreen);
    // Get.toNamed(AppRoutes.bonusChallengeScreen);
  }
}