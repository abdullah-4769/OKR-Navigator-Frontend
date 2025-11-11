import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_curved_arrow.dart';
import '../../widgets/custom_svg.dart';

class SplashScreenTeam extends StatelessWidget {
  const SplashScreenTeam({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final isPortrait = size.height > size.width;

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
                    SizedBox(height: height * 0.06),

                    /// Top Logo
                    CustomSvg(
                      semanticsLabel: 'okr_logo'.tr,
                      assetPath: 'assets/images/okrnev.svg',
                      height: height * 0.08,
                      width: width * 0.25,
                    ),

                    SizedBox(height: height * 0.03),

                    /// Mask SVG
                    CustomSvg(
                      semanticsLabel: 'mask_group'.tr,
                      assetPath: 'assets/images/team.svg',
                      height: isPortrait ? height * 0.22 : height * 0.4,
                      width: isPortrait ? width * 0.55 : width * 0.35,
                    ),

                    SizedBox(height: height * 0.02),

                    /// Title
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                      child: Text(
                        'welcome_team'.tr,
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w900,
                          fontSize: isPortrait ? width * 0.07 : width * 0.05,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: height * 0.02),

                    /// Subtitle
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: Text(
                        'splash_team_subtitle'.tr,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.black,
                          height: 1.5,
                          fontSize: isPortrait ? width * 0.04 : width * 0.03,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: height * 0.22),

                    /// Bottom Logo
                    CustomSvg(
                      assetPath: 'assets/images/logo.svg',
                      width: width * 0.1,
                      height: width * 0.1,
                      semanticsLabel: '',
                    ),
                    SizedBox(height: height * 0.03),
                  ],
                ),
              ),

              /// Left Arrow
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.0,
                    bottom: height * 0.15,
                  ),
                  child: CustomCurvedArrow(
                    isLeft: true,
                    onTap: () => Get.back(),
                    width: width * 0.15,
                    height: height * 0.2,
                  ),
                ),
              ),

              /// Right Arrow
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: width * 0.0,
                    bottom: height * 0.15,
                  ),
                  child: CustomCurvedArrow(
                    isLeft: false,
                    onTap: () => Get.toNamed(AppRoutes.teamIndustryChooseScreen),
                    width: width * 0.15,
                    height: height * 0.2,
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
