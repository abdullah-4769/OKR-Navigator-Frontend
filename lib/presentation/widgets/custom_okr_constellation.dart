// widgets/custom_okr_constellation.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/okr_constellation_controller.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';

class CustomOKRConstellation extends StatelessWidget {
  const CustomOKRConstellation({super.key});

  @override
  Widget build(BuildContext context) {
    final OKRConstellationController controller =
    Get.find<OKRConstellationController>();

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
        child: SizedBox(
          height: 240.h, // Increased height for better spacing
          child: Obx(() {
            final icons = controller.selectedIcons;

            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                /// 🚀 Rocket in center with text attached below
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Rocket Icon
                    Container(
                      width: 70.w,
                      height: 70.h,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryRed,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.rocket_launch,
                        color: Colors.white,
                        size: 36.sp,
                      ),
                    ),

                    /// 🔵 Text directly below rocket with proper spacing
                    SizedBox(height: 8.h), // Space between rocket and text
                    Text(
                      'launch_product'.tr,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily: 'Gotham-Bold',
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                /// 1st icon - top-left
                if (icons.isNotEmpty)
                  Positioned(
                    top: 10.h,
                    left: 10.w,
                    child: _buildIconCircle(icons[0]),
                  ),

                /// 2nd icon - top-right
                if (icons.length > 1)
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: _buildIconCircle(icons[1]),
                  ),

                /// 3rd icon - bottom-left
                if (icons.length > 2)
                  Positioned(
                    bottom: 10.h, // Adjusted since text is now part of the column
                    left: 10.w,
                    child: _buildIconCircle(icons[2]),
                  ),

                /// 4th icon - bottom-right
                if (icons.length > 3)
                  Positioned(
                    bottom: 10.h, // Adjusted since text is now part of the column
                    right: 10.w,
                    child: _buildIconCircle(icons[3]),
                  ),
              ],
            );
          }),
        ),);
  }

  /// 🔵 Reusable circle icon widget
  Widget _buildIconCircle(IconData icon) => Container(
    width: 60.w,
    height: 60.h,
    decoration: const BoxDecoration(
      color: AppColors.primaryBlue,
      shape: BoxShape.circle,
    ),
    child: Icon(icon, color: Colors.white, size: 28.sp),
  );
}