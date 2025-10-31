import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/home_navbar_controller.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';

class CustomHomeNavBar extends StatefulWidget {
  const CustomHomeNavBar({super.key});

  @override
  State<CustomHomeNavBar> createState() => _CustomHomeNavBarState();
}

class _CustomHomeNavBarState extends State<CustomHomeNavBar>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _bounceController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation for the home icon
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Bounce animation controller
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Bounce animation with elastic curve
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.elasticOut,
      ),
    );

    // Slide animation from right
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _triggerBounce() {
    _bounceController.reset();
    _bounceController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeNavBarController(), permanent: true);

    return RepaintBoundary(
      child: Obx(() {
        final isExpanded = controller.isExpanded.value;
        final screenWidth = MediaQuery.of(context).size.width;

        // Trigger bounce animation when expanded
        if (isExpanded) {
          _triggerBounce();
        }

        return AnimatedAlign(
          duration: const Duration(milliseconds: 400),
          alignment: Alignment.centerRight,
          curve: Curves.easeOutCubic,
          child: GestureDetector(
            // ✅ SWIPE LOGIC with debouncing
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx < -5 && !isExpanded) {
                controller.showNavBar();
              } else if (details.delta.dx > 5 && isExpanded) {
                controller.hideNavBar();
              }
            },
            onHorizontalDragEnd: (_) {
              if (isExpanded) {
                controller.startAutoHideTimer();
              }
            },

            // ✅ Tap to go Home or expand with bounce
            onTap: () {
              if (isExpanded) {
                controller.navigateHome();
              } else {
                controller.showNavBar();
                _triggerBounce();
              }
            },

            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height*0.080,
                  maxWidth: screenWidth * 0.6,
                  minWidth: AppDimensions.d80.w,
                ),
                child: AnimatedBuilder(
                  animation: _bounceAnimation,
                  builder: (context, child) => Transform.scale(
                    scale: isExpanded ? 0.90 + (_bounceAnimation.value * 0.17) : 1.0,
                    alignment: Alignment.centerRight,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      width: isExpanded ? null : AppDimensions.d80.w,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.d10.w,
                        vertical: AppDimensions.d8.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed,
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(AppDimensions.d30.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 12 + (_bounceAnimation.value * 8),
                            spreadRadius: _bounceAnimation.value * 2,
                            offset: Offset(2, 3 + (_bounceAnimation.value * 2)),
                          ),
                          // Glow effect when expanded
                          if (isExpanded)
                            BoxShadow(
                              color: AppColors.primaryRed.withValues(alpha: 0.4 * _bounceAnimation.value),
                              blurRadius: 20,
                              spreadRadius: 2,
                              offset: const Offset(0, 0),
                            ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 🔹 Home Icon with pulse and bounce
                          AnimatedBuilder(
                            animation: Listenable.merge([_pulseAnimation, _bounceAnimation]),
                            builder: (context, child) => Transform.scale(
                              scale: isExpanded
                                  ? 0.8 + (_bounceAnimation.value * 0.1)
                                  : _pulseAnimation.value,
                              child: Transform.rotate(
                                angle: isExpanded ? (_bounceAnimation.value * 0.1) : 0,
                                child: AnimatedContainer(
                                  duration: const Duration(seconds: 2),
                                  width: AppDimensions.d50.w,
                                  height: AppDimensions.d50.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: isExpanded
                                        ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.15),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                        : [],
                                  ),
                                  child: Icon(
                                    Icons.home_sharp,
                                    color: AppColors.reddish,
                                    size: AppDimensions.d36.w,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // 🔹 Animated Text with bouncing slide
                          if (isExpanded)
                            SlideTransition(
                              position: _slideAnimation,
                              child: FadeTransition(
                                opacity: _bounceAnimation,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(width: 6.w),

                                    Flexible(
                                      fit: FlexFit.loose,
                                      child: Transform.translate(
                                        offset: Offset(
                                          (_bounceAnimation.value < 0.9)
                                              ? (1.2 - _bounceAnimation.value) * 6
                                              : 0,
                                          0,
                                        ),
                                        child: ShaderMask(
                                          shaderCallback: (bounds) {
                                            return LinearGradient(
                                              colors: [
                                                Colors.white,
                                                Colors.white,
                                                Colors.white.withValues(alpha: 0.8),
                                              ],
                                              stops: const [0.0, 0.7, 1.0],
                                            ).createShader(bounds);
                                          },
                                          child: Text(
                                            'back_home'.tr,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: AppDimensions.d12.sp,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: 'GothamBold',
                                              letterSpacing: 0.5,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 30.w),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}