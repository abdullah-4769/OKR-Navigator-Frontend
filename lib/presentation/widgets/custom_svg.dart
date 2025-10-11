import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSvg extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;

  const CustomSvg({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
    required String semanticsLabel,
  });

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    assetPath,
    width: width,
    height: height,
    color: color,
    fit: fit,
  );
}
