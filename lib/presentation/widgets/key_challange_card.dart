import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KeyChallengeCard extends StatelessWidget {
  final String title;
  final String description;

  const KeyChallengeCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF6E3), // light beige background
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFE67E22), // orange border
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFE74C3C), // reddish-orange
            ),
          ),

          SizedBox(height: 6.h),

          /// Description
          Text(
            description,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
}
