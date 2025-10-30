// lib/controllers/team_mode_controller/team_lobby_controller.dart

import 'dart:developer';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:get/get.dart';
import '../../../generated/models/responses/team_mode/team_lobby_response.dart';

import '../../../data/repositories/strategy_repository.dart';
import '../../../data/repositories/storage_repository.dart';
import '../../../services/notification_service.dart';
import '../../../utils/snackbar_helper.dart';
import '../../data/repositories/team_repository.dart';
import 'create_team_controller.dart';

class TeamLobbyController extends GetxController {
  var players = <String>[].obs;
  var isLoading = false.obs;
  var isInvitingMember = false.obs;
  var teamData = Rxn<TeamLobbyResponse>();
  var errorMessage = ''.obs;

  var memberScores = <Map<String, dynamic>>[].obs;

  final TeamRepository _teamRepository = Get.find<TeamRepository>();
  final StrategyRepository _strategyRepository = Get.find<StrategyRepository>();
  final StorageRepository _storageRepository = Get.find<StorageRepository>();
  final FirebaseNotificationService _notificationService = Get.find<FirebaseNotificationService>();

  @override
  void onInit() {
    super.onInit();
    // Clear initial data to ensure the count starts correctly
    players.clear();
    memberScores.clear();
    _loadLobbyData();
  }

  Future<void> _loadLobbyData() async {
    await fetchTeamDetails();
    fetchMemberScores();
  }

  // ------------------------------------------------
  // 1. GET TEAM DETAILS (API INTEGRATION)
  // ------------------------------------------------
  Future<void> fetchTeamDetails() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final createTeamController = Get.find<CreateTeamController>();
      final teamId = createTeamController.createdTeamId.value;

      if (teamId == null) {
        errorMessage.value = 'No team ID found. Please create a team first.';
        SnackbarHelper.error('No team ID found.');
        return;
      }

      final teamLobbyResponse = await _teamRepository.getTeamDetails(teamId);
      teamData.value = teamLobbyResponse;

