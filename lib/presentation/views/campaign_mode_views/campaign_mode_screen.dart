// Update your CampaignModeScreen with dynamic level handling
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../core/app_theme.dart';
import '../../routes/app_routes.dart';
import '../../widgets/campaign_mode_widgets/custom_industry_card.dart';
import '../../widgets/campaign_mode_widgets/custom_progress_bar.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

import '../../widgets/custom_circular_avatar.dart';
import '../../widgets/custom_objective_container.dart';

import '../../widgets/custom_button.dart';

class CampaignModeScreen extends StatelessWidget {
  const CampaignModeScreen({super.key});

  @override
  Widget build(BuildContext context) => OrientationBuilder(
    builder: (context, orientation) {
      final width = MediaQuery.of(context).size.width;
      final height = MediaQuery.of(context).size.height;
      final theme = Theme.of(context);

      return Scaffold(
        backgroundColor: AppColors.white,
        body: CustomBackground(
          child: Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.h),

                      /// ✅ Header
                      CustomHeader(
                        title: "campaign".tr,
                        highlightedText: "mode".tr,
                        onBackTap: () => Get.back(),
                        showDashboardIcon: false,
                      ),

                      SizedBox(height: 12.h),

                      /// ✅ Avatar
                      CustomCircularAvatar(
                        imagePath: "assets/images/solo2.png",
                        size: 130,
                        innerColors: const [
                          AppColors.softRed,
                          AppColors.softRed,
                          AppColors.softRed,
                        ],
                        borderGradient: [
                          AppColors.primaryRed,
                          AppColors.primaryRed.withValues(alpha: 0.3),
                        ],
                        borderWidth: 2,
                        innermostFactor: 0.8, // make last circle bigger

                        imageScale: 50,
                        // make image bigger
                        imageOffset: Offset(0, 9), // move image slightly up
                      ),

                      SizedBox(height: 8.h),

                      /// ✅ Navigator Mission
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CustomObjectiveContainer(
                          title: "navigator_mission".tr,
                          description: "navigator_mission_desc".tr,
                          titleColor: AppColors.black,
                          icon: Icons.explore,
                        ),
                      ),

                      /// ✅ Campaign Progress
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            "campaign_progress".tr,
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: AppColors.primaryRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: CustomProgressPath(
                            stepLabels: ['1', '2', '3'],
                            currentStep: 1,
                            showCircles: true,
                          ),
                        ),
                      ),

                      SizedBox(height: 2.h),

                      /// ✅ Organizations
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            "organizations".tr,
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: AppColors.primaryRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "organizations_desc".tr,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 8.h),

                      /// Org A
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: CustomIndustryCard(
                          orgTitle: "organization_a".tr,
                          subTitle: "startup_phase_level1".tr,
                          strategyText: "8 ${'strategy_cards'.tr}",
                          challengeText: "12 ${'challenges'.tr}",

                          bottomTitle: "growth_scale_obj".tr,
                          onStart: () {
                            // Get.toNamed(AppRoutes.orgADetailScreen);
                          },
                          imagePath: 'assets/images/role_icon.png',
                          isUnlocked: true,
                        ),
                      ),

                      /// Org B
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: CustomIndustryCard(
                          orgTitle: "organization_b".tr,
                          subTitle: "startup_phase_level2".tr,
                          strategyText: "8 ${'strategy_cards'.tr}",
                          challengeText: "12 ${'challenges'.tr}",

                          bottomTitle: "locked".tr,
                          onStart: () {},
                          imagePath: 'assets/images/role_icon.png',
                          isUnlocked: false,
                        ),
                      ),

                      /// Org C
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: CustomIndustryCard(
                          orgTitle: "organization_c".tr,
                          subTitle: "startup_phase_level2".tr,
                          strategyText: "8 ${'strategy_cards'.tr}",
                          challengeText: "12 ${'challenges'.tr}",

                          bottomTitle: "locked".tr,
                          onStart: () {},
                          imagePath: 'assets/images/role_icon.png',
                          isUnlocked: false,
                        ),
                      ),

                      SizedBox(height: 20.h),

                      /// ✅ Buttons
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: CustomButton(
                          text: "begin_campaign".tr,
                          backgroundColor: AppColors.primaryRed,
                          icon: Icons.play_arrow,
                          onPressed: () {
                            Get.toNamed(AppRoutes.missionScreen);
                          },
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: CustomButton(
                          text: "campaign_guide".tr,
                          backgroundColor: AppColors.primaryBlue,
                          icon: Icons.info,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// ✅ Floating Navbar
              Positioned(
                right: width * -0.07,
                top: height * 0.4,
                child: const CustomHomeNavBar(),
              ),
            ],
          ),
        ),
      );
    },
  );
}













