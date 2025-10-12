import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';

class CustomButton2 extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // ✅ Callback
  final bool isLoading;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool hasShadow;
  final Color? borderColor;

  // ✅ NEW: Optional print message
  final String? debugMessage;

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
    this.debugMessage, // ✅ add to constructor
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = isLoading || onPressed == null;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? AppDimensions.d48.h,
      child: ElevatedButton(
        onPressed: isDisabled
            ? null
            : () {
          // ✅ Optional print statement
          if (debugMessage != null) {
            // ignore: avoid_print
            print('🖱️ Button Pressed: $debugMessage');
          }
          onPressed?.call();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? AppColors.grey
              : backgroundColor ?? AppColors.primaryRed,
          disabledBackgroundColor: AppColors.grey,
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
                fontWeight: FontWeight.w400,
                fontFamily: 'GothamBold',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
