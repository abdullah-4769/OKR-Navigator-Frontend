import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextInputAction inputAction;
  final int? maxLength;
  final String? Function(String?)? validator;
  final bool enabled;
  final int? maxLines;
  final TextCapitalization textCapitalization;
  final bool autocorrect;
  final bool enableSuggestions;

  const CustomTextField({
    super.key,
    required this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.inputAction = TextInputAction.next,
    this.maxLength,
    this.validator,
    this.enabled = true,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.enableSuggestions = true,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    obscureText: obscureText,
    keyboardType: keyboardType,
    onChanged: onChanged,
    onFieldSubmitted: onSubmitted,
    textInputAction: inputAction,
    maxLength: maxLength,
    maxLines: maxLines,
    enabled: enabled,
    textCapitalization: textCapitalization,
    autocorrect: autocorrect,
    enableSuggestions: enableSuggestions,
    validator: validator,
    style: TextStyle(
      fontSize: AppDimensions.d16.sp,
      color: AppColors.textPrimary,
      fontFamily: 'Gothic',
    ),
    decoration: InputDecoration(
      counterText: '',
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: AppDimensions.d14.sp,
        color: AppColors.textSecondary,
        fontFamily: 'Gothic',
      ),
      prefixIcon: prefixIcon != null
          ? Padding(
              padding: EdgeInsets.all(AppDimensions.d12.w),
              child: prefixIcon,
            )
          : null,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.softRed,
      contentPadding: EdgeInsets.symmetric(
        vertical: AppDimensions.d16.h,
        horizontal: AppDimensions.d16.w,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.d20.r),
        borderSide: BorderSide(
          color: AppColors.borderGrey,
          width: AppDimensions.d1.w,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.d20.r),
        borderSide: BorderSide(
          color: AppColors.borderGrey,
          width: AppDimensions.d1.w,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.d20.r),
        borderSide: BorderSide(
          color: AppColors.primaryRed,
          width: AppDimensions.d2.w,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.d12.r),
        borderSide: BorderSide(
          color: AppColors.error,
          width: AppDimensions.d1.w,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.d12.r),
        borderSide: BorderSide(
          color: AppColors.error,
          width: AppDimensions.d2.w,
        ),
      ),
      errorStyle: TextStyle(
        fontSize: AppDimensions.d12.sp,
        color: AppColors.error,
        fontFamily: 'Gothic',
      ),
    ),
  );
}
