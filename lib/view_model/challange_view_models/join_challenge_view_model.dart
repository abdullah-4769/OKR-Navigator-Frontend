// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:game_app/data/response/api_response.dart';
// import '../../generated/models/requests/challange_mode/join_challange_request.dart';
// import '../../repository/challange_repositories/join_challange_repository.dart';
//
// class JoinChallengeViewModel extends GetxController {
//   final JoinChallengeRepository _repository = JoinChallengeRepository();
//
//   final Rx<ApiResponse> _joinChallengeResponse = ApiResponse.notStarted().obs;
//   ApiResponse get joinChallengeResponse => _joinChallengeResponse.value;
//
//   final isJoining = false.obs;
//
//   Future<void> joinChallenge(String code) async {
//     print('JoinChallengeViewModel: joinChallenge called with code: $code');
//     try {
//       isJoining.value = true;
//       _joinChallengeResponse.value = ApiResponse.loading();
//       print('JoinChallengeViewModel: Set isJoining to true, response to loading');
//
//       final prefs = await SharedPreferences.getInstance();
//       final userId = prefs.getString('userId');
//       print('JoinChallengeViewModel: Retrieved userId: $userId');
//
//       if (userId == null) {
//         print('JoinChallengeViewModel: Error - User ID not found in SharedPreferences');
//         _joinChallengeResponse.value = ApiResponse.error("User ID not found");
//         return;
//       }
//
//       final request = JoinChallengeRequest(userId: userId);
//       print('JoinChallengeViewModel: Sending join request with code: $code, userId: $userId');
//
//       final response = await _repository.joinChallenge(code, request);
//       print('JoinChallengeViewModel: Received response: $response');
//
//       _joinChallengeResponse.value = ApiResponse.completed(response);
//       print('JoinChallengeViewModel: Set response to completed');
//       // ✅ Save joined challenge ID for later use
//       try {
//         final prefs = await SharedPreferences.getInstance();
//         // Assuming response is a Map (based on your API response)
//         final challengeId = response['id']?.toString();
//         if (challengeId != null) {
//           await prefs.setString('joinChallengeId', challengeId);
//           print('✅ Saved joinChallengeId: $challengeId');
//         } else {
//           print('⚠️ No challenge ID found in join challenge response');
//         }
//       } catch (e) {
//         print('⚠️ Error saving joinChallengeId to SharedPreferences: $e');
//       }
//
//     } catch (error) {
//       print('JoinChallengeViewModel: Error occurred: $error');
//       _joinChallengeResponse.value = ApiResponse.error(error.toString());
//     } finally {
//       isJoining.value = false;
//       print('JoinChallengeViewModel: Set isJoining to false');
//     }
//
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/storage_repository.dart';
import '../../presentation/views/challange_mode/challange_detail_screen.dart';
import '../../repository/challange_repositories/join_challange_repository.dart';

class JoinChallengeViewModel extends GetxController {
  final JoinChallengeRepository _repository = JoinChallengeRepository();
  final StorageRepository _storageRepo = Get.find<StorageRepository>();

  final inviteCodeController = TextEditingController();
  final isJoining = false.obs;
  final joinStatus = ''.obs;
  final inviteCode = ''.obs;


  @override
  void onInit() {
    super.onInit();
    // ✅ ADD THIS: Listen to text controller changes
    inviteCodeController.addListener(() {
      inviteCode.value = inviteCodeController.text.trim();
    });
  }

  @override
  void onClose() {
    inviteCodeController.removeListener(() {});
    inviteCodeController.dispose();
    super.onClose();
  }

  // ✅ FIXED: Get current user ID with proper fallback chain
  String? _getCurrentUserId() {
    // Try StorageRepository first (most reliable)
    String? userId = _storageRepo.getUserId();

    if (userId != null && userId.isNotEmpty) {
      if (kDebugMode) print("✅ Got user ID from StorageRepository: $userId");
      return userId;
    }

    if (kDebugMode) print("❌ No user ID found in StorageRepository");
    return null;
  }

  // ✅ FIXED: Join challenge with code - proper user ID handling
  Future<void> joinChallengeWithCode(String code, String userId) async {
    // Validate inputs
    if (code.isEmpty) {
      joinStatus.value = 'Error: Invite code is required';
      return;
    }

    if (userId.isEmpty) {
      joinStatus.value = 'Error: User not logged in';
      Get.snackbar(
        'Authentication Required',
        'Please log in to join challenges',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isJoining.value = true;
      joinStatus.value = 'Joining challenge...';

      if (kDebugMode) {
        print('🎯 Attempting to join challenge:');
        print('  - Invite Code: $code');
        print('  - User ID: $userId');
      }

      // Call repository to join challenge
      final result = await _repository.joinChallenge(code, userId);

      if (kDebugMode) print('✅ Join challenge response: $result');

      // Extract challenge ID from response
      final challengeId = result['challengeId']?.toString() ??
          result['id']?.toString();

      if (challengeId == null || challengeId.isEmpty) {
        throw Exception('No challenge ID received from server');
      }

      // Save challenge ID to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('acceptInviteChallengeId', challengeId);
      if (kDebugMode) print('✅ Saved acceptInviteChallengeId: $challengeId');

      // Update status
      joinStatus.value = 'Success! Joined challenge';
      isJoining.value = false;

      // Show success message
      Get.snackbar(
        'Success!',
        'You have successfully joined the challenge!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      // Clear the input
      inviteCodeController.clear();

      // Navigate to challenge details after a short delay
      Future.delayed(Duration(milliseconds: 500), () {
        Get.to(() => ChallengeDetailsScreen());
      });

    } catch (e) {
      isJoining.value = false;

      // Parse error message
      String errorMessage = e.toString();
      if (errorMessage.contains('Challenge not found')) {
        joinStatus.value = 'Error: Invalid invite code';
        errorMessage = 'Invalid invite code. Please check and try again.';
      } else if (errorMessage.contains('already joined') || errorMessage.contains('Already')) {
        joinStatus.value = 'Error: Already joined this challenge';
        errorMessage = 'You have already joined this challenge.';
      } else if (errorMessage.contains('User not found')) {
        joinStatus.value = 'Error: User not found. Please log in again.';
        errorMessage = 'User authentication failed. Please log in again.';
      } else {
        joinStatus.value = 'Error: Failed to join challenge';
      }

      if (kDebugMode) print('❌ Error joining challenge: $e');

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
      );
    }
  }

  // Clear status message
  void clearStatus() {
    joinStatus.value = '';
  }

  // Validate invite code format
  bool isValidInviteCode(String code) {
    return code.length == 6 && RegExp(r'^[A-Z0-9]+$').hasMatch(code);
  }
}