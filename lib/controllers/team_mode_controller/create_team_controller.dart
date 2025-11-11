// lib/controllers/team_mode_controller/create_team_controller.dart

import 'package:flutter/material.dart';
import 'package:game_app/data/repositories/team_repository.dart';
import 'package:game_app/generated/models/requests/team_mode/join_team.dart';
import 'package:game_app/generated/models/requests/team_mode/edit_team_request.dart';
import 'package:game_app/services/notification_service.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'package:dio/dio.dart';

import '../../presentation/routes/app_routes.dart';
import '../../generated/network.dart';
import '../../generated/models/requests/team_mode/create_team_request.dart';
import '../../generated/models/responses/team_mode/create_team_response.dart';
import '../../data/repositories/storage_repository.dart';
import '../../utils/snackbar_helper.dart'; 
import 'team_lobby_controller.dart'; 


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
static const int maxTeamSize = 5; 

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
      
      // Log request
      log('🔵 JOIN TEAM REQUEST:');
      log('URL: POST /team/join');
      log('REQUEST: ${request.toJson()}');

      // Attempt to join the team
      final response = await _teamRepository.joinTeam(request);
      
      // Log successful response
      log('🟢 JOIN TEAM RESPONSE:');
      log('RESPONSE: ${response.toString()}');

      if (response.id != null) {
        createdTeamId.value = response.id;
        SnackbarHelper.success("Joined existing team: ${response.title ?? 'Team'}!");
        
        // WebSocket Call: POST /ws/join-team
        try {
          await _teamRepository.joinWsTeam(token, userId);
          log('Successfully joined WebSocket team room');
        } catch (wsError) {
          log('WebSocket join failed: $wsError');
          SnackbarHelper.warning("Joined team but WebSocket connection failed. You may not receive real-time updates.");
        }

        // Get team member IDs for notification
        final teamMemberUserIds = response.members?.map((m) => m.userId ?? '').where((id) => id.isNotEmpty && id != userId).toList() ?? [];
        
        // Send team member join notification
        _notificationService.sendTeamMemberUpdate(
          playerName: userName,
          hasJoined: true,
          teamId: response.id!,
          teamMemberUserIds: teamMemberUserIds,
        );

        // Navigate to team lobby and refresh it to show the new member
        Get.toNamed(AppRoutes.teamLobby);
        
        // Refresh the team lobby to show the newly joined member
        // Wait a bit for navigation to complete, then refresh
        Future.delayed(const Duration(milliseconds: 300), () {
          if (Get.isRegistered<TeamLobbyController>()) {
            Get.find<TeamLobbyController>().fetchTeamDetails();
          }
        });
      } else {
        SnackbarHelper.error(response.title ?? "Failed to join team. Invalid token or user ID.");
      }
    } on DioException catch (e) {
      // Log error response
      log('🔴 JOIN TEAM ERROR:');
      log('STATUS CODE: ${e.response?.statusCode}');
      log('ERROR RESPONSE: ${e.response?.data}');
      
      final errorData = e.response?.data;
      final errorMessage = errorData is Map 
          ? (errorData['message']?.toString() ?? '')
          : errorData?.toString() ?? '';
      
      // Check if user is already a member of the team
      if (e.response?.statusCode == 400 && 
          errorMessage.toLowerCase().contains('already a member')) {
        log('ℹ️ User is already a member - handling gracefully');
        SnackbarHelper.info("You are already part of this team.");
        
        // Try to extract team ID from error response
        int? teamId;
        
        // Check if error response contains team info
        if (errorData is Map) {
          // Try various possible keys for team ID
          if (errorData['teamId'] != null) {
            teamId = int.tryParse(errorData['teamId'].toString());
          } else if (errorData['id'] != null) {
            teamId = int.tryParse(errorData['id'].toString());
          } else if (errorData['team'] != null && errorData['team'] is Map) {
            final team = errorData['team'] as Map;
            if (team['id'] != null) {
              teamId = int.tryParse(team['id'].toString());
            } else if (team['teamId'] != null) {
              teamId = int.tryParse(team['teamId'].toString());
            }
          }
        }
        
        // If we got a team ID, use it and navigate
        if (teamId != null) {
          createdTeamId.value = teamId;
          log('✅ Extracted team ID from error response: $teamId');
          Get.toNamed(AppRoutes.teamLobby);
        } else {
          // Try to get team details by attempting the join again or using token
          // Since user is already a member, we'll try to fetch their team memberships
          // For now, if no teamId in error, we'll still navigate and let lobby handle it
          // The lobby controller will need teamId, so we need to find another way
          log('⚠️ Could not extract team ID from error response');
          log('⚠️ Attempting to get team details using existing user team memberships...');
          
          // Note: If the API doesn't provide teamId in error response,
          // we might need an additional endpoint to get team by token/userId
          // For now, we'll show the info message but note that navigation requires teamId
          SnackbarHelper.warning("Unable to navigate automatically. Please use your existing team from the lobby.");
        }
      } 
      // Handle team full error
      else if (e.response?.statusCode == 400 && 
               (errorMessage.toLowerCase().contains('team is full') || 
                errorMessage.toLowerCase().contains('full'))) {
        SnackbarHelper.error("Team is already full (Max $maxTeamSize players allowed).");
      }
      // Handle other errors
      else {
        final displayMessage = errorMessage.isNotEmpty 
            ? errorMessage 
            : "Network error or invalid team data.";
        SnackbarHelper.error(displayMessage);
      }
    } catch (e) {
      log('🔴 JOIN TEAM UNEXPECTED ERROR: $e');
      log('ERROR TYPE: ${e.runtimeType}');
      
      // Catch specific server error if the server implements max size validation
      if (e.toString().contains('Team is full')) { 
         SnackbarHelper.error("Team is already full (Max $maxTeamSize players allowed).");
      } else {
         SnackbarHelper.error("Network error or invalid team data.");
      }
    } finally {
      isJoiningTeam.value = false;
    }
  }
  /// --- Helper to fetch team details (Used to pre-fill edit screen) ---
  void loadTeamDetailsForEdit(int teamId) async {
      try {
        final response = await _teamRepository.getTeamDetails(teamId);
        if (response.id != null) {
            teamNameController.text = response.title ?? '';
            teamMissionController.text = response.mission ?? '';
            selectedAvatarIndex.value = int.tryParse(response.teamavatorid ?? '-1') ?? -1;
            // The createdTeamId should already be set from the lobby navigation
        }
      } catch (e) {
        log('Error loading team details for edit: $e');
        SnackbarHelper.error('Failed to load team details for editing.');
      }
  }
  
  /// --- Dedicated Edit Method ---
  Future<void> _performEdit(int teamId) async {
     try {
        isCreatingTeam.value = true; // Reusing this flag for 'isSaving' state
        
        final request = EditTeamRequest(
          title: teamNameController.text.trim(),
          mission: teamMissionController.text.trim(),
          teamavatorid: selectedAvatarIndex.value >= 0 ? selectedAvatarIndex.value.toString() : "0",
        );
        
        // 1. Call API
        final updatedTeam = await _teamRepository.editTeam(teamId, request);
        
        // 2. Update local controllers with new data from API response
        teamNameController.text = updatedTeam.title ?? '';
        teamMissionController.text = updatedTeam.mission ?? '';
        selectedAvatarIndex.value = int.tryParse(updatedTeam.teamavatorid ?? '-1') ?? -1;
        
        SnackbarHelper.success("Team updated successfully!");
        
        // 3. Manually trigger TeamLobbyController refresh if it's visible
        if(Get.isRegistered<TeamLobbyController>()) {
            Get.find<TeamLobbyController>().fetchTeamDetails();
        }
        
        // 4. Navigate back to Lobby, replacing the edit screen
        Get.offNamed(AppRoutes.teamLobby);

    } catch (e) {
        SnackbarHelper.error("Failed to update team: ${e.toString()}");
        log('Edit team error: $e');
    } finally {
        isCreatingTeam.value = false;
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

        // Navigate to lobby, replacing the create screen
        Get.offNamed(AppRoutes.teamLobby);
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

  /// Handles dispatching to Create or Edit logic based on flag
  void continueCreateTeam({required bool isEditing}) {
    if (teamNameController.text.trim().isEmpty) {
      SnackbarHelper.warning("Please enter a team name");
      return;
    }
    // Check if an avatar has been explicitly selected
    if (selectedAvatarIndex.value == -1) { 
      SnackbarHelper.warning("Please choose a team avatar");
      return;
    }

    if (isEditing) {
        final teamId = createdTeamId.value;
        if (teamId != null) {
            _performEdit(teamId);
        } else {
            SnackbarHelper.error("Cannot edit: Team ID is missing.");
        }
    } else {
        createTeam();
    }
  }

  

  @override
  void onClose() {
    teamNameController.dispose();
    teamMissionController.dispose();
    teamCodeController.dispose();
    super.onClose();
  }
}