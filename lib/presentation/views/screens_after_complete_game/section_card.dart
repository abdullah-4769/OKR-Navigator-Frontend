// lib/presentation/widgets/section_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';


/// Reusable SectionCard used to match the red/yellow bordered boxes
/// Accepts an icon, a color for border, a title, optional "back home" overlay,
/// and a list of items (title, subtitle, success).
class SectionCard extends StatelessWidget {
  final IconData icon;
  final Color borderColor;
  final String title;
  final List<Map<String, dynamic>> items;
  final bool showBackHome;
  final VoidCallback? onBackHome;

  const SectionCard({
    super.key,
    required this.icon,
    required this.borderColor,
    required this.title,
    required this.items,
    this.showBackHome = false,
    this.onBackHome,
  });

  @override
  Widget build(BuildContext context) {
    final double padH = AppDimensions.d16.w;
    final radius = AppDimensions.d18.r;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: AppDimensions.d8.h),
          padding: EdgeInsets.all(padH),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: borderColor.withOpacity(0.9), width: 1.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // header row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: AppDimensions.d18.r,
                    backgroundColor: borderColor,
                    child: Icon(icon, color: Colors.white, size: AppDimensions.d18.w),
                  ),
                  SizedBox(width: AppDimensions.d12.w),
                  Expanded(
                    child: Text(
                      title.tr,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppDimensions.d12.h),

              // items list
              Column(
                children: items.map((m) {
                  final String t = (m['title'] ?? '').toString().tr;
                  final String s = (m['subtitle'] ?? '').toString().tr;
                  final bool success = (m['success'] ?? false) as bool;
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: AppDimensions.d8.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // text column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                s,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // success icon
                        SizedBox(width: AppDimensions.d8.w),
                        if (success)
                          Container(
                            width: 28.w,
                            height: 28.w,
                            decoration: const BoxDecoration(
                                color: Colors.green, shape: BoxShape.circle),
                            child: const Icon(Icons.check, color: Colors.white, size: 18),
                          )
                        else
                          SizedBox(width: 28.w, height: 28.w),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),

        // Back home floating pill (overlapping right edge)
        if (showBackHome)
          Positioned(
            right: -10.w,
            top: 6.h,
            child: GestureDetector(
              onTap: onBackHome,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: borderColor,
                  borderRadius: BorderRadius.circular(28.r),
                  boxShadow: [
                    BoxShadow(
                      color: borderColor.withOpacity(0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.house_outlined, color: Colors.white, size: 16.w),
                    SizedBox(width: 8.w),
                    Text(
                      "back_home".tr,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
