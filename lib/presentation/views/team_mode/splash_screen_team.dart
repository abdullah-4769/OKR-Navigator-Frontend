import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_curved_arrow.dart';
import '../../widgets/custom_svg.dart';

class SplashScreenTeam extends StatefulWidget {
  const SplashScreenTeam({super.key});

  @override
  State<SplashScreenTeam> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreenTeam> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return OrientationBuilder(
      builder: (context, orientation) => Scaffold(
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
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: AppDimensions.d50.h),

                      // Top Logo
                      CustomSvg(
                        semanticsLabel: 'okr_logo'.tr,
                        assetPath: 'assets/images/okrnev.svg',
                        height: 70.h,
                        width: 90.w,
                      ),

                      SizedBox(height: AppDimensions.d24.h),

                      // Mask SVG
                      CustomSvg(
                        semanticsLabel: 'mask_group'.tr,
                        assetPath: 'assets/images/team.svg',
                        height: 170.h,
                        width: 200.w,
                      ),

                      SizedBox(height: AppDimensions.d16.h),

                      // Title - Using Theme
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.d16.w,
                        ),
                        child: Center(
                          child: Text(
                            'welcome_team'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.w900, // Keep bold
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      SizedBox(height: AppDimensions.d16.h),

                      // Subtitle - Using Theme
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.d12.w,
                        ),
                        child: Center(
                          child: Text(
                            'splash_team_subtitle'.tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              color: AppColors.black,
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

                // Left Arrow Button
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth * 0.00,
                      bottom: screenHeight * 0.15,
                    ),
                    child: CustomCurvedArrow(
                      isLeft: true,
                      onTap: () => Get.back(),
                      width: AppDimensions.d55.w,
                      height: AppDimensions.d130.h,
                    ),
                  ),
                ),

                // Right Arrow Button
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: screenWidth * 0.00,
                      bottom: screenHeight * 0.15,
                    ),
                    child: CustomCurvedArrow(
                      isLeft: false,
                      onTap: () => Get.toNamed(AppRoutes.createTeam),
                      width: AppDimensions.d55.w,
                      height: AppDimensions.d130.h,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
