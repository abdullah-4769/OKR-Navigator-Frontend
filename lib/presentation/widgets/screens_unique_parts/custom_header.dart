import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../../routes/app_routes.dart'; // ✅ for navigation
import '../common_image.dart';
import '../custom_curved_arrow.dart';
import '../custom_svg.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? highlightedText;
  final VoidCallback onBackTap;
  final bool showDashboardIcon;

  const CustomHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.highlightedText,
    required this.onBackTap,
    this.showDashboardIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentRoute = Get.currentRoute; // ✅ capture current route

    return OrientationBuilder(
      builder: (context, orientation) {
        final width = MediaQuery.of(context).size.width;
        final height = MediaQuery.of(context).size.height;

        return SizedBox(
          height: orientation == Orientation.portrait ? 130.h : 100.h,
          child: Stack(
            children: [
              Row(
                children: [
                  /// 🔙 Left back arrow
                  SizedBox(
                    width: width * 0.18,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: CustomCurvedArrow(
                        isLeft: true,
                        onTap: onBackTap,
                        width: orientation == Orientation.portrait
                            ? width * 0.15
                            : width * 0.9,
                        height: orientation == Orientation.portrait
                            ? height * 0.18
                            : height * 0.16,
                      ),
                    ),
                  ),

                  /// 🔹 Center title & highlight
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.displayLarge?.copyWith(
                            color: AppColors.primaryRed,
                            fontSize: orientation == Orientation.portrait
                                ? 30.sp
                                : 24.sp,
                            height: 1.25,
                          ),
                        ),
                        if (highlightedText != null && highlightedText!.isNotEmpty)
                          Text(
                            highlightedText!,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: AppColors.primaryBlue,
                              fontSize: orientation == Orientation.portrait
                                  ? 18.sp
                                  : 15.sp,
                              height: 0.1,
                            ),
                          ),
                      ],
                    ),
                  ),

                  /// 🔸 Right side icons → language + profile
                  SizedBox(
                    width: width * 0.35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        /// 🌐 Language icon
                        IconButton(
                          icon: const Icon(
                            Icons.language,
                            color: AppColors.primaryBlue,
                            size: 28,
                          ),
                          tooltip: 'Change Language',
                          onPressed: () {
                            // Navigate to language screen, pass current route
                            Get.toNamed(
                              AppRoutes.language,
                              parameters: {
                                'from': currentRoute, // ✅ pass current screen
                              },
                            );
                          },
                        ),

                        /// 👤 Profile icon (optional)
                        if (showDashboardIcon)
                          CircleAvatar(
                            radius: 24.r,
                            backgroundColor: AppColors.white,
                            child: Padding(
                              padding: EdgeInsets.all(4.r),
                              child: CommonImage(
                                assetPath: 'assets/images/global_persondashboard.png',
                                semanticsLabel: 'profile'.tr,
                                height: 34.r,
                                width: 34.r,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              /// 🔹 Subtitle
              if (subtitle != null && subtitle!.isNotEmpty)
                Positioned(
                  top: orientation == Orientation.portrait ? 120.h : 90.h,
                  left: width * 0.1,
                  right: width * 0.1,
                  child: Text(
                    subtitle!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textBlack,
                      fontSize: orientation == Orientation.portrait ? 14.sp : 12.sp,
                      height: 1.2,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}