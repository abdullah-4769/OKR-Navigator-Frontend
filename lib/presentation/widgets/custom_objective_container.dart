
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';

class CustomObjectiveContainer extends StatelessWidget {
  final String title;       // Selected Objective text
  final String subtitle;    // (optional subtitle)
  final String description; // Description of objective
  final Color titleColor;   // For dynamic control of title color

  const CustomObjectiveContainer({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.description,
    this.titleColor = AppColors.primaryRed, // default red
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.d12.r),
      child: Stack(
        children: [
          // Background
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: EdgeInsets.all(AppDimensions.d12.w),
            color: AppColors.lightGrey.withOpacity(0.2),
          ),

          // Gradient border overlay (edges only)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.d12.r),
              ),
              child: CustomPaint(
                painter: _GradientBorderPainter(
                  borderRadius: AppDimensions.d12.r,
                  strokeWidth: 4, // 🔥 thicker border
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primaryRed,
                      AppColors.primaryRed.withOpacity(0.15),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.all(AppDimensions.d12.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // // 🔥 Title in Red
                // Text(
                //   "Selected Objective",
                //   style: TextStyle(
                //     fontSize: AppDimensions.d16.sp,
                //     fontWeight: FontWeight.w700,
                //     color: AppColors.primaryRed,
                //     fontFamily: 'Gotham',
                //   ),
                // ),
                SizedBox(height: AppDimensions.d8.h),

                // Selected Objective text (passed from card page)
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppDimensions.d18.sp,
                    color: titleColor, // default = red
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppDimensions.d12.sp,
                    color: AppColors.grey,
                    fontFamily: 'Gotham',
                  ),
                ),
                SizedBox(height: AppDimensions.d6.h),

                // Description
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppDimensions.d15.sp,
                    color: AppColors.black.withOpacity(0.7),
                    fontFamily: 'Gotham',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for gradient border
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


















