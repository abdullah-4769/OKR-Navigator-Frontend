import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/key_results_controller.dart';
import '../../controllers/campaign_mode_controllers/compaign_key_result_controller.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';

class CustomSelectedKeyResultsContainer extends StatelessWidget {
  const CustomSelectedKeyResultsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Dynamically detect which controller is active
    late final dynamic controller;
    bool isCampaignMode = false;

    if (Get.isRegistered<KeyResultsController>()) {
      controller = Get.find<KeyResultsController>();
    } else if (Get.isRegistered<CampaignKeyResultsController>()) {
      controller = Get.find<CampaignKeyResultsController>();
      isCampaignMode = true;
    } else {
      // Fallback to avoid crashes if no controller is found
      return _buildFallbackContainer();
    }

    return Obx(() {
      // 🔹 FIXED: Handle both int and RxInt types
      final int selectedCount = _getSelectedCount(controller, isCampaignMode);
      final int requiredCount = _getRequiredCount(controller, isCampaignMode);

      final int remaining = requiredCount - selectedCount;
      final String remainingText = remaining <= 0
          ? 'All key results selected!'
          : remaining == 1
          ? '1 more needed'
          : '$remaining more needed';

      // Get selected key results for display
      final List<dynamic> selectedKeyResults = controller.getSelectedKeyResults();

      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppDimensions.d18.w,
          vertical: AppDimensions.d16.h,
        ),
        padding: EdgeInsets.all(AppDimensions.d16.w),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.circular(AppDimensions.d12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with counter
            Row(
              children: [
                // Circular counter
                Container(
                  width: AppDimensions.d40.w,
                  height: AppDimensions.d40.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$selectedCount',
                      style: TextStyle(
                        fontSize: AppDimensions.d20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                        fontFamily: 'Gotham-Bold',
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppDimensions.d12.w),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Key Results Selected',
                        style: TextStyle(
                          fontSize: AppDimensions.d16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Gotham-Bold',
                        ),
                      ),
                      SizedBox(height: AppDimensions.d4.h),
                      Text(
                        remainingText,
                        style: TextStyle(
                          fontSize: AppDimensions.d14.sp,
                          color: Colors.white.withOpacity(0.9),
                          fontFamily: 'Gotham',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Selected key results list
            if (selectedKeyResults.isNotEmpty) ...[
              SizedBox(height: AppDimensions.d12.h),
              Divider(
                color: Colors.white.withOpacity(0.3),
                height: 1,
              ),
              SizedBox(height: AppDimensions.d12.h),
              Text(
                'Selected:',
                style: TextStyle(
                  fontSize: AppDimensions.d14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Gotham-Bold',
                ),
              ),
              SizedBox(height: AppDimensions.d8.h),
              ...selectedKeyResults.take(3).map((kr) => Padding(
                padding: EdgeInsets.only(bottom: AppDimensions.d6.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: AppDimensions.d16.w,
                      color: Colors.white,
                    ),
                    SizedBox(width: AppDimensions.d8.w),
                    Expanded(
                      child: Text(
                        _getKeyResultTitle(kr),
                        style: TextStyle(
                          fontSize: AppDimensions.d1.sp,
                          color: Colors.white,
                          fontFamily: 'Gotham',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )).toList(),

              if (selectedKeyResults.length > 3) ...[
                SizedBox(height: AppDimensions.d4.h),
                Text(
                  '+ ${selectedKeyResults.length - 3} more',
                  style: TextStyle(
                    fontSize: AppDimensions.d12.sp,
                    color: Colors.white.withOpacity(0.8),
                    fontFamily: 'Gotham',
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],

            // Empty state
            if (selectedKeyResults.isEmpty) ...[
              SizedBox(height: AppDimensions.d12.h),
              Divider(
                color: Colors.white.withOpacity(0.3),
                height: 1,
              ),
              SizedBox(height: AppDimensions.d12.h),
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: AppDimensions.d16.w,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  SizedBox(width: AppDimensions.d8.w),
                  Expanded(
                    child: Text(
                      'Select key results to continue',
                      style: TextStyle(
                        fontSize: AppDimensions.d1.sp,
                        color: Colors.white.withOpacity(0.8),
                        fontFamily: 'Gotham',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    });
  }

  // 🔹 Helper to safely get selectedCount (handles both int and RxInt)
  int _getSelectedCount(dynamic controller, bool isCampaignMode) {
    try {
      final selectedCount = controller.selectedCount;

      // If it's already an int, return it
      if (selectedCount is int) {
        return selectedCount;
      }

      // If it's an RxInt, get the value
      if (selectedCount is RxInt) {
        return selectedCount.value;
      }

      // Fallback
      return 0;
    } catch (e) {
      print('Error getting selectedCount: $e');
      return 0;
    }
  }

  // 🔹 Helper to safely get requiredCount (handles both int and RxInt)
  int _getRequiredCount(dynamic controller, bool isCampaignMode) {
    try {
      final requiredCount = controller.requiredCount;

      // If it's already an int, return it
      if (requiredCount is int) {
        return requiredCount;
      }

      // If it's an RxInt, get the value
      if (requiredCount is RxInt) {
        return requiredCount.value;
      }

      // Fallback
      return 3;
    } catch (e) {
      print('Error getting requiredCount: $e');
      return 3;
    }
  }

  // Helper method to extract title from different key result types
  String _getKeyResultTitle(dynamic kr) {
    if (kr is Map<String, dynamic>) {
      return kr['title']?.toString() ?? 'Unknown Title';
    } else if (kr.runtimeType.toString().contains('KeyResult')) {
      // Assuming it's a KeyResult model object
      try {
        return kr.title?.toString() ?? 'Unknown Title';
      } catch (e) {
        return 'Key Result';
      }
    }
    return kr.toString();
  }

  Widget _buildFallbackContainer() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.d18.w,
        vertical: AppDimensions.d16.h,
      ),
      padding: EdgeInsets.all(AppDimensions.d16.w),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(AppDimensions.d12.r),
      ),
      child: Row(
        children: [
          Container(
            width: AppDimensions.d40.w,
            height: AppDimensions.d40.w,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '0',
                style: TextStyle(
                  fontSize: AppDimensions.d20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                  fontFamily: 'Gotham-Bold',
                ),
              ),
            ),
          ),
          SizedBox(width: AppDimensions.d12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Key Results Selected',
                  style: TextStyle(
                    fontSize: AppDimensions.d16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Gotham-Bold',
                  ),
                ),
                SizedBox(height: AppDimensions.d4.h),
                Text(
                  '3 more needed',
                  style: TextStyle(
                    fontSize: AppDimensions.d14.sp,
                    color: Colors.white.withOpacity(0.9),
                    fontFamily: 'Gotham',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
