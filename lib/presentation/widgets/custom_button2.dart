import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';

class CustomButton2 extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // ✅ Made nullable
  final bool isLoading;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool hasShadow;
  final Color? borderColor;

  const CustomButton2({
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
    this.hasShadow = true,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = isLoading || onPressed == null; // ✅ NEW LOGIC

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? AppDimensions.d48.h,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          // ✅ Always use gray when disabled
          backgroundColor: isDisabled
              ? AppColors
                    .grey // <-- Change here
              : backgroundColor ?? AppColors.primaryRed,
          disabledBackgroundColor: AppColors.grey, // ✅ Ensures gray background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: 1.5)
                : BorderSide.none,
          ),
          elevation: hasShadow ? 4 : 0,
          shadowColor: hasShadow
              ? Colors.black.withValues(alpha: 0.25)
              : Colors.transparent,
        ),
        child: isLoading
            ? SizedBox(
                width: AppDimensions.d22.w,
                height: AppDimensions.d22.w,
                child: CircularProgressIndicator(
                  color: textColor ?? AppColors.white,
                  strokeWidth: 2,
                ),
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
                      fontSize: AppDimensions.d16.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Gotham',
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
