import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';

class CustomObjectiveContainer extends StatelessWidget {
  final String title; // Selected Objective text
  final String subtitle; // Optional subtitle
  final String description; // Description of objective
  final Color titleColor; // For dynamic control of title color
  final IconData? icon; // ✅ New: Pass Flutter Icon instead of image

  const CustomObjectiveContainer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    this.titleColor = AppColors.primaryRed, // Default red
    this.icon, // ✅ Optional icon
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(AppDimensions.d12.r),
    child: Stack(
      children: [
        // Background
        Container(
          width: MediaQuery.of(context).size.width * 0.85,
          padding: EdgeInsets.all(AppDimensions.d12.w),
          color: AppColors.lightGrey.withValues(alpha:0.2),
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
                strokeWidth: 4,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryRed,
                    AppColors.primaryRed.withValues(alpha:0.15),
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
              // ✅ Icon displayed only if provided
              if (icon != null) ...[
                Container(
                  padding: EdgeInsets.all(AppDimensions.d10.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed, // 🔴 Background always reddish
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha:0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white, // ✅ Icon color always white
                    size: AppDimensions.d28.sp,
                  ),
                ),
                SizedBox(height: AppDimensions.d10.h),
              ],

              // Title
              Text(
                title.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppDimensions.d18.sp,
                  color: titleColor,
                  fontFamily: 'Gotham',
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Subtitle
              Text(
                subtitle.tr,
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
                description.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppDimensions.d15.sp,
                  color: AppColors.black.withValues(alpha:0.7),
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
