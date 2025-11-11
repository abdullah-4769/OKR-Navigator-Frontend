import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../core/app_colors.dart';
import '../routes/app_routes.dart';


class CustomLanguageButton extends StatelessWidget {
  final double? iconSize;
  final Color? iconColor;
  final String? tooltip;
  final bool showText;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;

  const CustomLanguageButton({
    super.key,
    this.iconSize,
    this.iconColor,
    this.tooltip,
    this.showText = false,
    this.padding,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: padding ?? EdgeInsets.zero,
      icon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.language,
            color: iconColor ?? AppColors.primaryBlue,
            size: iconSize ?? 28,
          ),
          if (showText) ...[
            SizedBox(width: 4.w),
            Text(
              'language'.tr,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: iconColor ?? AppColors.primaryBlue,
              ),
            ),
          ],
        ],
      ),
      tooltip: tooltip ?? 'Change Language'.tr,
      onPressed: onPressed ?? _changeLanguage,
    );
  }

  void _changeLanguage() {
    final currentRoute = Get.currentRoute;
    Get.toNamed(
      AppRoutes.language,
      parameters: {
        'from': currentRoute,
      },
    );
  }
}