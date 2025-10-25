import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer';

import '../../data/repositories/team_repo.dart';
import '../../utils/snackbar_helper.dart';
import 'create_team_controller.dart'; 
import 'team_lobby_controller.dart';

class TeamChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  final TeamRepository _teamRepository = Get.find<TeamRepository>();
  final RxBool isSending = false.obs;

  // Mock messages for display. New messages are added here.
  final RxList<Map<String, dynamic>> chatMessages = <Map<String, dynamic>>[
    {
      'name': 'You',
      'role': 'CEO',
      'level': 5,
      'message': 'Team, I got "Development of New Markets" strategy! Perfect for our goals 🚀',
      'isCurrentUser': true,
    },
    {
      'name': 'Johnson',
      'role': 'Strategist',
      'level': 5,
      'message': 'Nice! I drew "Digital Transformation Initiative". These strategies complement each other well!',
      'isCurrentUser': false,
    },
    {
      'name': 'Tasha',
      'role': 'Strategist',
      'level': 5,
      'message': 'let\'s Start the Game,Nice! I drew "Digital Transformation Initiative". These strategies complement each other well!',
      'isCurrentUser': false,
    },
  ].obs;

  Future<void> sendChatMessage() async {
    final message = messageController.text.trim();
    if (message.isEmpty) {
      SnackbarHelper.warning('Please enter a message.');
      return;
    }

    // Attempt to get the team token from the lobby controller (preferred) or create team controller
    final teamToken = Get.find<TeamLobbyController>().teamData.value?.token ??
        (Get.isRegistered<CreateTeamController>() ? Get.find<CreateTeamController>().teamCodeController.text.trim() : null);

    if (teamToken == null || teamToken.isEmpty) {
      SnackbarHelper.error('Cannot send message: Team token not found.');
      return;
    }

    try {
      isSending.value = true;
      
      // 1. Call WS Message API to send the message to the room
      await _teamRepository.sendWsMessage(teamToken, message); // <-- WS API Call
      
      // 2. Add message to local list for immediate visual update
      chatMessages.add({
        'name': 'You', 
        'role': 'CEO (Assumed)', 
        'level': 5, 
        'message': message,
        'isCurrentUser': true,
      });

      messageController.clear();
      SnackbarHelper.info('Message sent via WebSocket!');
    } catch (e) {
      log('Error sending chat message: $e');
      SnackbarHelper.error('Failed to send message: ${e.toString()}');
    } finally {
      isSending.value = false;
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}