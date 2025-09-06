// widgets/custom_okr_constellation.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';
import '../controllers/okr_constellation_controller.dart';

class CustomOKRConstellation extends StatelessWidget {
  const CustomOKRConstellation({super.key});

  @override
  Widget build(BuildContext context) {
    final OKRConstellationController controller =
    Get.find<OKRConstellationController>();

    return Container(
      width: double.infinity.w,
      margin: EdgeInsets.symmetric(horizontal: AppDimensions.d10.w),
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
        height: 200.h, // increased height for text space
        child: Obx(() {
          final icons = controller.selectedIcons;

          return Stack(
            clipBehavior: Clip.none, // allow + button overflow
            alignment: Alignment.center,
            children: [
              /// 🚀 Rocket in center
              Container(
                width: 70.w,
                height: 70.w,
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
              // SizedBox(height: 8.h),
              /// 🔵 Text below rocket, above plus
              Positioned(

                bottom: 40.h, // place between rocket and plus
                child: Text(
                  "Launch product",
                  style: TextStyle(
                    fontSize: AppDimensions.d16.sp,
                    fontFamily: 'Gotham-Bold',
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),

              /// 1st icon - top-left
              if (icons.length > 0)
                Positioned(
                  top: 15.h,
                  left: 30.w,
                  child: _buildIconCircle(icons[0]),
                ),

              /// 2nd icon - top-right
              if (icons.length > 1)
                Positioned(
                  top: 15.h,
                  right: 30.w,
                  child: _buildIconCircle(icons[1]),
                ),

              /// 3rd icon - bottom-left
              if (icons.length > 2)
                Positioned(
                  bottom: 30.h,
                  left: 30.w,
                  child: _buildIconCircle(icons[2]),
                ),

              /// ➕ Plus button (half visible at bottom)
              if (controller.showPlusButton)
                Positioned(
                  bottom: -30.h, // half outside container
                  child: Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: AppColors.softRed,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryRed, // border color
                        width: 3,
                      ),
                    ),
                    child: Icon(
                      Icons.add,
                      color: AppColors.primaryRed,
                      size: 30.sp,
                      weight: 550,
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  /// 🔵 Reusable circle icon widget
  Widget _buildIconCircle(IconData icon) {
    return Container(
      width: 60.w,
      height: 60.w,
      decoration: const BoxDecoration(
        color: AppColors.primaryBlue,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 28.sp,
      ),
    );
  }
}
