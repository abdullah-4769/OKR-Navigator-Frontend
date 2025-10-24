import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Required for SvgPicture
import 'package:get/get.dart';
import '../../../generated/models/responses/strategy/generate_intiatives_response.dart'; // Import API response model

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart'; //
import '../../widgets/custom_home_navbar.dart'; //
import '../../widgets/custom_info_container.dart'; //
import '../../widgets/screens_unique_parts/custom_background.dart'; //
import '../../widgets/screens_unique_parts/custom_header.dart'; //

class TeamAIAnalysisScreen extends StatelessWidget {
    // Removed unused TeamAIStrategyController
 TeamAIAnalysisScreen({super.key});

 String _safeTranslate(String? key, {String fallback = ''}) {
  if (key == null) return fallback;
  try {
   return key.tr;
  } catch (e) {
   return fallback;
  }
 }

// 💡 NEW: Dynamic Analysis Container Widget
Widget _buildAnalysisContainer({
    required int percentage,
    required String decision,
    required String explanation,
}) {
    // Determine dynamic colors based on the score
    Color dynamicBarColor;
    IconData statusIcon;

    final bool isHighScore = percentage >= 80;
    final bool isMediumScore = percentage >= 50 && percentage < 80;
    final bool isAccepted = decision.toLowerCase() == 'accepted' || isHighScore;

    if (isHighScore) {
      dynamicBarColor = const Color(0xff8DC046);
      statusIcon = Icons.sentiment_very_satisfied;
    } else if (isMediumScore) {
      dynamicBarColor = Colors.orange;
      statusIcon = Icons.sentiment_neutral;
    } else {
      dynamicBarColor = Colors.red.shade400;
      statusIcon = Icons.sentiment_dissatisfied;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: dynamicBarColor,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          children: [
            // Top section with robot
            Container(
              decoration: BoxDecoration(color: dynamicBarColor),
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: SvgPicture.asset("assets/images/robot.svg", height: 100.h, width: 100.w),
            ),
            
            // Score Display
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                color: dynamicBarColor.withOpacity(isHighScore ? 0.8 : 0.6), 
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(statusIcon, color: Colors.black, size: 32.sp),
                  SizedBox(width: 12.w),
                  Text(
                    '${percentage}%',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Relevance threshold text
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: dynamicBarColor.withOpacity(isHighScore ? 0.9 : 0.7),
              ),
              child: Text(
                _safeTranslate('relevance_threshold') + ': >80%',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ),

            // Analysis result card (Explanation)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon and Title
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: dynamicBarColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isAccepted ? Icons.lightbulb : Icons.warning_amber_rounded,
                            color: dynamicBarColor,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            decision,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Explanation text
                    Text(
                      explanation,
                      style: TextStyle(color: Colors.black54, fontSize: 15.sp, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
}

 @override
  Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

    // [FIX 1: DEFENSIVE CASTING] Safely retrieve and cast arguments
    final args = Get.arguments;
    GenerateInitiativesResponse? evaluationData;
    bool castSuccessful = false;

    // Only attempt to cast if the argument is the expected API response type
    if (args is GenerateInitiativesResponse) {
        evaluationData = args;
        castSuccessful = true;
    } else {
        // Fallback for when no valid arguments are received (e.g., direct navigation or error)
        // This prevents the crashing loop by safely skipping the cast.
    }
    
    // 2. Extract dynamic data with fallbacks
    final hasData = castSuccessful; // Use cast success for logic
    final score = evaluationData?.score ?? 0;
    final decision = evaluationData?.decision ?? 'Analysis Pending';
    // Provide a more helpful error message if data is missing
    final explanation = evaluationData?.explanation ?? 'Analysis data is missing or invalid. Please re-submit initiatives.'; 

    // Determine colors for the fallback CustomInfoContainer if used
    final fallbackColor = AppColors.primaryRed;

    return OrientationBuilder(
   builder: (context, orientation) => Scaffold(
    body: CustomBackground(
     child: SafeArea(
      child: Stack(
       children: [
        /// ------------ MAIN SCROLL CONTENT ------------
        Positioned.fill(
         child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: AppDimensions.d18.h),
          child: Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
            /// ------------ HEADER ------------
            CustomHeader(
             title: _safeTranslate('suggestion'),
             highlightedText: _safeTranslate('of_initiatives'),
             subtitle: '',
             onBackTap: () =>
               Get.offAllNamed(AppRoutes.teamSuggestionInitiativeScreen),
            ),

            SizedBox(height: AppDimensions.d20.h),

            /// ------------ DYNAMIC ANALYSIS CONTAINER ------------
            Padding(
             padding: EdgeInsets.symmetric(horizontal: 16.w),
             child: hasData
                            ? _buildAnalysisContainer(
                                percentage: score,
                                decision: decision,
                                explanation: explanation,
                            )
                            : CustomInfoContainer(
                                percentage: 0,
                                robotAsset: "assets/images/robot.svg",
                                title: decision,
                                description: explanation,
                                percentageBarColor: fallbackColor,
                            ),
            ),

            SizedBox(height: AppDimensions.d25.h),

            /// ------------ BUTTON ------------
            Padding(
             padding: EdgeInsets.symmetric(horizontal: 20.w),
             child: CustomButton(
              text: _safeTranslate('check_contextual_challenge'),
                            // FIX 2: Enable button only if we received valid data
              onPressed: hasData 
                                ? () => Get.toNamed(AppRoutes.teamContextualChallengeScreen)
                                : () {}, // Pass empty function when disabled
             ),
            ),

            SizedBox(height: AppDimensions.d30.h),
           ],
          ),
         ),
        ),

        /// ------------ FLOATING HOME NAV ------------
        Positioned(
         right: screenWidth * -0.07,
         top: screenHeight * 0.50,
         child: const CustomHomeNavBar(),
        ),
       ],
      ),
     ),
    ),
   ));
 }
}