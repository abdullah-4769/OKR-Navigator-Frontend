import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

import '../../core/api_constants.dart';
import '../../data/repositories/storage_repository.dart';
import '../../data/repositories/team_repository.dart';
import '../../services/notification_service.dart';
import '../../utils/snackbar_helper.dart';
import 'create_team_controller.dart';

class TeamChatController extends GetxController {
  final StorageRepository _storageRepository = Get.find<StorageRepository>();
  final TeamRepository _teamRepository = Get.find<TeamRepository>();
  final FirebaseNotificationService _notificationService =
  Get.find<FirebaseNotificationService>();
  final Dio _dio = Dio();

  final TextEditingController messageController = TextEditingController();

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;

  final RxList<Map<String, dynamic>> chatMessages = <Map<String, dynamic>>[].obs;
  final RxBool isConnected = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;
  final RxString teamToken = ''.obs;
  final RxString teamName = 'Team Alpha'.obs;
  final RxList<Map<String, dynamic>> teamMembers = <Map<String, dynamic>>[].obs;

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
  }

  @override
  void onReady() {
    super.onReady();
    connect();
  }

  @override
  void onClose() {
    _disconnect();
    messageController.dispose();
    super.onClose();
  }

  void _initializeTeamData() {
    if (Get.isRegistered<CreateTeamController>()) {
      final createTeamController = Get.find<CreateTeamController>();
      final teamId = createTeamController.createdTeamId.value;
      if (teamId != null) {
        _loadTeamToken(teamId);
      }
    }
  }

  Future<void> _loadTeamToken(int teamId) async {
    try {
      teamToken.value = 'ABC123'; // Should come from actual team data
    } catch (e) {
      log('Error loading team token: $e');
    }
  }

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
          '${ApiConstants.baseUrl}/team/$teamId/details', // ✅ Use ApiConstants
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

  Future<void> connect() async {
    final user = _storageRepository.getUser();
    if (user == null || teamToken.value.isEmpty) return;

    try {
      isLoading.value = true;

      _channel = IOWebSocketChannel.connect(
        'ws://${ApiConstants.baseUrl.split("://")[1]}/ws?teamToken=${teamToken.value}', // ✅ WebSocket URL from ApiConstants
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

  void _disconnect() {
    _subscription?.cancel();
    _channel?.sink.close();
    isConnected.value = false;
  }

  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message);

      chatMessages.add({
        'id': data['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        'name': data['userName'] ?? 'Unknown',
        'role': data['userRole'] ?? 'Member',
        'level': data['userLevel'] ?? 1,
        'message': data['message'] ?? '',
        'timestamp': data['timestamp'] ?? DateTime.now().toIso8601String(),
        'isCurrentUser': data['userId'] == _storageRepository.getUser()?.id,
      });

      if (data['userId'] != _storageRepository.getUser()?.id) {
        _sendMessageNotification(data['userName'], data['message']);
      }
    } catch (e) {
      log('Error handling message: $e');
    }
  }

  void _handleError(dynamic error) {
    log('WebSocket error: $error');
    SnackbarHelper.error('Connection error');
    isConnected.value = false;
  }

  void _handleDisconnect() {
    log('WebSocket disconnected');
    isConnected.value = false;
    SnackbarHelper.warning('Disconnected from team chat');
  }

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

      _channel?.sink.add(jsonEncode({
        'teamToken': teamToken.value,
        'userId': user.id,
        'userName': user.name ?? 'Unknown',
        'userRole': 'CEO',
        'userLevel': 5,
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
      }));

      await _teamRepository.sendWsMessage(teamToken.value, message);
      messageController.clear();
    } catch (e) {
      log('Error sending message: $e');
      SnackbarHelper.error('Failed to send message');
    } finally {
      isSending.value = false;
    }
  }

  void sendQuickResponse(String response) {
    messageController.text = response;
    sendChatMessage();
  }

  Future<void> _loadPreviousMessages() async {
    try {
      chatMessages.assignAll([
        {
          'id': '1',
          'name': 'You',
          'role': 'CEO',
          'level': 5,
          'message':
          'Team, I got "Development of New Products" strategy. Perfect for our goal!',
          'timestamp':
          DateTime.now().subtract(const Duration(minutes: 10)).toIso8601String(),
          'isCurrentUser': true,
        },
        {
          'id': '2',
          'name': 'Johnson',
          'role': 'Manager',
          'level': 5,
          'message':
          'Nice! I chose "Digital Transformation Initiative". These strategies complement each other well.',
          'timestamp':
          DateTime.now().subtract(const Duration(minutes: 8)).toIso8601String(),
          'isCurrentUser': false,
        },
        {
          'id': '3',
          'name': 'Tasha',
          'role': 'Strategist',
          'level': 5,
          'message': 'Let\'s start the game!',
          'timestamp':
          DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
          'isCurrentUser': false,
        },
      ]);
    } catch (e) {
      log('Error loading previous messages: $e');
    }
  }

  void _sendMessageNotification(String userName, String message) {
    final user = _storageRepository.getUser();
    if (user != null) {
      _notificationService.sendNotification(
        title: 'New message from $userName',
        body: message.length > 50
            ? '${message.substring(0, 50)}...'
            : message,
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
}
