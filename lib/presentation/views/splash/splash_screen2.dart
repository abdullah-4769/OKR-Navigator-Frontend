import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_curved_arrow.dart';
import '../../widgets/custom_svg.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({super.key});

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: AppDimensions.d50.h),

                    // Top Logo
                    CustomSvg(
                      semanticsLabel: 'okr_logo'.tr,
                      assetPath: 'assets/images/okrnev.svg',
                      height: AppDimensions.d70.h,
                      width: AppDimensions.d90.w,
                    ),

                    SizedBox(height: AppDimensions.d24.h),

                    // Mask Image
                    CustomSvg(
                      semanticsLabel: 'mask_group'.tr,
                      assetPath: 'assets/images/maskgroup.svg',
                      height: 170.h,
                      width: 200.w,
                    ),

                    SizedBox(height: AppDimensions.d20.h),

                    // Title
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.d16.w,
                      ),
                      child: Center(
                        child: Text(
                          'splash2_title'.tr,
                          style: TextStyle(
                            fontSize: AppDimensions.d24.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                            fontFamily: 'Gotham Black',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    SizedBox(height: AppDimensions.d16.h),

                    // Subtitle
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.d12.w,
                      ),
                      child: Center(
                        child: Text(
                          'splash2_subtitle'.tr,
                          style: TextStyle(
                            fontSize: AppDimensions.d16.sp,
                            color: AppColors.black,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Gotham Black',
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.25),

                    // Bottom Logo
                    Center(
                      child: CustomSvg(
                        assetPath: 'assets/images/logo.svg',
                        width: AppDimensions.d30.w,
                        height: AppDimensions.d30.h,
                        semanticsLabel: '',
                      ),
                    ),
                    SizedBox(height: AppDimensions.d20.h),
                  ],
                ),
              ),

              // Left Arrow
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.00,
                    bottom: screenHeight * 0.15,
                  ),
                  child: CustomCurvedArrow(
                    isLeft: true,
                    onTap: () => Get.offAllNamed(AppRoutes.splash1),
                    width: AppDimensions.d55.w,
                    height: AppDimensions.d130.h,
                  ),
                ),
              ),

              // Right Arrow
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: screenWidth * 0.00,
                    bottom: screenHeight * 0.15,
                  ),
                  child: CustomCurvedArrow(
                    isLeft: false,
                    onTap: () => Get.offAllNamed(AppRoutes.home),
                    width: AppDimensions.d55.w,
                    height: AppDimensions.d130.h,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
