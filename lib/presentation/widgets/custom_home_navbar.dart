import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';
import '../controllers/home_navbar_controller.dart';

class CustomHomeNavBar extends StatelessWidget {
  const CustomHomeNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeNavBarController(), permanent: true);

    return Obx(() {
      final isExpanded = controller.isExpanded.value;
      final screenWidth = MediaQuery.of(context).size.width;

      return AnimatedAlign(
        duration: const Duration(milliseconds: 350),
        alignment: Alignment.centerRight,
        curve: Curves.easeInOut,
        child: GestureDetector(
          onTap: isExpanded ? controller.navigateHome : controller.toggleNavBar,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth * 0.7, // ✅ Responsive: never exceed 70% width
              minWidth: AppDimensions.d60.w,
            ),
            child: Container(
              width: isExpanded ? AppDimensions.d180.w : AppDimensions.d60.w,
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.d8.w,
                vertical: AppDimensions.d6.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(AppDimensions.d30.r),
                  right: const Radius.circular(0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(2, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🔹 Home Icon
                  Container(
                    width: AppDimensions.d50.w,
                    height: AppDimensions.d50.w,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.home_sharp,
                      color: AppColors.reddish,
                      size: AppDimensions.d30.w,
                    ),
                  ),

                  if (isExpanded) ...[
                    SizedBox(width: 12.w),
                    Flexible(
                      child: Text(
                        "Back Home",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppDimensions.d14.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Gotham',
                        ),
                        overflow: TextOverflow.ellipsis, // ✅ Prevents overflow
                        maxLines: 1,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}



