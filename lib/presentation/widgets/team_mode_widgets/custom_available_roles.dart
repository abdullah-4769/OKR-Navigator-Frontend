import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';

class CustomAvailableRoles extends StatelessWidget {
  const CustomAvailableRoles({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final roles = [
      {'name': 'You', 'level': 'Level 5', 'role': 'CEO'},
      {'name': 'Mike Chen', 'level': 'Level 3', 'role': 'Strategist'},
      {'name': '-', 'level': '', 'role': 'HR Manager'},
      {'name': '-', 'level': '', 'role': 'Analyst'},
      {'name': '-', 'level': '', 'role': 'Team Lead'},
      {'name': '-', 'level': '', 'role': 'Manager'},
    ];

    return Container(
      padding: EdgeInsets.all(AppDimensions.d16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.d24.r),
        border: Border.all(color: AppColors.primaryRed),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                    backgroundColor: AppColors.primaryRed,
                    child: const Icon(Icons.groups, color: AppColors.white)),
              ),
              SizedBox(width: 8.w),
              Text('Available Roles'.tr,
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          SizedBox(height: 3.h),
          ...roles.map((r) => Column(

            children: [

              Row(

                children: [

                  CircleAvatar(

                    child:
                  SvgPicture.asset('assets/images/solo.svg',
                      height: 32.h, width: 32.w),),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      '${r['name']}  ${r['level']}',
                      style: textTheme.bodyMedium
                          ?.copyWith(color: AppColors.black),
                    ),
                  ),
                  Text(r['role']!,
                      style: textTheme.bodyMedium
                          ?.copyWith(color: AppColors.grey)),
                ],
              ),
              if (r != roles.last)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Divider(
                    color: AppColors.grey.withOpacity(.2),
                    height: 1,
                  ),
                ),
            ],
          ))
        ],
      ),
    );
  }
}
