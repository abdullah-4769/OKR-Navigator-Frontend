import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';

import '../routes/app_routes.dart';
import '../widgets/custom_home_navbar.dart';
import '../widgets/custom_svg.dart';
import '../widgets/screens_unique_parts/custom_background.dart';
import '../widgets/screens_unique_parts/custom_header.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PersonalAchievementsScreen extends StatelessWidget {
  const PersonalAchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) => OrientationBuilder(
    builder: (context, orientation) {
      final width = MediaQuery.of(context).size.width;
      final height = MediaQuery.of(context).size.height;
      final theme = Theme.of(context);

      return Scaffold(
        backgroundColor: AppColors.white,
        body: CustomBackground(
          child: Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: Column(
                    children: [
                      /// ✅ Reusable Header
                      CustomHeader(
                        title: 'personal'.tr,
                        highlightedText: 'achievements'.tr,
                        onBackTap: () =>
                            Get.offAllNamed(AppRoutes.personalDashboardScreen),
                        showDashboardIcon: true, // ✅ auto profile avatar
                      ),

                      SizedBox(height: height * 0.02),

                      /// Avatar + Level
                      Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.primaryRed, width: 2),
                        ),
                        child: CircleAvatar(
                          radius: width * 0.14,
                          backgroundColor: Colors.white,
                          child: CustomSvg(

                            height: width * 0.2,
                            width: width * 0.2, semanticsLabel:'', assetPath: 'assets/images/solo.svg',
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "strategic_architect".tr,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.bold,
                          fontSize:
                          orientation == Orientation.portrait ? 16.sp : 14.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text("level".trParams({"num": "1"}),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.w600,
                            )),
                      ),

                      SizedBox(height: 12.h),

                      /// Points
                      Text("⭐ 110 ${'points'.tr}",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.bold,
                          )),

                      SizedBox(height: 16.h),

                      /// Stats Row
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: width * 0.08),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: _statCard("12", "badges".tr,
                                    "assets/images/solo.svg")),
                            SizedBox(width: 8.w),
                            Expanded(
                                child: _statCard("16", "trophies".tr,
                                    "assets/images/solo.svg")),
                            SizedBox(width: 8.w),
                            Expanded(
                                child: _statCard("2", "games".tr,
                                    "assets/images/solo.svg")),
                          ],
                        ),
                      ),

                      SizedBox(height: 20.h),

                      /// Recent Achievements
                      _sectionCard(
                        context,
                        title: "recent_achievements".tr,
                        items: [
                          "strategic_thinker".tr,
                          "goal_master".tr,
                          "innovation_expert".tr,
                          "challenge_solver".tr,
                        ],
                      ),

                      /// Recent Games
                      _gamesCard(
                        context,
                        games: [
                          {
                            "title": "solo_campaign".tr,
                            "date": "Jan 15, 2025",
                            "score": "85%"
                          },
                          {
                            "title": "team_challenge".tr,
                            "date": "Jan 12, 2025",
                            "score": "92%"
                          },
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              /// ✅ Floating HomeNavBar
              Positioned(
                right: width * -0.07,
                top: height * 0.45,
                child: const CustomHomeNavBar(),
              ),
            ],
          ),
        ),
      );
    },
  );

  /// ✅ Stat Card
  Widget _statCard(String value, String label, String assetPath) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            assetPath,
            height: 32.h,
            width: 32.w,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: TextStyle(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11.sp,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// ✅ Section Card
  Widget _sectionCard(BuildContext context,
      {required String title, required List<String> items}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.primaryRed.withOpacity(0.4)),
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
                      color: AppColors.primaryBlue,
                    )),
              ),
              const Icon(Icons.arrow_forward_ios,
                  size: 18, color: Colors.grey),
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
                  child: Text(
                    e,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }

  /// ✅ Games Card
  Widget _gamesCard(BuildContext context,
      {required List<Map<String, String>> games}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text("recent_games".tr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    )),
              ),
              const Icon(Icons.arrow_forward_ios,
                  size: 18, color: Colors.grey),
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
                  child: Icon(Icons.person,
                      color: AppColors.primaryRed, size: 20.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(g['title'] ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlue)),
                      SizedBox(height: 4.h),
                      Text(g['date'] ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Text("${g['score']} ${'score'.tr}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
