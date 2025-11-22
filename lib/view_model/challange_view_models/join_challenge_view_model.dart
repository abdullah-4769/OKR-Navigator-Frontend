
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/storage_repository.dart';
import '../../presentation/views/challange_mode/challange_detail_screen.dart';
import '../../repository/challange_repositories/join_challange_repository.dart';

class JoinChallengeViewModel extends GetxController {
  final TextEditingController inviteCodeController = TextEditingController();
  final StorageRepository _storageRepo = Get.find<StorageRepository>();
  final JoinChallengeRepository _repository = JoinChallengeRepository();

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

  @override
  void onClose() {
    inviteCodeController.dispose();
    super.onClose();
  }
}