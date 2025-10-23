import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../presentation/routes/app_routes.dart';
import '../../generated/network.dart';
import '../../generated/models/requests/team_mode/create_team_request.dart';
import '../../generated/models/responses/team_mode/create_team_response.dart';
import '../../data/repositories/storage_repository.dart';

class CreateTeamController extends GetxController {
  final teamNameController = TextEditingController();
  final teamMissionController = TextEditingController();
  final teamCodeController = TextEditingController();
  
  // Loading state
  var isLoading = false.obs;
  
  // Store created team ID
  var createdTeamId = Rxn<int>();


// For now static local images (replace with your assets)
  final avatars = <String>[
    'assets/images/role_icon.png',
    'assets/images/role_icon2.png',
    'assets/images/role_icon.png',
    'assets/images/role_icon2.png',
  ].obs;

  var selectedAvatarIndex = (-1).obs;

  void selectAvatar(int index) {
    selectedAvatarIndex.value = index;
  }


  void joinTeam() {
    if (teamCodeController.text.trim().isEmpty) return;
    // TODO: handle join team logic
    Get.snackbar("Success".tr, "Joined existing team!".tr);
  }

  Future<void> createTeam() async {
    try {
      isLoading.value = true;
      
      // Get user ID from storage
      final storageRepository = Get.find<StorageRepository>();
      final user = storageRepository.getUser();
      final hostId = user?.id;
      
      if (hostId == null) {
        Get.snackbar("Error".tr, "User not found. Please login again.".tr);
        return;
      }
      
      // Create request object
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
        createdTeamId.value = createTeamResponse.team?.id;
        Get.snackbar("Success".tr, "Team created successfully!".tr);
        Get.toNamed(AppRoutes.teamLobby);
      } else {
        Get.snackbar("Error".tr, "Failed to create team. Please try again.".tr);
      }
    } catch (e) {
      Get.snackbar("Error".tr, "Network error. Please check your connection.".tr);
      print('Create team error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void continueCreateTeam() {
    if (teamNameController.text.trim().isEmpty) {
      Get.snackbar("Error".tr, "Please enter a team name".tr);
      return;
    }

    // Call the API method
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
