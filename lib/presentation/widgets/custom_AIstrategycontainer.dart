import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';

class CustomAIStrategyContainer extends StatelessWidget {
  const CustomAIStrategyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppDimensions.d24.w,
        vertical: AppDimensions.d16.h,
      ),
      padding: EdgeInsets.all(AppDimensions.d20.w),
      decoration: BoxDecoration(
        color: AppColors.primaryRed,
        borderRadius: BorderRadius.circular(AppDimensions.d16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header Row
          Row(
            children: [
              SvgPicture.asset(
                "assets/images/robot.svg",
                height: AppDimensions.d50.h,
                width: AppDimensions.d50.w,
              ),
              SizedBox(width: AppDimensions.d12.w),
              Text(
                "AI Strategic Analysis",
                style: TextStyle(
                  fontFamily: 'Gotham-Bold',
                  fontSize: AppDimensions.d20.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: AppDimensions.d20.h),

          /// Inner White Box
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppDimensions.d16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.d12.r),
              border: Border.all(color: AppColors.primaryRed.withOpacity(0.5)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.analytics_outlined,
                    size: AppDimensions.d40.w, color: AppColors.primaryRed),
                SizedBox(height: AppDimensions.d12.h),
                Text(
                  "Submit your initiatives for AI analysis",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppDimensions.d14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    fontFamily: 'Gotham',
                  ),
                ),
                SizedBox(height: AppDimensions.d8.h),
                Text(
                  "Feedback will appear here",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppDimensions.d12.sp,
                    color: AppColors.textSecondary.withOpacity(0.7),
                    fontFamily: 'Gotham',
                  ),
                ),
                // Removed the Submit button
              ],
            ),
          ),
        ],
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import '../../../core/app_colors.dart';
// import '../../../core/app_dimensions.dart';
//
// class CustomAIStrategyContainer extends StatelessWidget {
//   final VoidCallback onSubmit;
//
//   const CustomAIStrategyContainer({super.key, required this.onSubmit});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(
//         horizontal: AppDimensions.d24.w,
//         vertical: AppDimensions.d16.h,
//       ),
//       padding: EdgeInsets.all(AppDimensions.d20.w),
//       decoration: BoxDecoration(
//         color: AppColors.primaryRed,
//         borderRadius: BorderRadius.circular(AppDimensions.d16.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 12,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           /// Header Row
//           Row(
//             children: [
//               SvgPicture.asset(
//                 "assets/images/robot.svg",
//                 height: AppDimensions.d50.h,
//                 width: AppDimensions.d50.w,
//               ),
//               SizedBox(width: AppDimensions.d12.w),
//               Text(
//                 "AI Strategic Analysis",
//                 style: TextStyle(
//                   fontFamily: 'Gotham-Bold',
//                   fontSize: AppDimensions.d20.sp,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//
//           SizedBox(height: AppDimensions.d20.h),
//
//           /// Inner White Box
//           Container(
//             width: double.infinity,
//             padding: EdgeInsets.all(AppDimensions.d16.w),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(AppDimensions.d12.r),
//               border: Border.all(color: AppColors.primaryRed.withOpacity(0.5)),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.analytics_outlined,
//                     size: AppDimensions.d40.w, color: AppColors.primaryRed),
//                 SizedBox(height: AppDimensions.d12.h),
//                 Text(
//                   "Submit your initiatives for AI analysis",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: AppDimensions.d14.sp,
//                     fontWeight: FontWeight.w500,
//                     color: AppColors.textSecondary,
//                     fontFamily: 'Gotham',
//                   ),
//                 ),
//                 SizedBox(height: AppDimensions.d8.h),
//                 Text(
//                   "Feedback will appear here",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: AppDimensions.d12.sp,
//                     color: AppColors.textSecondary.withOpacity(0.7),
//                     fontFamily: 'Gotham',
//                   ),
//                 ),
//                 SizedBox(height: AppDimensions.d16.h),
//                 ElevatedButton(
//                   onPressed: onSubmit,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primaryRed,
//                     foregroundColor: Colors.white,
//                     padding: EdgeInsets.symmetric(vertical: AppDimensions.d14.h),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(AppDimensions.d8.r),
//                     ),
//                   ),
//                   child: Text(
//                     "Submit for Analysis",
//                     style: TextStyle(
//                       fontSize: AppDimensions.d16.sp,
//                       fontWeight: FontWeight.w600,
//                       fontFamily: 'Gotham',
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
//
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:flutter_svg/flutter_svg.dart';
// // import 'package:get/get.dart';
// // import '../../core/app_colors.dart';
// // import '../../core/app_dimensions.dart';
// // import '../controllers/custom_ai_startegy_controller.dart';
// //
// // class CustomAIStrategyContainer extends StatelessWidget {
// //   final AIStrategyController controller = Get.find<AIStrategyController>();
// //
// //   CustomAIStrategyContainer({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       margin: EdgeInsets.symmetric(
// //         horizontal: AppDimensions.d24.w,
// //         vertical: AppDimensions.d16.h,
// //       ),
// //       padding: EdgeInsets.all(AppDimensions.d20.w),
// //       decoration: BoxDecoration(
// //         color: AppColors.primaryRed,
// //         borderRadius: BorderRadius.circular(AppDimensions.d16.r),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.08),
// //             blurRadius: 12,
// //             offset: const Offset(0, 4),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // Header Row
// //           Row(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               SvgPicture.asset(
// //                 "assets/images/robot.svg",
// //                 height: AppDimensions.d50.h,
// //                 width: AppDimensions.d50.w,
// //               ),
// //               SizedBox(width: AppDimensions.d12.w),
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       "AI Strategic Analysis",
// //                       style: TextStyle(
// //                         fontFamily: 'Gotham-Bold',
// //                         fontSize: AppDimensions.d20.sp,
// //                         color: Colors.white,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                     ),
// //                     SizedBox(height: AppDimensions.d4.h),
// //                     Obx(() => Text(
// //                       "Relevance threshold: >${controller.threshold.value}%",
// //                       style: TextStyle(
// //                         fontSize: AppDimensions.d12.sp,
// //                         color: Colors.white.withOpacity(0.8),
// //                         fontFamily: 'Gotham',
// //                       ),
// //                     )),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //
// //           SizedBox(height: AppDimensions.d20.h),
// //
// //           // Inner Container (Reactive)
// //           Obx(() {
// //             return Container(
// //               width: double.infinity,
// //               padding: EdgeInsets.all(AppDimensions.d16.w),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.circular(AppDimensions.d12.r),
// //                 border: Border.all(
// //                   color: controller.isAnalysisDone.value
// //                       ? AppColors.successGreen.withOpacity(0.5)
// //                       : AppColors.primaryRed.withOpacity(0.5),
// //                 ),
// //               ),
// //               child: controller.isAnalysisDone.value
// //                   ? Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     "AI Feedback",
// //                     style: TextStyle(
// //                       fontSize: AppDimensions.d16.sp,
// //                       fontWeight: FontWeight.bold,
// //                       color: AppColors.primaryBlue,
// //                       fontFamily: 'Gotham-Bold',
// //                     ),
// //                   ),
// //                   SizedBox(height: AppDimensions.d8.h),
// //                   Text(
// //                     controller.feedback.value,
// //                     style: TextStyle(
// //                       fontSize: AppDimensions.d14.sp,
// //                       color: AppColors.textSecondary,
// //                       fontFamily: 'Gotham',
// //                     ),
// //                   ),
// //                 ],
// //               )
// //                   : Column(
// //                 children: [
// //                   Icon(
// //                     Icons.analytics_outlined,
// //                     size: AppDimensions.d40.w,
// //                     color: AppColors.primaryRed,
// //                   ),
// //                   SizedBox(height: AppDimensions.d12.h),
// //                   Text(
// //                     "Submit your initiatives for AI analysis",
// //                     style: TextStyle(
// //                       fontSize: AppDimensions.d14.sp,
// //                       fontWeight: FontWeight.w500,
// //                       color: AppColors.textSecondary,
// //                       fontFamily: 'Gotham',
// //                     ),
// //                     textAlign: TextAlign.center,
// //                   ),
// //                   SizedBox(height: AppDimensions.d8.h),
// //                   Text(
// //                     "Feedback will appear here",
// //                     style: TextStyle(
// //                       fontSize: AppDimensions.d12.sp,
// //                       color: AppColors.textSecondary.withOpacity(0.7),
// //                       fontFamily: 'Gotham',
// //                     ),
// //                     textAlign: TextAlign.center,
// //                   ),
// //                   SizedBox(height: AppDimensions.d16.h),
// //                   ElevatedButton(
// //                     onPressed: controller.submitForAnalysis,
// //                     style: ElevatedButton.styleFrom(
// //                       backgroundColor: AppColors.primaryRed,
// //                       foregroundColor: Colors.white,
// //                       padding: EdgeInsets.symmetric(
// //                         vertical: AppDimensions.d14.h,
// //                       ),
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius:
// //                         BorderRadius.circular(AppDimensions.d8.r),
// //                       ),
// //                     ),
// //                     child: Text(
// //                       "Submit for Analysis",
// //                       style: TextStyle(
// //                         fontSize: AppDimensions.d16.sp,
// //                         fontWeight: FontWeight.w600,
// //                         fontFamily: 'Gotham',
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             );
// //           }),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// //
// // //
// // //
// // //
// // //
// // //
// // //
// // //
// // //
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // // import 'package:flutter_svg/flutter_svg.dart';
// // // import 'package:get/get.dart';
// // // import '../../core/app_colors.dart';
// // // import '../../core/app_dimensions.dart';
// // // import '../controllers/custom_ai_startegy_controller.dart';
// // //
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // // import 'package:flutter_svg/flutter_svg.dart';
// // // import 'package:get/get.dart';
// // // import '../../core/app_colors.dart';
// // // import '../../core/app_dimensions.dart';
// // // import '../controllers/custom_ai_startegy_controller.dart';
// // //
// // // class CustomAIStrategyContainer extends StatelessWidget {
// // //   //final AIStrategyController controller = Get.put(AIStrategyController());
// // //   final AIStrategyController controller = Get.find<AIStrategyController>();
// // //   CustomAIStrategyContainer({super.key});
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Obx(() {
// // //       return Container(
// // //         margin: EdgeInsets.symmetric(
// // //           horizontal: AppDimensions.d24.w,
// // //           vertical: AppDimensions.d16.h,
// // //         ),
// // //         padding: EdgeInsets.all(AppDimensions.d20.w),
// // //         decoration: BoxDecoration(
// // //           color: AppColors.primaryRed, // ✅ Always red in Phase 1
// // //           borderRadius: BorderRadius.circular(AppDimensions.d16.r),
// // //           boxShadow: [
// // //             BoxShadow(
// // //               color: Colors.black.withOpacity(0.08),
// // //               blurRadius: 12,
// // //               offset: const Offset(0, 4),
// // //             ),
// // //           ],
// // //         ),
// // //         child: Column(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             // ✅ Header: Robot Icon + Title
// // //             Row(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 SvgPicture.asset(
// // //                   "assets/images/robot.svg",
// // //                   height: AppDimensions.d50.h,
// // //                   width: AppDimensions.d50.w,
// // //                 ),
// // //                 SizedBox(width: AppDimensions.d12.w),
// // //                 Expanded(
// // //                   child: Column(
// // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // //                     children: [
// // //                       Text(
// // //                         "AI Strategic Analysis",
// // //                         style: TextStyle(
// // //                           fontFamily: 'Gotham-Bold',
// // //                           fontSize: AppDimensions.d20.sp,
// // //                           color: Colors.white,
// // //                           fontWeight: FontWeight.bold,
// // //                         ),
// // //                       ),
// // //                       SizedBox(height: AppDimensions.d4.h),
// // //                       Text(
// // //                         "Relevance threshold: >${controller.threshold.value}%",
// // //                         style: TextStyle(
// // //                           fontSize: AppDimensions.d12.sp,
// // //                           color: Colors.white.withOpacity(0.8),
// // //                           fontFamily: 'Gotham',
// // //                         ),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //
// // //             SizedBox(height: AppDimensions.d20.h),
// // //
// // //             // ✅ Inner White Container
// // //             Container(
// // //               width: double.infinity,
// // //               padding: EdgeInsets.all(AppDimensions.d16.w),
// // //               decoration: BoxDecoration(
// // //                 color: Colors.white,
// // //                 borderRadius: BorderRadius.circular(AppDimensions.d12.r),
// // //                 border: Border.all(
// // //                   color: AppColors.primaryRed.withOpacity(0.5),
// // //                 ),
// // //               ),
// // //               child: Column(
// // //                 mainAxisAlignment: MainAxisAlignment.center,
// // //                 children: [
// // //                   // ✅ Icon in the middle
// // //                   Icon(
// // //                     Icons.analytics,
// // //                     size: AppDimensions.d40.w,
// // //                     color: AppColors.primaryRed,
// // //                   ),
// // //                   SizedBox(height: AppDimensions.d12.h),
// // //
// // //                   // ✅ First Text: Submit Initiatives
// // //                   Text(
// // //                     "Submit your initiatives for AI analysis",
// // //                     textAlign: TextAlign.center,
// // //                     style: TextStyle(
// // //                       fontSize: AppDimensions.d14.sp,
// // //                       fontWeight: FontWeight.w500,
// // //                       color: AppColors.textSecondary,
// // //                       fontFamily: 'Gotham',
// // //                     ),
// // //                   ),
// // //                   SizedBox(height: AppDimensions.d8.h),
// // //
// // //                   // ✅ Second Text: Feedback Placeholder
// // //                   Text(
// // //                     "Feedback will appear here",
// // //                     textAlign: TextAlign.center,
// // //                     style: TextStyle(
// // //                       fontSize: AppDimensions.d12.sp,
// // //                       color: AppColors.textSecondary.withOpacity(0.7),
// // //                       fontFamily: 'Gotham',
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       );
// // //     });
// // //   }
// // // }
// // //
// // //
// // //
// // //
// // //
// // //
