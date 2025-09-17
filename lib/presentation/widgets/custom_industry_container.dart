import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';

class CustomIndustryContainer extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  // ✅ NEW
  final bool showSelectionCircle;

  // Dynamic Bottom Tags
  final bool showTag1;
  final IconData? tag1Icon;
  final String? tag1Text;

  final bool showTag2;
  final IconData? tag2Icon;
  final String? tag2Text;

  final bool showTag3;
  final IconData? tag3Icon;
  final String? tag3Text;

  const CustomIndustryContainer({
    super.key,
    required this.title,
    required this.description,
    this.icon = Icons.auto_graph_sharp,
    required this.isSelected,
    required this.onTap,
    this.showSelectionCircle = true, // ✅ default true
    this.showTag1 = false,
    this.tag1Icon,
    this.tag1Text,
    this.showTag2 = false,
    this.tag2Icon,
    this.tag2Text,
    this.showTag3 = false,
    this.tag3Icon,
    this.tag3Text,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor =
    isSelected ? AppColors.primaryRed : AppColors.textSecondary;

    final media = MediaQuery.of(context);
    final isLandscape = media.orientation == Orientation.landscape;
    final maxWidth = media.size.width;

    return OrientationBuilder(
      builder: (context, orientation) => GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: EdgeInsets.only(bottom: AppDimensions.d8.h),
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.d16.w,
              vertical: AppDimensions.d18.h,
            ),
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              minWidth: maxWidth * 0.85,
            ),
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(AppDimensions.d16.r),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryRed
                    : AppColors.grey.withValues(alpha: 0.3),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? AppColors.primaryRed.withValues(alpha: 0.12)
                      : Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 Icon + Title + Selection Circle Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(AppDimensions.d10.w),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryRed : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        size: AppDimensions.d24.w,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(width: AppDimensions.d14.w),

                    /// Title Text
                    Expanded(

                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: isLandscape
                              ? AppDimensions.d16.sp
                              : AppDimensions.d18.sp,
                          fontWeight: FontWeight.w700,
                          color: activeColor,
                          fontFamily: 'GothamBold',
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    /// ✅ Selection Circle (optional)
                    if (showSelectionCircle)
                      Container(
                        height: AppDimensions.d18.w,
                        width: AppDimensions.d18.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppColors.primaryRed
                              : Colors.transparent,
                          border:
                          Border.all(color: AppColors.primaryRed, width: 2),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: AppDimensions.d10.h),

                /// 🔹 Description
                Text(
                  description,
                  style: TextStyle(
                    fontSize: AppDimensions.d14.sp,
                    color: AppColors.textSecondary,
                    fontFamily: 'Gotham',
                    height: 1.4,
                  ),
                  maxLines: isLandscape ? 3 : 4,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: AppDimensions.d12.h),

                /// 🔹 Bottom Tags
                if (showTag1 || showTag2 || showTag3)
                  Wrap(
                    spacing: AppDimensions.d16.w,
                    runSpacing: AppDimensions.d6.h,
                    children: [
                      if (showTag1 && tag1Icon != null && tag1Text != null)
                        _buildTag(tag1Icon!, tag1Text!, activeColor),
                      if (showTag2 && tag2Icon != null && tag2Text != null)
                        _buildTag(tag2Icon!, tag2Text!, activeColor),
                      if (showTag3 && tag3Icon != null && tag3Text != null)
                        _buildTag(tag3Icon!, tag3Text!, activeColor),
                    ],
                  ),
              ],
            ),
          ),
        ),
    );
  }

  /// 🔹 Helper Method for Small Tags
  Widget _buildTag(IconData icon, String text, Color color) => Container(
    padding: EdgeInsets.symmetric(
      horizontal: AppDimensions.d8.w,
      vertical: AppDimensions.d4.h,
    ),
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppDimensions.d8.r),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: AppDimensions.d14.w),
        SizedBox(width: 4.w),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: AppDimensions.d12.sp,
              fontWeight: FontWeight.w500,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}
