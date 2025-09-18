import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_colors.dart';

class CustomIndustryCard extends StatelessWidget {
  final String orgTitle;       // Organization Name
  final String subTitle;       // Subtitle (Phase, Level, etc.)
  final String bottomTitle;    // Bottom text (Objectives)
  final String? strategyText;  // Optional strategy text
  final String? challengeText; // Optional challenge text
  final String imagePath;      // Avatar image
  final bool isUnlocked;       // State (locked/unlocked)
  final VoidCallback? onStart; // Start Button callback (only if unlocked)
  final bool showPlayButton;   // 🔹 NEW: flag to show/hide play button

  const CustomIndustryCard({
    super.key,
    required this.orgTitle,
    required this.subTitle,
    required this.bottomTitle,
    this.strategyText,
    this.challengeText,
    required this.imagePath,
    required this.isUnlocked,
    this.onStart,
    this.showPlayButton = true, // default true (backward compatible)
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
    padding: EdgeInsets.all(14.w),
    decoration: BoxDecoration(
      color: isUnlocked
          ? AppColors.softRed.withOpacity(0.15)
          : AppColors.grey.withOpacity(0.2),
      border: Border.all(
        color: isUnlocked ? AppColors.primaryRed : AppColors.grey,
        width: 1.5,
      ),
      borderRadius: BorderRadius.circular(18.r),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 Top Row (Avatar + Titles + Circle)
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar with border + greyscale when locked
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isUnlocked ? AppColors.primaryRed : AppColors.grey,
                  width: 2,
                ),
              ),
              child: ColorFiltered(
                colorFilter: isUnlocked
                    ? const ColorFilter.mode(
                    Colors.transparent, BlendMode.multiply)
                    : const ColorFilter.matrix(<double>[
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0.2126, 0.7152, 0.0722, 0, 0,
                  0, 0, 0, 1, 0,
                ]),
                child: CircleAvatar(
                  radius: 18.r,
                  backgroundImage: AssetImage(imagePath),
                  backgroundColor: Colors.yellow,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orgTitle,
                    style: TextStyle(
                      color: isUnlocked ? AppColors.black : AppColors.grey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subTitle,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            // 🔹 Right circle with lock
            Container(
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                isUnlocked ? AppColors.primaryRed : Colors.transparent,
                border: Border.all(
                  color: isUnlocked ? AppColors.primaryRed : AppColors.grey,
                  width: 1.5,
                ),
              ),
              child: isUnlocked
                  ? null
                  : Icon(Icons.lock, size: 14.sp, color: AppColors.grey),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        /// 🔹 Tags Row (Optional)
        if (strategyText != null || challengeText != null)
          Row(
            children: [
              if (strategyText != null) ...[
                Icon(Icons.menu_book,
                    size: 16.sp,
                    color:
                    isUnlocked ? AppColors.primaryRed : AppColors.grey),
                SizedBox(width: 4.w),
                Text(
                  strategyText!,
                  style: TextStyle(
                      color: isUnlocked
                          ? AppColors.primaryRed
                          : AppColors.grey,
                      fontSize: 10.sp),
                ),
              ],
              if (challengeText != null) ...[
                SizedBox(width: 14.w),
                Icon(Icons.flag,
                    size: 16.sp,
                    color:
                    isUnlocked ? AppColors.primaryRed : AppColors.grey),
                SizedBox(width: 4.w),
                Text(
                  challengeText!,
                  style: TextStyle(
                      color: isUnlocked
                          ? AppColors.primaryRed
                          : AppColors.grey,
                      fontSize: 10.sp),
                ),
              ],
            ],
          ),

        if (strategyText != null || challengeText != null)
          SizedBox(height: 14.h),

        /// 🔹 Bottom Container (Objectives + Start/Locked Btn)
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isUnlocked
                ? Colors.yellow.withValues(alpha: 0.3)
                : AppColors.grey.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isUnlocked
                  ? Colors.yellow.withValues(alpha: 0.5)
                  : AppColors.grey.withOpacity(0.15),
              width: 2.0,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.emoji_events,
                  color: isUnlocked ? AppColors.primaryRed : AppColors.grey,
                  size: 14.sp),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  bottomTitle,
                  style: TextStyle(
                    color: isUnlocked
                        ? AppColors.textSecondary
                        : AppColors.grey,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              /// 🔹 Show Play Button only if `showPlayButton == true`
              if (showPlayButton)
                GestureDetector(
                  onTap: isUnlocked ? onStart : null,
                  child: Row(
                    children: [
                      Text(
                        isUnlocked ? "Start" : "Locked",
                        style: TextStyle(
                          color: AppColors.primaryRed, // 🔴 Always red
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      CircleAvatar(
                        radius: 10.r,
                        backgroundColor: isUnlocked
                            ? AppColors.primaryRed
                            : AppColors.grey,
                        child: Icon(Icons.play_arrow,
                            color: Colors.white, size: 18.sp),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        )
      ],
    ),
  );
}
