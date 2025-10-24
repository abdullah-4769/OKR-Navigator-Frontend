import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:game_app/presentation/views/campaign_mode_views/widgets/custom_timer_widget.dart';
import 'package:game_app/presentation/views/campaign_mode_views/widgets/startegy_widgets.dart';
import 'package:game_app/presentation/widgets/bubble_button.dart';
import 'package:game_app/presentation/widgets/custom_button2.dart';
import 'package:game_app/presentation/widgets/custom_objective_container.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../data/response/status.dart';
import '../../../services/shared_preference.dart';
import '../../../view_model/campaign_mode/campaign_senerio_view_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/responsive_arrow.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import '../../widgets/team_mode_widgets/custom_view_widget.dart';
import '../../widgets/team_mode_widgets/section_card.dart';
import '../../widgets/team_mode_widgets/stat_card.dart';
import 'navigator_final_test_certification.dart';

class NavigatorCertificationStartScreen extends StatefulWidget {
  const NavigatorCertificationStartScreen({super.key});

  @override
  State<NavigatorCertificationStartScreen> createState() => _NavigatorCertificationStartScreenState();
}

class _NavigatorCertificationStartScreenState extends State<NavigatorCertificationStartScreen> {

  final viewModel = Get.put(NavigatorCertificationViewModel());

// Example: when entering screen, fetch strategies dynamically
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      // No need to pass parameters anymore
      await viewModel.fetchStrategies();
    });
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    var badges = 12.obs;
    var trophies = 16.obs;
    var games = 8.obs;
    return Scaffold(

      body: CustomBackground(
        child: OrientationBuilder(
          builder: (context, orientation) => Stack(
            children: [
              /// Scrollable content
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: height * 0.015),
                  child: Obx(
                        () => Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [


                        /// Header
                        CustomHeader(
                          title: 'Navigator'.tr,
                          highlightedText: 'Certification'.tr,
                          subtitle: '',
                          onBackTap: () => Get.back(),
                        ),


                        /// Stats Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            StatCard(
                              value: badges.value.toString(),
                              label: 'badges'.tr,
                              assetPath: 'assets/images/badge.png',
                            ),
                            StatCard(
                              value: trophies.value.toString(),
                              label: 'trophies'.tr,
                              assetPath: 'assets/images/trophy.png',
                            ),
                            StatCard(
                              value: games.value.toString(),
                              label: 'games'.tr,
                              assetPath: 'assets/images/game.png',
                            ),
                          ],
                        ),

                        SizedBox(height: 10.h),
                        Center(child:
                        CountdownTimerWidget(
                          totalMinutes: 15,
                          size: 130,
                          onTimerComplete: () {
                            // Custom navigation or action
                            Get.offAllNamed('/campaignModeScreen');
                            // Or any other action
                          },
                        )),
                        SizedBox(height: 10.h),
                        Center(child: const ResponsiveArrow()),
                        SizedBox(height: 10.h),
                        /// Dynamic Scenario from API
                        Obx(() {
                          final scenario = viewModel.scenarioText.value;
                          final response = viewModel.strategies.value;

                          if (response.status == Status.completed && scenario.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CustomObjectiveContainer(
                                title: 'Business Scenario',
                                description: scenario,
                                icon: Icons.business_center,
                              ),
                            );
                          } else if (response.status == Status.loading) {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CustomObjectiveContainer(
                                title: 'Loading Scenario...',
                                description: 'Preparing your certification challenge...',
                                icon: Icons.hourglass_empty,
                              ),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CustomObjectiveContainer(
                                title: 'Scenario Unavailable',
                                description: 'Could not load the business scenario. Please try again.',
                                icon: Icons.error_outline,
                              ),
                            );
                          }
                        }),
                        // /// Recent Achievements
                        //  Padding(
                        //   padding: EdgeInsets.all(16.0),
                        //   child: CustomObjectiveContainer(
                        //     title: 'Scenario: TechCorp Global'.tr,
                        //
                        //     description: 'A multinational technology company facing declining market share and internal coordination challenges across 3 departments: Sales, Product, and Operations.',
                        //     icon: Icons.ac_unit_outlined,
                        //
                        //   ),
                        // ),

                        /// Feedback Section
                        SizedBox(height: 10.h),
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 16.w),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: CustomBubbleButton(text: "Draw New",
                                width: 120.w,
                                height: 30.h,
                                onTap: () => {},)
                          ),
                        ),



                        SizedBox(height: 10.h),


                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 16.w),
                          child: GrowthStrategySection(),
                        ),


                        SizedBox(height: 10.h),

                        /// Recent Games
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SectionCard(
                            title: 'Quick Tips'.tr,
                            icon: Icons.lightbulb,
                            borderColor: AppColors.primaryRed,

                            showScore: false, items: [
                            {
                              'title': 'our initiative lacks cost competitiveness consider price benchmarking or bundling.',

                            },



                          ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        /// -------- ACTION BUTTONS --------
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppDimensions.d24.w),
                          child: Column(
                            children: [
                              SizedBox(height: AppDimensions.d12.h),

                              // Use GetBuilder instead of Obx for better performance
                              GetBuilder<NavigatorCertificationViewModel>(
                                builder: (viewModel) {
                                  // Check if strategy is selected
                                  final hasSelectedStrategy = SharedPrefs.getCertificateSelectedAIStrategy().isNotEmpty;

                                  return CustomButton(
                                    icon: Icons.start,
                                    text: "Continue".tr,
                                    backgroundColor: hasSelectedStrategy ? AppColors.primaryRed : AppColors.primaryRed,
                                    onPressed:  () {
                                      // Print all saved data for debugging
                                      SharedPrefs.printCertificateData();

                                      // Navigate to next screen
                                      Get.toNamed(AppRoutes.navigatorFinalTestCertificationScreen);
                                    },
                                  );
                                },
                              ),

                              SizedBox(height: 10.h),
                            ],
                          ),
                        ),
                      ],
                    ),
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
