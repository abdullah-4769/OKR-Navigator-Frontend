
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../data/repositories/storage_repository.dart';
import '../../presentation/views/challange_mode/challange_detail_screen.dart';
import '../../repository/challange_repositories/join_challange_repository.dart';
import '../../repository/challange_repositories/challengers_vs_repository.dart';
import '../../services/notification_service.dart';
import '../../data/response/status.dart';

class JoinChallengeViewModel extends GetxController {
  final TextEditingController inviteCodeController = TextEditingController();
  final StorageRepository _storageRepo = Get.find<StorageRepository>();
  final JoinChallengeRepository _repository = JoinChallengeRepository();
  final ShowChallengersVsRepository _challengersRepository = ShowChallengersVsRepository();
  final FirebaseNotificationService _notificationService = Get.find<FirebaseNotificationService>();

  var isJoining = false.obs;
  var joinStatus = ''.obs;
  var inviteCode = ''.obs;

  void clearStatus() {
    joinStatus.value = '';
  }

  bool isValidInviteCode(String code) {
    return code.length == 6 && RegExp(r'^[A-Z0-9]{6}$').hasMatch(code.toUpperCase());
  }

  /// Join a challenge using invite code
  Future<void> joinChallengeWithCode(String inviteCode, String userId) async {
    if (!isValidInviteCode(inviteCode)) {
      Get.snackbar(
        'Invalid Code',
        'Please enter a valid 6-character invite code',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isJoining.value = true;
      joinStatus.value = 'Joining challenge...';

      final upperCode = inviteCode.toUpperCase();

      print('\n🎯 ========== JOINING CHALLENGE ==========');
      print('📋 Code: $upperCode');
      print('👤 User ID: $userId');

      // Call repository to join
      final result = await _repository.joinChallenge(upperCode, userId);

      final challengeId = result['challengeId'];
      final int? numericChallengeId = challengeId is int
          ? challengeId as int
          : int.tryParse(challengeId.toString());

      print('✅ Join successful!');
      print('   Challenge ID: $challengeId');
      print('   User ID: $userId');
      print('=========================================\n');

      joinStatus.value = 'Successfully joined!';

      // Show success message
      Get.snackbar(
        'Success! 🎉',
        'You joined the challenge!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );

      final joiningPlayerName = _storageRepo.getUser()?.name ?? 'Player';
      if (numericChallengeId != null) {
        await _notifyExistingPlayers(
          challengeId: numericChallengeId,
          joiningUserId: userId,
          joiningPlayerName: joiningPlayerName,
        );
      }

      // Navigate to challenge details
      await Future.delayed(Duration(milliseconds: 800));
      Get.to(() => ChallengeDetailsScreen());

    } catch (e) {
      print('❌ ERROR: $e');

      joinStatus.value = 'Error: ${e.toString()}';

      Get.snackbar(
        'Failed to Join',
        e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
      );
    } finally {
      isJoining.value = false;
    }
  }

  Future<void> _notifyExistingPlayers({
    required int challengeId,
    required String joiningUserId,
    required String joiningPlayerName,
  }) async {
    try {
      final response =
          await _challengersRepository.getChallengePlayers(challengeId.toString());
      final status = response.status;
      if ((status == Status.completed || status == Status.COMPLETED) &&
          response.data != null) {
        final List<dynamic> players = response.data!;

        String? hostUserId;
        if (players.isNotEmpty) {
          final hostCandidate = players.first;
          if (hostCandidate is Map<String, dynamic>) {
            hostUserId =
                hostCandidate['userId']?.toString() ?? hostCandidate['id']?.toString();
          }
        }

        final recipients = players
            .where((player) =>
                player is Map<String, dynamic> &&
                player['isPlaceholder'] != true)
            .map((player) =>
                player['userId']?.toString() ?? player['id']?.toString() ?? '')
            .where((id) => id.isNotEmpty && id != joiningUserId)
            .toList();

        if (recipients.isNotEmpty) {
          await _notificationService.sendChallengePlayerProgress(
            playerName: joiningPlayerName,
            otherParticipantUserIds: recipients,
          );
        }

        if (hostUserId != null &&
            hostUserId.isNotEmpty &&
            hostUserId != joiningUserId) {
          await _notificationService.sendChallengeInvitationResponse(
            playerName: joiningPlayerName,
            hostUserId: hostUserId,
            isAccepted: true,
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to notify challenge members: $e');
      }
    }
  }

  @override
  void onClose() {
    inviteCodeController.dispose();
    super.onClose();
  }
}