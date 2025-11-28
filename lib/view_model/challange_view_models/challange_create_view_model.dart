// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../core/api_constants.dart';
// import '../../data/response/api_response.dart';
// import '../../data/repositories/storage_repository.dart';
// import '../../presentation/views/challange_mode/challange_detail_screen.dart';
// import '../../repository/challange_repositories/challange_create_repository.dart';
// import '../../repository/challange_repositories/challenge_accept_invitation_repository.dart';
// import '../../repository/challange_repositories/challenge_send__invite_repostory.dart';
// ============================================
// FILE 1: challange_create_view_model.dart
// ============================================

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api_constants.dart';
import '../../data/response/api_response.dart';
import '../../data/repositories/storage_repository.dart';
import '../../presentation/views/challange_mode/challange_detail_screen.dart';
import '../../repository/challange_repositories/challange_create_repository.dart';
import '../../repository/challange_repositories/challenge_accept_invitation_repository.dart';
import '../../repository/challange_repositories/challenge_send__invite_repostory.dart';
import '../../services/shared_preference.dart';
import '../../services/notification_service.dart';

class ChallengeCreateViewModel extends GetxController {
  final ChallengeRepository _repository = ChallengeRepository();
  final ChallengeAcceptInvitationRepository _invitationRepository = ChallengeAcceptInvitationRepository();
  final ChallengeSendInviteRepository _sendInviteRepository = ChallengeSendInviteRepository();
  final StorageRepository _storageRepo = Get.find<StorageRepository>();
  final FirebaseNotificationService _notificationService = Get.find<FirebaseNotificationService>();

  final isChallengeCreated = false.obs;
  var inviteCode = ''.obs;
  var inviteCodeResponse = ApiResponse<String>.notStarted().obs;
  var invitationResponse = ApiResponse<List<dynamic>>.notStarted().obs;

  final searchPlayersController = TextEditingController();
  final searchChallengersController = TextEditingController();

  var filteredPlayers = <Map<String, dynamic>>[].obs;
  var filteredChallengers = <Map<String, dynamic>>[].obs;

