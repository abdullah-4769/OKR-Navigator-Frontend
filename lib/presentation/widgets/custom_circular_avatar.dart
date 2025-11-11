import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCircularAvatar extends StatelessWidget {
  final String imagePath;
  final List<Color> innerColors; // must be 3
  final List<Color>? borderGradient; // optional gradient border
  final double size;

  // ✅ Controls
  final double imageScale; // scale factor for image
  final Offset imageOffset; // shift image
  final double borderWidth; // gradient border thickness
  final double innermostFactor; // size of last circle (default 0.6)

  const CustomCircularAvatar({
    super.key,
    required this.imagePath,
    required this.innerColors,
    this.borderGradient,
    this.size = 100,
    this.imageScale = 0.6,
    this.imageOffset = Offset.zero,
    this.borderWidth = 3,
    this.innermostFactor = 0.6, // 👈 default same as before
  }) : assert(innerColors.length == 3, 'innerColors must have exactly 3 colors');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.w,
      height: size.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer gradient border
          Container(
            width: size.w,
            height: size.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: borderGradient != null
                  ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: borderGradient!,
              )
                  : null,
              color: borderGradient == null ? innerColors[0] : null,
            ),
          ),

          // Inner circle (background layers)
          Container(
            width: (size - 2 * borderWidth).w,
            height: (size - 2 * borderWidth).w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: innerColors[0],
            ),
            child: Center(
              child: Container(
                width: (size * 0.75).w,
                height: (size * 0.75).w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: innerColors[1],
                ),
                child: Center(
                  child: Container(
                    width: (size * innermostFactor).w, // 👈 configurable now
                    height: (size * innermostFactor).w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: innerColors[2],
                    ),
                    child: Center(
                      child: Transform.translate(
                        offset: imageOffset,
                        child: Image.asset(
                          imagePath,
                          width: (size * imageScale).w, // 👈 not capped anymore
                          height: (size * imageScale).w,
                          fit: BoxFit.contain,
                        ),
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
}
