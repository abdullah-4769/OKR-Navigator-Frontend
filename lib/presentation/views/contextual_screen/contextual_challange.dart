import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/contextual_challange_controller.dart';
import '../../../controllers/journey_controller.dart';
import '../../../controllers/key_objective_controller.dart';
import '../../../controllers/key_results_controller.dart';
import '../../../core/app_colors.dart';
import '../../../data/repositories/storage_repository.dart';
import '../../../generated/models/responses/contexual_challenge/innovation_model.dart';
import '../../../view_model/challenge_view_model/contextual_challenge_view_model.dart';
import '../../../view_model/challenge_view_model/innovative_view_model.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_adjustment_container.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_market_distribution_card.dart';
import '../../widgets/custom_objective_container.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

class ContextualChallengeScreen extends StatelessWidget {
  const ContextualChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final challengeViewModel = Get.put(ChallengeViewModel());
    final innovative = Get.put(InnovativeStrategiesViewModel());

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
                        subtitle: ''.tr,
                        onBackTap: () =>
                            Get.toNamed(AppRoutes.aiAnalysisShowScreen),
                      ),

                      SizedBox(height: height * 0.025),

                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'adapt_strategy_to_challenge'.tr,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  color: AppColors.black,
                                  height: 1.2,
                                  fontWeight: FontWeight.w400,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.025),

                      /// Challenge Alert
                      Obx(() {
                        return Padding(
                            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                            child: CustomMarketDisruptionCard(
                              icon: Icons.warning_amber_rounded,
                              title: challengeViewModel.marketDisruptionTitle,
                              description: challengeViewModel.marketDisruptionDescription,
                              warningText: 'revenue_drop_warning'.tr,
                              warningIcon: Icons.trending_down,
                            )
                        );
                      }),

                      SizedBox(height: height * 0.025),


                      SizedBox(height: height * 0.001),

                      /// Adapt Section
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                'adapt_you'.tr,
                                style: Theme.of(context).textTheme.headlineSmall
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
                                  style: Theme.of(context).textTheme.bodyMedium
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
                      /// 🔹 Combined Container for all strategy sections
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: AppColors.grey.withOpacity(0.4)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// 🔸 Current Strategy
                              CustomAdjustmentContainer(
                                icon: Icons.track_changes,
                                iconColor: AppColors.primaryRed,
                                title: 'current_strategy'.tr,
                                description: 'development_new_markets'.tr,
                              ),

                              Divider(height: 20.h, color: AppColors.grey.withOpacity(0.4)),

                              /// 🔸 Objective
                              CustomAdjustmentContainer(
                                icon: Icons.flag,
                                iconColor: AppColors.primaryRed,
                                title: 'objective'.tr,
                                description: 'expand_emerging_markets'.tr,
                                actionText: 'modify'.tr,
                                actionColor: AppColors.primaryBlue,
                                onActionTap: () {
                                  // TODO: open objective editing dialog
                                },
                              ),

                              Divider(height: 20.h, color: AppColors.grey.withOpacity(0.4)),

                              /// 🔸 Key Results
                              CustomAdjustmentContainer(
                                icon: Icons.flag,
                                iconColor: AppColors.primaryGreen,
                                title: 'key_results'.tr,
                                actionText: 'adjust'.tr,
                                actionColor: AppColors.primaryBlue,
                                onActionTap: () {},

                              ),

                              Divider(height: 20.h, color: AppColors.grey.withOpacity(0.4)),

                              /// 🔸 Initiatives
                              // Update the Initiatives section in your existing ContextualChallengeScreen

                              /// 🔸 Initiatives
                              CustomAdjustmentContainer(
                                icon: Icons.rocket_launch,
                                iconColor: AppColors.primaryRed,
                                title: 'initiatives'.tr,
                                actionText: 'revise'.tr,
                                actionColor: AppColors.primaryBlue,
                                onActionTap: () {
                                  _showInnovativeStrategiesDialog(context);
                                },
                              ),
                            ],
                          ),
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
                              Get.toNamed(AppRoutes.contextualCAdjustment);
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
  Widget _buildResultItem(
    BuildContext context,
    String text, {
    bool highlight = false,
  }) => Container(
    width: double.infinity,
    margin: EdgeInsets.only(bottom: 8.h),
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(
        color: highlight
            ? AppColors.primaryRed
            : AppColors.grey.withOpacity(0.5),
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
    BuildContext context,
    int number,
    String title,
    String subtitle,
  ) => Container(
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
            '$number',
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
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    ),
  );
  void _showInnovativeStrategiesDialog(BuildContext context) {
    final innovativeViewModel = Get.put(InnovativeStrategiesViewModel());
    final storageRepository = Get.find<StorageRepository>();

    // Get strategy ID - you might need to adjust this based on your app structure
    int strategyId = 4; // Default value, replace with dynamic value if needed

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Innovative Strategies'),
        content: Obx(() {
          if (innovativeViewModel.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (innovativeViewModel.errorMessage.isNotEmpty) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error, color: Colors.red, size: 48),
                SizedBox(height: 16),
                Text('Error: ${innovativeViewModel.errorMessage.value}'),
              ],
            );
          }

          return Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: innovativeViewModel.innovativeStrategies.length,
              itemBuilder: (context, index) {
                final strategy = innovativeViewModel.innovativeStrategies[index];
                return _buildStrategyCard(context, strategy);
              },
            ),
          );
        }),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              innovativeViewModel.fetchInnovativeStrategies(strategyId);
            },
            child: Text('Refresh'),
          ),
        ],
      ),
    ).then((_) {
      // Fetch data when dialog is shown
      innovativeViewModel.fetchInnovativeStrategies(strategyId);
    });
  }

  Widget _buildStrategyCard(BuildContext context, InnovativeStrategy strategy) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strategy.keyResult,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryRed,
              ),
            ),
            SizedBox(height: 12),

            if (strategy.firstInnovative != null)
              _buildInnovativeItem(context, '1.', strategy.firstInnovative!),

            if (strategy.secondInnovative != null)
              _buildInnovativeItem(context, '2.', strategy.secondInnovative!),

            if (strategy.thirdInnovative != null)
              _buildInnovativeItem(context, '3.', strategy.thirdInnovative!),
          ],
        ),
      ),
    );
  }

  Widget _buildInnovativeItem(BuildContext context, String number, InnovativeItem item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number ${item.title}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            item.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
