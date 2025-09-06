import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../controllers/strategy_selection_controller.dart';

class CustomCardPagerBuilder extends StatelessWidget {
  final StrategySelectionController controller = Get.find();

  CustomCardPagerBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          // 🔹 Card Display Container
          Container(
            height: 400.h,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: AppDimensions.d24.w),
            padding: EdgeInsets.all(AppDimensions.d16.w),
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppDimensions.d20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.15),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: controller.selectedCardIndex.value == -1
                    ? SvgPicture.asset(
                  "assets/images/backcard.svg",
                  key: const ValueKey<String>("backcard"),
                  height: 280.h,
                )
                    : Image.asset(
                  controller.cardAssets[controller.selectedCardIndex.value],
                  key: ValueKey<int>(controller.selectedCardIndex.value),
                  height: 280.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          SizedBox(height: AppDimensions.d20.h),

          // 🔹 Bubble Button Below Card
          GestureDetector(
            onTap: () {
              if (controller.isCardRevealed.value) {
                controller.resetAndDrawNewCard();
              } else {
                controller.revealRandomCard();
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.d60.w,
                vertical: AppDimensions.d14.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.lightSkyBlue,
                borderRadius: BorderRadius.circular(50.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Text(
                controller.isCardRevealed.value
                    ? "Draw New Strategy"
                    : "Tap to Reveal Your Strategy",
                style: TextStyle(
                  fontFamily: 'Gotham-Bold',
                  fontSize: AppDimensions.d16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../core/app_colors.dart';
// import '../../../core/app_dimensions.dart';
//
// class CustomCardPagerBuilder extends StatelessWidget {
//   final bool isCardRevealed;
//   final VoidCallback onCardRevealed;
//
//   const CustomCardPagerBuilder({
//     super.key,
//     required this.isCardRevealed,
//     required this.onCardRevealed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: AppDimensions.d24.w),
//       padding: EdgeInsets.all(AppDimensions.d16.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(AppDimensions.d20.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             spreadRadius: 1,
//             blurRadius: 10,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // If card is revealed → show the strategy content
//           if (isCardRevealed) ...[
//             Container(
//               width: double.infinity,
//               height: AppDimensions.d200.h,
//               decoration: BoxDecoration(
//                 color: AppColors.primaryBlue,
//                 borderRadius: BorderRadius.circular(AppDimensions.d16.r),
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 "Your Strategy Card",
//                 style: TextStyle(
//                   fontSize: AppDimensions.d20.sp,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ] else ...[
//             // If card not revealed → show Reveal Button
//             GestureDetector(
//               onTap: onCardRevealed,
//               child: Container(
//                 width: double.infinity,
//                 height: AppDimensions.d160.h,
//                 decoration: BoxDecoration(
//                   color: AppColors.primaryRed,
//                   borderRadius: BorderRadius.circular(AppDimensions.d16.r),
//                 ),
//                 alignment: Alignment.center,
//                 child: Text(
//                   "Reveal Strategy",
//                   style: TextStyle(
//                     fontSize: AppDimensions.d18.sp,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }













// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../core/app_colors.dart';
// import '../../../core/app_dimensions.dart';
//
// class CustomCardPagerBuilder extends StatelessWidget {
//   final bool isCardRevealed;
//   final Function(int) onCardRevealed; // ✅ Accepts index now
//
//   const CustomCardPagerBuilder({
//     super.key,
//     required this.isCardRevealed,
//     required this.onCardRevealed,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(horizontal: AppDimensions.d24.w),
//       padding: EdgeInsets.all(AppDimensions.d16.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(AppDimensions.d20.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             spreadRadius: 1,
//             blurRadius: 10,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // If card is revealed → show the strategy content
//           if (isCardRevealed) ...[
//             Container(
//               width: double.infinity,
//               height: AppDimensions.d200.h,
//               decoration: BoxDecoration(
//                 color: AppColors.primaryBlue,
//                 borderRadius: BorderRadius.circular(AppDimensions.d16.r),
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 "Your Strategy Card",
//                 style: TextStyle(
//                   fontSize: AppDimensions.d20.sp,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ] else ...[
//             // If card not revealed → show Reveal Button
//             GestureDetector(
//               onTap: () {
//                 // ✅ Passing index 0 for now (you can update if multiple cards exist)
//                 onCardRevealed(0);
//               },
//               child: Container(
//                 width: double.infinity,
//                 height: AppDimensions.d160.h,
//                 decoration: BoxDecoration(
//                   color: AppColors.primaryRed,
//                   borderRadius: BorderRadius.circular(AppDimensions.d16.r),
//                 ),
//                 alignment: Alignment.center,
//                 child: Text(
//                   "Reveal Strategy",
//                   style: TextStyle(
//                     fontSize: AppDimensions.d18.sp,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
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








// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import '../../core/app_colors.dart';
// import '../../core/app_dimensions.dart';
// import '../controllers/strategy_selection_controller.dart';
//
// class CustomCardPagerBuilder extends StatelessWidget {
//   final StrategySelectionController controller = Get.find();
//
//   CustomCardPagerBuilder({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       return Column(
//         children: [
//           // 🔹 CARD DISPLAY CONTAINER
//           Container(
//             height: 400.h,
//             width: MediaQuery.of(context).size.width,
//             margin: EdgeInsets.symmetric(horizontal: AppDimensions.d24.w),
//             padding: EdgeInsets.all(AppDimensions.d16.w),
//             decoration: BoxDecoration(
//               color: AppColors.primaryRed.withOpacity(0.08),
//               borderRadius: BorderRadius.circular(AppDimensions.d20.r),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.08),
//                   blurRadius: 8,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Center(
//               child: AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 500),
//                 transitionBuilder: (child, animation) {
//                   return FadeTransition(
//                     opacity: animation,
//                     child: SlideTransition(
//                       position: Tween<Offset>(
//                         begin: const Offset(0.0, 0.15),
//                         end: Offset.zero,
//                       ).animate(animation),
//                       child: child,
//                     ),
//                   );
//                 },
//                 child: SvgPicture.asset(
//                   controller.selectedCardIndex.value == -1
//                       ? "assets/images/backcard.svg" // show back card if none selected
//                       : controller
//                       .cardAssets[controller.selectedCardIndex.value],
//                   key: ValueKey<int>(controller.selectedCardIndex.value),
//                   height: 280.h,
//                 ),
//               ),
//             ),
//           ),
//
//           SizedBox(height: AppDimensions.d20.h),
//
//           // 🔹 BUBBLE BUTTON
//           GestureDetector(
//             onTap: () {
//               if (controller.isCardRevealed.value) {
//                 controller.resetAndDrawNewCard();
//               } else {
//                 controller.revealRandomCard();
//               }
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(
//                 horizontal: AppDimensions.d60.w,
//                 vertical: AppDimensions.d14.h,
//               ),
//               decoration: BoxDecoration(
//                 color: AppColors.lightSkyBlue,
//                 borderRadius: BorderRadius.circular(50.r),
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.primaryBlue.withOpacity(0.3),
//                     blurRadius: 10,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Text(
//                 controller.isCardRevealed.value
//                     ? "Draw New Strategy"
//                     : "Tap to Reveal Your Strategy",
//                 style: TextStyle(
//                   fontFamily: 'Gotham-Bold',
//                   fontSize: AppDimensions.d16.sp,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }
//
//
//
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import '../../core/app_colors.dart';
// import '../../core/app_dimensions.dart';
// import '../controllers/strategy_selection_controller.dart';
//
// class CustomCardPagerBuilder extends StatelessWidget {
//   final StrategySelectionController controller = Get.find();
//
//   CustomCardPagerBuilder({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       return Column(
//         children: [
//           // 🔹 CARD DISPLAY CONTAINER
//           Container(
//             height: 400.h,
//             width: MediaQuery.of(context).size.width,
//
//             margin: EdgeInsets.symmetric(horizontal: AppDimensions.d24.w),
//             padding: EdgeInsets.all(AppDimensions.d16.w),
//             decoration: BoxDecoration(
//               color: AppColors.primaryRed.withOpacity(0.08),
//               borderRadius: BorderRadius.circular(AppDimensions.d20.r),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.08),
//                   blurRadius: 8,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Center(
//               child: AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 500),
//                 transitionBuilder: (child, animation) {
//                   return FadeTransition(
//                     opacity: animation,
//                     child: SlideTransition(
//                       position: Tween<Offset>(
//                         begin: const Offset(0.0, 0.15),
//                         end: Offset.zero,
//                       ).animate(animation),
//                       child: child,
//                     ),
//                   );
//                 },
//                 child: SvgPicture.asset(
//                   controller.cardAssets[controller.selectedCardIndex.value],
//                   key: ValueKey<int>(controller.selectedCardIndex.value),
//                   height: 280.h,
//                 ),
//               ),
//             ),
//           ),
//
//           SizedBox(height: AppDimensions.d20.h),
//
//           // 🔹 BUBBLE BUTTON
//           GestureDetector(
//             onTap: () {
//               if (controller.isCardRevealed.value) {
//                 controller.resetAndDrawNewCard();
//               } else {
//                 controller.revealRandomCard();
//               }
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(
//                 horizontal: AppDimensions.d60.w,
//                 vertical: AppDimensions.d14.h,
//               ),
//               decoration: BoxDecoration(
//                 color: AppColors.lightSkyBlue,
//                 borderRadius: BorderRadius.circular(50.r),
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.primaryBlue.withOpacity(0.3),
//                     blurRadius: 10,
//                     offset: const Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Text(
//                 controller.isCardRevealed.value
//                     ? "Draw New Strategy"
//                     : "Tap to Reveal Your Strategy",
//                 style: TextStyle(
//                   fontFamily: 'Gotham-Bold',
//                   fontSize: AppDimensions.d16.sp,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }
