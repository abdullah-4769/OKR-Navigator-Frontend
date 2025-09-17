import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/contextual_challange_controller.dart';
import '../../../controllers/journey_controller.dart';
import '../../../controllers/key_objective_controller.dart';
import '../../../controllers/key_results_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_adjustment_container.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_market_distribution_card.dart';
import '../../widgets/custom_objective_container.dart';
import '../../widgets/custom_journey_map.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

class ContextualChallengeScreen extends StatelessWidget {
  const ContextualChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ContextualChallengeController());
    final journeyController = Get.find<JourneyController>();
    Get.lazyPut(() => KeyObjectiveController());
    Get.lazyPut(() => KeyResultsController());

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final orientation = MediaQuery.of(context).orientation;

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
                    padding: EdgeInsets.only(bottom: height * 0.001),
                    child: Column(
                      children: [

                        /// Header
                        CustomHeader(
                          title: 'contextual'.tr,
                          highlightedText: 'challenge'.tr,
                          subtitle: 'adapt_strategy_to_challenge'.tr,
                          onBackTap: () =>
                              Get.toNamed(AppRoutes.aiAnalysisShowScreen),
                        ),

                        SizedBox(height: height * 0.025),

                        /// Challenge Alert
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                          child: CustomObjectiveContainer(

                            title: 'challenge_alert'.tr,
                            subtitle: '',
                            description: 'adaptation_required'.tr,
                            titleColor: AppColors.primaryRed,
                          ),
                        ),

                        SizedBox(height: height * 0.025),

                        /// Market Disruption
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                          child: CustomMarketDisruptionCard(
                            icon: Icons.warning_amber_rounded,
                            title: "market_disruption_challenge".tr,
                            description: "competitor_launched_product".tr,
                            warningText: "revenue_drop_warning".tr,
                            warningIcon: Icons.trending_down,
                          ),
                        ),

                        SizedBox(height: height * 0.001),

                        /// Adapt Section
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  'adapt_you'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                    color: AppColors.primaryRed,
                                    height: 1.2,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 6.h),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                                  child: Text(
                                    'readjust_strategy'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                      color: AppColors.black,
                                      height: 1.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.001),

                        /// Current Strategy & Related Containers
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                          child: Column(
                            children: [
                              /// 🔹 Current Strategy
                              CustomAdjustmentContainer(
                                icon: Icons.track_changes,
                                iconColor: AppColors.primaryRed,
                                title: "current_strategy".tr,
                                description: "development_new_markets".tr,
                              ),

                              SizedBox(height: 4.h),

                              /// 🔹 Objective
                              CustomAdjustmentContainer(
                                icon: Icons.flag,
                                iconColor: AppColors.primaryRed,
                                title: "objective".tr,
                                description: "expand_emerging_markets".tr,
                                actionText: "modify".tr,
                                actionColor: AppColors.primaryBlue,
                                onActionTap: () {
                                  // TODO: open objective editing dialog
                                },
                              ),

                              SizedBox(height: 4.h),

                              /// 🔹 Key Results
                              CustomAdjustmentContainer(
                                icon: Icons.flag,
                                iconColor: AppColors.primaryGreen,
                                title: "key_results".tr,
                                actionText: "adjust".tr,
                                actionColor: AppColors.primaryBlue,
                                onActionTap: () {},
                                children: [
                                  _buildResultItem(
                                    context,
                                    "achieve_revenue_new_products".tr,
                                    highlight: true,
                                  ),
                                  _buildResultItem(
                                    context,
                                    "launch_new_geographic_markets".tr,
                                  ),
                                  _buildResultItem(
                                    context,
                                    "achieve_market_share_target".tr,
                                  ),
                                ],
                              ),

                              /// 🔹 Initiatives
                              CustomAdjustmentContainer(
                                icon: Icons.rocket_launch,
                                iconColor: AppColors.primaryRed,
                                title: "initiatives".tr,
                                actionText: "revise".tr,
                                actionColor: AppColors.primaryBlue,
                                onActionTap: () {},
                                children: [
                                  _buildInitiativeItem(
                                    context,
                                    1,
                                    "first_initiative".tr,
                                    "premium_product_program".tr,
                                  ),
                                  _buildInitiativeItem(
                                    context,
                                    2,
                                    "second_initiative".tr,
                                    "strategic_market_entry".tr,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: height * 0.003),

                        /// Propose Adjustment Button
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: width * 0.05.w,
                              horizontal: height * 0.05.h,
                            ),
                            child: CustomButton(
                              text: 'propose_adjustment'.tr,
                              onPressed: () {
                                Get.offNamed(AppRoutes.contextualCAdjustment);
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

  /// 🔹 Key Result Item
  Widget _buildResultItem(BuildContext context, String text,
      {bool highlight = false}) => Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: highlight ? AppColors.primaryRed : AppColors.grey.withOpacity(0.5),
          width: highlight ? 1.5 : 1,
        ),
        color: Colors.white,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: highlight ? AppColors.primaryRed : AppColors.textSecondary,
          fontWeight: highlight ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );

  /// 🔹 Initiative Item
  Widget _buildInitiativeItem(
      BuildContext context, int number, String title, String subtitle) => Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey.withOpacity(0.4)),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Number Circle
          Container(
            width: 28.w,
            height: 28.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryRed,
            ),
            child: Text(
              "$number",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 12.w),

          /// Title + Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryRed,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
}
