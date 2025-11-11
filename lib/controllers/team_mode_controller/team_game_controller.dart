// lib/controllers/team_mode_controller/team_game_timer_controller.dart

import 'dart:async';
import 'package:get/get.dart';
import '../../services/notification_service.dart';
import '../../data/repositories/team_repository.dart';
import '../../data/repositories/storage_repository.dart';
import 'create_team_controller.dart';

class TeamGameTimerController extends GetxController {
  // Remaining time in seconds
  final RxInt remainingSeconds = 0.obs;
  // Total time in seconds (for progress calculation)
  final RxInt totalSeconds = 0.obs;

  Timer? _timer;
  int? _lastNotificationMinute; // Track last notification minute to avoid duplicates
  
  final FirebaseNotificationService _notificationService = Get.find<FirebaseNotificationService>();
  final TeamRepository _teamRepository = Get.find<TeamRepository>();
  final StorageRepository _storageRepository = Get.find<StorageRepository>();

  void initializeTimer({required int minutes, required int seconds}) {
    // Stop any existing timer
    _timer?.cancel();
    _lastNotificationMinute = null; // Reset notification tracking

    int initialSeconds = minutes * 60 + seconds;
    totalSeconds.value = initialSeconds;
    remainingSeconds.value = initialSeconds;

    // Start the countdown only if the time is positive
    if (initialSeconds > 0) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (remainingSeconds.value > 0) {
          remainingSeconds.value--;
          
          // 🔔 NOTIFICATION: Send time reminder at specific intervals (every 5 minutes)
          final remainingMinutes = remainingSeconds.value ~/ 60;
          if (remainingMinutes > 0 && 
              remainingMinutes % 5 == 0 && 
              _lastNotificationMinute != remainingMinutes) {
            _lastNotificationMinute = remainingMinutes;
            _sendTimeReminderNotification(remainingMinutes);
          }
        } else {
          _timer?.cancel();
          // Optional: Trigger end-game logic here
        }
      });
    }
  }

  /// Send team time reminder notification
  Future<void> _sendTimeReminderNotification(int remainingMinutes) async {
    try {
      final teamId = Get.find<CreateTeamController>().createdTeamId.value;
      if (teamId == null) return;
      
      // Get team member IDs
      final teamLobbyResponse = await _teamRepository.getTeamDetails(teamId);
      final teamMemberUserIds = teamLobbyResponse.members
          ?.map((m) => m.userId ?? '')
          .where((id) => id.isNotEmpty)
          .toList() ?? [];
      
      if (teamMemberUserIds.isNotEmpty) {
        _notificationService.sendTeamTimeReminder(
          remainingMinutes: remainingMinutes,
          teamId: teamId,
          teamMemberUserIds: teamMemberUserIds,
        );
      }
    } catch (e) {
      print('❌ Error sending time reminder notification: $e');
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}