import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/journey_controller.dart';
import '../../../controllers/key_objective_controller.dart';
import '../../../controllers/key_results_controller.dart';
import '../../../controllers/team_mode_controller/team_contextual_challange_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_adjustment_container.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_market_distribution_card.dart';
import '../../widgets/custom_objective_container.dart';
import '../../widgets/responsive_arrow.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import '../../../controllers/team_mode_controller/team_strategy_selection_controller.dart';

class TeamContextualChallengeScreen extends StatelessWidget {
	const TeamContextualChallengeScreen({super.key});

    // ✅ NEW HELPER FUNCTION: Safely handles translations and raw strings
    String _safeTranslate(String? text, {String fallback = ''}) {
        if (text == null || text.isEmpty) return fallback.tr;
        try {
          // If the string contains a space, treat it as raw content (e.g., user input/API description)
          if (text.contains(' ')) return text; 
          return text.tr;
        } catch (e) {
          return text; // Fallback to raw string if translation fails
        }
    }
    
	@override
	Widget build(BuildContext context) {
		
		final controller = Get.put(TeamContextualChallengeController());
    final strategyController = Get.find<TeamStrategySelectionController>();
		final size = MediaQuery.of(context).size;
		final width = size.width;
		final height = size.height;

		return Scaffold(
			backgroundColor: Colors.white,
			body: CustomBackground(
				child: OrientationBuilder(
					builder: (context, orientation) => Stack(
						children: [
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
													Get.offAllNamed(AppRoutes.aiAnalysisShowScreen),
											),


											SizedBox(height: height * 0.02),

											/// Challenge Alert
											Padding(
												padding: EdgeInsets.symmetric(horizontal: width * 0.05.w),
												child: CustomObjectiveContainer(
													icon: Icons.add_alert,
													title: 'challenge_alert'.tr,
													subtitle: '',
													description: 'adaptation_required'.tr,
													titleColor: AppColors.primaryRed,
												),
											),
											SizedBox(height: height * 0.015.h),
											const ResponsiveArrow(),
											SizedBox(height: height * 0.002.h),

											/// Market Disruption
											Padding(
												padding: EdgeInsets.symmetric(horizontal: width * 0.05),
												child: CustomMarketDisruptionCard(
													icon: Icons.flash_on,
													title: "market_disruption_challenge".tr,
													description: "competitor_launched_product".tr,
													warningText: "revenue_drop_warning".tr,
													warningIcon: Icons.trending_down,
												),
											),

											SizedBox(height: height * 0.02),

											/// Adapt Section (Text)
											Padding(
												padding: const EdgeInsets.all(16.0),
												child: Column(
													children: [
														Text(
															'adapt_you'.tr,
															style: Theme.of(context)
																.textTheme
																.headlineLarge
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
																	.bodySmall
																	?.copyWith(
																	fontSize: 14.sp,
																	color: AppColors.black,
																	height: 1.0,
																),
																textAlign: TextAlign.center,
															),
														),
													],
												),
											),

											SizedBox(height: height * 0.02),

											/// Current Strategy & Related Containers (DYNAMIC CONTENT HERE)
											Obx(() => Padding( // ✅ WRAP IN OBX
												padding: EdgeInsets.symmetric(horizontal: width * 0.05),
												child: Column(
													children: [
														/// Current Strategy (Assumed to be static for now, fetched from the Strategy controller)
                            Builder(
                              builder: (_) {
                                final strategyTitle = strategyController.strategyDisplayTitle;
                                final description = strategyTitle.isNotEmpty
                                    ? strategyTitle
                                    : 'No strategy selected yet';

                                return CustomAdjustmentContainer(
                                  icon: Icons.track_changes,
                                  iconColor: AppColors.primaryRed,
                                  title: "current_strategy".tr,
                                  description: description,
                                );
                              },
                            ),

														SizedBox(height: 4.h),

														/// Objective (MODIFY) - DYNAMIC
														CustomAdjustmentContainer(
															icon: Icons.flag,
															iconColor: AppColors.primaryRed,
															title: "objective".tr,
                                                            // ✅ DYNAMIC: Use controller getter
															description: _safeTranslate(controller.currentObjectiveDescription),
															actionText: "modify".tr,
															actionColor: AppColors.primaryBlue,
															onActionTap: controller.modifyObjective, 
														),

														SizedBox(height: 4.h),

														/// Key Results (ADJUST) - DYNAMIC
														CustomAdjustmentContainer(
															icon: Icons.flag,
															iconColor: AppColors.primaryGreen,
															title: "key_results".tr,
															actionText: "adjust".tr,
															actionColor: AppColors.primaryBlue,
															onActionTap: controller.adjustKeyResults,
															children: [
                                                                // ✅ DYNAMIC: Loop through live Key Results
																...controller.displayKeyResults.asMap().entries.map((entry) {
                                                                    final index = entry.key;
                                                                    final kr = entry.value;
                                                                    return _buildResultItem(
                                                                        context,
                                                                        _safeTranslate(kr['title']!, fallback: kr['description']!),
                                                                        highlight: index == 0,
                                                                    );
                                                                }).toList(),
															],
														),

														/// Initiatives (REVISE) - DYNAMIC
														CustomAdjustmentContainer(
															icon: Icons.rocket_launch, 
															iconColor: AppColors.primaryRed, 
															title: "initiatives".tr, 
															actionText: "revise".tr, 
															actionColor: AppColors.primaryBlue,
															onActionTap: controller.reviseInitiatives, 
															children: [
                                                                // ✅ DYNAMIC: Loop through live Initiatives
																...controller.displayInitiatives.asMap().entries.map((entry) {
                                                                    final index = entry.key;
                                                                    final init = entry.value;
                                                                    return _buildInitiativeItem(
                                                                        context,
                                                                        index + 1,
                                                                        _safeTranslate(init['title']!),
                                                                        _safeTranslate(init['description']!),
                                                                    );
                                                                }).toList(),
															],
														),
													],
												),
											)),

											/// Propose Adjustment Button
											Center(
												child: Padding(
													padding: EdgeInsets.symmetric(
														vertical: width * 0.05.w,
														horizontal: height * 0.05.h,
													),
													child: CustomButton(
														icon: Icons.settings,
														text: 'propose_adjustment'.tr,
														onPressed: controller.proposeAdjustments,
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

	Widget _buildResultItem(BuildContext context, String text,
			{bool highlight = false}) =>
			Container(
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
						color: highlight
								? AppColors.primaryRed
								: AppColors.textSecondary,
						fontWeight:
						highlight ? FontWeight.w600 : FontWeight.w400,
					),
				),
			);

	Widget _buildInitiativeItem(
			BuildContext context, int number, String title, String subtitle) =>
			Container(
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
								style: Theme.of(context)
										.textTheme
										.bodyMedium
										?.copyWith(
									color: Colors.white,
									fontWeight: FontWeight.bold,
								),
							),
						),
						SizedBox(width: 12.w),
						Expanded(
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(
										title,
										style: Theme.of(context)
												.textTheme
												.bodyMedium
												?.copyWith(
											fontWeight: FontWeight.bold,
											color: AppColors.primaryRed,
										),
									),
									SizedBox(height: 4.h),
									Text(
										subtitle,
										style: Theme.of(context)
												.textTheme
												.bodySmall
												?.copyWith(
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
