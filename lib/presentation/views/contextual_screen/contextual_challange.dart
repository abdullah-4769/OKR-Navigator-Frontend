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
    // ✅ Single instantiation - register dependencies once
    Get.put(ChallengeViewModel(), permanent: true);
    Get.put(InnovativeStrategiesViewModel(), permanent: true);
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
                        onBackTap: () => Get.toNamed(AppRoutes.aiAnalysisShowScreen),
                      ),
                      SizedBox(height: height * 0.025),

                      /// Adapt Strategy Text
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'adapt_strategy_to_challenge'.tr,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                        final challengeViewModel = Get.find<ChallengeViewModel>();
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                          child: CustomMarketDisruptionCard(
                            icon: Icons.warning_amber_rounded,
                            title: challengeViewModel.marketDisruptionTitle,
                            description: challengeViewModel.marketDisruptionDescription,
                            warningText: 'revenue_drop_warning'.tr,
                            warningIcon: Icons.trending_down,
                          ),
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
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

                      /// Strategy Sections Container - ✅ CONDITIONAL KEY RESULTS
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
                              /// Current Strategy
                              CustomAdjustmentContainer(
                                icon: Icons.track_changes,
                                iconColor: AppColors.primaryRed,
                                title: 'current_strategy'.tr,
                                description: 'development_new_markets'.tr,
                              ),
                              Divider(height: 20.h, color: AppColors.grey.withOpacity(0.4)),

                              /// Objective
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

                              /// Key Results - ✅ CONDITIONAL LOGIC
                              // In ContextualChallengeScreen - Update the Key Results section:

                              Obx(() {
                                final keyResultsController = Get.find<KeyResultsController>();
                                final hasCompletedSelection = keyResultsController.isSelectionComplete();
                                final selectedCount = keyResultsController.selectedCount.value;

                                print('🔍 ContextualChallenge: Selection complete = $hasCompletedSelection, Count = $selectedCount');

                                return CustomAdjustmentContainer(
                                  icon: Icons.flag,
                                  iconColor: hasCompletedSelection ? AppColors.primaryGreen : AppColors.primary,
                                  title: 'key_results'.tr,
                                  description: hasCompletedSelection
                                      ? '${selectedCount} ${'key_results_selected'.tr}'
                                      : 'select_key_results_to_continue'.tr,
                                  actionText: hasCompletedSelection
                                      ? '${'view'.tr} ($selectedCount)'
                                      : 'select_adjust'.tr,
                                  actionColor: hasCompletedSelection ? AppColors.primaryGreen : AppColors.primaryBlue,
                                  // suffixIcon: hasCompletedSelection ? Icons.check_circle : Icons.add_circle_outline,
                                  onActionTap: () {
                                    print('🔘 Key Results action tapped - Complete: $hasCompletedSelection');
                                    if (hasCompletedSelection) {
                                      _showSelectedKeyResultsDialog(context);
                                    } else {
                                      Get.toNamed(AppRoutes.keyResultsScreen);
                                    }
                                  },
                                );
                              }),
                              Divider(height: 20.h, color: AppColors.grey.withOpacity(0.4)),

                              /// Initiatives
                              CustomAdjustmentContainer(
                                icon: Icons.rocket_launch,
                                iconColor: AppColors.primaryRed,
                                title: 'initiatives'.tr,
                                actionText: 'revise'.tr,
                                actionColor: AppColors.primaryBlue,
                                onActionTap: () {
                                  final strategyId = 4;
                                  _showInnovativeStrategiesDialog(context, strategyId: strategyId);
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
                            onPressed: () => Get.toNamed(AppRoutes.contextualCAdjustment),
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

  /// ✅ Show selected key results dialog
  void _showSelectedKeyResultsDialog(BuildContext context) {
    final keyResultsController = Get.find<KeyResultsController>();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 24),
            SizedBox(width: 12.w),
            Text(
              'Selected Key Results',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Obx(() {
          final selectedCount = keyResultsController.selectedCount.value;
          if (selectedCount == 0) {
            return const Text('No key results selected yet');
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('You have selected $selectedCount key result(s):'),
              SizedBox(height: 16.h),
              ...keyResultsController.getSelectedKeyResults().map((result) =>
                  Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: AppColors.primaryGreen.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 20),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(result.title ?? 'Unknown',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  )),
                              if (result.description != null)
                                Text(result.description!,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
              ).toList(),
            ],
          );
        }),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Allow re-selection
              Get.toNamed(AppRoutes.keyResultsScreen);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: Text('Edit Selection'),
          ),
        ],
        actionsPadding: EdgeInsets.all(16.w),
      ),
    );
  }

  /// ✅ Innovative Strategies Dialog
  void _showInnovativeStrategiesDialog(BuildContext context, {required int strategyId}) {
    final innovativeViewModel = Get.find<InnovativeStrategiesViewModel>();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.lightbulb_outline, color: AppColors.primaryBlue, size: 24),
              SizedBox(width: 12.w),
              Text(
                'Innovative Strategies',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        content: Obx(() {
          if (innovativeViewModel.isLoading.value) {
            return SizedBox(
              width: 280.w,
              height: 200.h,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Loading innovative strategies...',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (innovativeViewModel.errorMessage.isNotEmpty) {
            return SizedBox(
              width: double.maxFinite,
              height: 200.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  SizedBox(height: 16.h),
                  Text('Failed to Load',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(height: 8.h),
                  Text(innovativeViewModel.errorMessage.value,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.red[700],
                      )),
                  SizedBox(height: 16.h),
                  ElevatedButton.icon(
                    onPressed: () => innovativeViewModel.fetchInnovativeStrategies(strategyId),
                    icon: Icon(Icons.refresh, size: 18),
                    label: Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          if (innovativeViewModel.innovativeStrategies.isEmpty) {
            return SizedBox(
              width: double.maxFinite,
              height: 200.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
                  SizedBox(height: 16.h),
                  Text('No Strategies Found',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      )),
                  SizedBox(height: 8.h),
                  Text('No innovative strategies available for this selection.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[500],
                      )),
                ],
              ),
            );
          }

          return SizedBox(
            width: double.maxFinite,
            height: 400.h,
            child: Column(
              children: [
                // Summary
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.primaryBlue, size: 16),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'Found ${innovativeViewModel.innovativeStrategies.length} strategy(s)',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                // Strategies List
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: innovativeViewModel.innovativeStrategies.length,
                    itemBuilder: (context, index) {
                      final strategy = innovativeViewModel.innovativeStrategies[index];
                      return _buildStrategyCard(context, strategy, index + 1);
                    },
                  ),
                ),
              ],
            ),
          );
        }),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close', style: TextStyle(color: AppColors.textSecondary)),
          ),
          Obx(() => ElevatedButton.icon(
            onPressed: innovativeViewModel.isLoading.value
                ? null
                : () => innovativeViewModel.fetchInnovativeStrategies(strategyId),
            icon: Icon(Icons.refresh, size: 18),
            label: Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.primaryBlue.withOpacity(0.5),
            ),
          )),
        ],
        actionsPadding: EdgeInsets.all(16.w),
      ),
    );

    // Fetch data after dialog shown
    Future.delayed(Duration.zero, () {
      if (innovativeViewModel.innovativeStrategies.isEmpty &&
          !innovativeViewModel.isLoading.value) {
        innovativeViewModel.fetchInnovativeStrategies(strategyId);
      }
    });
  }

  Widget _buildStrategyCard(BuildContext context, InnovativeStrategy strategy, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Strategy Header
            Row(
              children: [
                Container(
                  width: 24.w,
                  height: 24.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryRed,
                  ),
                  child: Text(
                    '$index',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    strategy.keyResult,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryRed,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Innovative Items
            if (strategy.firstInnovative != null)
              _buildInnovativeItem(context, '1. ', strategy.firstInnovative!),
            if (strategy.secondInnovative != null)
              _buildInnovativeItem(context, '2. ', strategy.secondInnovative!),
            if (strategy.thirdInnovative != null)
              _buildInnovativeItem(context, '3. ', strategy.thirdInnovative!),

            // No items message
            if (strategy.firstInnovative == null &&
                strategy.secondInnovative == null &&
                strategy.thirdInnovative == null)
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.grey),
                    SizedBox(width: 8.w),
                    Text(
                      'No innovative items available',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInnovativeItem(BuildContext context, String number, InnovativeItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.03),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number${item.title}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryBlue,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            item.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}



// other file from  team ano

//import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../../../controllers/contextual_challange_controller.dart';
// import '../../../controllers/journey_controller.dart';
// import '../../../controllers/key_objective_controller.dart';
// import '../../../controllers/key_results_controller.dart';
// import '../../../core/app_colors.dart';
// import '../../../data/repositories/storage_repository.dart';
// import '../../../generated/models/responses/contexual_challenge/innovation_model.dart';
// import '../../../view_model/challenge_view_model/contextual_challenge_view_model.dart';
// import '../../../view_model/challenge_view_model/innovative_view_model.dart';
// import '../../routes/app_routes.dart';
// import '../../widgets/custom_adjustment_container.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_home_navbar.dart';
// import '../../widgets/custom_market_distribution_card.dart';
// import '../../widgets/custom_objective_container.dart';
// import '../../widgets/screens_unique_parts/custom_background.dart';
// import '../../widgets/screens_unique_parts/custom_header.dart';
//
// class ContextualChallengeScreen extends StatelessWidget {
//   const ContextualChallengeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final challengeViewModel = Get.put(ChallengeViewModel());
//     final innovative = Get.put(InnovativeStrategiesViewModel());
//
//     final controller = Get.put(ContextualChallengeController());
//     final journeyController = Get.find<JourneyController>();
//     Get.lazyPut(() => KeyObjectiveController());
//     Get.lazyPut(() => KeyResultsController());
//
//     final size = MediaQuery.of(context).size;
//     final width = size.width;
//     final height = size.height;
//     final orientation = MediaQuery.of(context).orientation;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: CustomBackground(
//         child: OrientationBuilder(
//           builder: (context, orientation) => Stack(
//             children: [
//               /// Scrollable Content
//               Positioned.fill(
//                 child: SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   padding: EdgeInsets.only(bottom: height * 0.001),
//                   child: Column(
//                     children: [
//                       /// Header
//                       CustomHeader(
//                         title: 'contextual'.tr,
//                         highlightedText: 'challenge'.tr,
//                         subtitle: ''.tr,
//                         onBackTap: () =>
//                             Get.toNamed(AppRoutes.aiAnalysisShowScreen),
//                       ),
//
//                       SizedBox(height: height * 0.025),
//
//                       Center(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             'adapt_strategy_to_challenge'.tr,
//                             style: Theme.of(context).textTheme.headlineSmall
//                                 ?.copyWith(
//                                   color: AppColors.black,
//                                   height: 1.2,
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: height * 0.025),
//
//                       /// Challenge Alert
//                       Obx(() {
//                         return Padding(
//                             padding: EdgeInsets.symmetric(horizontal: width * 0.05),
//                             child: CustomMarketDisruptionCard(
//                               icon: Icons.warning_amber_rounded,
//                               title: challengeViewModel.marketDisruptionTitle,
//                               description: challengeViewModel.marketDisruptionDescription,
//                               warningText: 'revenue_drop_warning'.tr,
//                               warningIcon: Icons.trending_down,
//                             )
//                         );
//                       }),
//
//                       SizedBox(height: height * 0.025),
//
//
//                       SizedBox(height: height * 0.001),
//
//                       /// Adapt Section
//                       Center(
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             children: [
//                               Text(
//                                 'adapt_you'.tr,
//                                 style: Theme.of(context).textTheme.headlineSmall
//                                     ?.copyWith(
//                                       color: AppColors.primaryRed,
//                                       height: 1.2,
//                                     ),
//                                 textAlign: TextAlign.center,
//                               ),
//                               SizedBox(height: 6.h),
//                               Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 8.w),
//                                 child: Text(
//                                   'readjust_strategy'.tr,
//                                   style: Theme.of(context).textTheme.bodyMedium
//                                       ?.copyWith(
//                                         color: AppColors.black,
//                                         height: 1.0,
//                                       ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//
//                       SizedBox(height: height * 0.001),
//
//                       /// Current Strategy & Related Containers
//                       /// 🔹 Combined Container for all strategy sections
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: width * 0.05),
//                         child: Container(
//                           width: double.infinity,
//                           padding: EdgeInsets.all(16.w),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(16.r),
//                             border: Border.all(color: AppColors.grey.withOpacity(0.4)),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 6,
//                                 offset: const Offset(0, 3),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               /// 🔸 Current Strategy
//                               CustomAdjustmentContainer(
//                                 icon: Icons.track_changes,
//                                 iconColor: AppColors.primaryRed,
//                                 title: 'current_strategy'.tr,
//                                 description: 'development_new_markets'.tr,
//                               ),
//
//                               Divider(height: 20.h, color: AppColors.grey.withOpacity(0.4)),
//
//                               /// 🔸 Objective
//                               CustomAdjustmentContainer(
//                                 icon: Icons.flag,
//                                 iconColor: AppColors.primaryRed,
//                                 title: 'objective'.tr,
//                                 description: 'expand_emerging_markets'.tr,
//                                 actionText: 'modify'.tr,
//                                 actionColor: AppColors.primaryBlue,
//                                 onActionTap: () {
//                                   // TODO: open objective editing dialog
//                                 },
//                               ),
//
//                               Divider(height: 20.h, color: AppColors.grey.withOpacity(0.4)),
//
//                               /// 🔸 Key Results
//                               CustomAdjustmentContainer(
//                                 icon: Icons.flag,
//                                 iconColor: AppColors.primaryGreen,
//                                 title: 'key_results'.tr,
//                                 actionText: 'adjust'.tr,
//                                 actionColor: AppColors.primaryBlue,
//                                 onActionTap: () {},
//
//                               ),
//
//                               Divider(height: 20.h, color: AppColors.grey.withOpacity(0.4)),
//
//                               /// 🔸 Initiatives
//                               // Update the Initiatives section in your existing ContextualChallengeScreen
//
//                               /// 🔸 Initiatives
//                               CustomAdjustmentContainer(
//                                 icon: Icons.rocket_launch,
//                                 iconColor: AppColors.primaryRed,
//                                 title: 'initiatives'.tr,
//                                 actionText: 'revise'.tr,
//                                 actionColor: AppColors.primaryBlue,
//                                 onActionTap: () {
//                                   _showInnovativeStrategiesDialog(context);
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//
//
//
//                       SizedBox(height: height * 0.003),
//
//                       /// Propose Adjustment Button
//                       Center(
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(
//                             vertical: width * 0.05.w,
//                             horizontal: height * 0.05.h,
//                           ),
//                           child: CustomButton(
//                             text: 'propose_adjustment'.tr,
//                             onPressed: () {
//                               Get.toNamed(AppRoutes.contextualCAdjustment);
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               /// Home Navbar
//               Positioned(
//                 right: width * -0.07,
//                 top: height * 0.5,
//                 child: const CustomHomeNavBar(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// 🔹 Key Result Item
//   Widget _buildResultItem(
//     BuildContext context,
//     String text, {
//     bool highlight = false,
//   }) => Container(
//     width: double.infinity,
//     margin: EdgeInsets.only(bottom: 8.h),
//     padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(12.r),
//       border: Border.all(
//         color: highlight
//             ? AppColors.primaryRed
//             : AppColors.grey.withOpacity(0.5),
//         width: highlight ? 1.5 : 1,
//       ),
//       color: Colors.white,
//     ),
//     child: Text(
//       text,
//       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//         color: highlight ? AppColors.primaryRed : AppColors.textSecondary,
//         fontWeight: highlight ? FontWeight.w600 : FontWeight.w400,
//       ),
//     ),
//   );
//
//   /// 🔹 Initiative Item
//   Widget _buildInitiativeItem(
//     BuildContext context,
//     int number,
//     String title,
//     String subtitle,
//   ) => Container(
//     width: double.infinity,
//     margin: EdgeInsets.only(bottom: 8.h),
//     padding: EdgeInsets.all(12.w),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(12.r),
//       border: Border.all(color: AppColors.grey.withOpacity(0.4)),
//       color: Colors.white,
//     ),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         /// Number Circle
//         Container(
//           width: 28.w,
//           height: 28.w,
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: AppColors.primaryRed,
//           ),
//           child: Text(
//             '$number',
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         SizedBox(width: 12.w),
//
//         /// Title + Subtitle
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.primaryRed,
//                 ),
//               ),
//               SizedBox(height: 4.h),
//               Text(
//                 subtitle,
//                 style: Theme.of(
//                   context,
//                 ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
//   void _showInnovativeStrategiesDialog(BuildContext context) {
//     final innovativeViewModel = Get.put(InnovativeStrategiesViewModel());
//     final storageRepository = Get.find<StorageRepository>();
//
//     // Get strategy ID - you might need to adjust this based on your app structure
//     int strategyId = 4; // Default value, replace with dynamic value if needed
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Innovative Strategies'),
//         content: Obx(() {
//           if (innovativeViewModel.isLoading.value) {
//             return Center(child: CircularProgressIndicator());
//           }
//
//           if (innovativeViewModel.errorMessage.isNotEmpty) {
//             return Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.error, color: Colors.red, size: 48),
//                 SizedBox(height: 16),
//                 Text('Error: ${innovativeViewModel.errorMessage.value}'),
//               ],
//             );
//           }
//
//           return Container(
//             width: double.maxFinite,
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: innovativeViewModel.innovativeStrategies.length,
//               itemBuilder: (context, index) {
//                 final strategy = innovativeViewModel.innovativeStrategies[index];
//                 return _buildStrategyCard(context, strategy);
//               },
//             ),
//           );
//         }),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text('Close'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               innovativeViewModel.fetchInnovativeStrategies(strategyId);
//             },
//             child: Text('Refresh'),
//           ),
//         ],
//       ),
//     ).then((_) {
//       // Fetch data when dialog is shown
//       innovativeViewModel.fetchInnovativeStrategies(strategyId);
//     });
//   }
//
//   Widget _buildStrategyCard(BuildContext context, InnovativeStrategy strategy) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 8),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               strategy.keyResult,
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.primaryRed,
//               ),
//             ),
//             SizedBox(height: 12),
//
//             if (strategy.firstInnovative != null)
//               _buildInnovativeItem(context, '1.', strategy.firstInnovative!),
//
//             if (strategy.secondInnovative != null)
//               _buildInnovativeItem(context, '2.', strategy.secondInnovative!),
//
//             if (strategy.thirdInnovative != null)
//               _buildInnovativeItem(context, '3.', strategy.thirdInnovative!),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInnovativeItem(BuildContext context, String number, InnovativeItem item) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '$number ${item.title}',
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           SizedBox(height: 4),
//           Text(
//             item.description,
//             style: Theme.of(context).textTheme.bodySmall?.copyWith(
//               color: AppColors.textSecondary,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }