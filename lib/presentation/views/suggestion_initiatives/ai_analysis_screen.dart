// lib/presentation/screens/ai_analysis/ai_analysis_screen.dart
// lib/presentation/screens/ai_analysis/ai_analysis_show_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/app_dimensions.dart';
import '../../../generated/models/responses/ai_analysis_model/ai_analysis_model.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

class AIAnalysisShowScreen extends StatelessWidget {
  AIAnalysisShowScreen({super.key});

  final AIAnalysisViewModel viewModel = Get.put(AIAnalysisViewModel());

  String _safeTranslate(String? key, {String fallback = ''}) {
    if (key == null) return fallback;
    try {
      return key.tr;
    } catch (e) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: CustomBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: AppDimensions.d18.h),
                  child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.03),
                      CustomHeader(
                        title: _safeTranslate('ai_analysis'),
                        highlightedText: _safeTranslate('results'),
                        subtitle: '',
                        onBackTap: () => Get.offAllNamed(AppRoutes.teamSuggestionInitiativeScreen),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      if (viewModel.isAnalysisDone.value)
                        _buildAnalysisCard(viewModel)
                      else
                        _buildLoadingCard(),
                      SizedBox(height: screenHeight * 0.02),
                      if (viewModel.isAnalysisDone.value) _buildScoreSection(viewModel),
                      SizedBox(height: screenHeight * 0.02),
                      if (viewModel.isAnalysisDone.value) _buildDecisionBadge(viewModel),
                      SizedBox(height: screenHeight * 0.02),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: CustomButton(
                          text: _safeTranslate('check_contextual_challenge'),
                          onPressed: viewModel.isAnalysisDone.value
                              ? () => Get.toNamed(AppRoutes.contextualChallenge)
                              : () {},
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.001),
                    ],
                  )),
                ),
              ),
              Positioned(
                right: screenWidth * -0.07,
                top: screenHeight * 0.50,
                child: const CustomHomeNavBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalysisCard(AIAnalysisViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: viewModel.isAccepted ? const Color(0xFFBFD200) : Colors.orange,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  viewModel.isAccepted ? Icons.check_circle : Icons.info,
                  color: viewModel.isAccepted ? const Color(0xFFBFD200) : Colors.orange,
                  size: 28.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    viewModel.decision,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              _safeTranslate('explanation', fallback: 'Explanation'),
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              viewModel.explanation,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreSection(AIAnalysisViewModel viewModel) {
    Color scoreColor;
    if (viewModel.isHighScore) {
      scoreColor = const Color(0xFFBFD200);
    } else if (viewModel.isMediumScore) {
      scoreColor = Colors.orange;
    } else {
      scoreColor = Colors.red;
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Text(
              _safeTranslate('initiative_score', fallback: 'Initiative Score'),
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              viewModel.score,
              style: TextStyle(
                color: scoreColor,
                fontSize: 48.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '/ 100',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecisionBadge(AIAnalysisViewModel viewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: viewModel.isAccepted ? const Color(0xFFBFD200).withOpacity(0.2) : Colors.orange.withOpacity(0.2),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: viewModel.isAccepted ? const Color(0xFFBFD200) : Colors.orange,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              viewModel.isAccepted ? Icons.check_circle_outline : Icons.warning_amber_rounded,
              color: viewModel.isAccepted ? const Color(0xFFBFD200) : Colors.orange,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              viewModel.decision.toUpperCase(),
              style: TextStyle(
                color: viewModel.isAccepted ? const Color(0xFFBFD200) : Colors.orange,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(40.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            CircularProgressIndicator(
              color: const Color(0xFFBFD200),
            ),
            SizedBox(height: 20.h),
            Text(
              _safeTranslate('loading_analysis', fallback: 'Analyzing initiatives...'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../../../controllers/custom_ai_startegy_controller.dart';
// import '../../../core/app_colors.dart';
// import '../../../core/app_dimensions.dart';
// import '../../routes/app_routes.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_home_navbar.dart';
// import '../../widgets/custom_info_container.dart';
// import '../../widgets/screens_unique_parts/custom_background.dart';
// import '../../widgets/screens_unique_parts/custom_header.dart';
//
// class AIAnalysisScreen extends StatelessWidget {
//   AIAnalysisScreen({super.key});
//
//   final AIStrategyController controller = Get.put(AIStrategyController());
//
//   String _safeTranslate(String? key, {String fallback = ''}) {
//     if (key == null) return fallback;
//     try {
//       return key.tr;
//     } catch (e) {
//       return fallback;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return OrientationBuilder(
//       builder: (context, orientation) => Scaffold(
//         body: CustomBackground(
//           child: SafeArea(
//             child: Stack(
//               children: [
//                 /// ---------- MAIN SCROLL CONTENT ----------
//                 Positioned.fill(
//                   child: SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     padding: EdgeInsets.only(bottom: AppDimensions.d18.h),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SizedBox(height: screenHeight * 0.03),
//
//                         /// ---------- HEADER ----------
//                         CustomHeader(
//                           title: _safeTranslate('suggestion'),
//                           highlightedText: _safeTranslate('of_initiatives'),
//                           subtitle: '',
//                           onBackTap: () =>
//                               Get.offAllNamed(AppRoutes.teamSuggestionInitiativeScreen),
//                         ),
//
//                         SizedBox(height: screenHeight * 0.005),
//
//                         /// ---------- INFO CONTAINER ----------
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 16.w),
//                           child: const CustomInfoContainer(
//                             percentage: 65,
//                             robotAsset: "assets/images/robot.svg",
//                             title: "Strategic Tips",
//                             description:
//                             "Focus on measurable actions that directly impact revenue\n\n"
//                                 "Consider market research, product development, or sales strategies\n\n"
//                                 "Think about timeline, resources, and success metrics",
//                             percentageBarColor: Color(0xFFBFD200),
//                           ),
//                         ),
//
//                         SizedBox(height: screenHeight * 0.02),
//
//                         /// ---------- BUTTON ----------
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 20.w),
//                           child: Obx(() {
//                             final bool enabled =
//                                 controller.isAnalysisDone.value;
//                             return CustomButton(
//                               text: _safeTranslate(
//                                   'check_contextual_challenge'),
//                               onPressed: enabled
//                                   ? () => Get.toNamed(
//                                 AppRoutes.contextualChallenge,
//                               )
//                                   : () {Get.toNamed(
//                                 AppRoutes.contextualChallenge,
//                               );},
//                             );
//                           }),
//                         ),
//
//                         SizedBox(height: screenHeight * 0.001),
//                       ],
//                     ),
//                   ),
//                 ),
//
//                 /// ---------- FLOATING HOME NAV ----------
//                 Positioned(
//                   right: screenWidth * -0.07,
//                   top: screenHeight * 0.50,
//                   child: const CustomHomeNavBar(),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
