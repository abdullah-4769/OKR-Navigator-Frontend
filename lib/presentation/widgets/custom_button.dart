import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.leading,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius = AppDimensions.d30,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width ?? double.infinity.w,
    height: height ?? AppDimensions.d48.h,
    child: ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primaryRed,
        disabledBackgroundColor: (backgroundColor ?? AppColors.primaryRed)
            .withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
      ),
      child: isLoading
          ? SizedBox(
              width: AppDimensions.d22.w,
              height: AppDimensions.d22.h,
              child: const CircularProgressIndicator(color: Colors.white),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leading != null) ...[
                  leading!,
                  SizedBox(width: AppDimensions.d8.w),
                ],
                Text(
                  text,
                  style: TextStyle(
                    color: textColor ?? AppColors.white,
                    fontSize: AppDimensions.d18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
    ),
  );
}
