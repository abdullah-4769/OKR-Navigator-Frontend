import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/core/app_dimensions.dart';
import 'package:game_app/data/repositories/storage_repository.dart';
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
  final StorageRepository _storageRepo = Get.find<StorageRepository>();

  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: AppConstants.splashDuration));
    if (!mounted) return;

    try {
      // ✅ UPDATED: Check both access token AND user data (for Google login)
      final token = _storageRepo.getAccessToken();
      final userId = _storageRepo.getUserId();
      final isLoggedIn = _storageRepo.isLoggedIn();

      // Debug logs
      print('🔍 Splash Screen Check:');
      print('   - Access Token: ${token != null ? "✅ Found" : "❌ Not found"}');
      print('   - User ID: ${userId ?? "❌ Not found"}');
      print('   - Is Logged In: $isLoggedIn');

      // Check if user is logged in (works for both email and Google login)
      if (isLoggedIn && userId != null && userId.isNotEmpty) {
        print('✅ User is logged in → Navigating to Home');
        await Get.offAllNamed(AppRoutes.home);
      } else {
        print('❌ User not logged in → Navigating to Language Selection');
        await Get.offAllNamed(AppRoutes.language);
      }
    } catch (e) {
      print('❌ Error during splash navigation: $e');
      // On error, go to language/login screen
      await Get.offAllNamed(AppRoutes.language);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: OrientationBuilder(
      builder: (context, orientation) {
        final isPortrait = orientation == Orientation.portrait;

        return Center(
          child: Container(
            width: double.infinity.w,
            height: double.infinity.h,
            decoration: BoxDecoration(
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

                    const CustomSvg(
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
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:game_app/core/app_dimensions.dart';
// import 'package:game_app/data/repositories/storage_repository.dart';
// import 'package:game_app/presentation/widgets/custom_svg.dart';
// import 'package:get/get.dart';
//
// import '../../../core/app_colors.dart';
// import '../../../core/app_constants.dart';
// import '../../routes/app_routes.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _navigateToNext();
//   }
//
//   Future<void> _navigateToNext() async {
//     await Future.delayed(const Duration(seconds: AppConstants.splashDuration));
//     if (!mounted) return;
//
//     final token = Get.find<StorageRepository>().getAccessToken();
//     if (token != null) {
//       await Get.offAllNamed(AppRoutes.home);
//     } else {
//       await Get.offAllNamed(AppRoutes.language);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     body: OrientationBuilder(
//       builder: (context, orientation) {
//         final isPortrait = orientation == Orientation.portrait;
//
//         return Center(
//           child: Container(
//             width: double.infinity.w,
//             height: double.infinity.h,
//             decoration:  BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
//               ),
//             ),
//             child: SafeArea(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: AppDimensions.d16.w),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(height: AppDimensions.d300.h),
//
//                     CustomSvg(
//                       semanticsLabel: 'OKR Logo',
//                       assetPath: 'assets/images/okrnev.svg',
//                       height: AppDimensions.d80.h,
//                       width: AppDimensions.d90.w,
//                     ),
//
//                     SizedBox(height: isPortrait ? 30.h : AppDimensions.d20.h),
//                     SizedBox(height: 270.h),
//
//                     const CustomSvg(
//                       semanticsLabel: 'Company Logo',
//                       assetPath: 'assets/images/logo.svg',
//                     ),
//
//                     SizedBox(height: AppDimensions.d30.h),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     ),
//   );
// }
