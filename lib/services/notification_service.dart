// lib/services/notification_service.dart
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; 
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../data/repositories/storage_repository.dart';
import '../data/repositories/team_repo.dart';
import 'notifications/notifications_service.dart';

// Top-level function for background messages (required by Flutter)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling background message: ${message.messageId}");
}

enum NotificationType {
  // Solo Mode
  soloEvaluationCompleted,
  soloEvaluationFailed,
  soloOverallCompletion,
  
  // Challenge Mode
  challengeInvitationReceived,
  challengeInvitationSent,
  challengeInvitationAccepted,
  challengeInvitationRejected,
  challengeStarted,
  challengePlayerProgress,
  challengeCompleted,
  
  // Campaign Mode
  campaignLevelUnlocked,
  campaignLevelReminder,
  campaignCertificationReminder,
  campaignCertificationComplete,
  
  // Team Mode
  teamInvitation,
  teamAutoJoined,
  teamMemberJoined,
  teamMemberLeft,
  teamRosterUpdated,
  teamRoleAssigned,
  teamGameStarted,
  teamPlayerProgress,
  teamTimeReminder,
  teamScoreUpdated,
  teamGameComplete,
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
    await _localNotifications.initialize(
        initializationSettings,
        // Optional: Handle notification tap when app is opened from terminated state
        onDidReceiveNotificationResponse: (NotificationResponse response) async {
            // Handle tap event (e.g., navigate to a specific screen based on payload)
            print('Local notification tapped. Payload: ${response.payload}');
        },
    );

