import 'package:get/get.dart';
import '../../services/notification_service.dart';
import '../../data/repositories/storage_repository.dart';

class CampaignModeController extends GetxController {
  var selectedMode = ''.obs;
  
  final FirebaseNotificationService _notificationService = Get.find<FirebaseNotificationService>();
  final StorageRepository _storageRepository = Get.find<StorageRepository>();

  void selectMode(String mode) {
    selectedMode.value = mode;
  }

  void startCampaign() {
    if (selectedMode.isNotEmpty) {
      // Send campaign level unlocked notification
      _sendCampaignLevelUnlockedNotification();
      
      // TODO: Navigate to campaign gameplay screen
      print("Starting campaign in $selectedMode mode...");
    } else {
      Get.snackbar("Select Mode", "Please select a campaign mode first");
    }
  }

  /// Send campaign level unlocked notification
  void _sendCampaignLevelUnlockedNotification() {
    final user = _storageRepository.getUser();
    if (user != null) {
      _notificationService.sendCampaignLevelUnlocked(
        playerName: user.name ?? 'Player',
        level: 1, // Starting level
        playerUserId: user.id!,
      );
    }
  }
}
