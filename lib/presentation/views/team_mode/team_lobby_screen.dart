import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/widgets/custom_button2.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../../../controllers/team_mode_controller/team_lobby_controller.dart';

import '../../widgets/bubble_button.dart';
import '../../widgets/global_widgets/custom_progress_path.dart';
import '../../widgets/scoreboard_widgets/custom_rank_container.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import '../../widgets/custom_circular_avatar.dart';
import '../../widgets/custom_button.dart';

class TeamLobbyScreen extends StatelessWidget {
  const TeamLobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TeamLobbyController());
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: CustomBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: height * 0.015),
                      /// 🔻 Header
                      CustomHeader(
                        title: 'Team'.tr,
                        highlightedText: "Lobby".tr,
                        showDashboardIcon: true,
                        onBackTap: () => Get.back(),
                      ),


                      SizedBox(height: height * 0.01),
                      /// 🔻 Team Avatar with bubble
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CustomCircularAvatar(
                            imagePath: 'assets/images/role_icon.png',
                            size: 150,
                            innerColors: const [
                              Colors.yellow,
                              Colors.orange,
                              Colors.red,
                            ],
                            borderGradient:  [
                AppColors.primaryRed.withOpacity(0.9),
                AppColors.primaryRed.withOpacity(0.3),
                            ],
                          ),


                        ],
                      ),

                      SizedBox(height: height * 0.015),




                      Container(
                width: double.infinity, // ✅ take all available width
                margin: EdgeInsets.symmetric(horizontal: width * 0.06), // ✅ small safe side margin
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppColors.softRed.withValues(alpha: 0.5),
                  border: Border.all(color: AppColors.primaryRed, width: 0.5),
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Team Code: ",
                      style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
                    ),
                    Row(
                      children: [
                        Text(
                          "ABC123",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryRed,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        CircleAvatar(
                          radius: 16.r,
                          backgroundColor: AppColors.primaryRed,
                          child: Icon(Icons.copy, size: 18.sp, color: AppColors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),


              SizedBox(height: height * 0.015),

                      /// 🔻 Waiting Text
                      Text(
                        "Waiting for others to join...",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                        ),
                      ),

                      SizedBox(height: height * 0.02),

                      /// 🔻 Members Joined Progress
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: width * 0.06),
                        child: Center(
                          child: Column(
                            children: [
                              Row( mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.groups,
                                      color: AppColors.primaryRed),
                                  SizedBox(width: 6.w),
                                  Text(
                                    "3 Members Joined",
                                    style: TextStyle(
                                      color: AppColors.primaryRed,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              const CustomProgressPath(
                                stepLabels: ["1", "2", "3", "4", "5"],
                                currentStep: 2,
                                showCircles: false,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.02),

                      /// 🔻 Start Game text
                      Text(
                        "Start Game (Minimum 2 players required)",
                        style: TextStyle(
                            color: AppColors.primaryRed,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500),
                      ),

                      SizedBox(height: height * 0.02),

                      /// 🔻 Players List
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: width * 0.06),
                        child: Column(
                          children: [
                            const CustomRankContainer(
                              rank: 1,
                              name: "You",
                              level: 5,
                              points: 100,
                              score: 80,
                              isHighlighted: true,
                            ),
                            const CustomRankContainer(
                              rank: 2,
                              name: "Johnson",
                              level: 5,
                              points: 90,
                              score: 60,
                            ),
                            const CustomRankContainer(
                              rank: 3,
                              name: "Tasha",
                              level: 5,
                              points: 70,
                              score: 55,
                            ),

                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(48.r),
                                border: Border.all(color: AppColors.primaryRed, width: 1),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // ➕ Icon
                                  Container(
                                    width: 34.w,
                                    height: 34.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppColors.primaryRed, width: 1.5),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 16.sp,
                                      color: AppColors.primaryRed,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),

                                  // 📝 Texts
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Waiting for player...",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      Text(
                                        "Invite someone to join",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: AppColors.textSecondary.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )

                          ],
                        ),
                      ),

                      SizedBox(height: height * 0.03),

                      /// 🔻 Buttons
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: width * 0.1),
                        child: Column(
                          children: [
                            Obx(() {
                              final hasEnoughPlayers = controller.players.length >= 2;
                              return CustomButton2(
                                backgroundColor: hasEnoughPlayers
                                    ? AppColors.primaryBlue
                                    : AppColors.textSecondary.withOpacity(0.3),
                                textColor: Colors.white,
                                text: "Begin Mission".tr,
                                onPressed: hasEnoughPlayers ? controller.beginMission : null,
                              );
                            }),


                            SizedBox(height: 10.h),
                            CustomButton(
                              backgroundColor: AppColors.primaryRed,
                              textColor: Colors.white,
                              text: "Invite Members".tr,
                              onPressed: controller.inviteMembers,
                            ),
                            SizedBox(height: 10.h),
                            CustomButton(
                              backgroundColor: AppColors.primaryBlue,
                              textColor: Colors.white,
                              text: "Edit Team Info".tr,
                              onPressed: () => Get.back(),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: height * 0.04),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
