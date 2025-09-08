import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../controllers/game_mode_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_curved_arrow.dart';

class GameModeScreen extends StatelessWidget {
  const GameModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GameModeController());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              // Back Button + Title - FIXED: Removed incorrect Positioned widget
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.d0.w,
                  vertical: AppDimensions.d16.h,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: CustomCurvedArrow(
                        isLeft: true,
                        onTap: () {
                          Get.offAllNamed(AppRoutes.home);
                        },
                        width: AppDimensions.d60.w,
                        height: AppDimensions.d150.h,
                      ),
                    ),
                    SizedBox(width: AppDimensions.d70.w), // FIXED: Changed .h to .w

                    Expanded( // FIXED: Added Expanded to prevent overflow
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            "Select",
                            style: TextStyle(
                              fontFamily: "Gotham-Bold",
                              color: AppColors.primaryRed, // FIXED: Use AppColors
                              fontSize: AppDimensions.d30.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Game Mode",
                            style: TextStyle(
                              fontFamily: "Gotham-Bold",
                              color: AppColors.primaryBlue, // FIXED: Use AppColors
                              fontSize: AppDimensions.d24.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
        
              SizedBox(height: AppDimensions.d10.h),
        
              // Cards Carousel
              SizedBox(
                height: size.height * 0.45,
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: controller.gameModes.length,
                  itemBuilder: (context, index) {
                    return Obx(() {
                      bool isSelected = controller.selectedIndex.value == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(
                          horizontal: isSelected ? 8.w : 12.w, // FIXED: Consistent units
                          vertical: isSelected ? 0.h : 30.h, // FIXED: Consistent units
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryRed // FIXED: Use AppColors
                                : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              spreadRadius: 1.r,
                              blurRadius: 6.r,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // FIXED: Added null check and error handling for SVG
                            controller.gameModes[index]['icon'] != null
                                ? SvgPicture.asset(
                              controller.gameModes[index]['icon']!,
                              height: size.height * 0.20,
                              placeholderBuilder: (context) => Container(
                                height: size.height * 0.20,
                                color: Colors.grey[200],
                                child: Icon(
                                  Icons.image,
                                  size: 50.r,
                                  color: Colors.grey[400],
                                ),
                              ),
                            )
                                : Container(
                              height: size.height * 0.20,
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.image_not_supported,
                                size: 50.r,
                                color: Colors.grey[400],
                              ),
                            ),
                            SizedBox(height: AppDimensions.d12.h),
                            Text(
                              controller.gameModes[index]['title'] ?? 'Unknown Mode', // FIXED: Null check
                              style: TextStyle(
                                fontFamily: "Gotham-Bold",
                                fontSize: AppDimensions.d20.sp,
                                color: isSelected
                                    ? AppColors.primaryRed // FIXED: Use AppColors
                                    : Colors.black54,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                decoration: isSelected
                                    ? TextDecoration.underline
                                    : TextDecoration.none,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    });
                  },
                ),
              ),
        
              SizedBox(height: AppDimensions.d20.h),
        
              // Navigation Arrows
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildArrowButton(
                      icon: Icons.arrow_back,
                      onTap: controller.previousCard,
                      isDisabled: controller.selectedIndex.value == 0,
                    ),
                    SizedBox(width: AppDimensions.d20.w),
                    _buildArrowButton(
                      icon: Icons.arrow_forward,
                      onTap: controller.nextCard,
                      isDisabled: controller.selectedIndex.value ==
                          controller.gameModes.length - 1,
                    ),
                  ],
                );
              }),
        
              SizedBox(height: AppDimensions.d30.h),
        
        // Continue Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.d24.w),
                child: CustomButton(
                  text: "Select & Continue",
                  onPressed: () {
                    // ✅ Correct navigation
                    Get.offAllNamed(AppRoutes.pricingScreen);
                  },
                ),
              ),
        
        //
        
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArrowButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDisabled,
  }) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        padding: EdgeInsets.all(AppDimensions.d12.r),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDisabled ? Colors.grey.shade300 : AppColors.primaryRed,
        ),
        child: Icon(
          icon,
          color: isDisabled ? Colors.grey : Colors.white,
          size: AppDimensions.d24.r,
        ),
      ),
    );
  }
}