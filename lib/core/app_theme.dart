import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.primary,
  fontFamily: 'Gotham',
  useMaterial3: true, // ✅ modern Material
  textTheme: TextTheme(
    // ---------------------- DISPLAY ----------------------
    displayLarge: TextStyle(
      fontFamily: 'Gotham',
      fontWeight: FontWeight.w900, // Extra bold / Black
      fontSize: 32.sp, // Large hero text
      color: AppColors.textPrimary,
    ),
    displayMedium: TextStyle(
      fontFamily: 'Gotham',
      fontWeight: FontWeight.w800,
      fontSize: 28.sp,
      color: AppColors.textPrimary,
    ),
    displaySmall: TextStyle(
      fontFamily: 'Gotham',
      fontWeight: FontWeight.w700,
      fontSize: 24.sp,
      color: AppColors.textPrimary,
    ),

    // ---------------------- HEADLINE ----------------------
    headlineLarge: TextStyle(
      fontFamily: 'Gotham',
      fontWeight: FontWeight.w700, // Bold
      fontSize: 22.sp,
      color: AppColors.textPrimary,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Gotham',
      fontWeight: FontWeight.w600,
      fontSize: 20.sp,
      color: AppColors.textPrimary,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Gotham',
      fontWeight: FontWeight.w400,
      fontSize: 18.sp,
      color: AppColors.textPrimary,
    ),

    // ---------------------- TITLE ----------------------
    titleLarge: TextStyle(
      fontFamily: 'Gotham',
      fontWeight: FontWeight.w600,
      fontSize: 18.sp,
      color: AppColors.textPrimary,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Gotham',
      fontWeight: FontWeight.w500,
      fontSize: 16.sp,
      color: AppColors.textPrimary,
    ),
    titleSmall: TextStyle(
      fontFamily: 'Gotham',
      fontWeight: FontWeight.w400,
      fontSize: 14.sp,
      color: AppColors.textPrimary,
    ),

    // ---------------------- BODY ----------------------
    bodyLarge: TextStyle(
      fontFamily: 'Gotham',
      fontWeight: FontWeight.w400,
      fontSize: 16.sp,
      color: AppColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Gotham',
      fontWeight: FontWeight.w400,
      fontSize: 14.sp,
      color: AppColors.textSecondary,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Gotham',
      fontWeight: FontWeight.w400, // ✅ force non-bold
      fontSize: 12.sp,
      color: AppColors.textSecondary,
    ),

    // ---------------------- LABEL (Buttons, Chips, etc.) ----------------------
    labelLarge: TextStyle(
      fontFamily: 'Gotham',
      fontWeight: FontWeight.w600,
      fontSize: 14.sp,
      color: AppColors.textPrimary,
    ),
    labelMedium: TextStyle(
      fontFamily: 'Gotham',
      fontWeight: FontWeight.w500,
      fontSize: 12.sp,
      color: AppColors.textSecondary,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Gotham',
      fontWeight: FontWeight.w500,
      fontSize: 11.sp,
      color: AppColors.textSecondary.withOpacity(0.8),
    ),
  ),
);
