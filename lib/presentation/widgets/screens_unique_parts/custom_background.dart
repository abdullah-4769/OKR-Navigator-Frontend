import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';


class CustomBackground extends StatelessWidget {
  final Widget child;
  final Gradient? gradient; // optional override

  const CustomBackground({
    super.key,
    required this.child,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
        gradient: gradient ??
            const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.backgroundTop,
                AppColors.backgroundBottom,
              ],
            ),
      ),
      child: SafeArea(child: child),
    );
}
