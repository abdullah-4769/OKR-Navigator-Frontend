import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCurvedArrow extends StatelessWidget {
  final bool isLeft; // true → left.svg, false → right.svg
  final VoidCallback onTap; // Callback on click
  final double width; // Custom width
  final double height; // Custom height

  const CustomCurvedArrow({
    super.key,
    required this.isLeft,
    required this.onTap,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: SizedBox(
      width: width.w,
      height: height.h,
      child: SvgPicture.asset(
        isLeft ? 'assets/images/left.svg' : 'assets/images/right.svg',
      ),
    ),
  );
}
