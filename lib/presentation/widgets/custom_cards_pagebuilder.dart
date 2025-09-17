import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';

class CustomCardPagerBuilder extends StatelessWidget {
  final dynamic controller; // Accept ANY Getx controller that has the same API

  const CustomCardPagerBuilder({super.key, required this.controller});

  @override
  Widget build(BuildContext context) => Obx(
        () => Column(
      children: [
        /// 🔹 Gradient Border Card
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.d20.r),
          child: CustomPaint(

            painter: _GradientBorderPainter(

              borderRadius: AppDimensions.d20.r,
              strokeWidth: 4,
              gradient: LinearGradient(

                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryRed,
                  AppColors.primaryRed.withValues(alpha: 0.15),
                ],
              ),
            ),
            child: Container(
              height: 400.h,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: AppDimensions.d24.w),
              padding: EdgeInsets.all(AppDimensions.d16.w),
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withValues(alpha: 0.08), // 🔹 background
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
                      ? Image.asset(
                    'assets/images/backcard_img.png',
                    key: const ValueKey<String>('backcard'),
                    height: 350.h,
                  )
                      : Image.asset(
                    controller.cardAssets[controller.selectedCardIndex.value],
                    key: ValueKey<int>(controller.selectedCardIndex.value),
                    height: 350.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        )
        ,

        SizedBox(height: AppDimensions.d20.h),

        /// 🔹 Bubble Button Below Card
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

/// 🔹 Gradient Border Painter (reused)
class _GradientBorderPainter extends CustomPainter {
  final double borderRadius;
  final double strokeWidth;
  final Gradient gradient;

  _GradientBorderPainter({
    required this.borderRadius,
    required this.strokeWidth,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
