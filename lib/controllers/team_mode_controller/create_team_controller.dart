import 'package:flutter/material.dart';

import 'package:game_app/generated/models/requests/team_mode/join_team.dart';
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
  var selectedAvatarIndex = (-1).obs; // Keep -1 for "no selection"

  @override
  void onInit() {
    super.onInit();
    selectedAvatarIndex.value = -1; 
  }
  
  void selectAvatar(int index) {
    selectedAvatarIndex.value = index;
  }
  // Loading state
  var isLoading = false.obs;
  
  // Store created team ID
  var createdTeamId = Rxn<int>();

  // Injected Repositories
  final TeamRepository _teamRepository = Get.find<TeamRepository>(); // ✅ NEW
  final StorageRepository _storageRepository = Get.find<StorageRepository>(); // ✅ NEW

// For now static local images (replace with your assets)
  final avatars = <String>[
    'assets/images/role_icon.png',
    'assets/images/role_icon2.png',
    'assets/images/role_icon.png',
    'assets/images/role_icon2.png',
  ].obs;

 

  // ------------------------------------------------
  // ✅ 1. JOIN TEAM (API INTEGRATION)
  // ------------------------------------------------
  Future<void> joinTeam() async {
    final token = teamCodeController.text.trim();
    final userId = _storageRepository.getUser()?.id;

    if (token.isEmpty) {
      SnackbarHelper.warning("Please enter a team code or token.");
      return;
    }
    if (userId == null) {
      SnackbarHelper.error("User not logged in. Please sign in again.");
      return;
    }

    try {
      isLoading.value = true;
      final request = JoinTeamRequest(token: token, userId: userId);
      
      // Call repository method to join team
      final response = await _teamRepository.joinTeam(request);

      if (response.id != null) {
        createdTeamId.value = response.id;
        SnackbarHelper.success("Joined existing team: ${response.title ?? 'Team'}!");
        Get.toNamed(AppRoutes.teamLobby);
      } else {
        SnackbarHelper.error(response.title ?? "Failed to join team. Invalid token or user ID.");
      }
    } catch (e) {
      log('Join team error: $e');
      SnackbarHelper.error("Network error or invalid team data.");
    } finally {
      isLoading.value = false;
    }
  }


  // ------------------------------------------------
  // ✅ 2. CREATE TEAM (API INTEGRATION CHECK - Logic is correct)
  // ------------------------------------------------
  Future<void> createTeam() async {
    try {
      isLoading.value = true;
      
      final user = _storageRepository.getUser();
      final hostId = user?.id;
      
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
      
      // Direct Dio call remains correct for this controller's logic flow
      final response = await dio.post(
        '/team/create',
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final createTeamResponse = CreateTeamResponse.fromJson(response.data);
        createdTeamId.value = createTeamResponse.team?.id;
        SnackbarHelper.success("Team created successfully!");
        Get.toNamed(AppRoutes.teamLobby);
      } else {
        SnackbarHelper.error(response.data['message'] ?? "Failed to create team. Please try again.");
      }
    } catch (e) {
      SnackbarHelper.error("Network error. Please check your connection.");
      log('Create team error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void continueCreateTeam() {
    if (teamNameController.text.trim().isEmpty) {
      SnackbarHelper.warning("Please enter a team name");
      return;
    }
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