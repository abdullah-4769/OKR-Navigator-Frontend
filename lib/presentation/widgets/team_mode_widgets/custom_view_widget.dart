import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_colors.dart';

class CustomViewWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onPressed;
  final IconData? trailingIcon;
  final double? width;
  final double? height;

  const CustomViewWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.onPressed,
    this.trailingIcon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onPressed,
    borderRadius: BorderRadius.circular(50.r),
    child: CustomPaint(
      painter: GradientBorderPainter(),
      child: Container(
        width: width ?? double.infinity,
        height: height,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: height == null ? 14.h : 0,
        ),
        decoration: BoxDecoration(
          color: AppColors.softRed.withOpacity(0.2),
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            if (trailingIcon != null) ...[
              SizedBox(width: 8.w),
              Icon(
                trailingIcon,
                color: AppColors.textPrimary,
                size: 18.sp,
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

class GradientBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Gradient gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.primaryRed,
        AppColors.primaryRed.withOpacity(0.15),
      ],
    );

    final Paint paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(50.r),
    );

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}