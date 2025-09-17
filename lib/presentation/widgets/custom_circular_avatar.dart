import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_colors.dart';
class CustomCircularAvatar extends StatelessWidget {
  final String imagePath;
  final List<Color> innerColors; // 3 colors for layered circles
  final List<Color>? borderGradient; // gradient for border (optional now)
  final double size;

  const CustomCircularAvatar({
    super.key,
    required this.imagePath,
    required this.innerColors,
    this.borderGradient, // made optional
    this.size = 100,
  }) : assert(innerColors.length == 3, 'innerColors must have exactly 3 colors');

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size.w,
    height: size.w,
    child: Stack(
      alignment: Alignment.center,
      children: [
        // Only draw gradient border if provided
        if (borderGradient != null)
          CustomPaint(
            size: Size(size.w, size.w),
            painter: _GradientBorderPainter(
              gradientColors: borderGradient!,
            ),
          ),

        // 3 layered circles
        Container(
          width: (size * 0.95).w,
          height: (size * 0.95).w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: innerColors[0],
          ),
          child: Center(
            child: Container(
              width: (size * 0.85).w,
              height: (size * 0.85).w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: innerColors[1],
              ),
              child: Center(
                child: Container(
                  width: (size * 0.7).w,
                  height: (size * 0.7).w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: innerColors[2],
                  ),
                  child: Center(
                    child: Image.asset(
                      imagePath,
                      width: (size * 1).w,
                      height: (size * 1).w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


/// CustomPainter for gradient border
class _GradientBorderPainter extends CustomPainter {
  final List<Color> gradientColors;

  _GradientBorderPainter({required this.gradientColors});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: gradientColors,
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width * 0.03;

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
