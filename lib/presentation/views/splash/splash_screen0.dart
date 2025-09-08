import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/core/app_dimensions.dart';
import 'package:game_app/presentation/widgets/custom_svg.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_constants.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(Duration(seconds: AppConstants.splashDuration));
    if (!mounted) return;

    Get.offAllNamed(AppRoutes.language);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;

          return Center(
            child: Container(
              width: double.infinity.w,
              height: double.infinity.h,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.d16.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: AppDimensions.d300.h),

                      CustomSvg(
                        semanticsLabel: 'OKR Logo',
                        assetPath: 'assets/images/okrnev.svg',
                        height: AppDimensions.d80.h,
                        width: AppDimensions.d90.w,
                      ),

                      SizedBox(height: isPortrait ? 30.h : AppDimensions.d20.h),
                      SizedBox(height: 270.h),

                      CustomSvg(
                        semanticsLabel: 'Company Logo',
                        assetPath: 'assets/images/logo.svg',
                      ),

                      SizedBox(height: AppDimensions.d30.h),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
