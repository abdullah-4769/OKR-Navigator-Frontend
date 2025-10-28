import 'package:flutter/material.dart';
import 'package:game_app/data/repositories/team_repo.dart';
import 'package:game_app/generated/models/requests/team_mode/set_team_role_for_game_request.dart';
import 'package:game_app/generated/models/responses/team_mode/set_team_role_for_game_response.dart';
import 'package:game_app/services/notification_service.dart';
import 'package:game_app/utils/snackbar_helper.dart';
import 'package:get/get.dart';
import '../../../generated/network.dart';
import '../../../generated/models/responses/team_mode/assign_roles_response.dart/assign_roles_response.dart';
import '../../../generated/models/requests/team_mode/update_team_member_request.dart';
import '../../../generated/models/responses/team_mode/update_team_member_response.dart';
import '../../../data/repositories/storage_repository.dart';
import 'create_team_controller.dart';

class AssignRolesController extends GetxController {
  var isLoading = false.obs;
  var isUpdatingRole = false.obs;
  var isAutoUpdatingRole =false.obs;
  var members = <AssignRoleResponse>[].obs;
  var errorMessage = ''.obs;
  
  final TeamRepository _teamRepository = Get.find<TeamRepository>(); // ✅ Inject Repository
  final StorageRepository _storageRepository = Get.find<StorageRepository>(); // ✅ Inject Storage
  final FirebaseNotificationService _notificationService = Get.find<FirebaseNotificationService>(); // ✅ INJECT SERVICE

  @override
  void onInit() {
    super.onInit();
    fetchTeamMembers(); 
  }
// ... (fetchTeamMembers remains unchanged) ...
  Future<void> fetchTeamMembers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Get team ID from create team controller
      final createTeamController = Get.find<CreateTeamController>();
      final teamId = createTeamController.createdTeamId.value;
      
      if (teamId == null) {
      //   errorMessage.value = 'No team ID found. Please create a team first.';
      //   SnackbarHelper.error('Cannot load members: Team ID missing.');
        return;
      }
      
      final membersList = await _teamRepository.getTeamMembers(teamId);
      members.assignAll(membersList);
      
    } catch (e) {
      errorMessage.value = 'Failed to load team members: ${e.toString()}';
      SnackbarHelper.error('Failed to load team members.');
      print('Error fetching team members: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  // ------------------------------------------------
  // ✅ 1. ASSIGN ROLE (Manual Role Change)
  // ------------------------------------------------
  Future<void> assignRole(String userId, String role) async {
    final createTeamController = Get.find<CreateTeamController>();
    final teamId = createTeamController.createdTeamId.value;
    final user = _storageRepository.getUser();
    final hostId = user?.id;

    if (teamId == null || hostId == null) {
      SnackbarHelper.error("Missing game context.");
      return;
    }
    
    try {
      isUpdatingRole.value = true;
      
      final request = UpdateTeamMemberRequest(
        hostId: hostId,
        userId: userId,
        role: role,
      );
      
      final response = await dio.post('/team/$teamId/update-role', data: request.toJson());
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final updateResponse = UpdateTeamMemberResponse.fromJson(response.data);
        
        // Update local list
        final memberIndex = members.indexWhere((member) => member.userId == userId);
        if (memberIndex != -1) {
          members[memberIndex].role = updateResponse.role;
          members.refresh();
        }
        
        SnackbarHelper.success("Role updated successfully!");
        
        // 🔔 NOTIFICATION: Role Assigned
        _notificationService.sendTeamNotification(
          teamId: teamId,
          title: "Role Assigned",
          body: "You have been assigned the role: $role.",
          recipientUserId: userId, // Send only to the affected user
          notificationType: 'ROLE_ASSIGNED',
        );

      } else {
        Get.snackbar("Error", "Failed to update role. Please try again.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update role: ${e.toString()}");
      print('Error updating role: $e');
    } finally {
      isUpdatingRole.value = false;
    }
  }


  // ------------------------------------------------
  // ✅ 2. SET ROLE FOR GAME (Simulates Game Start / Auto Assign)
  // ------------------------------------------------
  Future<void> setRoleForGame() async {
    final createTeamController = Get.find<CreateTeamController>();
    final teamId = createTeamController.createdTeamId.value;
    final user = _storageRepository.getUser();
    final hostId = user?.id;

    if (teamId == null || hostId == null) {
      SnackbarHelper.error("Missing game context.");
      return;
    }
    
    try {
      isAutoUpdatingRole.value = true;
      
      // Request auto-assignment (or Host role setting)
      final request = SetTeamRoleForGameRequest(teamId: teamId,role: 'HOST');
      
      final response = await dio.post('/game/set-role', data: request.toJson());
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assume API successfully assigned roles to all members and returned success
        
        SnackbarHelper.success("Roles auto-assigned! Game starting...");
        
        // 🔔 NOTIFICATION: Game Start (Send to all members)
        _notificationService.sendTeamNotification(
            teamId: teamId,
            title: "Team Game Started",
            body: "Your team game has started. Good luck, team!",
            notificationType: 'GAME_START',
        );
        
      } else {
        Get.snackbar("Error", "Failed to auto-assign roles. Please try again.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to auto-assign roles: ${e.toString()}");
      print('Error updating role: $e');
    } finally {
      isAutoUpdatingRole.value = false;
    }
  }
}