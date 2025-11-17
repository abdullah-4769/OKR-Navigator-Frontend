import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controllers/Other_screens_controllers/mini_simulation_controller.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';
import '../routes/app_routes.dart';
import '../widgets/custom_industry_container.dart';
import '../widgets/custom_home_navbar.dart';
import '../widgets/screens_unique_parts/custom_header.dart';
import '../widgets/screens_unique_parts/custom_background.dart';
import '../widgets/custom_button.dart';

class MiniSimulationScreen extends StatelessWidget {
  MiniSimulationScreen({super.key});

  final MiniSimulationController controller = Get.put(MiniSimulationController());

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.white,
      body: CustomBackground(

        child: OrientationBuilder(
          builder: (context, orientation) {
            final size = MediaQuery.of(context).size;
            final isPortrait = orientation == Orientation.portrait;

            return Stack(
              children: [
                /// Scrollable content
                Positioned.fill(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: isPortrait ? size.height * 0.015 : size.height * 0.01),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [


                        /// 🔹 Header
                        CustomHeader(
                          title: 'OKR',
                          highlightedText: 'mini_simulation'.tr,
                          subtitle: 'refine_strategy_address_challenge'.tr,
                          onBackTap: () => Get.offAllNamed(AppRoutes.aiAnalysisShowScreen),
                        ),

                        SizedBox(height: isPortrait ? size.height * 0.025 : size.height * 0.015),

                        /// 🔹 Title
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "OKR ",
                                  style: TextStyle(
                                    fontSize: isPortrait ? 26.sp : 22.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryRed,
                                    fontFamily: "Gotham",
                                  ),
                                ),
                                TextSpan(
                                  text: "mini_simulation".tr,
                                  style: TextStyle(
                                    fontSize: isPortrait ? 24.sp : 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryBlue,
                                    fontFamily: "Gotham",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: isPortrait ? size.height * 0.01 : size.height * 0.005),

                        /// 🔹 Subtitle
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppDimensions.d16.w),
                          child: Text(
                            'solve_scenario_minutes'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isPortrait ? 14.sp : 12.sp,
                              color: AppColors.textSecondary,
                              fontFamily: "Gotham",
                            ),
                          ),
                        ),
                        SizedBox(height: isPortrait ? size.height * 0.025 : size.height * 0.015),

                        /// 🔹 Stats Row
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppDimensions.d16.w),
                          child: Row(
                            children: [
                              Expanded(child: _statCard("5:00", "time_limit".tr, "assets/images/solo.svg", isPortrait)),
                              SizedBox(width: 8.w),
                              Expanded(child: _statCard("95%", "best_score".tr, "assets/images/solo.svg", isPortrait)),
                              SizedBox(width: 8.w),
                              Expanded(child: _statCard("8", "games".tr, "assets/images/solo.svg", isPortrait)),
                            ],
                          ),
                        ),
                        SizedBox(height: isPortrait ? size.height * 0.04 : size.height * 0.03),

                        /// 🔹 Section Title
                        Center(
                          child: Text(
                            "choose_scenario".tr,
                            style: TextStyle(
                              fontSize: isPortrait ? 18.sp : 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryRed,
                              fontFamily: "Gotham",
                            ),
                          ),
                        ),
                        SizedBox(height: isPortrait ? size.height * 0.02 : size.height * 0.015),

                        /// 🔹 Scenarios List
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppDimensions.d16.w),
                          child: Obx(() => Column(
                            children: [
                              /// 🔹 Scenario 1
                              CustomIndustryContainer(
                                title: "scenario_techcorp".tr,
                                description: 'scenario_description'.tr,
                                isSelected: controller.selectedScenario.value == 0,
                                onTap: () => controller.selectScenario(0),
                                showTag1: true,
                                tag1Icon: Icons.star,
                                tag1Text: "difficulty_medium".tr,
                              ),
                              SizedBox(height: 12.h),

                              /// 🔹 Scenario 2
                              CustomIndustryContainer(
                                title: "scenario_techcorp".tr,
                                description: 'scenario_description'.tr,
                                isSelected: controller.selectedScenario.value == 1,
                                onTap: () => controller.selectScenario(1),
                                showTag1: true,
                                tag1Icon: Icons.star,
                                tag1Text: "difficulty_medium".tr,
                              ),
                              SizedBox(height: 12.h),

                              /// 🔹 Scenario 3
                              CustomIndustryContainer(
                                title: "scenario_techcorp".tr,
                                description: 'scenario_description'.tr,
                                isSelected: controller.selectedScenario.value == 2,
                                onTap: () => controller.selectScenario(2),
                                showTag1: true,
                                tag1Icon: Icons.star,
                                tag1Text: "difficulty_hard".tr,
                              ),
                            ],
                          )),
                        ),
                        SizedBox(height: isPortrait ? size.height * 0.03 : size.height * 0.02),

                        /// 🔹 Quick Tips
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppDimensions.d16.w),
                          child: CustomIndustryContainer(
                            title: "quick_tips".tr,
                            description: 'cost_competitiveness_tip'.tr,
                            isSelected: false,
                            onTap: () {},
                            icon: Icons.lightbulb_outline,
                          ),
                        ),
                        SizedBox(height: isPortrait ? size.height * 0.04 : size.height * 0.03),

                        /// 🔹 Start Challenge Button
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppDimensions.d24.w),
                          child: CustomButton(
                            text: "start_bonus_challenge".tr,
                            onPressed: controller.startChallenge,
                            icon: Icons.play_arrow,
                            backgroundColor: AppColors.primaryRed,
                          ),
                        ),
                        SizedBox(height: isPortrait ? size.height * 0.04 : size.height * 0.03),
                      ],
                    ),
                  ),
                ),

                /// 🔹 Home Navbar (positioned like in reference screens)
                Positioned(
                  right: isPortrait ? size.width * -0.07 : size.width * -0.05,
                  top: isPortrait ? size.height * 0.5 : size.height * 0.4,
                  child: const CustomHomeNavBar(),
                ),
              ],
            );
          },
        ),
      ),
    );

  /// 🔹 Stat Card
  Widget _statCard(String value, String label, String assetPath, bool isPortrait) {
    return Container(
      padding: EdgeInsets.all(isPortrait ? 12.w : 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            assetPath,
            height: isPortrait ? 32.w : 28.w,
            width: isPortrait ? 32.w : 28.w,
            color: AppColors.primaryBlue,
          ),
          SizedBox(height: isPortrait ? 6.h : 4.h),
          Text(
            value,
            style: TextStyle(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.bold,
              fontSize: isPortrait ? 16.sp : 14.sp,
              fontFamily: "Gotham",
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: isPortrait ? 12.sp : 10.sp,
              fontFamily: "Gotham",
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}