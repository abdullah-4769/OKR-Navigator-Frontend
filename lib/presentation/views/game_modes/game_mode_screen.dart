import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../controllers/game_mode_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

class GameModeScreen extends StatelessWidget {
  const GameModeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final GameModeController controller = Get.find();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetGameMode();
    });

    final size = MediaQuery.of(context).size;

    return OrientationBuilder(
      builder: (context, orientation) {
        final cardHeight = orientation == Orientation.portrait
            ? size.height * 0.45
            : size.height * 0.65;

        return Scaffold(
          body: CustomBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: AppDimensions.d20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Header
                    CustomHeader(
                      title: "select".tr,
                      highlightedText: "game_mode".tr,
                      onBackTap: () => Get.offAllNamed(AppRoutes.home),
                      showDashboardIcon: false,
                    ),

                    SizedBox(height: AppDimensions.d10.h),

                    /// Cards Carousel (Adaptive height)
                    SizedBox(
                      height: cardHeight,
                      width: size.width,
                      child: PageView.builder(
                        controller: controller.pageController,
                        onPageChanged: controller.onPageChanged,
                        itemCount: controller.gameModes.length,
                        itemBuilder: (context, index) => Obx(() {
                          final bool isSelected =
                              controller.selectedIndex.value == index;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(
                              horizontal: isSelected ? 8.w : 12.w,
                              vertical: isSelected ? 0.h : 30.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryRed
                                    : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(20),
                                  spreadRadius: 1.r,
                                  blurRadius: 6.r,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /// Game Mode Icon
                                controller.gameModes[index]['icon'] != null
                                    ? SvgPicture.asset(
                                  controller.gameModes[index]['icon']!,
                                  height: size.height * 0.20,
                                  placeholderBuilder: (context) =>
                                      Container(
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

                                /// Game Mode Title
                                Text(
                                  (controller.gameModes[index]['title'] ?? '')
                                      .toString()
                                      .tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(
                                    fontSize: (size.width * 0.05).sp,
                                    color: isSelected
                                        ? AppColors.primaryRed
                                        : Colors.black54,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    decoration: isSelected
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),

                    SizedBox(height: AppDimensions.d20.h),

                    /// Navigation Arrows
                    Obx(
                          () => Row(
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
                      ),
                    ),

                    SizedBox(height: AppDimensions.d30.h),

                    /// Continue Button
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.d32.w,
                      ),
                      child: CustomButton(
                        text: 'select_continue'.tr,
                        onPressed: controller.navigateToPricingScreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Common Navigation Arrow Button Widget
  Widget _buildArrowButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDisabled,
  }) =>
      GestureDetector(
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
