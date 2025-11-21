import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/app_assets.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../services/shared_preference.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common_image.dart';
import '../../widgets/custom_svg.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}


class _StartScreenState extends State<StartScreen> {
  bool fromGameMode = false;
  String? selectedMode;

  @override
  void initState() {
    super.initState();
    _checkNavigationSource();
  }

  void _checkNavigationSource() {
    // Check if we came from GameModeScreen
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      fromGameMode = args['fromGameMode'] ?? false;
      selectedMode = args['selectedMode'];
      print('🎮 StartScreen - From GameMode: $fromGameMode');
      print('🎮 StartScreen - Selected Mode: $selectedMode');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: Stack(
            children: [
              // Background gradient
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
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
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Logo
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

                            // MaskGroup Image
                            CommonImage(
                              assetPath: 'assets/images/start_screen_img.png',
                              width: AppDimensions.d180.w,
                              height: AppDimensions.d200.h,
                              semanticsLabel: '',
                            ),

                            SizedBox(height: AppDimensions.d40.h),

                            // Welcome Title
                            Text(
                              fromGameMode && selectedMode != null
                                  ? _getWelcomeTitle()
                                  : 'welcome_to_okr_navigator'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(color: AppColors.primaryBlue),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: AppDimensions.d16.h),

                            // Description
                            Text(
                              fromGameMode && selectedMode != null
                                  ? _getModeDescription()
                                  : 'start_screen_description'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                color: AppColors.black,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: AppDimensions.d40.h),

                            // Swipe to Start Button
                            SwipeToStart(
                              onSwipeComplete: _handleSwipeComplete,
                            ),

                            SizedBox(height: AppDimensions.d40.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getWelcomeTitle() {
    switch (selectedMode) {
      case 'solo':
        return 'ready_for_solo_mode'.tr;
      case 'team':
        return 'ready_for_team_mode'.tr;
      case 'campaign':
        return 'ready_for_campaign_mode'.tr;
      default:
        return 'welcome_to_okr_navigator'.tr;
    }
  }

  String _getModeDescription() {
    switch (selectedMode) {
      case 'solo':
        return 'solo_mode_description'.tr;
      case 'team':
        return 'team_mode_description'.tr;
      case 'campaign':
        return 'campaign_mode_description'.tr;
      default:
        return 'start_screen_description'.tr;
    }
  }

  void _handleSwipeComplete() async {
    if (fromGameMode && selectedMode != null) {
      // Coming from game mode selection - proceed to pricing screen
      print('🎮 Proceeding to PricingScreen with mode: $selectedMode');
      
      // Verify the mode is saved
      final savedMode = await SharedPrefs.getGameMode();
      print('✅ Verified saved mode: $savedMode');
      
      Get.offAllNamed(AppRoutes.pricingScreen);
    } else {
      // Normal flow - go to splash1
      Get.offAllNamed(AppRoutes.splash2);
    }
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
    final double containerWidth =
        MediaQuery.of(context).size.width - 48.w; // Considering padding
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
          setState(() => _dragPosition = 0);
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

          // Base Text (Black)
          Positioned.fill(
            child: Center(
              child: Text(
                'swipe_to_start'.tr,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
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

          // Overlay Text (White)
          Positioned.fill(
            child: ClipRect(
              clipper: _TextClipper(width: _dragPosition + arrowSize),
              child: Center(
                child: Text(
                  'swipe_to_start'.tr,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          // Circular Arrow Button
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
              child: const Icon(
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

// Custom Clipper for Overlay Text
class _TextClipper extends CustomClipper<Rect> {
  final double width;
  _TextClipper({required this.width});

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, width, size.height);

  @override
  bool shouldReclip(_TextClipper oldClipper) => oldClipper.width != width;
}