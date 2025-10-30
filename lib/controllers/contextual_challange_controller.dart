// contextual_challenge_controller.dart
import 'package:get/get.dart';

class ContextualChallengeController extends GetxController {

  /// Propose adjustments for the strategy
  void proposeAdjustments() {
    // Navigate to the adjustments screen
    Get.toNamed('/adjustments-screen');
  }
}