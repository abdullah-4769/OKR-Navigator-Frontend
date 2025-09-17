import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/custom_ai_startegy_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_info_container.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

class AIAnalysisScreen extends StatelessWidget {
  AIAnalysisScreen({super.key});

  final AIStrategyController controller = Get.put(AIStrategyController());

  String _safeTranslate(String? key, {String fallback = ''}) {
    if (key == null) return fallback;
    try {
      return key.tr;
    } catch (e) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return OrientationBuilder(
      builder: (context, orientation) => Scaffold(
        body: CustomBackground(
          child: SafeArea(
            child: Stack(
              children: [
                /// ---------- MAIN SCROLL CONTENT ----------
                Positioned.fill(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: AppDimensions.d18.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: AppDimensions.d16.h),

                        /// ---------- HEADER ----------
                        CustomHeader(
                          title: _safeTranslate('suggestion'),
                          highlightedText: _safeTranslate('of_initiatives'),
                          subtitle: '',
                          onBackTap: () =>
                              Get.offAllNamed(AppRoutes.teamSuggestionInitiativeScreen),
                        ),

                        SizedBox(height: AppDimensions.d20.h),

                        /// ---------- INFO CONTAINER ----------
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: const CustomInfoContainer(
                            percentage: 65,
                            robotAsset: "assets/images/robot.svg",
                            title: "Strategic Tips",
                            description:
                            "Focus on measurable actions that directly impact revenue\n\n"
                                "Consider market research, product development, or sales strategies\n\n"
                                "Think about timeline, resources, and success metrics",
                            percentageBarColor: Color(0xFFBFD200),
                          ),
                        ),

                        SizedBox(height: AppDimensions.d25.h),

                        /// ---------- BUTTON ----------
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Obx(() {
                            final bool enabled =
                                controller.isAnalysisDone.value;
                            return CustomButton(
                              text: _safeTranslate(
                                  'check_contextual_challenge'),
                              onPressed: enabled
                                  ? () => Get.offAllNamed(
                                AppRoutes.contextualChallenge,
                              )
                                  : () {Get.offAllNamed(
                                AppRoutes.contextualChallenge,
                              );},
                            );
                          }),
                        ),

                        SizedBox(height: AppDimensions.d30.h),
                      ],
                    ),
                  ),
                ),

                /// ---------- FLOATING HOME NAV ----------
                Positioned(
                  right: screenWidth * -0.07,
                  top: screenHeight * 0.50,
                  child: const CustomHomeNavBar(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
