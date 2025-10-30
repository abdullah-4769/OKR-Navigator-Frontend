import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';

class RewardsUnlocked extends StatelessWidget {
  final String badgeImage;
  final String badgeName;

  final String titleImage;
  final String titleName;

  final String trophyImage;
  final String trophyName;

  const RewardsUnlocked({
    super.key,
    required this.badgeImage,
    required this.badgeName,
    required this.titleImage,
    required this.titleName,
    required this.trophyImage,
    required this.trophyName,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final height = media.size.height;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: width * 0.05),
          padding: EdgeInsets.all(width * 0.05),
          decoration: BoxDecoration(
            color: AppColors.softRed.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.primaryRed, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ✅ Header Row
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primaryRed,
                    radius: width * 0.05,
                    child: Icon(
                      Icons.emoji_events,
                      color: AppColors.white,
                      size: width * 0.05,
                    ),
                  ),
                  SizedBox(width: width * 0.04),
                  Expanded(
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "rewards_unlocked".tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: height * 0.015),

              /// ✅ Badge + Title Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: _rewardItem(
                      context,
                      imagePath: badgeImage,
                      title: badgeName.tr,
                      type: "badge".tr,
                    ),
                  ),
                  SizedBox(width: width * 0.05),
                  Expanded(
                    child: _rewardItem(
                      context,
                      imagePath: titleImage,
                      title: titleName.tr,
                      type: "title".tr,
                    ),
                  ),
                ],
              ),

              SizedBox(height: height * 0.025),

              /// ✅ Trophy Centered
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxW * 0.5),
                  child: _rewardItem(
                    context,
                    imagePath: trophyImage,
                    title: trophyName.tr,
                    type: "trophy".tr,
                    imageSize: width * 0.2,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _rewardItem(
      BuildContext context, {
        required String imagePath,
        required String title,
        required String type,
        double imageSize = 60,
      }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Image.asset(
            imagePath,
            width: imageSize.w,
            height: imageSize.w,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 6.h),
        FittedBox(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        FittedBox(
          child: Text(
            type,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
