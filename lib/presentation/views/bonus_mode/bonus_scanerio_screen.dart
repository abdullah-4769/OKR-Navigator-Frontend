// 5. BonusScenarioLoadingScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/Get.dart';
import '../../../core/app_colors.dart';
import '../../../view_model/bonus_controller/bonus_controller.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

class BonusScenarioLoadingScreen extends StatelessWidget {
  final controller = Get.find<BonusModeController>();

  BonusScenarioLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomBackground(
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.primaryRed, strokeWidth: 6),
                    SizedBox(height: 30.h),
                    Text(
                      'ai_creating_scenario'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'based_on_role_industry'.tr,
                      style: TextStyle(fontSize: 16.sp, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(right: size.width * -0.07, top: size.height * 0.5, child: const CustomHomeNavBar()),
          ],
        ),
      ),
    );
  }
}