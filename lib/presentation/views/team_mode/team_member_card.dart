import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';

class TeamMemberCard extends StatelessWidget {
  final String name;
  final String role;
  final int level;
  final int score;
  final bool isCurrentUser;
  final String status; // "View", "Working...", etc.
  final String badge;
  final String trophy;
  final String title;
  final String? avatar; // Avatar path from API or team selection
  final String? userId; // User ID for navigation
  final VoidCallback? onViewTap; // Callback for View button

  const TeamMemberCard({
    super.key,
    required this.name,
    required this.role,
    required this.level,
    required this.score,
    this.isCurrentUser = false,
    this.status = "View",
    this.badge = "",
    this.trophy = "",
    this.title = "",
    this.avatar,
    this.userId,
    this.onViewTap,
  });

  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.symmetric(
        vertical: AppDimensions.d12.h,
        horizontal: AppDimensions.d16.w,
      ),
      margin: EdgeInsets.only(bottom: AppDimensions.d12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.d16.r),
        border: Border.all(
          color: isCurrentUser ? AppColors.primaryRed : AppColors.grey.withOpacity(0.3),
          width: isCurrentUser ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar with border - Display team avatar if available
          Container(
            padding: EdgeInsets.all(AppDimensions.d4.w),
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? AppColors.primaryRed.withOpacity(0.15)
                  : AppColors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: isCurrentUser ? AppColors.primaryRed : AppColors.grey,
                width: 1.5,
              ),
            ),
            child: Container(
              height: AppDimensions.d40.w,
              width: AppDimensions.d40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCurrentUser
                    ? AppColors.primaryRed.withOpacity(0.1)
                    : AppColors.grey.withOpacity(0.05),
              ),
              child: avatar != null && avatar!.isNotEmpty
                  ? ClipOval(
                      child: Image.asset(
                        avatar!,
                        height: AppDimensions.d40.w,
                        width: AppDimensions.d40.w,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
                      ),
                    )
                  : _buildDefaultAvatar(),
            ),
          ),
          SizedBox(width: AppDimensions.d12.w),

          // Name, role, and level
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: AppDimensions.d16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: AppDimensions.d4.h),
                Text(
                  "$role • Level $level",
                  style: TextStyle(
                    fontSize: AppDimensions.d12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Score or status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (score > 0) ...[
                Text(
                  "$score%",
                  style: TextStyle(
                    fontSize: AppDimensions.d18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryRed,
                  ),
                ),
                SizedBox(height: AppDimensions.d4.h),
              ],
              GestureDetector(
                onTap: status.toLowerCase() == "view" && onViewTap != null ? onViewTap : null,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.d8.w,
                    vertical: AppDimensions.d4.h,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status),
                    borderRadius: BorderRadius.circular(AppDimensions.d12.r),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: AppDimensions.d10.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

  Widget _buildDefaultAvatar() {
    return Center(
      child: SvgPicture.asset(
        'assets/images/solo.svg',
        height: AppDimensions.d50.w,
        width: AppDimensions.d50.w,
        color: isCurrentUser ? AppColors.primaryRed : AppColors.grey,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "view":
        return AppColors.primaryBlue;
      case "working...":
        return AppColors.primaryRed;
      default:
        return AppColors.grey;
    }
  }
}