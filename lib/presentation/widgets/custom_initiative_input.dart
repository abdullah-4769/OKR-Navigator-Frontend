import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';

class CustomInitiativeInput extends StatelessWidget {
  final String numberText;
  final TextEditingController titleController;
  final TextEditingController descController;
  final String mode; // 'solo' or 'team'

  const CustomInitiativeInput({
    super.key,
    required this.numberText,
    required this.titleController,
    required this.descController,
    this.mode = 'solo',
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return OrientationBuilder(
      builder: (context, orientation) {
        // Adjust padding slightly based on orientation
        final horizontalPadding = orientation == Orientation.portrait
            ? width * 0.05
            : width * 0.1;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: height * 0.01,
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppDimensions.d16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.d16.r),
              border: Border.all(color: AppColors.grey.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
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
                    fontWeight: FontWeight.w900,
                    color: mode == 'team'
                        ? AppColors.primaryBlue
                        : AppColors.primaryRed,
                    fontFamily: 'GothamBold',
                  ),
                ),
                SizedBox(height: AppDimensions.d10.h),

                /// Title Field
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'enter_initiative_name'.tr,
                    hintStyle: TextStyle(fontSize: width * 0.035,
                      fontFamily: 'Gotham',
                      fontWeight: FontWeight.w900,
                    color: AppColors.grey),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: width * 0.03,
                      vertical: height * 0.015,

                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(AppDimensions.d10.r),
                      borderSide: BorderSide(
                        color: AppColors.grey.withValues(alpha: 0.3),
                      ),
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
                    hintStyle: TextStyle(fontSize: width * 0.035,
                        fontFamily: 'Gotham',
                        fontWeight: FontWeight.w900,
                        color: AppColors.grey),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: width * 0.03,
                      vertical: height * 0.02,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(AppDimensions.d10.r),
                      borderSide: BorderSide(
                        color: AppColors.grey.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
