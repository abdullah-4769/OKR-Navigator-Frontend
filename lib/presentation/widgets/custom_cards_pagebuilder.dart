import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../controllers/strategy_selection_controller.dart';

class CustomCardPagerBuilder extends StatelessWidget {
  final StrategySelectionController controller = Get.find();

  CustomCardPagerBuilder({super.key});

  @override
  Widget build(BuildContext context) => Obx(
        () => Column(
      children: [
        // 🔹 Card Display Container
        Container(
          height: 400.h,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: AppDimensions.d24.w),
          padding: EdgeInsets.all(AppDimensions.d16.w),
          decoration: BoxDecoration(
            color: AppColors.primaryRed.withValues(alpha:0.08),
            borderRadius: BorderRadius.circular(AppDimensions.d20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.15),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: controller.selectedCardIndex.value == -1
                  ? SvgPicture.asset(
                'assets/images/backcard.svg',
                key: const ValueKey<String>('backcard'),
                height: 280.h,
              )
                  : Image.asset(
                controller.cardAssets[controller.selectedCardIndex.value],
                key: ValueKey<int>(controller.selectedCardIndex.value),
                height: 280.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        SizedBox(height: AppDimensions.d20.h),

        // 🔹 Bubble Button Below Card
        GestureDetector(
          onTap: () {
            if (controller.isCardRevealed.value) {
              controller.resetAndDrawNewCard();
            } else {
              controller.revealRandomCard();
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.d60.w,
              vertical: AppDimensions.d14.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.lightSkyBlue,
              borderRadius: BorderRadius.circular(50.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryBlue.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Text(
              controller.isCardRevealed.value
                  ? 'draw_new_strategy'.tr
                  : 'tap_to_reveal_strategy'.tr,
              style: TextStyle(
                fontFamily: 'Gotham-Bold',
                fontSize: AppDimensions.d16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
