// contextual_challenge_controller.dart
import 'package:get/get.dart';

import '../services/shared_preference.dart';

class ContextualChallengeController extends GetxController {
  final selectedStrategy = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    loadSelectedStrategy();
  }

  Future<void> loadSelectedStrategy() async {
    final strategy = await SharedPrefs.getSelectedStrategy();
    selectedStrategy.value = strategy;
  }
  /// Propose adjustments for the strategy
  void proposeAdjustments() {
    // Navigate to the adjustments screen
    Get.toNamed('/adjustments-screen');
  }
}