import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../controllers/custom_ai_startegy_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_AIstrategycontainer.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_curved_arrow.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_info_container.dart';
import '../../widgets/custom_svg.dart';


class AIAnalysisScreen extends StatelessWidget {
  // ✅ Initialize controller with Get.put (if not already initialized)
  final AIStrategyController controller = Get.put(AIStrategyController());

  AIAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        return Scaffold(
          backgroundColor: Colors.white,

          body: SafeArea(
            child: Stack(
              children: [
                // 🔹 Background Gradient
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.backgroundTop,
                          AppColors.backgroundBottom
                        ],
                      ),
                    ),
                  ),
                ),

                // 🔹 Scrollable Content
                Positioned.fill(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: AppDimensions.d90.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: AppDimensions.d16.h),

                          // 🔹 Header
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: AppDimensions.d1.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomCurvedArrow(
                                  isLeft: true,
                                  onTap: () =>
                                      Get.offAllNamed(AppRoutes.keyResultsScreen),
                                  width: AppDimensions.d55.w,
                                  height: AppDimensions.d130.h,
                                ),
                                Expanded(
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Suggestion ',
                                          style: TextStyle(
                                            fontFamily: 'Gotham-Bold',
                                            fontSize: AppDimensions.d40.sp,
                                            color: AppColors.primaryRed,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\nof Initiatives',
                                          style: TextStyle(
                                            fontFamily: 'Gotham-Bold',
                                            fontSize: AppDimensions.d26.sp,
                                            color: AppColors.primaryBlue,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                CircleAvatar(
                                  radius: AppDimensions.d22.r,
                                  backgroundColor: AppColors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(2.r),
                                    child: CustomSvg(
                                      assetPath: 'assets/images/solo.svg',
                                      semanticsLabel: 'profile',
                                      height: AppDimensions.d60.h,
                                      width: AppDimensions.d60.w,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: AppDimensions.d10.h),
                          CustomInfoContainer(
                            backgroundColor: Colors.green, // parrot color
                            logoAsset: 'assets/icons/bulb.svg',

                            description: 'Submit your initiatives for AI analysis. Feedback will appear here.', title: '',
                          ),

                          SizedBox(height: AppDimensions.d10.h),
                          // 🔹 Complete Button (with proper GetX usage)
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: AppDimensions.d40.w),
                            child: Obx(() {
                              // Example: enable/disable button based on a controller observable
                              final bool isEnabled = controller.isAnalysisDone.value;
                              return CustomButton(
                                text: 'Check contextual Challange', onPressed: () {  },

                              );
                            }),
                          ),

                          SizedBox(height: AppDimensions.d20.h),
                        ],
                      ),
                    ),
                  ),
                ),

                // 🔹 Responsive Home Bar
                Positioned(
                  right: screenWidth * -0.07,
                  top: screenHeight * 0.50,
                  child: const CustomHomeNavBar(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}





//
//
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:get/get.dart';
// // import 'package:flutter_svg/flutter_svg.dart';
// // import '../../../core/app_colors.dart';
// // import '../../../core/app_dimensions.dart';
// // import '../../controllers/custom_ai_startegy_controller.dart';
// // import '../../routes/app_routes.dart';
// // import '../../widgets/custom_button2.dart';
// // import '../../widgets/custom_curved_arrow.dart';
// // import '../../widgets/custom_home_navbar.dart';
// // import '../../widgets/custom_industry_container.dart';
// // import '../../widgets/custom_objective_container.dart';
// // import '../../widgets/custom_selected_key_result_container.dart';
// // import '../../widgets/custom_svg.dart';
// //
// // class AIAnalysisScreen extends StatelessWidget {
// //   final AIStrategyController controller = Get.put(AIStrategyController());
// //
// //   AIAnalysisScreen({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       appBar: AppBar(
// //         backgroundColor: AppColors.primaryRed,
// //         elevation: 0,
// //         title: Text(
// //           "AI Strategic Analysis",
// //           style: TextStyle(
// //             color: Colors.white,
// //             fontFamily: 'Gotham-Bold',
// //             fontSize: AppDimensions.d18.sp,
// //           ),
// //         ),
// //       ),
// //       body:  SafeArea(
// //         child: Stack(
// //             children: [
// //             // 🔹 Background Gradient
// //             Positioned.fill(
// //             child: Container(
// //             decoration: const BoxDecoration(
// //             gradient: LinearGradient(
// //         begin: Alignment.topCenter,
// //         end: Alignment.bottomCenter,
// //         colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
// //             ),
// //             ),
// //             ),
// //             ),
// //
// //             // 🔹 Scrollable Content
// //             Positioned.fill(
// //             child: SingleChildScrollView(
// //             physics: const BouncingScrollPhysics(),
// //             child: Padding(
// //             padding: EdgeInsets.only(bottom: AppDimensions.d90.h),
// //             child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.center,
// //             children: [
// //             SizedBox(height: AppDimensions.d16.h),
// //
// //             // 🔹 Header
// //             Padding(
// //             padding: EdgeInsets.symmetric(horizontal: AppDimensions.d1.w),
// //             child: Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //             CustomCurvedArrow(
// //             isLeft: true,
// //             onTap: () => Get.offAllNamed(AppRoutes.keyResultsScreen),
// //             width: AppDimensions.d55.w,
// //             height: AppDimensions.d130.h,
// //             ),
// //             Expanded(
// //             child: RichText(
// //             textAlign: TextAlign.center,
// //             text: TextSpan(
// //             children: [
// //             TextSpan(
// //             text: 'Suggestion ',
// //             style: TextStyle(
// //             fontFamily: 'Gotham-Bold',
// //             fontSize: AppDimensions.d40.sp,
// //             color: AppColors.primaryRed,
// //             fontWeight: FontWeight.bold,
// //             ),
// //             ),
// //             TextSpan(
// //             text: '\nof Initiatives',
// //             style: TextStyle(
// //             fontFamily: 'Gotham-Bold',
// //             fontSize: AppDimensions.d26.sp,
// //             color: AppColors.primaryBlue,
// //             fontWeight: FontWeight.w700,
// //             ),
// //             ),
// //             ],
// //             ),
// //             ),
// //             ),
// //             CircleAvatar(
// //             radius: AppDimensions.d22.r,
// //             backgroundColor: AppColors.white,
// //             child: Padding(
// //             padding: EdgeInsets.all(2.r),
// //             child: CustomSvg(
// //             assetPath: 'assets/images/solo.svg',
// //             semanticsLabel: 'profile',
// //             height: AppDimensions.d60.h,
// //             width: AppDimensions.d60.w,
// //             ),
// //             ),
// //             ),
// //             ],
// //             ),
// //             ),
// //
// //             SizedBox(height: AppDimensions.d10.h),
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //
// //             // 🔹 Complete Button
// //             Padding(
// //             padding: EdgeInsets.symmetric(horizontal: AppDimensions.d40.w),
// //             child: Obx(
// //             () => CustomButton2(text: '', onPressed: () {  },
// //
// //
// //             )
// //             ),
// //             ),
// //             ]),
// //
// //             SizedBox(height: AppDimensions.d20.h),
// //     ],
// //             ),
// //             ),
// //             ),
// //             ),
// //
// //             // 🔹 Responsive Home Bar
// //             Positioned(
// //             right: screenWidth * -0.07000001,
// //             top: screenHeight * 0.50,
// //             child: const CustomHomeNavBar(),
// //             ),
// //             ],
// //             ),
// //       ),
// //     // Padding(
// //     //   padding: EdgeInsets.all(AppDimensions.d20.w),
// //     //   child: Obx(() {
// //     //     final bool isAnalysisDone = controller.isAnalysisDone.value;
// //     //
// //     //     return Column(
// //     //       crossAxisAlignment: CrossAxisAlignment.start,
// //     //       children: [
// //     //         // ✅ Header with Icon + Title
// //     //         Row(
// //     //           crossAxisAlignment: CrossAxisAlignment.start,
// //     //           children: [
// //     //             Center(
// //     //               child: SvgPicture.asset(
// //     //                 "assets/images/robot.svg",
// //     //                 height: AppDimensions.d50.h,
// //     //                 width: AppDimensions.d50.w,
// //     //               ),
// //     //             ),
// //     //             SizedBox(width: AppDimensions.d12.w),
// //     //             Expanded(
// //     //               child: Column(
// //     //                 crossAxisAlignment: CrossAxisAlignment.start,
// //     //                 children: [
// //     //                   Text(
// //     //                     "AI Strategic Analysis",
// //     //                     style: TextStyle(
// //     //                       fontFamily: 'Gotham-Bold',
// //     //                       fontSize: AppDimensions.d20.sp,
// //     //                       color: AppColors.primaryBlue,
// //     //                       fontWeight: FontWeight.bold,
// //     //                     ),
// //     //                   ),
// //     //                   SizedBox(height: AppDimensions.d4.h),
// //     //                   Text(
// //     //                     "Relevance threshold: >${controller.threshold.value}%",
// //     //                     style: TextStyle(
// //     //                       fontSize: AppDimensions.d12.sp,
// //     //                       color: AppColors.textSecondary,
// //     //                       fontFamily: 'Gotham',
// //     //                     ),
// //     //                   ),
// //     //                 ],
// //     //               ),
// //     //             ),
// //     //           ],
// //     //         ),
// //     //
// //     //         SizedBox(height: AppDimensions.d20.h),
// //     //
// //     //         // ✅ AI Analysis Container
// //     //         Container(
// //     //           width: double.infinity,
// //     //           padding: EdgeInsets.all(AppDimensions.d16.w),
// //     //           decoration: BoxDecoration(
// //     //             color: Colors.white,
// //     //             borderRadius: BorderRadius.circular(AppDimensions.d12.r),
// //     //             border: Border.all(
// //     //               color: isAnalysisDone
// //     //                   ? AppColors.successGreen.withOpacity(0.5)
// //     //                   : AppColors.primaryRed.withOpacity(0.5),
// //     //             ),
// //     //             boxShadow: [
// //     //               BoxShadow(
// //     //                 color: Colors.black.withOpacity(0.05),
// //     //                 blurRadius: 8,
// //     //                 offset: const Offset(0, 4),
// //     //               ),
// //     //             ],
// //     //           ),
// //     //           child: isAnalysisDone
// //     //               ? Column(
// //     //             crossAxisAlignment: CrossAxisAlignment.start,
// //     //             children: [
// //     //               Text(
// //     //                 "AI Feedback",
// //     //                 style: TextStyle(
// //     //                   fontSize: AppDimensions.d16.sp,
// //     //                   fontWeight: FontWeight.bold,
// //     //                   color: AppColors.primaryBlue,
// //     //                   fontFamily: 'Gotham-Bold',
// //     //                 ),
// //     //               ),
// //     //               SizedBox(height: AppDimensions.d8.h),
// //     //               Text(
// //     //                 controller.feedback.value,
// //     //                 style: TextStyle(
// //     //                   fontSize: AppDimensions.d14.sp,
// //     //                   color: AppColors.textSecondary,
// //     //                   fontFamily: 'Gotham',
// //     //                 ),
// //     //               ),
// //     //             ],
// //     //           )
// //     //               : Column(
// //     //             children: [
// //     //               Icon(
// //     //                 Icons.analytics,
// //     //                 size: AppDimensions.d40.w,
// //     //                 color: AppColors.primaryRed,
// //     //               ),
// //     //               SizedBox(height: AppDimensions.d12.h),
// //     //               Text(
// //     //                 "Submit your initiatives for AI analysis",
// //     //                 textAlign: TextAlign.center,
// //     //                 style: TextStyle(
// //     //                   fontSize: AppDimensions.d14.sp,
// //     //                   fontWeight: FontWeight.w500,
// //     //                   color: AppColors.textSecondary,
// //     //                   fontFamily: 'Gotham',
// //     //                 ),
// //     //               ),
// //     //               SizedBox(height: AppDimensions.d8.h),
// //     //               Text(
// //     //                 "Feedback will appear here",
// //     //                 textAlign: TextAlign.center,
// //     //                 style: TextStyle(
// //     //                   fontSize: AppDimensions.d12.sp,
// //     //                   color: AppColors.textSecondary.withOpacity(0.7),
// //     //                   fontFamily: 'Gotham',
// //     //                 ),
// //     //               ),
// //     //               SizedBox(height: AppDimensions.d16.h),
// //     //
// //     //               // ✅ Submit Button
// //     //               SizedBox(
// //     //                 width: double.infinity,
// //     //                 child: ElevatedButton(
// //     //                   onPressed: controller.submitForAnalysis,
// //     //                   style: ElevatedButton.styleFrom(
// //     //                     backgroundColor: AppColors.primaryRed,
// //     //                     foregroundColor: Colors.white,
// //     //                     padding: EdgeInsets.symmetric(
// //     //                       vertical: AppDimensions.d14.h,
// //     //                     ),
// //     //                     shape: RoundedRectangleBorder(
// //     //                       borderRadius:
// //     //                       BorderRadius.circular(AppDimensions.d8.r),
// //     //                     ),
// //     //                   ),
// //     //                   child: Text(
// //     //                     "Submit for Analysis",
// //     //                     style: TextStyle(
// //     //                       fontSize: AppDimensions.d16.sp,
// //     //                       fontWeight: FontWeight.w600,
// //     //                       fontFamily: 'Gotham',
// //     //                     ),
// //     //                   ),
// //     //                 ),
// //     //               ),
// //     //             ],
// //     //           ),
// //     //         ),
// //     //       ],
// //     //     );
// //     //   }),
// //     // ),
// //     );
// //   }
// // }
