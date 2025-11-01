// lib/controllers/team_mode_controller/assign_roles_controller.dart

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
 
  // 💡 NEW: Store host ID
  final Rxn<String> hostUserId = Rxn<String>(); // Reactive host user ID
  
  // 💡 NEW: Define all assignable roles (matching the dropdown list in the UI)
  static const List<String> allAssignableRoles = [
    'CEO', 
    'Strategist', 
    'HR Manager', 
    'Analyst', 
    'Team Lead', 
    'Manager',
  ];

 final TeamRepository _teamRepository = Get.find<TeamRepository>();
 final StorageRepository _storageRepository = Get.find<StorageRepository>();
 final FirebaseNotificationService _notificationService = Get.find<FirebaseNotificationService>();

 @override
 void onInit() {
  super.onInit();
    // Initialize hostUserId from storage
    hostUserId.value = _storageRepository.getUser()?.id;
  fetchTeamMembers(); 
 }

  // 💡 NEW: Getter for all roles currently assigned to ANY member
  Set<String> get assignedRoles {
    // Only consider roles that are part of the 'allAssignableRoles' list and are not null
    return members
        .map((m) => m.role)
        .where((role) => role != null && allAssignableRoles.contains(role!))
        .toSet()
        .cast<String>();
  }

  // 💡 NEW: Getter for roles available for selection (Requirement 2 & 3)
  // It returns roles that are not yet assigned to any other member.
  List<String> getAvailableRoles(String? memberId) {
      final available = List<String>.from(allAssignableRoles);
      final assigned = assignedRoles;
      
      // Find the current role of the member being viewed
      final currentMemberRole = members
          .firstWhereOrNull((m) => m.userId == memberId)?.role;
      
      // If the current member has a role assigned, temporarily remove it from the 
      // 'assigned' set so that they can re-select it or change it.
      if (currentMemberRole != null) {
          assigned.remove(currentMemberRole);
      }
      
      // Remove all roles assigned to others from the available list
      available.removeWhere((role) => assigned.contains(role));

      // Ensure the member's current role (if any) is included as an option.
      if (currentMemberRole != null && !available.contains(currentMemberRole)) {
           available.add(currentMemberRole);
      }

      // Sort alphabetically for consistent display
      available.sort();

      return available;
  }
  
 Future<void> fetchTeamMembers() async {
// ... (omitted fetchTeamMembers implementation - unchanged)
  try {
   isLoading.value = true;
   errorMessage.value = '';
   
   // Get team ID from create team controller
   final createTeamController = Get.find<CreateTeamController>();
   final teamId = createTeamController.createdTeamId.value;
   
   if (teamId == null) {
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
    // 💡 NEW: Self-assignment check (Requirement 1)
    if (userId == hostUserId.value) {
      SnackbarHelper.warning("The host cannot assign a new role to themselves.");
      return;
    }

    // 💡 NEW: Role uniqueness check (Requirement 2 & 3 - implemented here as an API call guard)
    // Check if the selected role is already assigned to another user
    final isAlreadyAssignedToOther = members.any((m) => m.role == role && m.userId != userId);
    
    if (isAlreadyAssignedToOther) {
        SnackbarHelper.warning("Role '$role' is already assigned to another team member.");
        return;
    }

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
     members.refresh(); // Refresh to update the UI and the 'assignedRoles' getter
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
// ... (setRoleForGame remains unchanged)
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