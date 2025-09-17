import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_colors.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color borderColor;
  final List<Map<String, dynamic>> items;
  final bool showCheck;
  final bool showScore;

  const SectionCard({
    super.key,
    required this.title,
    this.icon,
    required this.borderColor,
    required this.items,
    this.showCheck = false,
    this.showScore = false,
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.symmetric(vertical: 6.h),
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18.r),
      border: Border.all(color: borderColor),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          children: [
            // Only show CircleAvatar if icon is provided
            if (icon != null) ...[
              CircleAvatar(
                radius: 18.r,
                backgroundColor: borderColor,
                child: Icon(icon, color: Colors.white),
              ),
              SizedBox(width: 12.w),
            ],
            Expanded(
              child: Text(title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryRed)),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
        SizedBox(height: 12.h),
        ...items.map((m) => Column(
          children: [
            Row(
              children: [
                // Optional icon for each item
                if (m['icon'] != null)
                  Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Icon(m['icon'], size: 18.sp, color: m['iconColor'] ?? AppColors.primaryRed),
                  ),
                Expanded(
                  child: Text(
                    m['key'] ?? m['title'] ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (showCheck)
                  Icon(Icons.check_circle,
                      color: m['done'] == true
                          ? Colors.green
                          : Colors.grey,
                      size: 20.sp),
                if (showScore)
                  Text('${m['score']}%',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13.sp))
              ],
            ),
            Divider(color: AppColors.grey.withOpacity(0.2), height: 14.h),
          ],
        )).toList(),
      ],
    ),
  );
}