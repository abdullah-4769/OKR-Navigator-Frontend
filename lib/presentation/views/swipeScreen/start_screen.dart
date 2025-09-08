import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/app_assets.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';

import '../../widgets/custom_svg.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // Background gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.d24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo and Title
                  Column(
                    children: [
                      CustomSvg(
                        assetPath: AppAssets.okrLogo,
                        width: AppDimensions.d90.w,
                        height: AppDimensions.d80.h,
                        semanticsLabel: '',
                      ),
                      SizedBox(height: AppDimensions.d16.h),
                    ],
                  ),

                  SizedBox(height: AppDimensions.d20.h),

                  // MaskGroup SVG in the middle
                  CustomSvg(
                    assetPath: 'assets/images/maskgroup.svg',
                    width: AppDimensions.d180.w,
                    height: AppDimensions.d200.h,
                    fit: BoxFit.contain,
                    semanticsLabel: '',
                  ),

                  SizedBox(height: AppDimensions.d40.h),

                  // Welcome Text
                  Text(
                    'Welcome to OKR Navigator',
                    style: TextStyle(
                      fontSize: AppDimensions.d28.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                      fontFamily: 'Gothic',
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: AppDimensions.d16.h),

                  // Description
                  Text(
                    'Step into the role of a strategic leader. Whether you\'re flying solo, teaming up, or pursuing certification, every choice you make will shape the path to organizational success.',
                    style: TextStyle(
                      fontSize: AppDimensions.d16.sp,
                      color: AppColors.textSecondary,
                      fontFamily: 'Gothic',
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: AppDimensions.d40.h),

                  // ✅ Swipe to Start Container
                  SwipeToStart(
                    onSwipeComplete: () {
                      Get.offAllNamed(AppRoutes.splash1);
                    },
                  ),

                  SizedBox(height: AppDimensions.d40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- SwipeToStart Widget ----------------
class SwipeToStart extends StatefulWidget {
  final VoidCallback onSwipeComplete;
  const SwipeToStart({super.key, required this.onSwipeComplete});

  @override
  State<SwipeToStart> createState() => _SwipeToStartState();
}

class _SwipeToStartState extends State<SwipeToStart> {
  double _dragPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    final double containerWidth = MediaQuery.of(context).size.width - 48.w; // Padding accounted
    final double arrowSize = 50.w;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragPosition += details.delta.dx;
          if (_dragPosition < 0) _dragPosition = 0;
          if (_dragPosition > containerWidth - arrowSize) {
            _dragPosition = containerWidth - arrowSize;
          }
        });
      },
      onHorizontalDragEnd: (details) {
        if (_dragPosition >= containerWidth - arrowSize - 5) {
          widget.onSwipeComplete();
        } else {
          setState(() {
            _dragPosition = 0;
          });
        }
      },
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Background container
          Container(
            height: 60.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),

          // **Base Text** (Black)
          Positioned.fill(
            child: Center(
              child: Text(
                "Swipe to Start",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: AppDimensions.d16.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Gothic',
                ),
              ),
            ),
          ),

          // Progress Fill Container
          Positioned(
            left: 0,
            child: Container(
              height: 60.h,
              width: _dragPosition + arrowSize,
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
          ),

          // **Overlay Text** (White) — shows only where progress fill is
          Positioned.fill(
            child: ClipRect(
              clipper: _TextClipper(width: _dragPosition + arrowSize),
              child: Center(
                child: Text(
                  "Swipe to Start",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppDimensions.d16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Gothic',
                  ),
                ),
              ),
            ),
          ),

          // Circular Arrow
          Positioned(
            left: _dragPosition,
            child: Container(
              width: arrowSize,
              height: arrowSize,
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryRed, width: 2.w),
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// **Custom Clipper for Overlay Text**
class _TextClipper extends CustomClipper<Rect> {
  final double width;
  _TextClipper({required this.width});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, width, size.height);
  }

  @override
  bool shouldReclip(_TextClipper oldClipper) {
    return oldClipper.width != width;
  }
}
