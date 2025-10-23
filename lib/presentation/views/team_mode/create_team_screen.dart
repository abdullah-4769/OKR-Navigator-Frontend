import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../../../controllers/team_mode_controller/create_team_controller.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_circular_avatar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

class CreateTeamScreen extends StatelessWidget {
  const CreateTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateTeamController());
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      body: CustomBackground(
        child: SafeArea(
          child: OrientationBuilder(
            builder: (context, orientation) => Stack(
              children: [
                /// ---------- SCROLLABLE CONTENT ----------
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: height * 0.014),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      SizedBox(height: height * 0.01),
                      /// ---------- HEADER ----------
                      CustomHeader(
                        title: 'Create'.tr,
                        highlightedText: "New team".tr,
                        showDashboardIcon: false,
                        onBackTap: () => Get.back(),
                      ),

                      SizedBox(height: height * 0.02),

                      /// ---------- FORM AREA ----------
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /// Team Name
                            _roundedField(
                              context,
                              controller: controller.teamNameController,
                              hint: "enter_team_name".tr,
                              maxLines: 1,
                            ),
                            SizedBox(height: height * 0.02),

                            /// Team Mission
                            _roundedField(
                              context,
                              controller: controller.teamMissionController,
                              hint: "describe_your_team_mission".tr,
                              maxLines: 4,
                            ),
                            SizedBox(height: height * 0.035),

                            /// ---------- AVATAR SELECTION ----------
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "choose_team_avatar".tr,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.015),

                            SizedBox(
                              height: width * 0.25,
                              child: Obx(
                                    () => ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.avatars.length,
                                  separatorBuilder: (_, __) => SizedBox(width: width * 0.04),
                                  itemBuilder: (context, index) => CustomCircularAvatar(
                                    imagePath: controller.avatars[index],
                                    size: 70,
                                    innerColors: const [
                                      Colors.white,
                                      Colors.amber,
                                      Colors.orange,
                                    ],
                                    borderGradient: index == 0
                                        ? const [Colors.red, Colors.orange] // only first avatar
                                        : null, // others have no border
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: height * 0.035),

                            /// ---------- JOIN EXISTING TEAM ----------
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(width * 0.04),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: AppColors.textSecondary.withOpacity(0.2),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: AppColors.primaryRed,
                                        child: Icon(Icons.groups,
                                            color: AppColors.white),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        "join_existing_team".tr,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(color: AppColors.black),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                   "team_code".tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: AppColors.black),
                                  ),
                                  SizedBox(height: 12.h),

                                  TextField(
                                    controller: controller.teamCodeController,
                                    decoration: InputDecoration(
                                      hintText: "enter_team_code".tr,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16.w, vertical: 14.h),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(12.r),
                                        borderSide: BorderSide(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  CustomButton(
                                    backgroundColor: AppColors.primaryBlue,
                                    textColor: Colors.white,
                                    text: "join_team".tr,
                                    onPressed: controller.joinTeam,
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: height * 0.035),

                            /// ---------- CONTINUE ----------
                            Obx(() => CustomButton(
                              backgroundColor: AppColors.primaryRed,
                              textColor: Colors.white,
                              text: controller.isLoading.value ? "Creating...".tr : "continue".tr,
                              onPressed: controller.isLoading.value ? () {} : controller.continueCreateTeam,
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /// ---------- FLOATING NAV ----------
                Positioned(
                  right: -size.width * 0.05,
                  top: size.height * 0.45,
                  child: const CustomHomeNavBar(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _roundedField(BuildContext context,
      {required TextEditingController controller,
        required String hint,
        int maxLines = 1}) =>
      TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: AppColors.softRed.withOpacity(0.7),
          contentPadding:
          EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.r),
            borderSide: BorderSide(color: AppColors.softRed, width: 1.2),
          ),
        ),
      );
}
