import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../presentation/routes/app_routes.dart';

class CreateTeamController extends GetxController {
  final teamNameController = TextEditingController();
  final teamMissionController = TextEditingController();
  final teamCodeController = TextEditingController();


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

  void continueCreateTeam() {
    if (teamNameController.text.trim().isEmpty) {
      Get.snackbar("Error".tr, "Please enter a team name".tr);
      return;
    }


    Get.toNamed(AppRoutes.teamLobby);
  }

  @override
  void onClose() {
    teamNameController.dispose();
    teamMissionController.dispose();
    teamCodeController.dispose();
    super.onClose();
  }
}
