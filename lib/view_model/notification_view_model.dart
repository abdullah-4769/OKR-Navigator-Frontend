// lib/controllers/notification_viewmodel.dart (New File)
import 'package:get/get.dart';

import '../services/notifications/notifications_service.dart';
import 'app_notifications.dart';

class NotificationViewModel extends GetxController {
  final RxList<AppNotification> notifications = <AppNotification>[].obs;
  final RxBool isLoading = false.obs; // Start false, load sync

  final NotificationsService _service = NotificationsService();

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {
    isLoading.value = true;
    notifications.assignAll(_service.getSavedNotifications());
    isLoading.value = false;
  }

  Future<void> markAsRead(String id) async {
    await _service.markAsRead(id);
    loadNotifications(); // Refresh list
  }

  Future<void> clearAll() async {
    await _service.clearAllNotifications();
    notifications.clear();
  }
}