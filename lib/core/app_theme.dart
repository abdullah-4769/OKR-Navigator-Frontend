import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.primary,
  fontFamily: 'Gothic',

  // Text Styles
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Gotham',
      fontSize: AppDimensions.d28.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),
    headlineLarge: TextStyle(
      fontFamily: 'Gotham',
      fontSize: AppDimensions.d20.sp,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Gotham',
      fontSize: AppDimensions.d16.sp,
      color: AppColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Gotham',
      fontSize: AppDimensions.d14.sp,
      color: AppColors.textSecondary,
    ),
  ),

  // TextFields Styling
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.d12.r),
      borderSide: const BorderSide(color: AppColors.borderGrey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.d12.r),
      borderSide: BorderSide(
        color: AppColors.primary,
        width: AppDimensions.d2.w,
      ),
    ),
    hintStyle: TextStyle(
      color: AppColors.textSecondary,
      fontSize: AppDimensions.d14.sp,
    ),
  ),

  // Buttons Styling
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(
        vertical: AppDimensions.d14.h,
        horizontal: AppDimensions.d20.w,
      ),
      textStyle: TextStyle(
        fontSize: AppDimensions.d16.sp,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.d12.r),
      ),
    ),
  ),
);
