// lib/controllers/team_mode_controller/team_chat_controller.dart
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import '../../data/repositories/storage_repository.dart';
import '../../data/repositories/team_repo.dart';
import '../../services/notification_service.dart';
import '../../utils/snackbar_helper.dart';
import 'create_team_controller.dart'; 

class TeamChatController extends GetxController {
  final StorageRepository _storageRepository = Get.find<StorageRepository>();
  final TeamRepository _teamRepository = Get.find<TeamRepository>();
  final FirebaseNotificationService _notificationService = Get.find<FirebaseNotificationService>();
  final Dio _dio = Dio();

  // TextEditingController for message input
  final TextEditingController messageController = TextEditingController();

  // WebSocket connection
  WebSocketChannel? _channel;
  StreamSubscription? _subscription;

  // Observable variables
  final RxList<Map<String, dynamic>> chatMessages = <Map<String, dynamic>>[].obs;
  final RxBool isConnected = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;
  final RxString teamToken = ''.obs;
  final RxString teamName = 'Team Alpha'.obs;
  final RxList<Map<String, dynamic>> teamMembers = <Map<String, dynamic>>[].obs;

  // Quick responses
  final RxList<String> quickResponses = <String>[
    "Let's align our OKRs!",
    "Starting my objectives now",
    "Great team synergy!",
    "Need help with strategy?",
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeTeamData();
    _loadTeamMembers();
    connect(); // Auto-connect when controller initializes
  }

  @override
  void onClose() {
    _disconnect();
    messageController.dispose();
    super.onClose();
  }

  /// Initialize team data
  void _initializeTeamData() {
    // Get team data from CreateTeamController
    if (Get.isRegistered<CreateTeamController>()) {
      final createTeamController = Get.find<CreateTeamController>();
      final teamId = createTeamController.createdTeamId.value;
      
      if (teamId != null) {
        _loadTeamToken(teamId);
      }
    }
  }

  /// Load team token
  Future<void> _loadTeamToken(int teamId) async {
    try {
      teamToken.value = 'ABC123'; // This should come from team data
    } catch (e) {
      log('Error loading team token: $e');
    }
  }

  /// Load team members
  Future<void> _loadTeamMembers() async {
    try {
      isLoading.value = true;
      
      int? teamId;
      if (Get.isRegistered<CreateTeamController>()) {
        final createTeamController = Get.find<CreateTeamController>();
        teamId = createTeamController.createdTeamId.value;
      }
      
      if (teamId != null) {
        final response = await _dio.get(
          '${_getBaseUrl()}/team/$teamId/details',
        );

        if (response.statusCode == 200) {
          final data = response.data;
          if (data['members'] != null) {
            final List<dynamic> members = data['members'];
            teamMembers.assignAll(members.cast<Map<String, dynamic>>());
          }
        }
      }
    } catch (e) {
      log('Error loading team members: $e');
      SnackbarHelper.error('Failed to load team members');
    } finally {
      isLoading.value = false;
    }
  }

  /// Connect to WebSocket
  Future<void> connect() async {
    if (teamToken.value.isEmpty) {
      SnackbarHelper.error('Team token not found');
      return;
    }

    try {
      isLoading.value = true;
      
      _channel = IOWebSocketChannel.connect(
        'ws://192.168.1.6:3000/ws?teamToken=${teamToken.value}',
      );

      _subscription = _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnect,
      );

      isConnected.value = true;
      SnackbarHelper.success('Connected to team chat');
      
      await _loadPreviousMessages();
      
    } catch (e) {
      log('Error connecting to WebSocket: $e');
      SnackbarHelper.error('Failed to connect to team chat');
      isConnected.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Disconnect from WebSocket
  void _disconnect() {
    _subscription?.cancel();
    _channel?.sink.close();
    isConnected.value = false;
  }

  /// Handle incoming messages
  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message);
      
