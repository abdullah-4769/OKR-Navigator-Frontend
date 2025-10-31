import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_colors.dart';

class ChatWidget extends StatelessWidget {
  final String name;
  final String role;
  final int level;
  final String message;
  final bool isCurrentUser;

  const ChatWidget({
    super.key,
    required this.name,
    required this.role,
    required this.level,
    required this.message,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) => Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isCurrentUser ? AppColors.primaryRed.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isCurrentUser ? AppColors.primaryRed : AppColors.grey.withOpacity(0.2),
          width: isCurrentUser ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name, Role and Level
          Text(
            name,
            style: TextStyle(
              color: AppColors.primaryRed,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            '$role | Level $level',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.sp,
            ),
          ),

          SizedBox(height: 12.h),

          // Message
          Text(
            message,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 14.sp,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
}