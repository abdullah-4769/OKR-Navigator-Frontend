import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:game_app/presentation/widgets/custom_button.dart';
import 'package:game_app/presentation/widgets/custom_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_dimensions.dart';
import '../../../widgets/custom_objective_container.dart';
import '../../../widgets/screens_unique_parts/custom_background.dart';
import '../../../widgets/screens_unique_parts/custom_header.dart';
import '../../../widgets/team_mode_widgets/custom_available_roles.dart';
import '../../../widgets/custom_circular_avatar.dart'; // ✅ NEW import

class AssignRolesScreen extends StatelessWidget {
  const AssignRolesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: height * 0.015),

                /// ---------- HEADER ----------
                CustomHeader(
                  title: 'Assign'.tr,
                  highlightedText: "Roles".tr,
                  onBackTap: () => Navigator.pop(context),
                ),

                SizedBox(height: height * 0.015),
                /// ---------- MAIN CONTENT ----------

                   Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppDimensions.d16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Team Avatar + Time Limit
                        Center(
                          child: Column(
                            children: [
                              /// Larger solo icon
                              Center(
                                child: CustomCircularAvatar(
                                  imagePath: 'assets/images/role_icon.png',
                                  innerColors: [
                                    Colors.yellow.shade100,
                                    Colors.orange.shade100,
                                    Colors.lightGreenAccent,
                                  ],
                                  borderGradient: [
                                    AppColors.primaryRed.withOpacity(0.9),
                                    AppColors.primaryRed.withOpacity(0.3),
                                  ],
                                  size: 150,
                                ),
                              ),
                              SizedBox(height: height * 0.015),

                              /// Time limit inside styled container
                              CustomObjectiveContainer(
                                title: '',
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppDimensions.d16.w,
                                    vertical: AppDimensions.d8.h,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Time Limit'.tr,
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: AppColors.grey,
                                        ),
                                      ),
                                      Text(
                                        '5:00',
                                        style: textTheme.titleLarge?.copyWith(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: height * 0.015),

                              /// Description
                              SizedBox(
                                width: width * 0.8,
                                child: Text(
                                  'Assign roles to optimize team performance'.tr,
                                  textAlign: TextAlign.center,
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: height * 0.025),

                        /// Available Roles
                        const CustomAvailableRoles(),

                        SizedBox(height: height * 0.03),

                        /// Team Members heading
                        Center(
                          child: Text(
                            'Team Members'.tr,
                            style: textTheme.headlineLarge?.copyWith(
                              color: AppColors.primaryRed,
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.015),

                        /// Team member cards
                        _buildMemberCard(context, 'Johnson', 'Level 5'),
                        SizedBox(height: height * 0.015),
                        _buildMemberCard(context, 'Tasha', 'Level 5'),

                        SizedBox(height: height * 0.03),

                        /// Pro Tip
                        CustomObjectiveContainer(
                          icon: Icons.lightbulb,
                          title: 'Pro Tip'.tr,
                          description:
                          'Different roles have unique abilities and perspectives. Balance your team with complementary skills for better OKR outcomes.'
                              .tr,
                        ),

                        SizedBox(height: height * 0.03),

                        Center(
                          child: CustomButton(
                            text: 'Begin Mission'.tr,
                            onPressed: () {
                              Get.toNamed(AppRoutes.teamObjectiveSelectionScreen);
                            },
                          ),
                        ),
                        SizedBox(height: height * 0.02),

                        Center(
                          child: CustomButton(
                            text: 'Auto Assign Roles'.tr,
                            onPressed: () {},
                            backgroundColor: AppColors.primaryBlue,
                          ),
                        ),

                        SizedBox(height: height * 0.04),
                      ],
                    ),
                  ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Reusable team member card
  Widget _buildMemberCard(BuildContext context, String name, String level) {
    final textTheme = Theme.of(context).textTheme;
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      padding: EdgeInsets.all(AppDimensions.d16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.d16.r),
        border: Border.all(color: AppColors.grey.withOpacity(.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Avatar + name
          Row(
            children: [
              CustomCircularAvatar(
                imagePath: 'assets/images/role_icon.png',
                innerColors: [
                  Colors.yellow.shade100,
                  Colors.orange.shade100,
                  Colors.lightGreenAccent,
                ],
                borderGradient: [
                  AppColors.primaryRed.withOpacity(0.9),
                  AppColors.primaryRed.withOpacity(0.3),
                ],
                size: 30,
              ),

              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      level,
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          /// Heading above dropdown
          Text(
            'Assign Role'.tr,
            style: textTheme.titleSmall?.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.h),

          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              hintText: 'Select a role...'.tr,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 10.h,
              ),
            ),
            items: [
              'CEO',
              'Strategist',
              'HR Manager',
              'Analyst',
              'Team Lead',
              'Manager',
            ]
                .map((e) => DropdownMenuItem(
              value: e,
              child: Text(
                e,
                style: textTheme.titleSmall?.copyWith(
                  color: AppColors.black,
                ),
              ),
            ))
                .toList(),
            onChanged: (val) {
              // TODO: Handle role selection
            },
          ),
        ],
      ),
    );
  }
}
