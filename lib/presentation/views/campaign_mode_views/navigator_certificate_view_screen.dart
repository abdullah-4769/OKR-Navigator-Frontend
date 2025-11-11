import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_objective_container.dart';
import '../../widgets/global_widgets/custom_progress_path.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

class NavigatorCertificationViewScreen extends StatefulWidget {
  const NavigatorCertificationViewScreen({super.key});

  @override
  State<NavigatorCertificationViewScreen> createState() =>
      _NavigatorCertificationViewScreenState();
}

class _NavigatorCertificationViewScreenState
    extends State<NavigatorCertificationViewScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: LayoutBuilder(
      builder: (context, constraints) => SafeArea(
        child: CustomBackground(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric( vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  CustomHeader(
                    title: 'Navigator',
                    highlightedText: 'Certification',
                    onBackTap: () {
                      Get.back();
                    },
                  ),

                  SizedBox(height: 24.h),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 8.w),
                    child: const Center(
                      child: CustomObjectiveContainer(
                        icon: Icons.corporate_fare,

                        title: 'Congratrulation',
                        description:
                            'Complete your final assessment to\nearn your certification',
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 8.w),
                  child:
                  const Center(
                    child: CustomProgressPath(
                      stepLabels: ["1", "2", "3"],
                      currentStep: 3,
                      showCircles: true,
                    ),
                  ),),

                  // Campaign Progress
                  SizedBox(height: 24.h),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 8.w),
              child:
                  _buildFinalAssessmentCard(),),
                  SizedBox(height: 24.h),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 8.w),
                  child:
                  // Certification Levels
                  _buildCertificationLevels(),),
                  SizedBox(height: 24.h),
                  SizedBox(height: 20.h),
                  Center(
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 16.w),
                      child: CustomButton(
                        text: 'Start Certification Level',
                        icon: Icons.play_arrow,
                        onPressed: () {
                          Get.toNamed(AppRoutes.campaignModeScreen);
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                  // Center(
                  //   child: Padding(
                  //     padding:  EdgeInsets.symmetric(horizontal: 16.w),
                  //     child: CustomButton(
                  //       text: 'Download',
                  //       icon: Icons.download,
                  //       onPressed: () {
                  //         Get.toNamed(AppRoutes.campaignModeScreen);
                  //       },
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );


  Widget _buildFinalAssessmentCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: const BoxDecoration(
                  color: Color(0xFFD84315),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.assessment, color: Colors.white, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Text(
                'Final Assessment',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _buildAssessmentItem(
            '1',
            'Complex OKR Simulation',
            'Navigate a challenging multi-department scenario',
          ),
          SizedBox(height: 16.h),
          _buildAssessmentItem(
            '2',
            '15-Minute Time Limit',
            'Make strategic decisions under pressure',
          ),
          SizedBox(height: 16.h),
          _buildAssessmentItem(
            '2',
            'AI Assessment',
            'Chatbot AI evaluates your OKR pathway relevance',
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentItem(String number, String title, String description) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.w,
            height: 32.h,
            decoration: const BoxDecoration(
              color: Color(0xFFD84315),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationLevels() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9E6),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFFFD700), width: 2),
      ),
      child: Column(
        children: [
          Image.asset('assets/images/navigator_certificate_icon.png'),
          SizedBox(height: 12.h),
          Text(
            'Certification Levels',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20.h),
          _buildCertificationLevel(
            'Navigator Certified - Gold',
            'Score: 85-100% • Strategic Excellence',
            '🥇',
          ),
          SizedBox(height: 12.h),
          _buildCertificationLevel(
            'Navigator Certified - Silver',
            'Score: 70-84% • Strategic Proficiency',
            '🥈',
          ),
          SizedBox(height: 12.h),
          _buildCertificationLevel(
            'Navigator Certified - Bronze',
            'Score: 60-69% • Strategic Foundation',
            '🥉',
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationLevel(String title, String subtitle, String emoji) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(emoji, style: TextStyle(fontSize: 32.sp)),
        ],
      ),
    );
  }
}
