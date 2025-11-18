import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/widgets/common_image.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_curved_arrow.dart';
import '../../widgets/custom_svg.dart';

class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({super.key});

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsiveness
    ScreenUtil.init(context, designSize: const Size(375, 812));

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50.h),

                    // Top Logo
                    CustomSvg(
                      semanticsLabel: 'okr_logo'.tr,
                      assetPath: 'assets/images/okrnev.svg',
                      height: 70.h,
                      width: 90.w,
                    ),


                    // Mask SVG
                    CommonImage(
                      semanticsLabel: 'mask_group'.tr,
                      assetPath: 'assets/images/start_screen_img.png',
                      height: 190.h,
                      width: 200.w,
                    ),


                    // Title - Using Theme
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Center(
                        child: Text(
                          'welcome_navigator'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Subtitle - Using Theme
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      child: Center(
                        child: Text(
                          'splash1_subtitle'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                            color: AppColors.black,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    SizedBox(height: 0.25.sh), // Responsive height using screen percentage

                    // Bottom Logo
                    Center(
                      child: CustomSvg(
                        assetPath: 'assets/images/logo.svg',
                        width: 30.w,
                        height: 30.h,
                        semanticsLabel: '',
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),

              // Left Arrow Button
              Positioned(
                left: 0,
                bottom: 0.15.sh, // Responsive positioning
                child: CustomCurvedArrow(
                  isLeft: true,
                  onTap: () => Get.offAllNamed(AppRoutes.start),
                  width: 55.w,
                  height: 130.h,
                ),
              ),

              // Right Arrow Button
              Positioned(
                right: 0,
                bottom: 0.15.sh, // Responsive positioning
                child: CustomCurvedArrow(
                  isLeft: false,
                  onTap: () => Get.toNamed(AppRoutes.splash2),
                  width: 55.w,
                  height: 130.h,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}