import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/custom_circular_avatar.dart';
import '../../../controllers/team_mode_controller/team_achievements_controller.dart';
import '../../widgets/screens_unique_parts/custom_header.dart'; // ✅ Added

class TeamAchievementsScreen extends StatelessWidget {
  const TeamAchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TeamAchievementsController());
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: CustomBackground(
        child: SafeArea(
          child: OrientationBuilder(
            builder: (context, orientation) => Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: size.height * 0.14),
                    child: Obx(() => Column( 
                      children: [
                        /// ---------- HEADER ----------
                        CustomHeader(
                          title: controller.teamName.value, // DYNAMIC Team Name
                          highlightedText: 'achievements'.tr,
                          onBackTap: () => Get.offAllNamed(AppRoutes.teamScoreboardScreen),
                        ),

                        SizedBox(height: size.height * 0.02),


                        /// ---------- TEAM AVATAR & INFO ----------
                        Center(
                          child: Column(
                            children: [
                              // ... (Avatar remains static for appearance) ...
                              Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  color: AppColors.softRed.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: AppColors.primaryRed),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 140,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      color: Colors.yellowAccent,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: 110,
                                        height: 110,
                                        decoration: BoxDecoration(
                                          color: Colors.limeAccent.withValues(alpha: 0.9),
                                          borderRadius: BorderRadius.circular(100),
                                        ),
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
                                          size: 120,
                                        ),

                                      ),
                                    ),
                                  ),
                                ),
                              ),


                              SizedBox(height: 6.h),
                              Text("⭐ ${controller.points.value} ${'points'.tr}", // DYNAMIC Points
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: AppColors.primaryRed,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ),

                        SizedBox(height: 24.h),

                        /// ---------- STATS ----------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _statCard("${controller.badges.value}", "badges".tr, 'assets/images/badge.png'), // DYNAMIC
                            _statCard("${controller.trophies.value}", "trophies".tr, 'assets/images/trophy.png'), // DYNAMIC
                            _statCard("${controller.games.value}", "games".tr, 'assets/images/game.png'), // DYNAMIC
                          ],
                        ),

                        SizedBox(height: 24.h),

                        /// ---------- RECENT ACHIEVEMENTS ----------
                        _sectionCard(
                          context,
                          title: "recent_achievements".tr,
                          items: controller.recentAchievements, // DYNAMIC
                        ),

                        /// ---------- RECENT GAMES ----------
                        _gamesCard(
                          context,
                          games: controller.recentGames, // DYNAMIC
                        ),
                      ],
                    ),

                    /// ---------- FLOATING NAV ----------
                  )
                  ),
                    Positioned(
                      right: -size.width * 0.05,
                      top: size.height * 0.45,
                      child:  CustomHomeNavBar(),
                    ),
                  ],
                ),
              ),
          ),
        ));
  }

  Widget _statCard(String value, String label, String assetPath) => Container(
      width: 100.w,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Image.asset(assetPath, height: 36.h, width: 36.w),
          SizedBox(height: 6.h),
          Text(value,
              style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp)),
          Text(label,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12.sp)),
        ],
      ),
    );

  Widget _sectionCard(BuildContext context, {required String title, required List<String> items}) => Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 18.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.primaryRed),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    )),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ],
          ),
          SizedBox(height: 12.h),
          ...items.map((e) => Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14.r,
                  backgroundColor: AppColors.primaryRed,
                  child: Icon(Icons.check, color: Colors.white, size: 16.sp),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(e.tr, // Ensure translation if items are keys
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ))
        ],
      ),
    );

  Widget _gamesCard(BuildContext context, {required List<Map<String, String>> games}) => Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 18.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.primaryRed),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text("Recent Games",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    )),
              ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
            ],
          ),
          SizedBox(height: 12.h),
          ...games.map((g) => Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18.r,
                  backgroundColor: AppColors.primaryRed.withOpacity(0.2),
                  child: Icon(Icons.group, color: AppColors.primaryRed, size: 20.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(g['title'] ?? '',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.black)),
                      SizedBox(height: 4.h),
                      Text(g['date'] ?? '',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Text("${g['score']} ${'score'.tr}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ))
        ],
      ),
    );
}