      if (teamLobbyResponse.members != null) {
        players.assignAll(teamLobbyResponse.members!.map((member) => member.user?.name ?? 'Unknown').toList());
        log('Lobby: Players list populated with ${players.length} members.');
      } else {
        players.clear();
        log('Lobby: Players list cleared (0 members).');
      }

    } catch (e) {
      errorMessage.value = 'Failed to load team details: ${e.toString()}';
      SnackbarHelper.error('Failed to load team details.');
      print('Error fetching team details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------------------------------------
  // 2. FETCH MEMBER SCORES (API INTEGRATION)
  // ------------------------------------------------
  Future<void> fetchMemberScores() async {
    final teamId = teamData.value?.id;

    if (teamId == null || teamData.value?.members == null) {
      log('Scores: Skipping fetch. Team data or members not available.');
      return;
    }

    try {
      final List<Map<String, dynamic>> scores = [];

      for (final member in teamData.value!.members!) {
        try {
          final userScoreData = await _strategyRepository.getUserFinalScoreInTeam(teamId, member.userId!);

          scores.add({
            'userId': member.userId,
            'name': member.user?.name ?? 'Unknown',
            'role': member.role ?? 'Player',
            'level': (userScoreData['level'] as num? ?? 1).toInt(),
            'points': (userScoreData['points'] as num? ?? 0).toInt(),
            'score': (userScoreData['score'] as num? ?? 0).toInt(),
            'badge': userScoreData['badge']?.toString() ?? '',
            'trophy': userScoreData['trophy']?.toString() ?? '',
            'title': userScoreData['title']?.toString() ?? '',
          });
        } catch (e) {
          scores.add({
            'userId': member.userId,
            'name': member.user?.name ?? 'Unknown',
            'role': member.role ?? 'Player',
            'level': 1,
            'points': 0,
            'score': 0,
            'badge': '',
            'trophy': '',
            'title': '',
          });
        }
      }

      memberScores.assignAll(scores);

    } catch (e) {
      print('Error fetching member scores: $e');
    }
  }

  void beginMission() {
    _sendTeamGameStartedNotification();

    Get.toNamed(AppRoutes.assignRoleScreen);
  }

  void _sendTeamGameStartedNotification() {
    final createTeamController = Get.find<CreateTeamController>();
    final teamId = createTeamController.createdTeamId.value;

    if (teamId != null && teamData.value?.members != null) {
      final teamMemberUserIds = teamData.value!.members!
          .map((member) => member.userId!)
          .toList();

      _notificationService.sendTeamGameStarted(
        teamId: teamId,
        teamMemberUserIds: teamMemberUserIds,
      );
    }
  }

  Future<String?> inviteMembers() async {
    final teamToken = teamData.value?.token;

    if (teamToken == null) {
      SnackbarHelper.error("Error: Team Code missing.");
      return null;
    }

    try {
      isInvitingMember.value = true;

      try {
        await _teamRepository.sendWsInvite(teamToken);
        print('WebSocket invite sent successfully');
        _sendTeamInvitationNotification(teamToken);

      } catch (wsError) {
        print('WebSocket invite failed: $wsError');
        SnackbarHelper.warning("Team code generated but invite notification failed. You can still share the code manually.");
      }

      SnackbarHelper.success("Invite sent! Share the team code.");

      return teamToken;

    } catch (e) {
      SnackbarHelper.error("Failed to send invite: ${e.toString()}");
      print('Error sending invite: $e');
      return null;
    } finally {
      isInvitingMember.value = false;
    }
  }

  void _sendTeamInvitationNotification(String teamToken) {
    final createTeamController = Get.find<CreateTeamController>();
    final teamId = createTeamController.createdTeamId.value;
    final hostName = _storageRepository.getUser()?.name ?? 'Team Host';

    if (teamId != null) {
      _notificationService.sendTeamInvitation(
        hostName: hostName,
        recipientUserId: 'recipient_user_id',
        teamId: teamId,
        autoJoin: false,
      );
    }
  }
}

//
// import 'package:game_app/presentation/routes/app_routes.dart';
// import 'package:get/get.dart';
// import '../../../generated/models/responses/team_mode/team_lobby_response.dart';
//
// import '../../../data/repositories/strategy_repository.dart';
// import '../../../data/repositories/storage_repository.dart';
// import '../../../services/notification_service.dart';
// import '../../../utils/snackbar_helper.dart'; // ✅ NEW IMPORT
// import '../../data/repositories/team_repository.dart';
// import 'create_team_controller.dart';
//
// class TeamLobbyController extends GetxController {
//   var players = <String>[].obs;
//   var isLoading = false.obs;
//   var isInvitingMember = false.obs;
//   var teamData = Rxn<TeamLobbyResponse>();
//   var errorMessage = ''.obs;
//
//   // Member data with scores
//   var memberScores = <Map<String, dynamic>>[].obs;
//
//   final TeamRepository _teamRepository = Get.find<TeamRepository>();
//   final StrategyRepository _strategyRepository = Get.find<StrategyRepository>();
//   final StorageRepository _storageRepository = Get.find<StorageRepository>();
//   final FirebaseNotificationService _notificationService = Get.find<FirebaseNotificationService>();
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchTeamDetails(); // ✅ Screen load hote hi details fetch karein
//     fetchMemberScores(); // ✅ Also fetch member scores
//   }
//
//   // ------------------------------------------------
//   // ✅ 1. GET TEAM DETAILS (API INTEGRATION)
//   // ------------------------------------------------
//   Future<void> fetchTeamDetails() async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//
//       final createTeamController = Get.find<CreateTeamController>();
//       // createdTeamId pichli screen (CreateTeam) se set hota hai
//       final teamId = createTeamController.createdTeamId.value;
//
//       if (teamId == null) {
//         errorMessage.value = 'No team ID found. Please create a team first.';
//         SnackbarHelper.error('No team ID found.');
//         return;
//       }
//
//       // Call repository method: GET /team/{id}/details
//       final teamLobbyResponse = await _teamRepository.getTeamDetails(teamId);
//       teamData.value = teamLobbyResponse;
//
//       if (teamLobbyResponse.members != null) {
//         // UI ke liye players list update karein
//         players.assignAll(teamLobbyResponse.members!.map((member) => member.user?.name ?? 'Unknown').toList());
//       } else {
//         players.clear();
//       }
//
//       SnackbarHelper.success('Team Lobby details loaded!');
//
//     } catch (e) {
//       errorMessage.value = 'Failed to load team details: ${e.toString()}';
//       SnackbarHelper.error('Failed to load team details.');
//       print('Error fetching team details: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // ------------------------------------------------
//   // ✅ FETCH MEMBER SCORES (API INTEGRATION)
//   // ------------------------------------------------
//   Future<void> fetchMemberScores() async {
//     try {
//       final createTeamController = Get.find<CreateTeamController>();
//       final teamId = createTeamController.createdTeamId.value;
//
//       if (teamId == null || teamData.value?.members == null) {
//         return;
//       }
//
//       final List<Map<String, dynamic>> scores = [];
//
//       // Fetch individual scores for each member
//       for (final member in teamData.value!.members!) {
//         try {
//           // API Call: GET /final-team-score/{teamId}/user/{userId}/score
//           final userScoreData = await _strategyRepository.getUserFinalScoreInTeam(teamId, member.userId!);
//
//           scores.add({
//             'userId': member.userId,
//             'name': member.user?.name ?? 'Unknown',
//             'role': member.role ?? 'Player',
//             'level': (userScoreData['level'] as num? ?? 1).toInt(),
//             'points': (userScoreData['points'] as num? ?? 0).toInt(),
//             'score': (userScoreData['score'] as num? ?? 0).toInt(),
//             'badge': userScoreData['badge']?.toString() ?? '',
//             'trophy': userScoreData['trophy']?.toString() ?? '',
//             'title': userScoreData['title']?.toString() ?? '',
//           });
//         } catch (e) {
//           // If individual score fetch fails, use default values
//           scores.add({
//             'userId': member.userId,
//             'name': member.user?.name ?? 'Unknown',
//             'role': member.role ?? 'Player',
//             'level': 1,
//             'points': 0,
//             'score': 0,
//             'badge': '',
//             'trophy': '',
//             'title': '',
//           });
//         }
//       }
//
//       memberScores.assignAll(scores);
//
//     } catch (e) {
//       print('Error fetching member scores: $e');
//       // Don't show error to user as this is supplementary data
//     }
//   }
//
//   void beginMission() {
//     // Validation check: Minimum 2 players
//     // if (players.length < 2) {
//     //   SnackbarHelper.warning("Minimum 2 players required to start the mission.");
//     //   return;
//     // }
//
//     // Send team game started notification
//     _sendTeamGameStartedNotification();
//
//     Get.toNamed(AppRoutes.assignRoleScreen);
//   }
//
//   /// Send team game started notification to all team members
//   void _sendTeamGameStartedNotification() {
//     final createTeamController = Get.find<CreateTeamController>();
//     final teamId = createTeamController.createdTeamId.value;
//
//     if (teamId != null && teamData.value?.members != null) {
//       final teamMemberUserIds = teamData.value!.members!
//           .map((member) => member.userId!)
//           .toList();
//
//       _notificationService.sendTeamGameStarted(
//         teamId: teamId,
//         teamMemberUserIds: teamMemberUserIds,
//       );
//     }
//   }
//
//   // ------------------------------------------------
//   // ✅ 2. INVITE MEMBERS (WS INVITE INTEGRATION) - MODIFIED
//   // ------------------------------------------------
//   Future<String?> inviteMembers() async {
//     final teamToken = teamData.value?.token;
//
//     if (teamToken == null) {
//       SnackbarHelper.error("Error: Team Code missing.");
//       return null;
//     }
//
//     try {
//       isInvitingMember.value = true;
//
//       // 1. Call WS Invite API to notify potential members
//       try {
//         await _teamRepository.sendWsInvite(teamToken);
//         print('WebSocket invite sent successfully');
//
//         // Send team invitation notification
//         _sendTeamInvitationNotification(teamToken);
//
//       } catch (wsError) {
//         print('WebSocket invite failed: $wsError');
//         // Don't fail the entire operation if WS invite fails
//         SnackbarHelper.warning("Team code generated but invite notification failed. You can still share the code manually.");
//       }
//
//       SnackbarHelper.success("Invite sent! Share the team code.");
//
//       // 2. Return the token for the UI to display/copy
//       return teamToken;
//
//     } catch (e) {
//       SnackbarHelper.error("Failed to send invite: ${e.toString()}");
//       print('Error sending invite: $e');
//       return null;
//     } finally {
//       isInvitingMember.value = false;
//     }
//   }
//
//   /// Send team invitation notification
//   void _sendTeamInvitationNotification(String teamToken) {
//     final createTeamController = Get.find<CreateTeamController>();
//     final teamId = createTeamController.createdTeamId.value;
//     final hostName = _storageRepository.getUser()?.name ?? 'Team Host';
//
//     if (teamId != null) {
//       // Note: In a real implementation, you would get the recipient user ID
//       // from the invitation process or team token lookup
//       // For now, this is a placeholder for the notification system
//       _notificationService.sendTeamInvitation(
//         hostName: hostName,
//         recipientUserId: 'recipient_user_id', // Replace with actual recipient ID
//         teamId: teamId,
//         autoJoin: false,
//       );
//     }
//   }
// }