      // Add message to list with proper structure for ChatWidget
      chatMessages.add({
        'id': data['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        'name': data['userName'] ?? 'Unknown',
        'role': data['userRole'] ?? 'Member',
        'level': data['userLevel'] ?? 1,
        'message': data['message'] ?? '',
        'timestamp': data['timestamp'] ?? DateTime.now().toIso8601String(),
        'isCurrentUser': data['userId'] == _storageRepository.getUser()?.id,
      });
      
      // Send notification for new messages (if not from current user)
      if (data['userId'] != _storageRepository.getUser()?.id) {
        _sendMessageNotification(data['userName'], data['message']);
      }
      
    } catch (e) {
      log('Error handling message: $e');
    }
  }

  /// Handle WebSocket errors
  void _handleError(dynamic error) {
    log('WebSocket error: $error');
    SnackbarHelper.error('Connection error');
    isConnected.value = false;
  }

  /// Handle WebSocket disconnect
  void _handleDisconnect() {
    log('WebSocket disconnected');
    isConnected.value = false;
    SnackbarHelper.warning('Disconnected from team chat');
  }

  /// Send message - main method used by the screen
  Future<void> sendChatMessage() async {
    final message = messageController.text.trim();
    if (message.isEmpty) {
      SnackbarHelper.warning('Message cannot be empty');
      return;
    }

    if (!isConnected.value) {
      SnackbarHelper.error('Not connected to team chat');
      return;
    }

    try {
      isSending.value = true;
      final user = _storageRepository.getUser();
      if (user == null) {
        SnackbarHelper.error('User not found');
        return;
      }

      // Send message via WebSocket
      _channel?.sink.add(jsonEncode({
        'teamToken': teamToken.value,
        'userId': user.id,
        'userName': user.name ?? 'Unknown',
        'userRole': 'CEO',
        'userLevel': 5,
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
      }));

      // Also send via API for persistence
      await _teamRepository.sendWsMessage(teamToken.value, message);
      
      // Clear input
      messageController.clear();
      
    } catch (e) {
      log('Error sending message: $e');
      SnackbarHelper.error('Failed to send message');
    } finally {
      isSending.value = false;
    }
  }

  /// Send quick response
  void sendQuickResponse(String response) {
    messageController.text = response;
    sendChatMessage();
  }

  /// Load previous messages
  Future<void> _loadPreviousMessages() async {
    try {
      // Sample messages with proper structure for ChatWidget
      chatMessages.assignAll([
        {
          'id': '1',
          'name': 'You',
          'role': 'CEO',
          'level': 5,
          'message': 'Team, I got "Development of New Products" strategy. Perfect for our goal!',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 10)).toIso8601String(),
          'isCurrentUser': true,
        },
        {
          'id': '2',
          'name': 'Johnson',
          'role': 'Manager',
          'level': 5,
          'message': 'Nice! I chose "Digital Transformation Initiative". These strategies complement each other well.',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 8)).toIso8601String(),
          'isCurrentUser': false,
        },
        {
          'id': '3',
          'name': 'Tasha',
          'role': 'Strategist',
          'level': 5,
          'message': 'Let\'s start the game!',
          'timestamp': DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
          'isCurrentUser': false,
        },
      ]);
    } catch (e) {
      log('Error loading previous messages: $e');
    }
  }

  /// Send message notification
  void _sendMessageNotification(String userName, String message) {
    final user = _storageRepository.getUser();
    if (user != null) {
      _notificationService.sendNotification(
        title: 'New message from $userName',
        body: message.length > 50 ? '${message.substring(0, 50)}...' : message,
        notificationType: NotificationType.teamPlayerProgress,
        recipientUserId: user.id!,
        teamId: Get.find<CreateTeamController>().createdTeamId.value,
        additionalData: {
          'chatMessage': true,
          'senderName': userName,
          'fullMessage': message,
        },
      );
    }
  }

  // ... rest of your methods remain the same

  /// Helper method to get base URL
  String _getBaseUrl() {
    return 'http://192.168.1.6:3000';
  }
}