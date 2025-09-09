import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/pricing_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_curved_arrow.dart';
import '../../widgets/custom_svg.dart';

class PricingScreen extends StatelessWidget {
  PricingScreen({super.key});

  final PricingController controller = Get.put(PricingController());
  final PageController pageController = PageController(
    viewportFraction: 0.85,
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.d0.w,
                  vertical: AppDimensions.d16.h,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.offAllNamed('/splash0'),
                      child: CustomCurvedArrow(
                        isLeft: true,
                        width: AppDimensions.d60.w,
                        height: AppDimensions.d150.h,
                        onTap: () {
                          Get.offAllNamed(AppRoutes.gameMode);
                        },
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 130.h,
                      width: AppDimensions.d150.w,
                      child: CustomSvg(
                        assetPath: 'assets/images/okrnev.svg',
                        semanticsLabel: 'OKR'.tr,
                        height: 90.h,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(width: AppDimensions.d60.w),
                  ],
                ),
              ),
              SizedBox(height: AppDimensions.d10.h),
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: controller.pricingPlans.length,
                  onPageChanged: controller.onPageChanged,
                  itemBuilder: (context, index) {
                    final plan = controller.pricingPlans[index];
                    return Obx(() {
                      final bool isSelected =
                          controller.currentPageIndex.value == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(
                          horizontal: isSelected ? 20.w : 24.w,
                          vertical: isSelected ? 110.h : 110.h,
                        ),
                        width: screenWidth * 0.80,
                        child: _buildPricingCard(plan, isSelected),
                      );
                    });
                  },
                ),
              ),
              SizedBox(height: AppDimensions.d20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.d20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                          () => _buildArrowButton(
                        icon: Icons.arrow_back,
                        isDisabled: controller.currentPageIndex.value == 0,
                        onTap: () => controller.previousCard(pageController),
                      ),
                    ),
                    SizedBox(
                      width: constraints.maxWidth * 0.45,
                      child: CustomButton2(
                        text: 'select_continue'.tr,
                        onPressed: () {
                          controller.selectPlan(
                            controller.currentPageIndex.value,
                          );
                        },
                      ),
                    ),
                    Obx(
                          () => _buildArrowButton(
                        icon: Icons.arrow_forward,
                        isDisabled:
                        controller.currentPageIndex.value ==
                            controller.pricingPlans.length - 1,
                        onTap: () => controller.nextCard(pageController),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppDimensions.d30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPricingCard(Map<String, dynamic> plan, bool isSelected) => Stack(
    clipBehavior: Clip.none,
    children: [
      Card(
        elevation: isSelected ? 10 : 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.d16.r),
          side: BorderSide(
            color: AppColors.primaryRed,
          ),
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppDimensions.d16.w),
          decoration: BoxDecoration(
            color: AppColors.softRed.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(AppDimensions.d16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                plan['price'],
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              SizedBox(height: AppDimensions.d12.h),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: plan['features'].length,
                separatorBuilder: (_, __) => Divider(
                  height: AppDimensions.d12.h,
                  color: AppColors.grey.withValues(alpha: 0.3),
                  thickness: 1,
                ),
                itemBuilder: (_, index) {
                  final feature = plan['features'][index];
                  return Row(
                    children: [
                      Icon(
                        feature['included']
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: feature['included']
                            ? AppColors.sucessColor
                            : AppColors.grey,
                        size: 16.sp,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          feature['text'].tr,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.textBlack,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 30.h),
      Positioned(
        top: -105.h,
        right: 150.w,
        child: CustomSvg(
          assetPath: 'assets/images/solo.svg',
          semanticsLabel: 'solo'.tr,
          height: 120.h,
          width: 95.w,
        ),
      ),
    ],
  );

  Widget _buildArrowButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDisabled,
  }) =>
      GestureDetector(
        onTap: isDisabled ? null : onTap,
        child: Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDisabled
                ? AppColors.grey.withValues(alpha: 0.3)
                : AppColors.primaryRed,
          ),
          child: Icon(icon, color: Colors.white, size: 24.r),
        ),
      );
}
