import 'package:flutter/material.dart';
import 'package:game_app/core/app_colors.dart';
import 'package:get/get.dart';

import '../../../controllers/scoreboard_controllers/score_board_controller.dart';

class ModeSelectorWidget extends StatelessWidget {
  const ModeSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScoreboardController>();

    return Container(
      
      margin: EdgeInsets.symmetric(horizontal: 14,vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border
        )
      ),
      padding: const EdgeInsets.all(8.0),
      child: Obx(
            () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildModeButton(
              'Solo'.tr,
              GameMode.solo,
              controller.selectedMode.value == GameMode.solo,
              controller,
            ),
            _buildModeButton(
              'Team'.tr,
              GameMode.team,
              controller.selectedMode.value == GameMode.team,
              controller,
            ),
            _buildModeButton(
              'Campaign'.tr,
              GameMode.campaign,
              controller.selectedMode.value == GameMode.campaign,
              controller,
            ),
            _buildModeButton(
              'Challenge',
              GameMode.challenge,
              controller.selectedMode.value == GameMode.challenge,
              controller,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeButton(
      String label,
      GameMode mode,
      bool isSelected,
      ScoreboardController controller,
      ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          onPressed: () => controller.changeMode(mode),
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.red : Colors.white,
            foregroundColor: isSelected ? Colors.white : Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.red, width: 1),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
