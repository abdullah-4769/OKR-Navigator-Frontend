import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';

class CustomInitiativeInput extends StatelessWidget {
  final String numberText;
  final TextEditingController titleController;
  final TextEditingController descController;

  const CustomInitiativeInput({
    super.key,
    required this.numberText,
    required this.titleController,
    required this.descController,
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.only(bottom: AppDimensions.d16.h),
    padding: EdgeInsets.all(AppDimensions.d16.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppDimensions.d16.r),
      border: Border.all(color: AppColors.grey.withValues(alpha: 0.3)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha:0.05),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Initiative Number
        Text(
          numberText.tr,
          style: TextStyle(
            fontSize: AppDimensions.d16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryRed,
            fontFamily: 'Gotham',
          ),
        ),
        SizedBox(height: AppDimensions.d10.h),

        /// Title Field
        TextField(
          controller: titleController,
          decoration: InputDecoration(
            hintText: 'enter_initiative_name'.tr,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.d10.r),
              borderSide: BorderSide(color: AppColors.grey.withValues(alpha:0.3)),
            ),
          ),
        ),
        SizedBox(height: AppDimensions.d12.h),

        /// Description Field
        TextField(
          controller: descController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'describe_initiative_help'.tr,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.d10.r),
              borderSide: BorderSide(color: AppColors.grey.withValues(alpha:0.3)),
            ),
          ),
        ),
      ],
    ),
  );
}
