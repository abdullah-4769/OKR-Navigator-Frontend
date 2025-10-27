import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/app_colors.dart';

class FeedbackCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const FeedbackCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.symmetric(vertical: 6.h),
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14.r),
      border: Border.all(color: AppColors.grey.withOpacity(0.2)),
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
        /// Avatar + Name + Role Row
        Row(
          children: [
            /// Avatar
            CircleAvatar(
              radius: 20.r,
              backgroundImage: AssetImage(data['avatar'] ?? 'assets/images/default_avatar.png'),
            ),
            SizedBox(width: 12.w),

            /// Name and Role
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${data['name']}',
                    style: TextStyle(
                      color: AppColors.primaryRed,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${data['role']} | Level ${data['level']}',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 12.h),

        /// Message
        Text(
          data['message'],
          style: TextStyle(
            color: AppColors.black,
            fontSize: 14.sp,
            height: 1.4,
          ),
        ),

        SizedBox(height: 12.h),

        /// Rating with fraction
        Row(
          children: [
            /// Stars
            Row(
              children: List.generate(
                5,
                    (i) => Icon(
                  Icons.star,
                  size: 18.sp,
                  color: i < data['rating'] ? Colors.orange : Colors.grey,
                ),
              ),
            ),

            SizedBox(width: 8.w),

            /// Rating fraction
            Text(
              '${data['rating']}/5',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}