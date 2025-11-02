// lib/view_model/challange_view_models/challange_create_view_model.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api_constants.dart';
import '../../data/response/api_response.dart';
import '../../presentation/views/challange_mode/challange_detail_screen.dart';
import '../../repository/challange_repositories/challange_create_repository.dart';
import '../../repository/challange_repositories/challenge_accept_invitation_repository.dart';
import '../../repository/challange_repositories/challenge_send__invite_repostory.dart';
import '../../services/shared_preference.dart';

class ChallengeCreateViewModel extends GetxController {
  final ChallengeRepository _repository = ChallengeRepository();
  final ChallengeAcceptInvitationRepository _invitationRepository = ChallengeAcceptInvitationRepository();
  final isChallengeCreated = false.obs;

  // Reactive invite code
  var inviteCode = ''.obs;

  // API response state - FIXED: Changed from invitationResponse to invitationResponse
  var inviteCodeResponse = ApiResponse<String>.notStarted().obs;
  var invitationResponse = ApiResponse<List<dynamic>>.notStarted().obs; // FIXED: Correct variable name

  // Search controllers
  final searchPlayersController = TextEditingController();
  final searchChallengersController = TextEditingController();
  final ChallengeSendInviteRepository _sendInviteRepository = ChallengeSendInviteRepository();

  // Reactive filtered lists
  var filteredPlayers = <Map<String, dynamic>>[].obs;
  var filteredChallengers = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    filteredChallengers.value = [];

    // Listen to search text changes
    searchPlayersController.addListener(_filterPlayers);

