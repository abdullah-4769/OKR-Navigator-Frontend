import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_journey_map.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import '../../widgets/custom_ai_strategy_container.dart';
import '../../../controllers/journey_controller.dart';

class ContextualCAdjustmentScreen extends StatelessWidget {
  const ContextualCAdjustmentScreen({super.key});

  @override
  Widget build(BuildContext context) {


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


                        /// Header
                        CustomHeader(
                          title: 'contextual'.tr,
                          highlightedText: 'adjustment'.tr,
                          subtitle: 'refine_strategy_address_challenge'.tr,
                          onBackTap: () =>
                              Get.toNamed(AppRoutes.aiAnalysisShowScreen),
                        ),

                        SizedBox(height: height * 0.0025),

                        /// Single Main Adjustment Container
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(AppDimensions.d16.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColors.grey.withOpacity(0.4),
                              ),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Revised Key Result
                                Text(
                                  "revised_key_result".tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryRed,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "adjust_revenue_target_question".tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),

                                SizedBox(height: 8.h),

                                /// Additional Strategic Actions
                                Text(
                                  "additional_strategic_actions".tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryRed,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "new_initiatives_question".tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.004),



                        /// AI Strategy Analysis Box
                        const CustomAIStrategyContainer(),

                        SizedBox(height: height * 0.004),

                        /// Propose Adjustment Button
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: width * 0.05.w,
                              horizontal: height * 0.05.h,
                            ),
                            child: CustomButton(
                              text: 'submit_adaptations'.tr,
                              onPressed: () {
                                Get.toNamed(AppRoutes.gameCompleteScreen);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Home Navbar
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
