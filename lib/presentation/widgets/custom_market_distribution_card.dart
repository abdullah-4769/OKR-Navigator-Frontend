import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';

class CustomMarketDisruptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? warningText; // optional
  final IconData? warningIcon; // optional

  const CustomMarketDisruptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.warningText,
    this.warningIcon,

  });

  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimensions.d16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.d12.r),
        border: Border.all(
          color: AppColors.primaryRed.withOpacity(0.6),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Title Row (Icon + Title)
          Row(
            children: [
              CircleAvatar(
                  backgroundColor: AppColors.primaryRed,
                  child: Center(child: Icon(icon, color: AppColors.white, size: AppDimensions.d22.w))),
              SizedBox(width: AppDimensions.d8.w),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineLarge
                      ?.copyWith(
                    color: AppColors.primaryRed,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: AppDimensions.d8.h),

          /// 🔹 Description
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(
              color: AppColors.grey,
              height: 1.2,
            ),
          ),

          /// 🔹 Optional Warning Section
          if (warningText != null) ...[
            SizedBox(height: AppDimensions.d12.h),
            Container(
              padding: EdgeInsets.all(AppDimensions.d12.w),
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withOpacity(0.05),
                borderRadius: BorderRadius.circular(AppDimensions.d8.r),
                border: Border.all(
                  color: Colors.yellow.withOpacity(0.7),
                  width: 2,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [

                  Text(
                    'Impact: ',
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(
                      color: AppColors.primaryRed,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(width: AppDimensions.d8.w, ),

                  Expanded(
                    child: Text(
                      warningText!,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(
                        color: AppColors.primaryRed,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
}
