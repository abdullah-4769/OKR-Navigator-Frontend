import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';

class CustomScoreCard extends StatelessWidget {
  final int? score;
  final String title;
  final String? description;
  final String? imagePath;
  final bool showBackground;

  const CustomScoreCard({
    super.key,
    this.score,
    required this.title,
    this.description,
    this.imagePath,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;

    // Adjusted circle size for smaller cards
    final double circleSize = showBackground ? width * 0.3 : width * 0.35;
    final double imageSize = circleSize * 0.92; // Image fills most of the circle
    final double maxCircleSize = 120.w; // Cap max size for large screens

    Widget circleContent = Container(
      width: circleSize > maxCircleSize ? maxCircleSize : circleSize,
      height: circleSize > maxCircleSize ? maxCircleSize : circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primaryRed.withOpacity(0.15),
            Colors.white,
          ],
        ),
      ),
      child: CustomPaint(
        painter: _GradientBorderPainter(),
        child: Center(
          child: imagePath != null
              ? ClipOval(
            child: Image.asset(
              imagePath!,
              width: imageSize > maxCircleSize * 0.92 ? maxCircleSize * 0.92 : imageSize,
              height: imageSize > maxCircleSize * 0.92 ? maxCircleSize * 0.92 : imageSize,
              fit: BoxFit.cover,
            ),
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${score ?? 0}%",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.primaryRed,
                  fontWeight: FontWeight.bold,
                  fontSize: 26.sp,
                ),
              ),
              Text(
                "final_score".tr,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        circleContent,
        SizedBox(height: 12.h),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
          textAlign: TextAlign.center,
        ),
        if (description != null) ...[
          SizedBox(height: 6.h),
          Text(
            description!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    // Only wrap with background if showBackground is true
    if (showBackground) {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: width * 0.03),
        padding: EdgeInsets.all(width * 0.03),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.white,
          border: Border.all(color: AppColors.primaryRed),
        ),
        child: content,
      );
    } else {
      return content; // No extra spacing
    }
  }
}

class _GradientBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Gradient border paint
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.primaryRed.withOpacity(0.9), // Dark red at top
        AppColors.primaryRed.withOpacity(0.3), // Light red at bottom
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width * 0.02; // Thicker top

    // Draw border circle
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -3.14 / 2,
      3.14 * 2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}










// this is old we have new
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../../../core/app_colors.dart';
//
// /// Score Card Widget
// class CustomScoreCard extends StatelessWidget {
//   final int score;
//   final String title;
//   final String? description;
//
//   const CustomScoreCard({
//     super.key,
//     required this.score,
//     required this.title,
//     this.description,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final width = size.width;
//
//     return Container(
//       width: double.infinity,
//       margin: EdgeInsets.symmetric(horizontal: width * 0.05),
//       padding: EdgeInsets.all(width * 0.04),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(26.r),
//         color: Colors.white,
//         border: Border.all(color: AppColors.primaryRed),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           /// Circle with gradient border + soft red background
//           Container(
//             width: width * 0.45,
//             height: width * 0.45,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   AppColors.primaryRed.withOpacity(0.15), // soft red top
//                   Colors.white, // fade to white bottom
//                 ],
//               ),
//             ),
//             child: CustomPaint(
//               painter: _GradientBorderPainter(),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "$score%",
//                       style:
//                       Theme.of(context).textTheme.headlineLarge?.copyWith(
//                         color: AppColors.primaryRed,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 26.sp
//                       ),
//                     ),
//                     Text(
//                       "final_score".tr,
//                       style:
//                       Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         color: AppColors.textSecondary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           SizedBox(height: 12.h),
//
//           /// Title
//           Text(
//             title,
//             style: Theme.of(context).textTheme.titleLarge?.copyWith(
//               fontWeight: FontWeight.bold,
//               color: AppColors.black,
//             ),
//             textAlign: TextAlign.center,
//           ),
//
//           if (description != null) ...[
//             SizedBox(height: 6.h),
//             Text(
//               description!,
//               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                 color: AppColors.textSecondary,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
//
// /// Custom Painter for gradient + varying thickness border
// class _GradientBorderPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final rect = Rect.fromLTWH(0, 0, size.width, size.height);
//
//     // Gradient border paint
//     final gradient = LinearGradient(
//       begin: Alignment.topCenter,
//       end: Alignment.bottomCenter,
//       colors: [
//         AppColors.primaryRed.withOpacity(0.9), // dark red at top
//         AppColors.primaryRed.withOpacity(0.3), // light red at bottom
//       ],
//     );
//
//     final paint = Paint()
//       ..shader = gradient.createShader(rect)
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round
//       ..strokeWidth = size.width * 0.02; // thicker top
//
//     // Draw border circle
//     canvas.drawArc(
//       Rect.fromLTWH(0, 0, size.width, size.height),
//       -3.14 / 2,
//       3.14 * 2,
//       false,
//       paint,
//     );
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
