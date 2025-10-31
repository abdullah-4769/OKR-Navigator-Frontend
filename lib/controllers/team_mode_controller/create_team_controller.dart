
// lib/controllers/team_mode_controller/create_team_controller.dart

import 'package:flutter/material.dart';
import 'package:game_app/generated/models/requests/team_mode/join_team.dart';
import 'package:game_app/services/notification_service.dart';
import 'package:get/get.dart';
import 'dart:developer';
import '../../data/repositories/team_repository.dart';
import '../../presentation/routes/app_routes.dart';
import '../../generated/network.dart';
import '../../generated/models/requests/team_mode/create_team_request.dart';
import '../../generated/models/responses/team_mode/create_team_response.dart';
import '../../data/repositories/storage_repository.dart';
import '../../utils/snackbar_helper.dart';

class CreateTeamController extends GetxController {
  final teamNameController = TextEditingController();
  final teamMissionController = TextEditingController();
  final teamCodeController = TextEditingController();
  var selectedAvatarIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    selectedAvatarIndex.value = -1;
  }

  void selectAvatar(int index) {
    selectedAvatarIndex.value = index;
  }

  var isCreatingTeam = false.obs;
  var isJoiningTeam = false.obs;

  var createdTeamId = Rxn<int>();

  final TeamRepository _teamRepository = Get.find<TeamRepository>();
  final StorageRepository _storageRepository = Get.find<StorageRepository>();
  final FirebaseNotificationService _notificationService = Get.find<FirebaseNotificationService>();

  final avatars = <String>[
    'assets/images/role_icon.png',
    'assets/images/role_icon2.png',
    'assets/images/role_icon.png',
    'assets/images/role_icon2.png',
  ].obs;

  Future<void> joinTeam() async {
    final token = teamCodeController.text.trim();
    final user = _storageRepository.getUser();
    final userId = user?.id;
    final userName = user?.name ?? 'A new player';

    if (token.isEmpty) {
      SnackbarHelper.warning("Please enter a team code or token.");
      return;
    }
    if (userId == null) {
      SnackbarHelper.error("User not logged in. Please sign in again.");
      return;
    }

    try {
      isJoiningTeam.value = true;
      final request = JoinTeamRequest(token: token, userId: userId);

      final response = await _teamRepository.joinTeam(request);

      if (response.id != null) {
        createdTeamId.value = response.id;
        SnackbarHelper.success("Joined existing team: ${response.title ?? 'Team'}!");

        try {
          await _teamRepository.joinWsTeam(token, userId);
          log('Successfully joined WebSocket team room');
        } catch (wsError) {
          log('WebSocket join failed: $wsError');
          SnackbarHelper.warning("Joined team but WebSocket connection failed. You may not receive real-time updates.");
        }

        _notificationService.sendTeamNotification(
          teamId: response.id!,
          title: "Team Update",
          body: "$userName has joined the team.",
          notificationType: 'TEAM_JOIN',
        );

        Get.toNamed(AppRoutes.teamLobby);
      } else {
        SnackbarHelper.error(response.title ?? "Failed to join team. Invalid token or user ID.");
      }
    } catch (e) {
      log('Join team error: $e');
      SnackbarHelper.error("Network error or invalid team data.");
    } finally {
      isJoiningTeam.value = false;
    }
  }


  Future<void> createTeam() async {
    try {
      isCreatingTeam.value = true;

      final user = _storageRepository.getUser();
      final hostId = user?.id;
      final hostName = user?.name ?? 'The Host';

      if (hostId == null) {
        SnackbarHelper.error("User not found. Please login again.");
        return;
      }

      final request = CreateTeamRequest(
        title: teamNameController.text.trim(),
        mission: teamMissionController.text.trim(),
        hostId: hostId,
        teamavatorid: selectedAvatarIndex.value >= 0 ? selectedAvatarIndex.value.toString() : "0",
      );

      final response = await dio.post(
        '/team/create',
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final createTeamResponse = CreateTeamResponse.fromJson(response.data);
        final teamId = createTeamResponse.team?.id;

        createdTeamId.value = teamId;
        SnackbarHelper.success("Team created successfully!");

        if (teamId != null) {
          _notificationService.sendTeamNotification(
            teamId: teamId,
            title: "Team Roster Updated",
            body: "$hostName created the team: ${teamNameController.text.trim()}. Check the updated team list.",
            notificationType: 'TEAM_CREATED',
          );
        }

        Get.toNamed(AppRoutes.teamLobby);
      } else {
        SnackbarHelper.error(response.data['message'] ?? "Failed to create team. Please try again.");
      }
    } catch (e) {
      SnackbarHelper.error("Network error. Please check your connection.");
      log('Create team error: $e');
    } finally {
      isCreatingTeam.value = false;
    }
  }

  // FIXED: Block team creation if no avatar is selected
  void continueCreateTeam() {
    if (teamNameController.text.trim().isEmpty) {
      SnackbarHelper.warning("Please enter a team name");
      return;
    }
    // Check if an avatar has been explicitly selected
    if (selectedAvatarIndex.value == -1) {
      SnackbarHelper.warning("Please choose a team avatar");
      return;
    }

    createTeam();
  }



  @override
  void onClose() {
    teamNameController.dispose();
    teamMissionController.dispose();
    teamCodeController.dispose();
    super.onClose();
  }
}
// import 'package:flutter/material.dart';
// import 'package:game_app/generated/models/requests/team_mode/join_team.dart';
// import 'package:game_app/services/notification_service.dart';
// import 'package:get/get.dart';
// import 'dart:developer';
//
// import '../../data/repositories/team_repository.dart';
// import '../../presentation/routes/app_routes.dart';
// import '../../generated/network.dart';
// import '../../generated/models/requests/team_mode/create_team_request.dart';
// import '../../generated/models/responses/team_mode/create_team_response.dart';
// import '../../data/repositories/storage_repository.dart';
// import '../../utils/snackbar_helper.dart';
//
// class CreateTeamController extends GetxController {
//   final teamNameController = TextEditingController();
//   final teamMissionController = TextEditingController();
//   final teamCodeController = TextEditingController();
//   var selectedAvatarIndex = (-1).obs; // Keep -1 for "no selection"
//
//   @override
//   void onInit() {
//     super.onInit();
//     selectedAvatarIndex.value = -1;
//   }
//
//   void selectAvatar(int index) {
//     selectedAvatarIndex.value = index;
//   }
//   // Loading states - separate for create and join operations
//   var isCreatingTeam = false.obs;
//   var isJoiningTeam = false.obs;
//
//   // Store created team ID
//   var createdTeamId = Rxn<int>();
//
//   // Injected Repositories and Services
//   final TeamRepository _teamRepository = Get.find<TeamRepository>();
//   final StorageRepository _storageRepository = Get.find<StorageRepository>();
//   final FirebaseNotificationService _notificationService = Get.find<FirebaseNotificationService>(); // ✅ SERVICE INJECTED
//
// // For now static local images (replace with your assets)
//   final avatars = <String>[
//     'assets/images/role_icon.png',
//     'assets/images/role_icon2.png',
//     'assets/images/role_icon.png',
//     'assets/images/role_icon2.png',
//   ].obs;
//
//
//
//   // ------------------------------------------------
//   // ✅ 1. JOIN TEAM (API INTEGRATION + WS JOIN) - MODIFIED
//   // ------------------------------------------------
//   Future<void> joinTeam() async {
//     final token = teamCodeController.text.trim();
//     final user = _storageRepository.getUser();
//     final userId = user?.id;
//     final userName = user?.name ?? 'A new player'; // Get player name
//
//     if (token.isEmpty) {
//       SnackbarHelper.warning("Please enter a team code or token.");
//       return;
//     }
//     if (userId == null) {
//       SnackbarHelper.error("User not logged in. Please sign in again.");
//       return;
//     }
//
//     try {
//       isJoiningTeam.value = true;
//       final request = JoinTeamRequest(token: token, userId: userId);
//
//       // 1. Call repository method to join team (API /team/join)
//       final response = await _teamRepository.joinTeam(request);
//
//       if (response.id != null) {
//         createdTeamId.value = response.id;
//         SnackbarHelper.success("Joined existing team: ${response.title ?? 'Team'}!");
//
//         // 2. Call WS Join API to join the WebSocket room - NEW WS CALL
//         try {
//           await _teamRepository.joinWsTeam(token, userId);
//           log('Successfully joined WebSocket team room');
//         } catch (wsError) {
//           log('WebSocket join failed: $wsError');
//           // Don't fail the entire operation if WS join fails
//           SnackbarHelper.warning("Joined team but WebSocket connection failed. You may not receive real-time updates.");
//         }
//
//         // 3. Send Notification about team join
//         _notificationService.sendTeamNotification(
//           teamId: response.id!,
//           title: "Team Update",
//           body: "$userName has joined the team.",
//           notificationType: 'TEAM_JOIN',
//         );
//
//         Get.toNamed(AppRoutes.teamLobby);
//       } else {
//         SnackbarHelper.error(response.title ?? "Failed to join team. Invalid token or user ID.");
//       }
//     } catch (e) {
//       log('Join team error: $e');
//       SnackbarHelper.error("Network error or invalid team data.");
//     } finally {
//       isJoiningTeam.value = false;
//     }
//   }
//
//
//   // ------------------------------------------------
//   // ✅ 2. CREATE TEAM (API INTEGRATION + Notification for Team Created/Roster Update)
//   // ------------------------------------------------
//   Future<void> createTeam() async {
//     try {
//       isCreatingTeam.value = true;
//
//       final user = _storageRepository.getUser();
//       final hostId = user?.id;
//       final hostName = user?.name ?? 'The Host'; // Get host name
//
//       if (hostId == null) {
//         SnackbarHelper.error("User not found. Please login again.");
//         return;
//       }
//
//       final request = CreateTeamRequest(
//         title: teamNameController.text.trim(),
//         mission: teamMissionController.text.trim(),
//         hostId: hostId,
//         teamavatorid: selectedAvatarIndex.value >= 0 ? selectedAvatarIndex.value.toString() : "0",
//       );
//
//       // Direct Dio call remains correct for this controller's logic flow
//       final response = await dio.post(
//         '/team/create',
//         data: request.toJson(),
//       );
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final createTeamResponse = CreateTeamResponse.fromJson(response.data);
//         final teamId = createTeamResponse.team?.id;
//
//         createdTeamId.value = teamId;
//         SnackbarHelper.success("Team created successfully!");
//
//         // 🔔 NOTIFICATION: Team Roster Updated / Host Update
//         if (teamId != null) {
//              _notificationService.sendTeamNotification(
//                 teamId: teamId,
//                 title: "Team Roster Updated",
//                 body: "$hostName created the team: ${teamNameController.text.trim()}. Check the updated team list.",
//                 notificationType: 'TEAM_CREATED',
//             );
//         }
//
//         Get.toNamed(AppRoutes.teamLobby);
//       } else {
//         SnackbarHelper.error(response.data['message'] ?? "Failed to create team. Please try again.");
//       }
//     } catch (e) {
//       SnackbarHelper.error("Network error. Please check your connection.");
//       log('Create team error: $e');
//     } finally {
//       isCreatingTeam.value = false;
//     }
//   }
//
//   void continueCreateTeam() {
//     if (teamNameController.text.trim().isEmpty) {
//       SnackbarHelper.warning("Please enter a team name");
//       return;
//     }
//     if (selectedAvatarIndex.value == -1) {
//       SnackbarHelper.warning("Please choose a team avatar");
//       return;
//     }
//
//     createTeam();
//   }
//
//
//
//   @override
//   void onClose() {
//     teamNameController.dispose();
//     teamMissionController.dispose();
//     teamCodeController.dispose();
//     super.onClose();
//   }
// }