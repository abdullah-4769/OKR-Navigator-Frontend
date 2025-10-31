import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_circular_avatar.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import '../../routes/app_routes.dart';

class TeamScoreboardSelectScreen extends StatefulWidget {
  const TeamScoreboardSelectScreen({super.key});

  @override
  State<TeamScoreboardSelectScreen> createState() => _TeamScoreboardSelectScreenState();
}

class _TeamScoreboardSelectScreenState extends State<TeamScoreboardSelectScreen> {
  int? selectedIndex;

  final List<Map<String, String>> teams = [
    {"name": "Team Alpha", "icon": "assets/images/role_icon.png"},
    {"name": "Team Mavericks", "icon": "assets/images/role_icon2.png"},
    {"name": "Team Warriors", "icon": "assets/images/role_icon.png"},
    {"name": "Team Innovators", "icon": "assets/images/role_icon2.png"},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomBackground(
        child: SafeArea(
          child: Stack(
            children: [
              /// Scrollable content
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: height * 0.02),
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),

                      /// ---------- HEADER ----------
                      CustomHeader(
                        title: 'Your',
                        highlightedText: 'Scoreboard',
                        subtitle: '',
                        onBackTap: () => Get.back(),
                      ),

                      SizedBox(height: 15.h),

                      /// ---------- SELECT TEAM TITLE ----------
                      Text(
                        'Select Team',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'To view the team scoreboard',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.black,
                        ),
                      ),

                      SizedBox(height: 30.h),

                      /// ---------- TEAM GRID ----------
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: teams.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16.w,
                            mainAxisSpacing: 22.h,
                            childAspectRatio: 0.85,
                          ),
                          itemBuilder: (context, index) {
                            final team = teams[index];
                            final isSelected = selectedIndex == index;

                            return GestureDetector(
                              onTap: () => setState(() => selectedIndex = index),
                              child: Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.topRight,
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
                                          AppColors.primaryRed.withOpacity(0.1),
                                        ],
                                        size: 120,
                                      ),
                                      if (isSelected)
                                        Positioned(
                                          top: 6,
                                          right: 6,
                                          child: Icon(Icons.check_circle,
                                              color: AppColors.primaryRed, size: 20),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryBlue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Text(
                                      team['name']!,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: AppColors.primaryBlue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 20.h),

                      /// ---------- BUTTON ----------
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: CustomButton(
                          text: 'Select & Continue',
                          onPressed:
                              () => Get.toNamed(AppRoutes.teamScoreboardScreen)

                        ),
                      ),

                      SizedBox(height: 20.h),
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