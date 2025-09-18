import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/campaign_mode_controllers/mission_screen_controller.dart';
import '../../../core/app_colors.dart';
import '../../widgets/campaign_mode_widgets/custom_industry_card.dart';
import '../../widgets/campaign_mode_widgets/organization_path_card.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import '../../widgets/custom_home_navbar.dart';

import '../../widgets/team_mode_widgets/section_card.dart'; // ✅ use SectionCard

class MissionScreen extends StatelessWidget {
  static const String routeName = "/mission";
  final controller = Get.put(MissionScreenController());

  MissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomBackground(
        child: OrientationBuilder(
          builder: (context, orientation) => Stack(
            children: [
              /// Scrollable content
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: height * 0.02),
                  child: Obx(
                        () => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// Header
                        CustomHeader(
                          title: "start".tr,
                          highlightedText: "the_mission".tr,
                          subtitle: "",
                          onBackTap: () => Get.back(),
                        ),

                        SizedBox(height: 10.h),

                        /// Organization Path
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: OrganizationPathCard(
                            orgName: controller.orgName.value,
                            orgSubtitle: controller.orgSubtitle.value,
                            stars: controller.stars.value,
                            nodes: controller.nodes,

                          ),
                        ),

                        SizedBox(height: 10.h),

                        /// Industry Card
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: CustomIndustryCard(
                            orgTitle: controller.industryTitle.value,
                            subTitle: controller.industrySubtitle.value,
                            bottomTitle: controller.bottomTitle.value,
                            strategyText: "strategy".tr,
                            challengeText: "challenge".tr,
                            imagePath: "assets/images/role_icon.png",
                            isUnlocked: true,
                            onStart: controller.onStartMission,
                            showPlayButton: false,
                          ),
                        ),

                        SizedBox(height: 10.h),

                        /// 🔹 Rewards / Trophy Section Card
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: SectionCard(
                            showTopButton: false,
                            showLeftIcons: true,
                            showRightIcons: false,
                            icon: Icons.wine_bar,
                            title: "trophy_rewards".tr, // e.g. "Trophy & Rewards Unlocked"
                            borderColor: AppColors.primaryRed,
                            showCheck: true,
                            items: [
                              {
                                'key': "badge_strategic_thinker".tr,
                                'done': true,
                                'icon': Icons.check, // ✅ Tick inside circle
                                'iconColor': Colors.white,
                              },
                              {
                                'key': "title_master_adapter".tr,
                                'done': true,
                                'icon': Icons.check,
                                'iconColor': Colors.white,
                              },

                            ],
                            outerCircleColor: AppColors.primaryRed,
                            checkIconColor:AppColors.primaryRed,
                          ),
                        ),

                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
              ),

              /// Home Navbar (floating right center)
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