    fetchPlayersExceptCurrentUser(); // ✅ Load players from API
    fetchInvitations(); // ✅ Load invitations
  }

  // Fetch invitations from API
  Future<void> fetchInvitations() async {
    try {
      invitationResponse.value = ApiResponse.loading();

      // Get user ID from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId') ?? 'f1f9313d-becf-4bec-a605-1c304bbb9b87'; // fallback for testing

      if (kDebugMode) print("Fetching invitations for user: $userId");

      final invitations = await _invitationRepository.getPlayerInvitations(userId);

      if (kDebugMode) print("Received invitations data: $invitations");

      // Parse invitations into challengers format
      final challengers = _parseInvitationsToChallengers(invitations);

      if (kDebugMode) print("Parsed ${challengers.length} challengers");

      filteredChallengers.value = challengers;
      invitationResponse.value = ApiResponse.completed(invitations);

    } catch (e) {
      if (kDebugMode) print("Error fetching invitations: $e");
      invitationResponse.value = ApiResponse.error(e.toString());
      Get.snackbar(
        'Error',
        'Failed to load challengers: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Parse API response to challengers format - FIXED: Store both id and challengeId
  List<Map<String, dynamic>> _parseInvitationsToChallengers(List<dynamic> invitations) {
    final List<Map<String, dynamic>> challengers = [];

    for (var invitation in invitations) {
      try {
        final challenge = invitation['challenge'];
        final hostDetail = challenge['hostDetail'];

        // Only show PENDING invitations
        if (invitation['status'] == 'PENDING') {
          challengers.add({
            'id': invitation['id'], // FIXED: This is the invitation ID for the API
            'challengeId': challenge['id'], // Keep challengeId if needed for display
            'name': hostDetail['name'] ?? 'Unknown Player',
            'level': 'Level ${hostDetail['rank'] ?? '1'}',
            'avatar': hostDetail['avatarPicId'] != null
                ? '${ApiConstants.baseUrl}/uploads/${hostDetail['avatarPicId']}'
                : 'assets/images/solo2.png',
            'points': hostDetail['totalPoints'] ?? 0,
            'status': 'online',
            'invitationStatus': invitation['status'],
          });
        }
      } catch (e) {
        if (kDebugMode) print("Error parsing invitation: $e");
      }
    }

    return challengers;
  }

  // Respond to challenge invitation
  Future<void> respondToChallenge(int invitationId, bool accept) async {
    try {
      // Get user ID from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final playerId = prefs.getString('userId') ?? 'ceb0147f-273b-425e-a1f8-07e8f0dee9f2';

      if (kDebugMode) print("Responding to invitation $invitationId with accept: $accept");

      final response = await _invitationRepository.respondToChallenge(
          invitationId, // FIXED: Use invitationId, not challengeId
          playerId,
          accept
      );

      if (kDebugMode) print("Response received: $response");

      // Remove the challenger from the list using invitationId
      filteredChallengers.value = filteredChallengers.where(
              (challenger) => challenger['id'] != invitationId // FIXED: Use 'id' (invitationId)
      ).toList();

      if (accept) {
        Get.snackbar(
          'Success!',
          'Challenge accepted!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // ✅ Save accepted challenge ID
        try {
          final prefs = await SharedPreferences.getInstance();
          final acceptedChallengeId = response['challengeId']?.toString();
          if (acceptedChallengeId != null) {
            await prefs.setString('acceptInviteChallengeId', acceptedChallengeId);
            print('✅ Saved acceptInviteChallengeId: $acceptedChallengeId');
          } else {
            print('⚠️ No challengeId found in accept response');
          }
        } catch (e) {
          print('⚠️ Error saving acceptInviteChallengeId: $e');
        }

        // Navigate to challenge details screen
        Get.to(() => ChallengeDetailsScreen());
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
    }
  }

  void _filterPlayers() {
    final query = searchPlayersController.text.toLowerCase();
    if (query.isEmpty) {
      // Keep whatever was fetched from API
      return;
    }
    final filtered = filteredPlayers.where((player) =>
    player['name'].toLowerCase().contains(query) ||
        player['subtitle'].toLowerCase().contains(query) ||
        player['level'].toLowerCase().contains(query)).toList();
    filteredPlayers.value = filtered;
  }

  void clearPlayerSearch() {
    searchPlayersController.clear();
    fetchPlayersExceptCurrentUser(); // re-fetch players from API instead of mock data
  }

  void clearChallengerSearch() {
    searchChallengersController.clear();
    // Don't reset challengers as they come from API
  }

  // Copy invite code to clipboard
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

  Future<void> createChallenge(String hostId) async {
    try {
      inviteCodeResponse.value = ApiResponse.loading();
      if (kDebugMode) print("Creating challenge for host: $hostId");

      final challengeData = await _repository.createChallenge(hostId);

      // ✅ Extract values
      final code = challengeData['code'];
      final challengeId = challengeData['id'].toString();

      // ✅ Save challengeId in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('challengeId', challengeId);
      if (kDebugMode) print("Saved challengeId: $challengeId");

      // ✅ Update state
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
      if (kDebugMode) print("Error creating challenge: $e");
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

  // for the challngewr whom
  Future<void> fetchPlayersExceptCurrentUser() async {
    try {
      final userId = SharedPrefs.getUserId();
      if (userId == null) {
        Get.snackbar('Error', 'User ID not found');
        return;
      }

      final url = '${ApiConstants.baseUrl}/auth/users-except/$userId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Map<String, dynamic>> players = data.map((e) {
          return {
            'id': e['id'],
            'name': e['name'] ?? 'Unknown',
            'avatar': e['avatarPicId'] != null
                ? '${ApiConstants.baseUrl}/uploads/${e['avatarPicId']}'
                : 'assets/images/default_avatar.png', // ✅ default image fallback
            'status': 'Offline', // placeholder
            'subtitle': 'Available to challenge',
            'level': 'Level 1',
            'rank': '',
          };
        }).toList();

        filteredPlayers.value = players;
      } else {
        Get.snackbar('Error', 'Failed to fetch players');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching players');
    }
  }

  // Send challenge invite to selected player
  Future<void> sendChallengeInvite(String playerId) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // FIX: Get challengeId as String and parse to int
      final challengeIdStr = prefs.getString('challengeId');
      if (challengeIdStr == null) {
        Get.snackbar('Error', 'No active challenge found.');
        return;
      }

      // Parse to int
      final challengeId = int.tryParse(challengeIdStr);
      if (challengeId == null) {
        Get.snackbar('Error', 'Invalid challenge ID format.');
        return;
      }

      if (kDebugMode) print("Sending invite for challenge ID: $challengeId to player: $playerId");

      final result = await _sendInviteRepository.sendInvites(challengeId, [playerId]);

      Get.snackbar(
        'Invite Sent!',
        'Invitation sent successfully to the player.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      if (kDebugMode) print("Invite response: $result");
    } catch (e) {
      if (kDebugMode) print("Error sending invite: $e");
      Get.snackbar(
        'Error',
        'Failed to send challenge invite: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    searchPlayersController.dispose();
    searchChallengersController.dispose();
    super.onClose();
  }
}
























// // lib/view_model/challange_view_models/challange_create_view_model.dart
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../data/response/api_response.dart';
// import '../../presentation/views/challange_mode/challange_detail_screen.dart';
// import '../../repository/challange_repositories/challange_create_repository.dart';
// import '../../repository/challange_repositories/challenge_accept_invitation_repository.dart';
// import '../../repository/challange_repositories/challenge_send__invite_repostory.dart';
// import '../../services/shared_preference.dart';
//
//
// class ChallengeViewModel extends GetxController {
//   final ChallengeRepository _repository = ChallengeRepository();
//   final ChallengeAcceptInvitationRepository _invitationRepository = ChallengeAcceptInvitationRepository();
//   final isChallengeCreated = false.obs;
//
//   // Reactive invite code
//   var inviteCode = ''.obs;
//
//   // API response state - FIXED: Changed from invitationResponse to invitationResponse
//   var inviteCodeResponse = ApiResponse<String>.notStarted().obs;
//   var invitationResponse = ApiResponse<List<dynamic>>.notStarted().obs; // FIXED: Correct variable name
//
//   // Search controllers
//   final searchPlayersController = TextEditingController();
//   final searchChallengersController = TextEditingController();
//   final ChallengeSendInviteRepository _sendInviteRepository = ChallengeSendInviteRepository();
//
//   // // Mock data for players
//   // final List<Map<String, dynamic>> _allPlayers = [
//   //   {'rank': '1.', 'name': 'Johnson', 'level': 'Level 5', 'avatar': 'assets/images/solo2.png', 'subtitle': 'Strategist', 'status': 'Online'},
//   //   {'rank': '2.', 'name': 'Tasha', 'level': 'Level 5', 'avatar': 'assets/images/solo11.png', 'subtitle': 'Define Role', 'status': 'Online'},
//   //   {'rank': '3.', 'name': 'Mike', 'level': 'Level 4', 'avatar': 'assets/images/solo2.png', 'subtitle': 'Defender', 'status': 'Offline'},
//   //   {'rank': '4.', 'name': 'Sarah', 'level': 'Level 6', 'avatar': 'assets/images/solo11.png', 'subtitle': 'Attacker', 'status': 'Online'},
//   // ];
//
//   // Reactive filtered lists
//   var filteredPlayers = <Map<String, dynamic>>[].obs;
//   var filteredChallengers = <Map<String, dynamic>>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Initialize with mock data
//     //filteredPlayers.value = _allPlayers;
//     filteredChallengers.value = [];
//
//     // Listen to search text changes
//     searchPlayersController.addListener(_filterPlayers);
//
//
//     fetchPlayersExceptCurrentUser(); // ✅ Load players from API
//     fetchInvitations(); // ✅ Load invitations
//   }
//
//   // Fetch invitations from API
//   Future<void> fetchInvitations() async {
//     try {
//       invitationResponse.value = ApiResponse.loading();
//
//       // Get user ID from SharedPreferences
//       final prefs = await SharedPreferences.getInstance();
//       final userId = prefs.getString('userId') ?? 'f1f9313d-becf-4bec-a605-1c304bbb9b87'; // fallback for testing
//
//       if (kDebugMode) print("Fetching invitations for user: $userId");
//
//       final invitations = await _invitationRepository.getPlayerInvitations(userId);
//
//       if (kDebugMode) print("Received invitations data: $invitations");
//
//       // Parse invitations into challengers format
//       final challengers = _parseInvitationsToChallengers(invitations);
//
//       if (kDebugMode) print("Parsed ${challengers.length} challengers");
//
//       filteredChallengers.value = challengers;
//       invitationResponse.value = ApiResponse.completed(invitations);
//
//     } catch (e) {
//       if (kDebugMode) print("Error fetching invitations: $e");
//       invitationResponse.value = ApiResponse.error(e.toString());
//       Get.snackbar(
//         'Error',
//         'Failed to load challengers: ${e.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   // Parse API response to challengers format
//   // Parse API response to challengers format - FIXED: Store both id and challengeId
//   List<Map<String, dynamic>> _parseInvitationsToChallengers(List<dynamic> invitations) {
//     final List<Map<String, dynamic>> challengers = [];
//
//     for (var invitation in invitations) {
//       try {
//         final challenge = invitation['challenge'];
//         final hostDetail = challenge['hostDetail'];
//
//         // Only show PENDING invitations
//         if (invitation['status'] == 'PENDING') {
//           challengers.add({
//             'id': invitation['id'], // FIXED: This is the invitation ID for the API
//             'challengeId': challenge['id'], // Keep challengeId if needed for display
//             'name': hostDetail['name'] ?? 'Unknown Player',
//             'level': 'Level ${hostDetail['rank'] ?? '1'}',
//             'avatar': hostDetail['avatarPicId'] != null
//                 ? 'https://example.com/images/${hostDetail['avatarPicId']}'
//                 : 'assets/images/solo2.png',
//             'points': hostDetail['totalPoints'] ?? 0,
//             'status': 'online',
//             'invitationStatus': invitation['status'],
//           });
//         }
//       } catch (e) {
//         if (kDebugMode) print("Error parsing invitation: $e");
//       }
//     }
//
//     return challengers;
//   }
//
//
// // Respond to challenge invitation
//   Future<void> respondToChallenge(int invitationId, bool accept) async {
//     try {
//       // Get user ID from SharedPreferences
//       final prefs = await SharedPreferences.getInstance();
//       final playerId = prefs.getString('userId') ?? 'ceb0147f-273b-425e-a1f8-07e8f0dee9f2';
//
//       if (kDebugMode) print("Responding to invitation $invitationId with accept: $accept");
//
//       final response = await _invitationRepository.respondToChallenge(
//           invitationId, // FIXED: Use invitationId, not challengeId
//           playerId,
//           accept
//       );
//
//       if (kDebugMode) print("Response received: $response");
//
//       // Remove the challenger from the list using invitationId
//       filteredChallengers.value = filteredChallengers.where(
//               (challenger) => challenger['id'] != invitationId // FIXED: Use 'id' (invitationId)
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
//         // ✅ Save accepted challenge ID
//         try {
//           final prefs = await SharedPreferences.getInstance();
//           final acceptedChallengeId = response['challengeId']?.toString();
//           if (acceptedChallengeId != null) {
//             await prefs.setString('acceptInviteChallengeId', acceptedChallengeId);
//             print('✅ Saved acceptInviteChallengeId: $acceptedChallengeId');
//           } else {
//             print('⚠️ No challengeId found in accept response');
//           }
//         } catch (e) {
//           print('⚠️ Error saving acceptInviteChallengeId: $e');
//         }
//
//         // Navigate to challenge details screen
//         Get.to(() => ChallengeDetailsScreen());
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
//     }
//   }
//   void _filterPlayers() {
//     final query = searchPlayersController.text.toLowerCase();
//     if (query.isEmpty) {
//       // Keep whatever was fetched from API
//       return;
//     }
//     final filtered = filteredPlayers.where((player) =>
//     player['name'].toLowerCase().contains(query) ||
//         player['subtitle'].toLowerCase().contains(query) ||
//         player['level'].toLowerCase().contains(query)).toList();
//     filteredPlayers.value = filtered;
//   }
//   void clearPlayerSearch() {
//     searchPlayersController.clear();
//     fetchPlayersExceptCurrentUser(); // re-fetch players from API instead of mock data
//   }
//
//
//   void clearChallengerSearch() {
//     searchChallengersController.clear();
//     // Don't reset challengers as they come from API
//   }
//
//   // Copy invite code to clipboard
//   void copyInviteCode() {
//     if (inviteCode.value.isNotEmpty) {
//       Clipboard.setData(ClipboardData(text: inviteCode.value));
//       Get.snackbar(
//         'Copied!',
//         'Invite code copied to clipboard',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//
//         colorText: Colors.white,
//         duration: Duration(seconds: 4),
//       );
//     }
//   }
//
//
//   Future<void> createChallenge(String hostId) async {
//     try {
//       inviteCodeResponse.value = ApiResponse.loading();
//       if (kDebugMode) print("Creating challenge for host: $hostId");
//
//       final challengeData = await _repository.createChallenge(hostId);
//
//       // ✅ Extract values
//       final code = challengeData['code'];
//       final challengeId = challengeData['id'].toString();
//
//       // ✅ Save challengeId in SharedPreferences
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('challengeId', challengeId);
//       if (kDebugMode) print("Saved challengeId: $challengeId");
//
//       // ✅ Update state
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
//       if (kDebugMode) print("Error creating challenge: $e");
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
//
//   //
//   // // Create challenge and update invite code
//   // Future<void> createChallenge(String hostId) async {
//   //
//   //
//   //   try {
//   //     inviteCodeResponse.value = ApiResponse.loading();
//   //     if (kDebugMode) print("Creating challenge for host: $hostId");
//   //
//   //     final code = await _repository.createChallenge(hostId);
//   //
//   //     if (kDebugMode) print("Received invite code: $code");
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
//   //         'Error',
//   //         'Failed to create challenge: ${e.toString()}',
//   //         snackPosition: SnackPosition.BOTTOM,
//   //         backgroundColor: Colors.red,
//   //         colorText: Colors.white,
//   //         duration: Duration(seconds: 4),
//   //     );
//   //   }
//   // }
//
//
//   // for the challngewr whom
//   Future<void> fetchPlayersExceptCurrentUser() async {
//     try {
//       final userId = SharedPrefs.getUserId();
//       if (userId == null) {
//         Get.snackbar('Error', 'User ID not found');
//         return;
//       }
//
//       final url = 'http://192.168.43.101:3000/auth/users-except/$userId';
//       final response = await http.get(Uri.parse(url));
//
//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         final List<Map<String, dynamic>> players = data.map((e) {
//           return {
//             'id': e['id'],
//             'name': e['name'] ?? 'Unknown',
//             'avatar': e['avatarPicId'] != null
//                 ? 'http://192.168.43.101:3000/uploads/${e['avatarPicId']}'
//                 : 'assets/images/default_avatar.png', // ✅ default image fallback
//             'status': 'Offline', // placeholder
//             'subtitle': 'Available to challenge',
//             'level': 'Level 1',
//             'rank': '',
//           };
//         }).toList();
//
//         filteredPlayers.value = players;
//       } else {
//         Get.snackbar('Error', 'Failed to fetch players');
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'An error occurred while fetching players');
//     }
//   }// Send challenge invite to selected player
//   Future<void> sendChallengeInvite(String playerId) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//
//       // FIX: Get challengeId as String and parse to int
//       final challengeIdStr = prefs.getString('challengeId');
//       if (challengeIdStr == null) {
//         Get.snackbar('Error', 'No active challenge found.');
//         return;
//       }
//
//       // Parse to int
//       final challengeId = int.tryParse(challengeIdStr);
//       if (challengeId == null) {
//         Get.snackbar('Error', 'Invalid challenge ID format.');
//         return;
//       }
//
//       if (kDebugMode) print("Sending invite for challenge ID: $challengeId to player: $playerId");
//
//       final result = await _sendInviteRepository.sendInvites(challengeId, [playerId]);
//
//       Get.snackbar(
//         'Invite Sent!',
//         'Invitation sent successfully to the player.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//
//       if (kDebugMode) print("Invite response: $result");
//     } catch (e) {
//       if (kDebugMode) print("Error sending invite: $e");
//       Get.snackbar(
//         'Error',
//         'Failed to send challenge invite: ${e.toString()}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
//
//
//   @override
//   void onClose() {
//     searchPlayersController.dispose();
//     searchChallengersController.dispose();
//     super.onClose();
//   }
// }