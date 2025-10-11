// lib/presentation/widgets/custom_strategic_icons_show.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';

class StrategicIconsShow extends StatelessWidget {
  const StrategicIconsShow({super.key});

  @override
  Widget build(BuildContext context) {
    final List<IconData> icons = [
      Icons.leaderboard,
      Icons.group,
      Icons.star,
      Icons.trending_up,
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.d12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.d18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SizedBox(
        height: 220.h, // enough space for constellation
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// ⚡ Flash in center (red circle)
            Container(
              width: 70.w,
              height: 70.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryRed,
              ),
              child: Icon(
                Icons.flash_on,
                color: Colors.white,
                size: 34.sp,
              ),
            ),

            /// top-left
            Positioned(
              top: 20.h,
              left: 40.w,
              child: _buildIconCircle(icons[0]),
            ),

            /// top-right
            Positioned(
              top: 30.h,
              right: 40.w,
              child: _buildIconCircle(icons[1]),
            ),

            /// bottom-left
            Positioned(
              bottom: 30.h,
              left: 50.w,
              child: _buildIconCircle(icons[2]),
            ),

            /// bottom-right
            Positioned(
              bottom: 20.h,
              right: 50.w,
              child: _buildIconCircle(icons[3]),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔵 Blue circle with white icon
  Widget _buildIconCircle(IconData icon) => Container(
    width: 60.w,
    height: 60.w,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.primaryBlue,
    ),
    child: Icon(
      icon,
      color: Colors.white,
      size: 28.sp,
    ),
  );
}
