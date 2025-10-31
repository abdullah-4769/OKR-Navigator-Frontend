import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_colors.dart';

class ResponsiveArrow extends StatelessWidget {
  const ResponsiveArrow({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    // arrow size adjusts by screen width & orientation
    final arrowSize = isPortrait
        ? (size.width * 0.08).clamp(20.0, 40.0) // portrait scaling
        : (size.height * 0.08).clamp(16.0, 32.0); // landscape scaling

    return Icon(
      Icons.arrow_downward_rounded,
      color: AppColors.primaryRed,
      size: arrowSize.sp, // responsive with screenutil
    );
  }
}