  final _challengingPlayers = <String, bool>{}.obs;
  final _respondingInvitations = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    filteredChallengers.value = [];
    searchPlayersController.addListener(_filterPlayers);
    fetchPlayersExceptCurrentUser();
    fetchInvitations();
  }

  bool isChallengingPlayer(String playerId) {
    return _challengingPlayers[playerId] == true;
  }

  bool isRespondingToInvitation(String invitationId) {
    return _respondingInvitations[invitationId] == true;
  }

  String? _getCurrentUserId() {
    String? userId = _storageRepo.getUserId();
    if (userId != null && userId.isNotEmpty) {
      if (kDebugMode) print("✅ Got user ID from StorageRepository: $userId");
      return userId;
    }

    userId = SharedPrefs.getUserId();
    if (userId != null && userId.isNotEmpty) {
      if (kDebugMode) print("✅ Got user ID from SharedPrefs: $userId");
      return userId;
    }

    if (kDebugMode) print("❌ No user ID found in any storage");
    return null;
  }

  Future<void> fetchInvitations() async {
    try {
      invitationResponse.value = ApiResponse.loading();

      final userId = _getCurrentUserId();

      if (userId == null || userId.isEmpty) {
        throw Exception('User not logged in. Please login again.');
      }

      if (kDebugMode) print("Fetching invitations for user: $userId");

      final invitations = await _invitationRepository.getPlayerInvitations(userId);

      if (kDebugMode) print("Received invitations data: $invitations");

      final challengers = _parseInvitationsToChallengers(invitations, userId);

      if (kDebugMode) print("Parsed ${challengers.length} challengers");

      filteredChallengers.value = challengers;
      invitationResponse.value = ApiResponse.completed(invitations);

    } catch (e) {
      if (kDebugMode) print("Error fetching invitations: $e");
      invitationResponse.value = ApiResponse.error(e.toString());
    }
  }

  List<Map<String, dynamic>> _parseInvitationsToChallengers(
      List<dynamic> invitations,
      String currentUserId
      ) {
    final List<Map<String, dynamic>> challengers = [];

    for (var invitation in invitations) {
      try {
        if (invitation is! Map<String, dynamic>) continue;

        final challenge = invitation['challenge'];
        if (challenge is! Map<String, dynamic>) continue;

        final hostDetail = challenge['hostDetail'];
        if (hostDetail is! Map<String, dynamic>) continue;

        if (invitation['status'] == 'PENDING') {
          final invitationId = invitation['id'];
          final challengeId = challenge['id'];
          final playerName = hostDetail['name']?.toString() ?? 'Unknown Player';
          final rank = hostDetail['rank'] ?? 1;
          final points = hostDetail['totalPoints'] ?? 0;
          final avatarPicId = hostDetail['avatarPicId']?.toString();

          final recipientId = invitation['playerId']?.toString() ?? currentUserId;

          challengers.add({
            'id': invitationId?.toString() ?? '',
            'challengeId': challengeId?.toString() ?? '',
            'recipientId': recipientId,
            'name': playerName,
            'level': 'Level $rank',
            'avatar': avatarPicId != null && avatarPicId.isNotEmpty
                ? '${ApiConstants.baseUrl}/uploads/$avatarPicId'
                : 'assets/images/solo2.png',
            'points': points,
            'status': 'online',
            'invitationStatus': invitation['status']?.toString() ?? 'PENDING',
            'hostDetail': hostDetail,
          });
        }
      } catch (e) {
        if (kDebugMode) print("Error parsing invitation: $e - $invitation");
      }
    }

    return challengers;
  }

  Future<void> respondToChallenge(String invitationId, bool accept) async {
    if (invitationId.isEmpty || invitationId == 'null') {
      Get.snackbar('Error', 'Invalid invitation ID');
      return;
    }

    try {
      _respondingInvitations[invitationId] = true;
      update();

      final challenger = filteredChallengers.firstWhereOrNull(
              (c) => c['id']?.toString() == invitationId
      );

      if (challenger == null) {
        throw Exception('Invitation not found');
      }

      final recipientId = challenger['recipientId']?.toString();

      if (recipientId == null || recipientId.isEmpty) {
        throw Exception('Invalid recipient ID in invitation');
      }

      if (kDebugMode) {
        print("🎯 Responding to invitation:");
        print("  - Invitation ID: $invitationId");
        print("  - Recipient ID: $recipientId");
        print("  - Accept: $accept");
      }

      final invitationIdInt = int.tryParse(invitationId);
      if (invitationIdInt == null) {
        throw Exception('Invalid invitation ID format: $invitationId');
      }

      final response = await _invitationRepository.respondToChallenge(
          invitationIdInt,
          recipientId,
          accept
      );

      if (kDebugMode) print("Response received: $response");

      filteredChallengers.value = filteredChallengers.where(
              (challenger) => challenger['id'] != invitationId
      ).toList();

      if (accept) {
        Get.snackbar(
          'Success!',
          'Challenge accepted!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        try {
          final acceptedChallengeId = response['challengeId']?.toString();
          if (acceptedChallengeId != null) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('acceptInviteChallengeId', acceptedChallengeId);
            print('✅ Saved acceptInviteChallengeId: $acceptedChallengeId');
          }
        } catch (e) {
          print('⚠️ Error saving acceptInviteChallengeId: $e');
        }

        Future.delayed(Duration(milliseconds: 500), () {
          Get.to(() => ChallengeDetailsScreen());
        });
      } else {
        Get.snackbar(
          'Declined',
          'Challenge declined',
          duration: Duration(seconds: 4),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }

    } catch (e) {
      if (kDebugMode) print("Error responding to challenge: $e");
      Get.snackbar(
        'Error',
        'Failed to respond to challenge: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 4),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _respondingInvitations[invitationId] = false;
      update();
    }
  }

  void _filterPlayers() {
    final query = searchPlayersController.text.toLowerCase();
    if (query.isEmpty) {
      return;
    }
    final filtered = filteredPlayers.where((player) =>
    (player['name']?.toString().toLowerCase() ?? '').contains(query) ||
        (player['subtitle']?.toString().toLowerCase() ?? '').contains(query) ||
        (player['level']?.toString().toLowerCase() ?? '').contains(query)
    ).toList();
    filteredPlayers.value = filtered;
  }

  void clearPlayerSearch() {
    searchPlayersController.clear();
    fetchPlayersExceptCurrentUser();
  }

  void clearChallengerSearch() {
    searchChallengersController.clear();
  }

  void copyInviteCode() {
    if (inviteCode.value.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: inviteCode.value));
      Get.snackbar(
        'Copied!',
        'Invite code copied to clipboard',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
      );
    }
  }

  // ✅ FIXED: Create challenge with proper host ID tracking
  Future<void> createChallenge() async {
    try {
      inviteCodeResponse.value = ApiResponse.loading();

      final hostId = _storageRepo.getUserId();

      if (hostId == null || hostId.isEmpty) {
        if (kDebugMode) print("❌ User ID not found in storage");

        inviteCodeResponse.value = ApiResponse.error('User not logged in');

        Get.snackbar(
          'Authentication Required',
          'Please log in to create challenges',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      if (kDebugMode) print("✅ Creating challenge for host: $hostId");

      final challengeData = await _repository.createChallenge(hostId);

      final code = challengeData['code']?.toString() ?? '';
      final challengeId = challengeData['id']?.toString() ?? '';

      if (code.isEmpty || challengeId.isEmpty) {
        throw Exception('Invalid response from server: missing code or challengeId');
      }

      final prefs = await SharedPreferences.getInstance();

      // ✅ CRITICAL: Save the host ID
      await prefs.setString('challengeId', challengeId);
      await prefs.setString('challenge_host_id', hostId);

      if (kDebugMode) print("✅ Saved challengeId: $challengeId");
      if (kDebugMode) print("✅ Saved host ID: $hostId");

      inviteCode.value = code;
      inviteCodeResponse.value = ApiResponse.completed(code);

      Get.snackbar(
        'Success!',
        'Challenge created with code: $code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
      );
    } catch (e) {
      if (kDebugMode) print("❌ Error creating challenge: $e");
      inviteCodeResponse.value = ApiResponse.error(e.toString());
      Get.snackbar(
        'Error',
        'Failed to create challenge: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
      );
    }
  }

  Future<void> fetchPlayersExceptCurrentUser() async {
    try {
      final userId = _getCurrentUserId();

      if (userId == null || userId.isEmpty) {
        if (kDebugMode) print("User ID not found in any storage");
        Get.snackbar('Error', 'User ID not found. Please log in again.');
        return;
      }

      final url = '${ApiConstants.baseUrl}/auth/users-except/$userId';
      if (kDebugMode) print("Fetching players from: $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Map<String, dynamic>> players = [];

        for (var user in data) {
          try {
            final playerId = user['id']?.toString() ?? '';
            final playerName = user['name']?.toString() ?? 'Unknown Player';

            if (playerId.isEmpty) continue;

            players.add({
              'id': playerId,
              'name': playerName,
              'avatar': user['avatarPicId'] != null && user['avatarPicId'].toString().isNotEmpty
                  ? '${ApiConstants.baseUrl}/uploads/${user['avatarPicId']}'
                  : 'assets/images/default_avatar.png',
              'status': 'Online',
              'subtitle': 'Available to challenge',
              'level': 'Level ${user['rank'] ?? 1}',
              'rank': user['rank']?.toString() ?? '1',
              'points': user['totalPoints'] ?? 0,
            });
          } catch (e) {
            if (kDebugMode) print("Error parsing user data: $e - $user");
          }
        }

        filteredPlayers.value = players;
        if (kDebugMode) print("✅ Loaded ${players.length} players");
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) print("Error fetching players: $e");
      Get.snackbar(
        'Error',
        'Failed to load players: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> sendChallengeInvite(String playerId) async {
    if (playerId.isEmpty || playerId == 'null') {
      Get.snackbar('Error', 'Invalid player ID');
      return;
    }

    try {
      _challengingPlayers[playerId] = true;
      update();

      final prefs = await SharedPreferences.getInstance();
      final challengeIdStr = prefs.getString('challengeId');

      if (challengeIdStr == null) {
        throw Exception('No active challenge found. Please create a challenge first.');
      }

      final challengeId = int.tryParse(challengeIdStr);
      if (challengeId == null) {
        throw Exception('Invalid challenge ID format: $challengeIdStr');
      }

      if (kDebugMode) print("🎯 Sending invite for challenge ID: $challengeId to player: $playerId");

      final currentUserId = _getCurrentUserId();
      if (currentUserId == null) {
        throw Exception('User not authenticated');
      }

      final result = await _sendInviteRepository.sendInvites(challengeId, [playerId]);

      Get.snackbar(
        'Invite Sent!',
        'Challenge invitation sent successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      if (kDebugMode) print("✅ Invite response: $result");

      await fetchInvitations();

      String recipientName = 'Player';
      try {
        final matchedPlayer = filteredPlayers.firstWhere(
          (player) => player['id'] == playerId,
        );
        recipientName = matchedPlayer['name']?.toString() ??
            matchedPlayer['displayName']?.toString() ??
            recipientName;
      } catch (_) {}

      final hostName = _storageRepo.getUser()?.name ?? 'Player';
      await _notificationService.sendChallengeInvitation(
        hostName: hostName,
        recipientName: recipientName,
        recipientUserId: playerId,
        isReceived: true,
      );

    } catch (e) {
      if (kDebugMode) print("❌ Error sending invite: $e");
      Get.snackbar(
        'Error',
        'Failed to send challenge invite: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 4),
      );
    } finally {
      _challengingPlayers[playerId] = false;
      update();
    }
  }

  Future<void> refreshData() async {
    await fetchPlayersExceptCurrentUser();
    await fetchInvitations();
  }

  @override
  void onClose() {
    searchPlayersController.dispose();
    searchChallengersController.dispose();
    super.onClose();
  }
}

// ============================================
// FILE 2: challenge_details_screen.dart
// ============================================

// Add this import at the top:
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// Replace the _ChallengeDetailsScreenState class with this:


// The rest of the ChallengeDetailsScreen remains the same...
// import '../../services/shared_preference.dart';
//
// class ChallengeCreateViewModel extends GetxController {
//   final ChallengeRepository _repository = ChallengeRepository();
//   final ChallengeAcceptInvitationRepository _invitationRepository = ChallengeAcceptInvitationRepository();
//   final ChallengeSendInviteRepository _sendInviteRepository = ChallengeSendInviteRepository();
//   final StorageRepository _storageRepo = Get.find<StorageRepository>();
//
//   final isChallengeCreated = false.obs;
//   var inviteCode = ''.obs;
//   var inviteCodeResponse = ApiResponse<String>.notStarted().obs;
//   var invitationResponse = ApiResponse<List<dynamic>>.notStarted().obs;
//
//   final searchPlayersController = TextEditingController();
//   final searchChallengersController = TextEditingController();
//
//   var filteredPlayers = <Map<String, dynamic>>[].obs;
//   var filteredChallengers = <Map<String, dynamic>>[].obs;
//
//   final _challengingPlayers = <String, bool>{}.obs;
//   final _respondingInvitations = <String, bool>{}.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     filteredChallengers.value = [];
//     searchPlayersController.addListener(_filterPlayers);
//     fetchPlayersExceptCurrentUser();
//     fetchInvitations();
//   }
//
//   bool isChallengingPlayer(String playerId) {
//     return _challengingPlayers[playerId] == true;
//   }
//
//   bool isRespondingToInvitation(String invitationId) {
//     return _respondingInvitations[invitationId] == true;
//   }
//
//   // ✅ FIXED: Get current user ID with proper fallback chain
//   String? _getCurrentUserId() {
//     // Try StorageRepository first (most reliable)
//     String? userId = _storageRepo.getUserId();
//
//     if (userId != null && userId.isNotEmpty) {
//       if (kDebugMode) print("✅ Got user ID from StorageRepository: $userId");
//       return userId;
//     }
//
//     // Fallback to SharedPrefs
//     userId = SharedPrefs.getUserId();
//     if (userId != null && userId.isNotEmpty) {
//       if (kDebugMode) print("✅ Got user ID from SharedPrefs: $userId");
//       return userId;
//     }
//
//     if (kDebugMode) print("❌ No user ID found in any storage");
//     return null;
//   }
//
//   Future<void> fetchInvitations() async {
//     try {
//       invitationResponse.value = ApiResponse.loading();
//
//       // ✅ FIXED: Use unified user ID getter
//       final userId = _getCurrentUserId();
//
//       if (userId == null || userId.isEmpty) {
//         throw Exception('User not logged in. Please login again.');
//       }
//
//       if (kDebugMode) print("Fetching invitations for user: $userId");
//
//       final invitations = await _invitationRepository.getPlayerInvitations(userId);
//
//       if (kDebugMode) print("Received invitations data: $invitations");
//
//       final challengers = _parseInvitationsToChallengers(invitations, userId);
//
//       if (kDebugMode) print("Parsed ${challengers.length} challengers");
//
//       filteredChallengers.value = challengers;
//       invitationResponse.value = ApiResponse.completed(invitations);
//
//     } catch (e) {
//       if (kDebugMode) print("Error fetching invitations: $e");
//       invitationResponse.value = ApiResponse.error(e.toString());
//     }
//   }
//
//   // ✅ FIXED: Pass currentUserId to properly identify recipient
//   List<Map<String, dynamic>> _parseInvitationsToChallengers(
//       List<dynamic> invitations,
//       String currentUserId
//       ) {
//     final List<Map<String, dynamic>> challengers = [];
//
//     for (var invitation in invitations) {
//       try {
//         if (invitation is! Map<String, dynamic>) continue;
//
//         final challenge = invitation['challenge'];
//         if (challenge is! Map<String, dynamic>) continue;
//
//         final hostDetail = challenge['hostDetail'];
//         if (hostDetail is! Map<String, dynamic>) continue;
//
//         // Only show PENDING invitations
//         if (invitation['status'] == 'PENDING') {
//           final invitationId = invitation['id'];
//           final challengeId = challenge['id'];
//           final playerName = hostDetail['name']?.toString() ?? 'Unknown Player';
//           final rank = hostDetail['rank'] ?? 1;
//           final points = hostDetail['totalPoints'] ?? 0;
//           final avatarPicId = hostDetail['avatarPicId']?.toString();
//
//           // ✅ FIXED: Get recipient ID from invitation
//           final recipientId = invitation['playerId']?.toString() ?? currentUserId;
//
//           challengers.add({
//             'id': invitationId?.toString() ?? '',
//             'challengeId': challengeId?.toString() ?? '',
//             'recipientId': recipientId, // ✅ CRITICAL: Save recipient ID
//             'name': playerName,
//             'level': 'Level $rank',
//             'avatar': avatarPicId != null && avatarPicId.isNotEmpty
//                 ? '${ApiConstants.baseUrl}/uploads/$avatarPicId'
//                 : 'assets/images/solo2.png',
//             'points': points,
//             'status': 'online',
//             'invitationStatus': invitation['status']?.toString() ?? 'PENDING',
//             'hostDetail': hostDetail,
//           });
//         }
//       } catch (e) {
//         if (kDebugMode) print("Error parsing invitation: $e - $invitation");
//       }
//     }
//
//     return challengers;
//   }
//
//   // ✅ FIXED: Use recipientId from invitation data
//   Future<void> respondToChallenge(String invitationId, bool accept) async {
//     if (invitationId.isEmpty || invitationId == 'null') {
//       Get.snackbar('Error', 'Invalid invitation ID');
//       return;
//     }
//
//     try {
//       _respondingInvitations[invitationId] = true;
//       update();
//
//       // ✅ FIXED: Find the challenger to get correct recipientId
//       final challenger = filteredChallengers.firstWhereOrNull(
//               (c) => c['id']?.toString() == invitationId
//       );
//
//       if (challenger == null) {
//         throw Exception('Invitation not found');
//       }
//
//       // ✅ FIXED: Use recipientId from invitation data, NOT current user ID
//       final recipientId = challenger['recipientId']?.toString();
//
//       if (recipientId == null || recipientId.isEmpty) {
//         throw Exception('Invalid recipient ID in invitation');
//       }
//
//       if (kDebugMode) {
//         print("🎯 Responding to invitation:");
//         print("  - Invitation ID: $invitationId");
//         print("  - Recipient ID: $recipientId");
//         print("  - Accept: $accept");
//       }
//
//       final invitationIdInt = int.tryParse(invitationId);
//       if (invitationIdInt == null) {
//         throw Exception('Invalid invitation ID format: $invitationId');
//       }
//
//       final response = await _invitationRepository.respondToChallenge(
//           invitationIdInt,
//           recipientId, // ✅ FIXED: Use correct recipient ID
//           accept
//       );
//
//       if (kDebugMode) print("Response received: $response");
//
//       // Remove the challenger from the list
//       filteredChallengers.value = filteredChallengers.where(
//               (challenger) => challenger['id'] != invitationId
//       ).toList();
//
//       if (accept) {
//         Get.snackbar(
//           'Success!',
//           'Challenge accepted!',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
//
//         // Save accepted challenge ID
//         try {
//           final acceptedChallengeId = response['challengeId']?.toString();
//           if (acceptedChallengeId != null) {
//             final prefs = await SharedPreferences.getInstance();
//             await prefs.setString('acceptInviteChallengeId', acceptedChallengeId);
//             print('✅ Saved acceptInviteChallengeId: $acceptedChallengeId');
//           }
//         } catch (e) {
//           print('⚠️ Error saving acceptInviteChallengeId: $e');
//         }
//
//         Future.delayed(Duration(milliseconds: 500), () {
//           Get.to(() => ChallengeDetailsScreen());
//         });
//       } else {
//         Get.snackbar(
//           'Declined',
//           'Challenge declined',
//           duration: Duration(seconds: 4),
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.orange,
//           colorText: Colors.white,
//         );
//       }
//
//     } catch (e) {
//       if (kDebugMode) print("Error responding to challenge: $e");
//       Get.snackbar(
//         'Error',
//         'Failed to respond to challenge: ${e.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//         duration: Duration(seconds: 4),
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     } finally {
//       _respondingInvitations[invitationId] = false;
//       update();
//     }
//   }
//
//   void _filterPlayers() {
//     final query = searchPlayersController.text.toLowerCase();
//     if (query.isEmpty) {
//       return;
//     }
//     final filtered = filteredPlayers.where((player) =>
//     (player['name']?.toString().toLowerCase() ?? '').contains(query) ||
//         (player['subtitle']?.toString().toLowerCase() ?? '').contains(query) ||
//         (player['level']?.toString().toLowerCase() ?? '').contains(query)
//     ).toList();
//     filteredPlayers.value = filtered;
//   }
//
//   void clearPlayerSearch() {
//     searchPlayersController.clear();
//     fetchPlayersExceptCurrentUser();
//   }
//
//   void clearChallengerSearch() {
//     searchChallengersController.clear();
//   }
//
//   void copyInviteCode() {
//     if (inviteCode.value.isNotEmpty) {
//       Clipboard.setData(ClipboardData(text: inviteCode.value));
//       Get.snackbar(
//         'Copied!',
//         'Invite code copied to clipboard',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//         duration: Duration(seconds: 4),
//       );
//     }
//   }
//
//   // ✅ FIXED: Create challenge with proper user ID handling
//   // Future<void> createChallenge([String? hostId]) async {
//   //   try {
//   //     inviteCodeResponse.value = ApiResponse.loading();
//   //
//   //     // Use provided hostId or get current user ID
//   //     final finalHostId = hostId ?? _getCurrentUserId();
//   //
//   //     if (finalHostId == null || finalHostId.isEmpty) {
//   //       throw Exception('User not logged in. Please login again.');
//   //     }
//   //
//   //     if (kDebugMode) print("Creating challenge for host: $finalHostId");
//   //
//   //     final challengeData = await _repository.createChallenge(finalHostId);
//   //
//   //     final code = challengeData['code']?.toString() ?? '';
//   //     final challengeId = challengeData['id']?.toString() ?? '';
//   //
//   //     if (code.isEmpty || challengeId.isEmpty) {
//   //       throw Exception('Invalid response from server: missing code or challengeId');
//   //     }
//   //
//   //     final prefs = await SharedPreferences.getInstance();
//   //     await prefs.setString('challengeId', challengeId);
//   //     if (kDebugMode) print("✅ Saved challengeId: $challengeId");
//   //
//   //     inviteCode.value = code;
//   //     inviteCodeResponse.value = ApiResponse.completed(code);
//   //
//   //     Get.snackbar(
//   //       'Success!',
//   //       'Challenge created with code: $code',
//   //       snackPosition: SnackPosition.BOTTOM,
//   //       backgroundColor: Colors.green,
//   //       colorText: Colors.white,
//   //       duration: Duration(seconds: 4),
//   //     );
//   //   } catch (e) {
//   //     if (kDebugMode) print("Error creating challenge: $e");
//   //     inviteCodeResponse.value = ApiResponse.error(e.toString());
//   //     Get.snackbar(
//   //       'Error',
//   //       'Failed to create challenge: ${e.toString()}',
//   //       snackPosition: SnackPosition.BOTTOM,
//   //       backgroundColor: Colors.red,
//   //       colorText: Colors.white,
//   //       duration: Duration(seconds: 4),
//   //     );
//   //   }
//   // }
//   Future<void> createChallenge() async {
//     try {
//       inviteCodeResponse.value = ApiResponse.loading();
//
//       // ✅ FIXED: Get user ID from StorageRepository (works for both email and Google)
//       final hostId = _storageRepo.getUserId();
//
//       if (hostId == null || hostId.isEmpty) {
//         if (kDebugMode) print("❌ User ID not found in storage");
//
//         inviteCodeResponse.value = ApiResponse.error('User not logged in');
//
//         Get.snackbar(
//           'Authentication Required',
//           'Please log in to create challenges',
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.orange,
//           colorText: Colors.white,
//         );
//         return;
//       }
//
//       if (kDebugMode) print("✅ Creating challenge for host: $hostId");
//
//       final challengeData = await _repository.createChallenge(hostId);
//
//       // Extract values with null safety
//       final code = challengeData['code']?.toString() ?? '';
//       final challengeId = challengeData['id']?.toString() ?? '';
//
//       if (code.isEmpty || challengeId.isEmpty) {
//         throw Exception('Invalid response from server: missing code or challengeId');
//       }
//
//       // Save challengeId in SharedPreferences
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('challengeId', challengeId);
//       if (kDebugMode) print("✅ Saved challengeId: $challengeId");
//
//       // Update state
//       inviteCode.value = code;
//       inviteCodeResponse.value = ApiResponse.completed(code);
//
//       Get.snackbar(
//         'Success!',
//         'Challenge created with code: $code',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//         duration: Duration(seconds: 4),
//       );
//     } catch (e) {
//       if (kDebugMode) print("❌ Error creating challenge: $e");
//       inviteCodeResponse.value = ApiResponse.error(e.toString());
//       Get.snackbar(
//         'Error',
//         'Failed to create challenge: ${e.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         duration: Duration(seconds: 4),
//       );
//     }
//   }
//   Future<void> fetchPlayersExceptCurrentUser() async {
//     try {
//       // ✅ FIXED: Use unified user ID getter
//       final userId = _getCurrentUserId();
//
//       if (userId == null || userId.isEmpty) {
//         if (kDebugMode) print("User ID not found in any storage");
//         Get.snackbar('Error', 'User ID not found. Please log in again.');
//         return;
//       }
//
//       final url = '${ApiConstants.baseUrl}/auth/users-except/$userId';
//       if (kDebugMode) print("Fetching players from: $url");
//
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final List<dynamic> data = jsonDecode(response.body);
//         final List<Map<String, dynamic>> players = [];
//
//         for (var user in data) {
//           try {
//             final playerId = user['id']?.toString() ?? '';
//             final playerName = user['name']?.toString() ?? 'Unknown Player';
//
//             if (playerId.isEmpty) continue;
//
//             players.add({
//               'id': playerId,
//               'name': playerName,
//               'avatar': user['avatarPicId'] != null && user['avatarPicId'].toString().isNotEmpty
//                   ? '${ApiConstants.baseUrl}/uploads/${user['avatarPicId']}'
//                   : 'assets/images/default_avatar.png',
//               'status': 'Online',
//               'subtitle': 'Available to challenge',
//               'level': 'Level ${user['rank'] ?? 1}',
//               'rank': user['rank']?.toString() ?? '1',
//               'points': user['totalPoints'] ?? 0,
//             });
//           } catch (e) {
//             if (kDebugMode) print("Error parsing user data: $e - $user");
//           }
//         }
//
//         filteredPlayers.value = players;
//         if (kDebugMode) print("✅ Loaded ${players.length} players");
//       } else {
//         throw Exception('HTTP ${response.statusCode}: ${response.body}');
//       }
//     } catch (e) {
//       if (kDebugMode) print("Error fetching players: $e");
//       Get.snackbar(
//         'Error',
//         'Failed to load players: ${e.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
//
// // Add this method to your existing ChallengeCreateViewModel
//   Future<void> sendChallengeInvite(String playerId) async {
//     if (playerId.isEmpty || playerId == 'null') {
//       Get.snackbar('Error', 'Invalid player ID');
//       return;
//     }
//
//     try {
//       _challengingPlayers[playerId] = true;
//       update();
//
//       final prefs = await SharedPreferences.getInstance();
//       final challengeIdStr = prefs.getString('challengeId');
//
//       if (challengeIdStr == null) {
//         throw Exception('No active challenge found. Please create a challenge first.');
//       }
//
//       final challengeId = int.tryParse(challengeIdStr);
//       if (challengeId == null) {
//         throw Exception('Invalid challenge ID format: $challengeIdStr');
//       }
//
//       if (kDebugMode) print("🎯 Sending invite for challenge ID: $challengeId to player: $playerId");
//
//       // ✅ FIXED: Get the current user ID properly
//       final currentUserId = _getCurrentUserId();
//       if (currentUserId == null) {
//         throw Exception('User not authenticated');
//       }
//
//       // ✅ FIXED: Create proper invitation data
//       final invitationData = {
//         'challengeId': challengeId,
//         'hostId': currentUserId, // The person sending the invite
//         'playerId': playerId,    // The person receiving the invite
//         'status': 'PENDING',
//       };
//
//       final result = await _sendInviteRepository.sendInvites(challengeId, [playerId]);
//
//       Get.snackbar(
//         'Invite Sent!',
//         'Challenge invitation sent successfully!',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//         duration: Duration(seconds: 3),
//       );
//
//       if (kDebugMode) print("✅ Invite response: $result");
//
//       // Refresh invitations to show the sent invite
//       await fetchInvitations();
//
//     } catch (e) {
//       if (kDebugMode) print("❌ Error sending invite: $e");
//       Get.snackbar(
//         'Error',
//         'Failed to send challenge invite: ${e.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         duration: Duration(seconds: 4),
//       );
//     } finally {
//       _challengingPlayers[playerId] = false;
//       update();
//     }
//   }
//   Future<void> refreshData() async {
//     await fetchPlayersExceptCurrentUser();
//     await fetchInvitations();
//   }
//
//   @override
//   void onClose() {
//     searchPlayersController.dispose();
//     searchChallengersController.dispose();
//     super.onClose();
//   }
// }