// lib/controllers/notification_viewmodel.dart
import 'package:get/get.dart';

// import '../services/notifications/notifications_service.dart';
import 'app_notifications.dart'; // Make sure this import is correct

class NotificationViewModel extends GetxController {
  final RxList<AppNotification> notifications = <AppNotification>[].obs;
  final RxBool isLoading = false.obs;

  // final NotificationsService _service = NotificationsService();

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {
    isLoading.value = true;
    // notifications.assignAll(_service.getSavedNotifications());
    isLoading.value = false;
  }

// Add to NotificationViewModel class
  Future<void> refreshWithIndicator() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate loading
    loadNotifications();
  }

  Future<void> markAsRead(String id) async {
    // await _service.markAsRead(id);
    loadNotifications(); // Refresh list
  }

  Future<void> clearAll() async {
    // await _service.clearAllNotifications();
    notifications.clear();
  }
}