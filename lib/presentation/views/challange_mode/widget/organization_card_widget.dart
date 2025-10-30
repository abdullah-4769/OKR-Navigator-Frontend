// OrganizationCardWidget.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/app_colors.dart';
import '../../../widgets/campaign_mode_widgets/custom_industry_card.dart';

class OrganizationCardWidget extends StatelessWidget {
  final int level;
  final String orgTitle;
  final String subTitle;
  final String strategyText;
  final String challengeText;
  final String bottomTitle;
  final bool isUnlocked;
  final bool isCompleted;
  final VoidCallback onStart;

  const OrganizationCardWidget({
    super.key,
    required this.level,
    required this.orgTitle,
    required this.subTitle,
    required this.strategyText,
    required this.challengeText,
    required this.bottomTitle,
    required this.isUnlocked,
    required this.isCompleted,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: CustomIndustryCard(
        orgTitle: orgTitle,
        subTitle: subTitle,
        strategyText: strategyText,
        challengeText: challengeText,
        bottomTitle: isCompleted ? "completed".tr : bottomTitle,
        onStart: isUnlocked ? onStart : () {
          if (!isUnlocked) {
            Get.snackbar(
              "Locked".tr,
              "Complete previous organization first".tr,
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
        imagePath: 'assets/images/role_icon.png',
        isUnlocked: isUnlocked,

      ),
    );
}