import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonImage extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  final String? semanticsLabel;

  const CommonImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
    this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (assetPath.endsWith('.svg')) {
      return SvgPicture.asset(
        assetPath,
        width: width,
        height: height,
        color: color, // Use color instead of colorFilter
        fit: fit,
        semanticsLabel: semanticsLabel,
      );
    } else {
      return Image.asset(
        assetPath,
        width: width,
        height: height,
        color: color,
        fit: fit,
      );
    }
  }
}
