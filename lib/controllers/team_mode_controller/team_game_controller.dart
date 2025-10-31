// lib/controllers/team_mode_controller/team_game_timer_controller.dart

import 'dart:async';
import 'package:get/get.dart';

class TeamGameTimerController extends GetxController {
  // Remaining time in seconds
  final RxInt remainingSeconds = 0.obs;
  // Total time in seconds (for progress calculation)
  final RxInt totalSeconds = 0.obs;

  Timer? _timer;

  void initializeTimer({required int minutes, required int seconds}) {
    // Stop any existing timer
    _timer?.cancel();

    int initialSeconds = minutes * 60 + seconds;
    totalSeconds.value = initialSeconds;
    remainingSeconds.value = initialSeconds;

    // Start the countdown only if the time is positive
    if (initialSeconds > 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (remainingSeconds.value > 0) {
          remainingSeconds.value--;
        } else {
          _timer?.cancel();
          // Optional: Trigger end-game logic here
        }
      });
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}