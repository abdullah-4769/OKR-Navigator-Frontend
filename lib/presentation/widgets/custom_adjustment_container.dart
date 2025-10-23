import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';

class CustomAdjustmentContainer extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? description;

  /// 🔹 Optional action button
  final String? actionText;
  final Color? actionColor;
  final VoidCallback? onActionTap;

  /// 🔹 Optional children rows
  final List<Widget>? children;

  /// 🔹 Card border + highlight
  final Color borderColor;
  final bool showShadow;

  const CustomAdjustmentContainer({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.description,
    this.actionText,
    this.actionColor,
    this.onActionTap,
    this.children,
    this.borderColor = const Color(0xFFE0E0E0),
    this.showShadow = false,
  });

  @override
  Widget build(BuildContext context) => Container(
      margin: EdgeInsets.only(bottom: AppDimensions.d16.h),
      padding: EdgeInsets.all(AppDimensions.d16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.d16.r),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: showShadow
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Header Row: Icon + Title + Action Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Icon Circle
              Container(
                padding: EdgeInsets.all(AppDimensions.d10.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryRed,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.white, size: AppDimensions.d20.w),
              ),
              SizedBox(width: AppDimensions.d12.w),

              // Title + Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:  Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w400, // Keep bold
                      ),
                    ),
                    if (description != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        description!,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                          color: AppColors.grey,
                          fontWeight: FontWeight.w400, // Keep bold
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Right Action Button
              if (actionText != null &&
                  actionColor != null &&
                  onActionTap != null)
                GestureDetector(
                  onTap: onActionTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.d12.w,
                      vertical: AppDimensions.d6.h,
                    ),
                    decoration: BoxDecoration(
                      color: actionColor,
                      borderRadius: BorderRadius.circular(AppDimensions.d20.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.edit,
                            size: AppDimensions.d14.w, color: Colors.white),
                        SizedBox(width: 4.w),
                        Text(
                          actionText!,
                          style: TextStyle(
                            fontSize: AppDimensions.d12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          /// 🔹 Children Section (e.g. Key Results / Initiatives list)
          if (children != null && children!.isNotEmpty) ...[
            SizedBox(height: AppDimensions.d12.h),
            Column(children: children!),
          ],
        ],
      ),
    );
}
