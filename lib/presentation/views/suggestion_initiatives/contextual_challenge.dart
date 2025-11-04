
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game_app/presentation/views/game_complete/game_complete_screen.dart';
import 'package:get/get.dart';
import '../../../core/app_dimensions.dart';
import '../../../generated/models/responses/evaluate_initiative/evaluate_initiative_model.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

class ContextualChallenge extends StatelessWidget {
  ContextualChallenge({super.key});

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

    final EvaluateInitiativeModel? evaluationData = Get.arguments as EvaluateInitiativeModel?;

    // Check if data exists
    final bool hasData = evaluationData != null;
    final int score = evaluationData?.score ?? 0;
    final String decision = evaluationData?.decision ?? 'Pending';
    final String explanation = evaluationData?.explanation ?? 'No analysis available';
    final bool isAccepted = decision.toLowerCase() == 'accepted';

    // Score categorization
    final bool isHighScore = score >= 80;
    final bool isMediumScore = score >= 50 && score < 80;

    // Get percentage for display
    final int percentage = score;

    return Scaffold(
      body: CustomBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: AppDimensions.d18.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: screenHeight * 0.03),
                      CustomHeader(
                        title: 'suggestion'.tr,
                        highlightedText: 'of_initiatives'.tr,
                        subtitle: '',
                        onBackTap: () => Get.offAllNamed(AppRoutes.teamSuggestionInitiativeScreen),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Main Analysis Container (matching the green card design)
                      if (hasData)
                        _buildAnalysisContainer(
                          percentage: percentage,
                          decision: decision,
                          explanation: explanation,
                          isAccepted: isAccepted,
                          isHighScore: isHighScore,
                          isMediumScore: isMediumScore,
                        )
                      else
                        _buildLoadingCard(),

                      SizedBox(height: screenHeight * 0.02),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: CustomButton(
                          text: _safeTranslate('check_contextual_challenge'),
                          onPressed: hasData
                              // ? () => Get.toNamed(AppRoutes.contextualChallenge)
                              ? () => Get.to(GameCompleteScreen())
                              : () {},
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.001),
                    ],
                  ),
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

  Widget _buildAnalysisContainer({
    required int percentage,
    required String decision,
    required String explanation,
    required bool isAccepted,
    required bool isHighScore,
    required bool isMediumScore,
  }) {
    // Determine colors based on score
    Color containerColor;
    Color percentageBarColor;
    Color iconColor;
    IconData statusIcon;

    if (isHighScore) {
      containerColor = const Color(0xff8DC046);
      percentageBarColor = const Color(0xFFA3B800);
      iconColor = const Color(0xFF2D5016);
      statusIcon = Icons.sentiment_very_satisfied;
    } else if (isMediumScore) {
      containerColor = Colors.orange;
      percentageBarColor = Colors.orange.shade700;
      iconColor = Colors.orange.shade900;
      statusIcon = Icons.sentiment_neutral;
    } else {
      containerColor = Colors.red.shade400;
      percentageBarColor = Colors.red.shade700;
      iconColor = Colors.red.shade900;
      statusIcon = Icons.sentiment_dissatisfied;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xff8DC046),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          children: [
            // Top section with robot and percentage
            Container(
              decoration: BoxDecoration(
                  color: Color(0xff8DC046)
              ),
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: Column(
                children: [
                  // Robot Image
                  SvgPicture.asset(
                    "assets/images/robot.svg",
                    height: 100.h,
                    width: 100.w,
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                color: Color(0xffC8CD37),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    statusIcon,
                    color: Colors.black,
                    size: 32.sp,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    '$percentage%',
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
                color: Color(0xffC8CD37),
              ),
              child: Text(
                _safeTranslate('relevance_threshold') + ': >80%',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Analysis result card
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
                            color: containerColor.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isAccepted ? Icons.lightbulb : Icons.warning_amber_rounded,
                            color: containerColor,
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
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.sp,
                        height: 1.5,
                      ),
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

  Widget _buildLoadingCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(40.w),
        decoration: BoxDecoration(
          color: const Color(0xFFBFD200),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              "assets/images/robot.svg",
              height: 100.h,
              width: 100.w,
            ),
            SizedBox(height: 20.h),
            CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
            SizedBox(height: 20.h),
            Text(
              _safeTranslate('loading_analysis', fallback: 'Analyzing initiatives...'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}