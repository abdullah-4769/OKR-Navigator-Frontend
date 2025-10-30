import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/widgets/global_widgets/custom_share_button.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../generated/models/responses/campaign/certification_evaluation_response.dart';
import '../../../services/campaign/certification_evaluation_viewmodel.dart';
import '../../../services/shared_preference.dart';

import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_initiative_input.dart';
import '../../widgets/game_complete_widgets/custom_score_card.dart';
import '../../widgets/global_widgets/custom_progress_path.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import '../../widgets/team_mode_widgets/section_card.dart';
import '../../widgets/custom_objective_container.dart';
import '../../widgets/custom_selected_key_result_container.dart';
import '../../widgets/responsive_arrow.dart';

// ================== MAIN SCREEN ==================
class CampaignFinalCertificationScreen extends StatefulWidget {
  const CampaignFinalCertificationScreen({super.key});

  @override
  State<CampaignFinalCertificationScreen> createState() =>
      _CampaignFinalCertificationScreenState();
}

class _CampaignFinalCertificationScreenState extends State<CampaignFinalCertificationScreen> {
  final CertificationEvaluationViewModel viewModel = Get.find<CertificationEvaluationViewModel>();

  @override
  void initState() {
    super.initState();
    // Ensure we have the latest results
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.evaluationResult == null) {
        // Try to load from SharedPreferences if available
        _loadSavedResults();
      }
    });
  }

  void _loadSavedResults() {
    final savedResult = SharedPrefs.getCertificationEvaluationResult();
    if (savedResult != null) {
      // You might want to convert the saved result back to your model
      print('📋 Loaded saved evaluation result');
    }
  }

  String _getLevelAchievement(String certificateLevel) {
    switch (certificateLevel.toLowerCase()) {
      case 'gold':
        return 'Gold Level Achieved';
      case 'silver':
        return 'Silver Level Achieved';
      case 'bronze':
        return 'Bronze Level Achieved';
      default:
        return 'Certificate Achieved';
    }
  }

  String _getBadgeImage(String certificateLevel) {
    switch (certificateLevel.toLowerCase()) {
      case 'gold':
        return "assets/images/gold_badge.png"; // Create these assets
      case 'silver':
        return "assets/images/silver_badge.png";
      case 'bronze':
        return "assets/images/bronze_badge.png";
      default:
        return "assets/images/badge.png";
    }
  }

  Color _getLevelColor(String certificateLevel) {
    switch (certificateLevel.toLowerCase()) {
      case 'gold':
        return Colors.amber;
      case 'silver':
        return Colors.grey;
      case 'bronze':
        return Colors.brown;
      default:
        return AppColors.primaryRed;
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      body: CustomBackground(
        child: OrientationBuilder(
          builder: (context, orientation) => Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: height * 0.015),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomHeader(
                        title: 'Certification',
                        highlightedText: 'Results',

                        onBackTap: () => Get.back(),
                      ),
                      SizedBox(height: height * 0.01),

                      Obx(() {
                        if (viewModel.isLoading.value) {
                          return _buildLoadingState();
                        } else if (viewModel.errorMessage.value.isNotEmpty) {
                          return _buildErrorState();
                        } else if (viewModel.evaluationResult != null) {
                          return _buildResultsState();
                        } else {
                          return _buildNoResultsState();
                        }
                      }),
                    ],
                  ),
                ),
              ),

              /// Floating NavBar
              Positioned(
                right: width * -0.07,
                top: height * 0.5,
                child: const CustomHomeNavBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
          ),
          SizedBox(height: 16.h),
          Text(
            'Generating Your Certificate...',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.primaryRed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.primaryRed,
          ),
          SizedBox(height: 16.h),
          Text(
            'Evaluation Failed',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.primaryRed,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            viewModel.errorMessage.value,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 16.h),
          _buildActionButtons(isError: true),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Icon(
            Icons.quiz_outlined,
            size: 64,
            color: AppColors.primaryRed,
          ),
          SizedBox(height: 16.h),
          Text(
            'No Results Available',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.primaryRed,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Please complete the certification process to see your results',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: 16.h),
          _buildActionButtons(isError: true),
        ],
      ),
    );
  }

  Widget _buildResultsState() {
    final result = viewModel.evaluationResult!;
    final breakdown = result.breakdown;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// AI Evaluation Focus Section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SectionCard(
            title: 'AI Evaluation Breakdown',
            icon: Icons.analytics,
            borderColor: AppColors.primaryRed,
            showScore: true,
            showLeftIcons: false,
            showRightIcons: true,
            showTopButton: false,
            items: [
              {'title': 'Strategy Alignment', 'score': breakdown.strategyScore},
              {'title': 'Objective Quality', 'score': breakdown.objectiveScore},
              {'title': 'Key Results', 'score': breakdown.keyResultScore},
              {'title': 'Initiatives', 'score': breakdown.initiativeScore},
              {'title': 'Overall Coherence', 'score': breakdown.coherenceScore},
            ],
          ),
        ),
        SizedBox(height: height * 0.01),

        /// Score Card
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Container(
            width: width * 0.9,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: _getLevelColor(result.certificateLevel), width: 2),
              boxShadow: [
                BoxShadow(
                  color: _getLevelColor(result.certificateLevel).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomScoreCard(
                  title: 'Final Score',
                  score: result.score,
                  showBackground: false,
                ),
                SizedBox(height: 16.h),
                Image.asset(
                  _getBadgeImage(result.certificateLevel),
                  height: 80.h,
                  width: 80.w,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.emoji_events, size: 60.h, color: _getLevelColor(result.certificateLevel)),
                ),
                SizedBox(height: 12.h),
                Text(
                  _getLevelAchievement(result.certificateLevel),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: _getLevelColor(result.certificateLevel),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  _getCertificateMessage(result),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: height * 0.02),

        /// Strengths Section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SectionCard(
            title: 'Key Strengths',
            icon: Icons.star,
            borderColor: Colors.green,
            showCheck: true,
            showScore: false,
            showLeftIcons: true,
            showRightIcons: false,
            showTopButton: false,
            checkIconColor: Colors.green,
            items: result.feedback.strengths
                .take(3) // Show top 3 strengths
                .map((strength) => {'title': strength})
                .toList(),
          ),
        ),

        /// Action Buttons
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.d24),
          child: _buildActionButtons(),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildActionButtons({bool isError = false}) {
    return Column(
      children: [
        if (!isError) ...[
          CustomButton(
            text: "Retake",
            icon: Icons.repeat,
            onPressed: () {
              print('📍 View Detailed Analysis pressed');
              Get.toNamed('/certificationResult');
            },
          ),
          SizedBox(height: AppDimensions.d12),
        ],
        CustomShareButton(
          text: "share_result".tr,
          shareText: "share_result",
          icon: Icons.share,

        ),
        SizedBox(height: AppDimensions.d12),
        if (isError) ...[
          CustomButton(
            text: "Retry Certification",
            icon: Icons.refresh,
            onPressed: () {
              print('📍 Retry pressed');
              viewModel.submitFinalEvaluation();
            },
          ),
          SizedBox(height: AppDimensions.d12),
        ],
        CustomButton(
          icon: Icons.home,
          text: "Back to Home",
          onPressed: () {
            Get.until((route) => route.isFirst);
          },
          backgroundColor: Colors.grey,
        ),
      ],
    );
  }

  String _getCertificateMessage(CertificationEvaluationResponse result) {
    if (result.score >= 85) {
      return 'Outstanding! You have demonstrated exceptional OKR mastery and strategic thinking.';
    } else if (result.score >= 70) {
      return 'Excellent work! Your OKR shows strong alignment and actionable initiatives.';
    } else if (result.score >= 60) {
      return 'Good job! You have a solid understanding of OKR fundamentals.';
    } else {
      return 'Well done on completing the certification! Continue practicing to improve your skills.';
    }
  }

  void _shareResults() {
    final result = viewModel.evaluationResult;
    if (result == null) return;

    final message = '''
🎯 OKR Certification Results

Score: ${result.score}%
Level: ${result.certificateLevel}

Strengths:
${result.feedback.strengths.take(2).map((s) => '• $s').join('\n')}

Download the OKR Navigator app to get your own certification!
''';

    // You can integrate with share_plus package for actual sharing
    Get.snackbar(
      'Share Results',
      'Results copied to clipboard!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // For actual sharing, use:
    // Share.share(message);
  }
}



