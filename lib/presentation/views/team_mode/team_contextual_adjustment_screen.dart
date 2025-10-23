import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/team_mode_controller/team_contextual_adjustment_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import '../../widgets/custom_ai_strategy_container.dart';

class TeamContextualAdjustmentScreen extends StatelessWidget {
  const TeamContextualAdjustmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TeamContextualAdjustmentController());

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomBackground(
        child: OrientationBuilder(
          builder: (context, orientation) => Stack(
            children: [
              /// Scrollable Content
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: height * 0.015),
                  child: Column(
                    children: [


                      /// Headerc
                      CustomHeader(
                        title: 'contextual'.tr,
                        highlightedText: 'challenge'.tr,
                        subtitle: 'adapt_strategy_to_challenge'.tr,
                        onBackTap: () =>
                            Get.toNamed(AppRoutes.customAIAnalysisScreen2),
                      ),

                      SizedBox(height: height * 0.02),

                      /// Proposed Adjustments Box (Read Only)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(AppDimensions.d16.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: AppColors.grey.withOpacity(0.4),
                            ),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Title
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primaryRed,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.build,
                                        color: Colors.white,
                                        size: AppDimensions.d18.w),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'propose_adjustments'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryRed,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 14.h),

                              /// Revised Key Result
                              Text(
                                "revised_key_result".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Obx(() => Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.grey.withOpacity(0.4),
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                  color: Colors.grey.shade50,
                                ),
                                child: Text(
                                  controller.revisedKeyResult.value,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              )),

                              SizedBox(height: 16.h),

                              /// Additional Strategic Actions
                              Text(
                                "additional_strategic_actions".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Obx(() => Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.grey.withOpacity(0.4),
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                  color: Colors.grey.shade50,
                                ),
                                child: Text(
                                  controller.additionalActions.value,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.025),

                      /// AI Strategy Analysis Section
                      const CustomAIStrategyContainer(),

                      SizedBox(height: height * 0.025),

                      /// Submit Adaptations Button
                   Padding(
    padding: EdgeInsets.symmetric(
      horizontal: width * 0.08,
    ),
    child: Obx(() => CustomButton(
        icon: Icons.send,
        text: controller.isSubmittingFinal.value ? 'submitting'.tr : 'submit_adaptations'.tr,
        // ✅ FIX: Wrap the asynchronous function in a synchronous lambda
        onPressed: () => controller.submitFinalAdjustment(), 
        
        // This flag automatically handles the button's visual state (graying out/spinner)
        isLoading: controller.isSubmittingFinal.value,
    )),
),

                      SizedBox(height: height * 0.04),
                    ],
                  ),
                ),
              ),

              /// Floating Home Navbar
              Positioned(
                right: width * -0.07,
                top: height * 0.5,
                child: const CustomHomeNavBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