    // 2. Permission and Token Retrieval + iOS foreground options
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true, badge: true, sound: true,
    );
    print('Notification permission: ${settings.authorizationStatus}');
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    
    // Get and save the token
    final token = await _messaging.getToken();
    if (token != null) {
      await _storageRepository.saveFCMToken(token); 
      final userId = _storageRepository.getUserId();
      // Subscribe to per-user topic for direct messages
      if (userId != null && userId.isNotEmpty) {
        try {
          await _messaging.subscribeToTopic('user_$userId');
          print('✅ Subscribed to topic: user_$userId');
        } catch (e) {
          print('❌ Failed subscribing to user topic: $e');
        }
      }
    }

    // 3. Token Refresh Listener
    _messaging.onTokenRefresh.listen((newToken) async {
      await _storageRepository.saveFCMToken(newToken);
      // Resend to backend here: await _teamRepository.registerFCMToken(newToken, userId);
    });

    // 4. Foreground Message Handler: delegate to unified NotificationsService
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await NotificationsService().handleRemoteMessage(message);
    });

    // 5. Background handler is registered in main.dart using NotificationsService.showFromBackground
    // Avoid duplicate background registration here.
  }

  /// Displays the notification using Flutter Local Notifications
  Future<void> _showLocalNotification(String? title, String? body, {String? payload}) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'okr_navigator_channel',
      'OKR Navigator Notifications',
      channelDescription: 'Notifications for game updates and team activities.',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      platformDetails,
      payload: payload,
    );
  }

  // Topic subscription helpers
  Future<void> subscribeToTeamTopic(int teamId) async {
    try {
      await _messaging.subscribeToTopic('team_$teamId');
      print('✅ Subscribed to topic: team_$teamId');
    } catch (e) {
      print('❌ Failed subscribing to team topic: $e');
    }
  }

  Future<void> unsubscribeFromTeamTopic(int teamId) async {
    try {
      await _messaging.unsubscribeFromTopic('team_$teamId');
      print('✅ Unsubscribed from topic: team_$teamId');
    } catch (e) {
      print('❌ Failed unsubscribing from team topic: $e');
    }
  }

  Future<void> subscribeToChallengeTopic(String challengeId) async {
    try {
      await _messaging.subscribeToTopic('challenge_$challengeId');
      print('✅ Subscribed to topic: challenge_$challengeId');
    } catch (e) {
      print('❌ Failed subscribing to challenge topic: $e');
    }
  }

  Future<void> unsubscribeFromChallengeTopic(String challengeId) async {
    try {
      await _messaging.unsubscribeFromTopic('challenge_$challengeId');
      print('✅ Unsubscribed from topic: challenge_$challengeId');
    } catch (e) {
      print('❌ Failed unsubscribing from challenge topic: $e');
    }
  }

  Future<void> subscribeToCampaignTopic(String campaignId) async {
    try {
      await _messaging.subscribeToTopic('campaign_$campaignId');
      print('✅ Subscribed to topic: campaign_$campaignId');
    } catch (e) {
      print('❌ Failed subscribing to campaign topic: $e');
    }
  }

  Future<void> unsubscribeFromCampaignTopic(String campaignId) async {
    try {
      await _messaging.unsubscribeFromTopic('campaign_$campaignId');
      print('✅ Unsubscribed from topic: campaign_$campaignId');
    } catch (e) {
      print('❌ Failed unsubscribing from campaign topic: $e');
    }
  }

  /// Generic method to send notifications (Network-based)
  Future<void> sendNotification({
    required String title,
    required String body,
    required NotificationType notificationType,
    String? recipientUserId,
    int? teamId,
    Map<String, dynamic>? additionalData,
  }) async {
    // 1. Trigger Local Notification Immediately (for local user feedback)
    _showLocalNotification(title, body); // <-- ADDED LOCAL NOTIFICATION TRIGGER
    
    // 2. Send Network Notification (FCM via Backend)
    final Map<String, dynamic> payload = {
      'title': title,
      'body': body,
      'notificationType': notificationType.name,
      'senderUserId': _storageRepository.getUser()?.id,
      if (recipientUserId != null) 'recipientUserId': recipientUserId,
      if (teamId != null) 'teamId': teamId,
      if (additionalData != null) ...additionalData,
    };

    try {
      // Calls your backend endpoint which should forward to FCM
      await _teamRepository.sendFCMNotification(payload);
      print('✅ Network Notification sent: $title');
    } catch (e) {
      print('❌ Failed to send network notification: $e');
    }
  }
  
  /// Solo Mode: Evaluation Completed Successfully
  Future<void> sendSoloEvaluationCompleted({
    required String playerName,
    required int level,
  }) async {
    await sendNotification(
      title: "Level Completed!",
      body: "Congratulations! You successfully completed this evaluation.",
      notificationType: NotificationType.soloEvaluationCompleted,
      additionalData: {
        'playerName': playerName,
        'level': level,
        'gameMode': 'solo',
      },
    );
  }

  /// Solo Mode: Evaluation Failed / Retry
  Future<void> sendSoloEvaluationFailed({
    required String playerName,
    required int remainingAttempts,
  }) async {
    await sendNotification(
      title: "Attempt Incomplete",
      body: "You didn't pass this evaluation. You have $remainingAttempts attempts remaining. Try again!",
      notificationType: NotificationType.soloEvaluationFailed,
      additionalData: {
        'playerName': playerName,
        'remainingAttempts': remainingAttempts,
        'gameMode': 'solo',
      },
    );
  }

  /// Solo Mode: Overall Completion
  Future<void> sendSoloOverallCompletion({
    required String playerName,
  }) async {
    await sendNotification(
      title: "Achievement Unlocked!",
      body: "You've completed the solo mode. Great job!",
      notificationType: NotificationType.soloOverallCompletion,
      additionalData: {
        'playerName': playerName,
        'gameMode': 'solo',
      },
    );
  }

  /// Challenge Mode: Invitation Received/Sent
  Future<void> sendChallengeInvitation({
    required String hostName,
    required String recipientName,
    required String recipientUserId,
    bool isReceived = true,
  }) async {
    await sendNotification(
      title: "New Challenge Invitation",
      body: "$hostName has invited you to a challenge. Accept or reject to join.",
      notificationType: NotificationType.challengeInvitationReceived,
      recipientUserId: recipientUserId,
      additionalData: {
        'hostName': hostName,
        'recipientName': recipientName,
        'gameMode': 'challenge',
        'isReceived': isReceived,
      },
    );
  }

  /// Challenge Mode: Invitation Accepted/Rejected
  Future<void> sendChallengeInvitationResponse({
    required String playerName,
    required String hostUserId,
    required bool isAccepted,
  }) async {
    final response = isAccepted ? "accepted" : "rejected";
    await sendNotification(
      title: "Challenge Update",
      body: "$playerName has $response your challenge invitation.",
      notificationType: NotificationType.challengeInvitationAccepted,
      recipientUserId: hostUserId,
      additionalData: {
        'playerName': playerName,
        'isAccepted': isAccepted,
        'gameMode': 'challenge',
      },
    );
  }

  /// Challenge Mode: Challenge Started
  Future<void> sendChallengeStarted({
    required String hostName,
    required List<String> participantUserIds,
  }) async {
    for (final userId in participantUserIds) {
      await sendNotification(
        title: "Challenge Started",
        body: "$hostName started the challenge. Good luck!",
        notificationType: NotificationType.challengeStarted,
        recipientUserId: userId,
        additionalData: {
          'hostName': hostName,
          'gameMode': 'challenge',
        },
      );
    }
  }

  /// Challenge Mode: Player Progress Update
  Future<void> sendChallengePlayerProgress({
    required String playerName,
    required List<String> otherParticipantUserIds,
  }) async {
    for (final userId in otherParticipantUserIds) {
      await sendNotification(
        title: "Player Progress Update",
        body: "$playerName has started the context challenge. Keep going!",
        notificationType: NotificationType.challengePlayerProgress,
        recipientUserId: userId,
        additionalData: {
          'playerName': playerName,
          'gameMode': 'challenge',
        },
      );
    }
  }

  /// Challenge Mode: Challenge Completed
  Future<void> sendChallengeCompleted({
    required String playerName,
    required String recipientUserId,
    required bool isWinner,
  }) async {
    final message = isWinner 
        ? "You won the challenge! Great performance."
        : "Challenge completed. Review your feedback and improve for next time.";
    
    await sendNotification(
      title: "Challenge Finished",
      body: message,
      notificationType: NotificationType.challengeCompleted,
      recipientUserId: recipientUserId,
      additionalData: {
        'playerName': playerName,
        'isWinner': isWinner,
        'gameMode': 'challenge',
      },
    );
  }

  /// Campaign Mode: Level Unlocked
  Future<void> sendCampaignLevelUnlocked({
    required String playerName,
    required int level,
    required String playerUserId,
  }) async {
    await sendNotification(
      title: "New Level Unlocked",
      body: "You unlocked Level $level. Continue your campaign!",
      notificationType: NotificationType.campaignLevelUnlocked,
      recipientUserId: playerUserId,
      additionalData: {
        'playerName': playerName,
        'level': level,
        'gameMode': 'campaign',
      },
    );
  }

  /// Campaign Mode: Level Progress Reminder
  Future<void> sendCampaignLevelReminder({
    required String playerName,
    required int level,
    required int remainingMinutes,
    required String playerUserId,
  }) async {
    await sendNotification(
      title: "Level Progress Reminder",
      body: "Level $level in progress. Time remaining: $remainingMinutes minutes.",
      notificationType: NotificationType.campaignLevelReminder,
      recipientUserId: playerUserId,
      additionalData: {
        'playerName': playerName,
        'level': level,
        'remainingMinutes': remainingMinutes,
        'gameMode': 'campaign',
      },
    );
  }

  /// Campaign Mode: Certification Reminder (Level 3)
  Future<void> sendCampaignCertificationReminder({
    required String playerName,
    required int remainingMinutes,
    required String playerUserId,
  }) async {
    await sendNotification(
      title: "Certification in Progress",
      body: "Level 3 Certification ongoing. Time remaining: $remainingMinutes minutes.",
      notificationType: NotificationType.campaignCertificationReminder,
      recipientUserId: playerUserId,
      additionalData: {
        'playerName': playerName,
        'remainingMinutes': remainingMinutes,
        'gameMode': 'campaign',
      },
    );
  }

  /// Campaign Mode: Certification Completion
  Future<void> sendCampaignCertificationComplete({
    required String playerName,
    required String playerUserId,
  }) async {
    await sendNotification(
      title: "Certification Complete",
      body: "Congratulations! You've completed the certification and earned your badge.",
      notificationType: NotificationType.campaignCertificationComplete,
      recipientUserId: playerUserId,
      additionalData: {
        'playerName': playerName,
        'gameMode': 'campaign',
      },
    );
  }

  /// Team Mode: Team Invitation
  Future<void> sendTeamInvitation({
    required String hostName,
    required String recipientUserId,
    required int teamId,
    bool autoJoin = false,
  }) async {
    final message = autoJoin 
        ? "You have been automatically added to the team by $hostName."
        : "$hostName invites you to join the team. Accept or auto-join if allowed.";
    
    final title = autoJoin ? "Auto-Joined Team" : "Team Invitation";
    
    await sendNotification(
      title: title,
      body: message,
      notificationType: NotificationType.teamInvitation,
      recipientUserId: recipientUserId,
      teamId: teamId,
      additionalData: {
        'hostName': hostName,
        'autoJoin': autoJoin,
        'gameMode': 'team',
      },
    );
  }

  /// Team Mode: Team Member Join/Leave
  Future<void> sendTeamMemberUpdate({
    required String playerName,
    required bool hasJoined,
    required int teamId,
    required List<String> teamMemberUserIds,
  }) async {
    final action = hasJoined ? "joined" : "left";
    final notificationType = hasJoined 
        ? NotificationType.teamMemberJoined 
        : NotificationType.teamMemberLeft;
    
    for (final userId in teamMemberUserIds) {
      await sendNotification(
        title: "Team Update",
        body: "$playerName has $action the team.",
        notificationType: notificationType,
        recipientUserId: userId,
        teamId: teamId,
        additionalData: {
          'playerName': playerName,
          'hasJoined': hasJoined,
          'gameMode': 'team',
        },
      );
    }
  }

  /// Team Mode: Team Roster Updated Before Game Start
  Future<void> sendTeamRosterUpdated({
    required int teamId,
    required List<String> teamMemberUserIds,
  }) async {
    for (final userId in teamMemberUserIds) {
      await sendNotification(
        title: "Team Roster Updated",
        body: "Team members have changed before the game started. Check the updated team list.",
        notificationType: NotificationType.teamRosterUpdated,
        recipientUserId: userId,
        teamId: teamId,
        additionalData: {
          'gameMode': 'team',
        },
      );
    }
  }

  /// Team Mode: Role Assigned
  Future<void> sendTeamRoleAssigned({
    required String playerName,
    required String roleName,
    required String playerUserId,
    required int teamId,
  }) async {
    await sendNotification(
      title: "Role Assigned",
      body: "You have been assigned the role: $roleName.",
      notificationType: NotificationType.teamRoleAssigned,
      recipientUserId: playerUserId,
      teamId: teamId,
      additionalData: {
        'playerName': playerName,
        'roleName': roleName,
        'gameMode': 'team',
      },
    );
  }

  /// Team Mode: Game Started
  Future<void> sendTeamGameStarted({
    required int teamId,
    required List<String> teamMemberUserIds,
  }) async {
    for (final userId in teamMemberUserIds) {
      await sendNotification(
        title: "Team Game Started",
        body: "Your team game has started. Good luck, team!",
        notificationType: NotificationType.teamGameStarted,
        recipientUserId: userId,
        teamId: teamId,
        additionalData: {
          'gameMode': 'team',
        },
      );
    }
  }

  /// Team Mode: Player Evaluation Progress
  Future<void> sendTeamPlayerProgress({
    required String playerName,
    required int teamId,
    required List<String> otherTeamMemberUserIds,
  }) async {
    for (final userId in otherTeamMemberUserIds) {
      await sendNotification(
        title: "Team Progress Update",
        body: "$playerName started a context challenge. Keep up the momentum!",
        notificationType: NotificationType.teamPlayerProgress,
        recipientUserId: userId,
        teamId: teamId,
        additionalData: {
          'playerName': playerName,
          'gameMode': 'team',
        },
      );
    }
  }

  /// Team Mode: Time Reminder
  Future<void> sendTeamTimeReminder({
    required int remainingMinutes,
    required int teamId,
    required List<String> teamMemberUserIds,
  }) async {
    for (final userId in teamMemberUserIds) {
      await sendNotification(
        title: "Time Reminder",
        body: "Team game in progress. Remaining time: $remainingMinutes minutes. Keep going!",
        notificationType: NotificationType.teamTimeReminder,
        recipientUserId: userId,
        teamId: teamId,
        additionalData: {
          'remainingMinutes': remainingMinutes,
          'gameMode': 'team',
        },
      );
    }
  }

  /// Team Mode: Score Updated
  Future<void> sendTeamScoreUpdated({
    required String playerName,
    required int teamId,
    required List<String> otherTeamMemberUserIds,
  }) async {
    for (final userId in otherTeamMemberUserIds) {
      await sendNotification(
        title: "Score Updated",
        body: "$playerName submitted their score. Team score updated.",
        notificationType: NotificationType.teamScoreUpdated,
        recipientUserId: userId,
        teamId: teamId,
        additionalData: {
          'playerName': playerName,
          'gameMode': 'team',
        },
      );
    }
  }

  /// Team Mode: Game Complete
  Future<void> sendTeamGameComplete({
    required String playerName,
    required String recipientUserId,
    required int teamId,
    required bool isWinner,
  }) async {
    final message = isWinner 
        ? "Your team won! Congratulations!"
        : "Game over. Review your feedback and prepare for the next match.";
    
    await sendNotification(
      title: "Team Game Complete",
      body: message,
      notificationType: NotificationType.teamGameComplete,
      recipientUserId: recipientUserId,
      teamId: teamId,
      additionalData: {
        'playerName': playerName,
        'isWinner': isWinner,
        'gameMode': 'team',
      },
    );
  }

  // ============================================================================
  // LEGACY METHOD (for backward compatibility)
  // ============================================================================

  /// Legacy method for team notifications (backward compatibility)
  Future<void> sendTeamNotification({
    required int teamId,
    required String title,
    required String body,
    String? recipientUserId,
    required String notificationType, 
  }) async {
    await sendNotification(
      title: title,
      body: body,
      notificationType: NotificationType.teamInvitation, // Default type
      recipientUserId: recipientUserId,
      teamId: teamId,
    );
  }
}
