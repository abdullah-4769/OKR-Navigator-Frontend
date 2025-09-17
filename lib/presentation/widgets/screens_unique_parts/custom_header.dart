import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../custom_curved_arrow.dart';
import '../custom_svg.dart';

class CustomHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? highlightedText;
  final VoidCallback onBackTap;
  final bool showDashboardIcon; // ✅ New flag

  const CustomHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.highlightedText,
    required this.onBackTap,
    this.showDashboardIcon = true, // ✅ default: true
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OrientationBuilder(
      builder: (context, orientation) {
        final width = MediaQuery.of(context).size.width;
        final height = MediaQuery.of(context).size.height;

        return Stack(
          children: [
            /// Top row → Arrow | Title+Highlight | Profile
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Left curved arrow
                SizedBox(
                  width: width * 0.18,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomCurvedArrow(
                      isLeft: true,
                      onTap: onBackTap,
                      width: orientation == Orientation.portrait
                          ? width * 0.15
                          : width * 0.9,
                      height: orientation == Orientation.portrait
                          ? height * 0.26
                          : height * 0.24,
                    ),
                  ),
                ),

                /// Center Title + Highlight only
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
                              ? 42.sp
                              : 32.sp,
                          height: 1.0,
                        ),
                      ),
                      if (highlightedText != null &&
                          highlightedText!.isNotEmpty)
                        Text(
                          highlightedText!,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: AppColors.primaryBlue,
                            fontSize: orientation == Orientation.portrait
                                ? 24.sp
                                : 20.sp,
                            height: 0.1, // tighter
                          ),
                        ),
                    ],
                  ),
                ),

                /// Right profile circle (optional)
                SizedBox(
                  width: width * 0.17,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: showDashboardIcon
                        ? CircleAvatar(
                      radius: 26.r,
                      backgroundColor: AppColors.white,
                      child: Padding(
                        padding: EdgeInsets.all(4.r),
                        child: CustomSvg(
                          assetPath: 'assets/images/persondashboard.svg',
                          semanticsLabel: 'profile'.tr,
                          height: 36.r,
                          width: 36.r,
                        ),
                      ),
                    )
                        : const SizedBox.shrink(), // ✅ hides if false
                  ),
                ),
              ],
            ),

            /// Subtitle positioned below
            if (subtitle != null && subtitle!.isNotEmpty)
              Positioned.fill(
                top: orientation == Orientation.portrait ? 160.h : 90.h,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: width * 0.8,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      subtitle!,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textBlack,
                        fontSize: orientation == Orientation.portrait
                            ? 14.sp
                            : 12.sp,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
