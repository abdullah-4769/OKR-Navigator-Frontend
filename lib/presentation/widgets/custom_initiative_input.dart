// widgets/custom_initiative_input.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';

class CustomInitiativeInput extends StatelessWidget {
  final String numberText;
  final TextEditingController titleController;
  final TextEditingController descController;

  const CustomInitiativeInput({
    Key? key,
    required this.numberText,
    required this.titleController,
    required this.descController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.d16.h),
      padding: EdgeInsets.all(AppDimensions.d16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.d16.r),
        border: Border.all(color: AppColors.grey.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
            numberText,
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
              hintText: "Enter initiative name...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.d10.r),
                borderSide: BorderSide(color: AppColors.grey.withOpacity(0.3)),
              ),
            ),
          ),
          SizedBox(height: AppDimensions.d12.h),

          /// Description Field
          TextField(
            controller: descController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Describe how this initiative helps...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.d10.r),
                borderSide: BorderSide(color: AppColors.grey.withOpacity(0.3)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
