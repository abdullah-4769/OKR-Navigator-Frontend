import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/custom_ai_startegy_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';

import '../../routes/app_routes.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_curved_arrow.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_info_container.dart';
import '../../widgets/custom_svg.dart';

class AIAnalysisScreen extends StatelessWidget {
  // Initialize controller with Get.put
  final AIStrategyController controller = Get.put(AIStrategyController());

  AIAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final screenWidth = constraints.maxWidth;
      final screenHeight = constraints.maxHeight;

      return Scaffold(
        backgroundColor: Colors.white,

        body: SafeArea(
          child: Stack(
            children: [
              // Background Gradient
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.backgroundTop,
                        AppColors.backgroundBottom,
                      ],
                    ),
                  ),
                ),
              ),

              // Scrollable Content
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: AppDimensions.d90.h),
                    child: Column(
                      children: [
                        SizedBox(height: AppDimensions.d16.h),

                        // Header
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.d1.w,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomCurvedArrow(
                                isLeft: true,
                                onTap: () =>
                                    Get.offAllNamed(AppRoutes.keyResultsScreen),
                                width: AppDimensions.d55.w,
                                height: AppDimensions.d130.h,
                              ),
                              Expanded(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'suggestion'.tr + ' ',
                                        style: TextStyle(
                                          fontFamily: 'Gotham-Bold',
                                          fontSize: AppDimensions.d40.sp,
                                          color: AppColors.primaryRed,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\n' + 'of_initiatives'.tr,
                                        style: TextStyle(
                                          fontFamily: 'Gotham-Bold',
                                          fontSize: AppDimensions.d26.sp,
                                          color: AppColors.primaryBlue,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                radius: AppDimensions.d22.r,
                                backgroundColor: AppColors.white,
                                child: Padding(
                                  padding: EdgeInsets.all(2.r),
                                  child: CustomSvg(
                                    assetPath: 'assets/images/solo.svg',
                                    semanticsLabel: 'profile'.tr,
                                    height: AppDimensions.d60.h,
                                    width: AppDimensions.d60.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: AppDimensions.d10.h),
                         CustomInfoContainer(
                          backgroundColor: Colors.green,
                          logoAsset: 'assets/icons/bulb.svg',
                          description: 'submit_initiatives_info'.tr,
                          title: '',
                        ),

                        SizedBox(height: AppDimensions.d10.h),
                        // Complete Button
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.d40.w,
                          ),
                          child: Obx(() {
                            final bool isEnabled =
                                controller.isAnalysisDone.value;
                            return CustomButton(
                              text: 'check_contextual_challenge'.tr,
                              onPressed: () {},
                            );
                          }),
                        ),

                        SizedBox(height: AppDimensions.d20.h),
                      ],
                    ),
                  ),
                ),
              ),

              // Home Navbar
              Positioned(
                right: screenWidth * -0.07,
                top: screenHeight * 0.50,
                child: const CustomHomeNavBar(),
              ),
            ],
          ),
        ),
      );
    },
  );
}
