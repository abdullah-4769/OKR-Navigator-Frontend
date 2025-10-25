// lib/services/firebase_notification_service.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; 
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../data/repositories/storage_repository.dart';
import '../data/repositories/team_repo.dart';

// Top-level function for background messages (required by Flutter)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // IMPORTANT: If you need to access shared preferences or other native features 
  // in the background, you must call Firebase.initializeApp() here. 
  print("Handling background message: ${message.messageId}");
}

class FirebaseNotificationService extends GetxService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  // Dependencies to be injected
  final StorageRepository _storageRepository = Get.find<StorageRepository>();
  final TeamRepository _teamRepository = Get.find<TeamRepository>();

  @override
  void onInit() {
    super.onInit();
    // Start initialization when the service is instantiated
    _initializeFCM();
  }

  /// Handles all local and Firebase initialization, listeners, and token management.
  Future<void> _initializeFCM() async {
    // 1. Local Notifications Setup
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _localNotifications.initialize(initializationSettings);

    // 2. Permission and Token Retrieval
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true, badge: true, sound: true,
    );
    print('Notification permission: ${settings.authorizationStatus}');
    
    // Get and save the token
    final token = await _messaging.getToken();
    if (token != null) {
      await _storageRepository.saveFCMToken(token); 
      final userId = _storageRepository.getUser()?.id;
      
      if (userId != null) {
        // You should implement a dedicated endpoint in TeamRepository/TeamApi 
        // to register this token against the userId on your server for targeting.
        // E.g.: await _teamRepository.registerFCMToken(token, userId);
      }
    }

    // 3. Token Refresh Listener
    _messaging.onTokenRefresh.listen((newToken) async {
      await _storageRepository.saveFCMToken(newToken);
      // Resend to backend here: await _teamRepository.registerFCMToken(newToken, userId);
    });

    // 4. Foreground Message Handler (uses local notifications to display)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        _showLocalNotification(notification.title, notification.body);
      }
    });

    // 5. Background Message Handler (using the top-level function)
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  /// Displays the notification using Flutter Local Notifications
  Future<void> _showLocalNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'team_channel',
      'Team Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      platformDetails,
    );
  }

  /// This is the method your controllers will call to trigger a server-side notification.
  Future<void> sendTeamNotification({
    required int teamId,
    required String title,
    required String body,
    String? recipientUserId,
    required String notificationType, 
  }) async {
    final Map<String, dynamic> payload = {
      'teamId': teamId,
      'title': title,
      'body': body,
      'notificationType': notificationType, 
      'senderUserId': _storageRepository.getUser()?.id,
      if (recipientUserId != null) 'recipientUserId': recipientUserId,
    };

    try {
      // Step 2.3 handles the repository call
      await _teamRepository.sendFCMNotification(payload); 
    } catch (e) {
      print('❌ Failed to trigger server-side notification: $e');
    }
  }
}