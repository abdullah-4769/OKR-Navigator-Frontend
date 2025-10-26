import 'dart:ui';

import 'package:get/get.dart';

import '../../presentation/widgets/campaign_mode_widgets/organization_path_card.dart';
import '../../services/notification_service.dart';
import '../../data/repositories/storage_repository.dart';


class MissionScreenController extends GetxController {
  /// Reactive values
  var orgName = "Organization A".obs;
  
  final FirebaseNotificationService _notificationService = Get.find<FirebaseNotificationService>();
  final StorageRepository _storageRepository = Get.find<StorageRepository>();
  var orgSubtitle = "Startup Growth".obs;
  var stars = 2.obs;

  var industryTitle = "Organization X".obs;
  var industrySubtitle = "Phase 1".obs;
  var bottomTitle = "3 Objectives".obs;

  /// Example path nodes
  final nodes = <OrgNode>[
    OrgNode(
      title: "Level 2",
      subtitle: "Organization B",
      imagePath: "assets/images/solo2.png",
      innerColors: [
        const Color(0xFFFFFFFF),
        const Color(0xFFEEEEEE),
        const Color(0xFFDDDDDD),
      ],
      borderGradient: [const Color(0xFFE53935), const Color(0xFFFFA726)],
    ),
    OrgNode(
      title: "You",
      subtitle: "Organization A",
      imagePath: "assets/images/campaign_image.png",
      innerColors: [
        const Color(0xFFFFFFFF),
        const Color(0xFFEEEEEE),
        const Color(0xFFDDDDDD),
      ],
      borderGradient: [const Color(0xFFE53935), const Color(0xFFFFA726)],
      isYou: true,
    ),
    OrgNode(
      title: "Level 3",
      subtitle: "Organization C",
      imagePath: "assets/images/campaign_image.png",
      innerColors: [
        const Color(0xFFFFFFFF),
        const Color(0xFFEEEEEE),
        const Color(0xFFDDDDDD),
      ],
      borderGradient: [const Color(0xFFE53935), const Color(0xFFFFA726)],
    ),
  ];

  /// Actions
  void onStartMission() {
    // Send campaign level reminder notification
    _sendCampaignLevelReminderNotification();
    
    // TODO: Navigate to mission details
    print("Start Mission tapped");
  }

  void onNextSteps() {
    // Send campaign certification reminder for level 3
    _sendCampaignCertificationReminderNotification();
    
    // TODO: Handle next steps action
    print("Next Steps tapped");
  }

  /// Send campaign level reminder notification
  void _sendCampaignLevelReminderNotification() {
    final user = _storageRepository.getUser();
    if (user != null) {
      _notificationService.sendCampaignLevelReminder(
        playerName: user.name ?? 'Player',
        level: 2, // Current level
        remainingMinutes: 30, // Example remaining time
        playerUserId: user.id!,
      );
    }
  }

  /// Send campaign certification reminder notification
  void _sendCampaignCertificationReminderNotification() {
    final user = _storageRepository.getUser();
    if (user != null) {
      _notificationService.sendCampaignCertificationReminder(
        playerName: user.name ?? 'Player',
        remainingMinutes: 45, // Example remaining time
        playerUserId: user.id!,
      );
    }
  }
}
