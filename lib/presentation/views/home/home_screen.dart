import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../controllers/home_controller.dart';
import '../../widgets/custom_svg.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController c = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.d24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppDimensions.d16.h),

                    // LOGO
                    Center(
                      child: CustomSvg(
                        assetPath: 'assets/images/okrnev.svg',
                        semanticsLabel: 'OKR',
                        height: 70.h,
                      ),
                    ),
                    SizedBox(height: AppDimensions.d18.h),

                    // Bonus + Certification
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            _underlineText('Bonus mode'),
                            Positioned(
                              left: -46.w,
                              top: -50.h,
                              child: CustomSvg(
                                assetPath: 'assets/images/robort.svg',
                                height: 58.h,
                                width: 58.w,
                                semanticsLabel: 'robot',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 22.w),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            _chip('Certification'),
                            Positioned(
                              right: -55.w,
                              top: -22.h,
                              child: CircleAvatar(
                                radius: 26.r,
                                backgroundColor: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.all(3.r),
                                  child: CustomSvg(
                                    assetPath: 'assets/images/certificate.svg',
                                    semanticsLabel: 'certificate',
                                    height: 28.h,
                                    width: 28.w,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: AppDimensions.d18.h),

                    // Cards + vertical dots
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: screenWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _verticalDots(),
                              SizedBox(width: 8.w),
                              SizedBox(
                                width: screenWidth * 0.8,
                                height: screenHeight * 0.5,
                                child: PageView.builder(
                                  controller: c.pageController,
                                  scrollDirection: Axis.vertical,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: c.cards.length,
                                  itemBuilder: (context, index) {
                                    return AnimatedBuilder(
                                      animation: c.pageController,
                                      builder: (context, child) {
                                        double page = c.pageController.hasClients
                                            ? (c.pageController.page ?? 0.0)
                                            : 0.0;
                                        final delta = (index - page);
                                        final translateX = delta * -40.w;
                                        final rotate = delta * -0.09;
                                        final scale = (1 - (delta.abs() * 0.1)).clamp(0.9, 1.0);

                                        return Transform.translate(
                                          offset: Offset(translateX, 0),
                                          child: Transform.rotate(
                                            angle: rotate,
                                            child: Transform.scale(
                                              scale: scale,
                                              child: _card(index),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: AppDimensions.d12.h),
                    _dashboardButton(),
                    SizedBox(height: AppDimensions.d16.h),
                  ],
                ),
              ),

              // Top-right profile
              Positioned(
                top: 12.h,
                right: 16.w,
                child: CircleAvatar(
                  radius: 18.r,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(2.r),
                    child: CustomSvg(
                      assetPath: 'assets/images/persondashboard.svg',
                      semanticsLabel: 'profile',
                      height: 30.h,
                      width: 30.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== Widgets =====
  Widget _underlineText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: AppDimensions.d14.sp,
        color: Colors.grey.shade700,
        fontWeight: FontWeight.w700,
        fontFamily: 'Gotham',
        decoration: TextDecoration.underline,
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: const Color(0xFF8FC6F6), width: 1.2),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          color: const Color(0xFF3E85C9),
          fontWeight: FontWeight.w700,
          fontFamily: 'Gotham',
        ),
      ),
    );
  }

  Widget _verticalDots() {
    return Obx(() {
      return SizedBox(
        width: 12.w,
        height: 140.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(c.cards.length * 2 - 1, (i) {
            if (i.isOdd) return SizedBox(height: 6.h);
            final dotIndex = i ~/ 2;
            final active = c.selectedCardIndex.value == dotIndex;
            return Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                color: active ? const Color(0xFFC34028) : Colors.black26,
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      );
    });
  }

  Widget _card(int index) {
    final m = c.cards[index];
    final bg = Color(m['bg'] as int);
    final bg2 = Color(m['bg2'] as int);

    return GestureDetector(
      onTap: c.onTapCTA, // <--- navigate to /gameMode
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: 0.75.sw,
          height: 0.28.sh,
          margin: EdgeInsets.only(bottom: 14.h),
          padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 16.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [bg, bg2],
            ),
            borderRadius: BorderRadius.circular(26.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.20),
                blurRadius: 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: _cardBody(m),
        ),
      ),
    );
  }

  Widget _cardBody(Map<String, dynamic> m) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    RichText(
    text: TextSpan(
    children: [
      TextSpan(
      text: '${m['titleTop']}\n',
      style: TextStyle(
        fontSize: 32.sp,
        height: 1.0,
        fontWeight: FontWeight.w900,
        fontFamily: 'Gotham',
        color: Colors.white,
      ),
    ),
    TextSpan(
    text: m['titleBottom'],
    style: TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w800,
    fontFamily: 'Gotham',
    color: Colors.black.withOpacity(0.6),
    ),
    ),
    ],
    ),
    ),
    SizedBox(height: 10.h),
    Text(
    m['subtitle'],
    style: TextStyle(
    fontSize: 13.sp,
    height: 1.35,
    color: Colors.white,
    fontFamily: 'Gotham',
    ),
    ),
    const Spacer(),
    Text(
    m['cta'],
    style: TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.underline,
    color: Colors.white,
    fontFamily: 'Gotham',
    ),
    ),
      ],
    );
  }

  Widget _dashboardButton() {
    return GestureDetector(
      onTap: () => Get.toNamed('/dashboard'),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Go to ',
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.black87,
              fontFamily: 'Gotham',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 15.sp,
              color: Colors.black87,
              fontFamily: 'Gotham',
              fontWeight: FontWeight.w800,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}










// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../../../core/app_colors.dart';
// import '../../../core/app_dimensions.dart';
// import '../../controllers/home_controller.dart';
// import '../../widgets/custom_svg.dart';
//
// class HomeScreen extends StatelessWidget {
//   HomeScreen({super.key});
//
//   final HomeController c = Get.put(HomeController());
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
//           ),
//         ),
//         child: SafeArea(
//           child: Stack(
//             children: [
//               // CONTENT COLUMN
//               Padding(
//                 padding: EdgeInsets.symmetric(horizontal: AppDimensions.d24.w),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: AppDimensions.d16.h),
//
//                     // OKR'Nav logo centered
//                     Center(
//                       child: CustomSvg(
//                         assetPath: 'assets/images/okrnev.svg',
//                         semanticsLabel: 'OKR',
//                         height: 70.h, // slightly increased
//                       ),
//                     ),
//
//                     SizedBox(height: AppDimensions.d18.h),
//
//                     // Bonus mode + Certification row
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         // BONUS (underlined) + robot + arrow pointing to it
//                         Stack(
//                           clipBehavior: Clip.none,
//                           children: [
//                             _underlineText('Bonus mode'),
//                             Positioned(
//                               left: -46.w,
//                               top: -50.h,
//                               child: CustomSvg(
//                                 assetPath: 'assets/images/robort.svg',
//                                 height: 58.h,
//                                 width: 58.w,
//                                 semanticsLabel: 'robot',
//                               ),
//                             ),
//                             // Positioned(
//                             //   right: -14.w,
//                             //   top: 4.h,
//                             //   child: CustomSvg(
//                             //     assetPath: 'assets/images/arrow.svg',
//                             //     height: 16.h,
//                             //     width: 16.w,
//                             //     semanticsLabel: 'arrow',
//                             //   ),
//                             // ),
//                           ],
//                         ),
//                         SizedBox(width: 22.w),
//
//                         // CERTIFICATION (pill) + certificate avatar + arrow
//                         Stack(
//                           clipBehavior: Clip.none,
//                           children: [
//                             _chip('Certification'),
//                             Positioned(
//                               right: -55.w,
//                               top: -22.h,
//                               child: CircleAvatar(
//                                 radius: 26.r, // slightly increased
//                                 backgroundColor: Colors.white,
//                                 child: Padding(
//                                   padding: EdgeInsets.all(3.r),
//                                   child: CustomSvg(
//                                     assetPath: 'assets/images/certificate.svg',
//                                     semanticsLabel: 'certificate',
//                                     height: 28.h,
//                                     width: 28.w,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               left: -12.w,
//                               top: 4.h,
//                               child: Transform.flip(
//                                 flipX: true,
//                                 child: CustomSvg(
//                                   assetPath: 'assets/images/arrow.svg',
//                                   height: 16.h,
//                                   width: 16.w,
//                                   semanticsLabel: 'arrow',
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//
//                     SizedBox(height: AppDimensions.d18.h),
//
//                     // RIGHT-EDGE CARD STACK + VERTICAL DOTS
//                     Expanded(
//                       child: Align(
//                         alignment: Alignment.centerRight,
//                         child: SizedBox(
//                           width: screenWidth,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               // VERTICAL DOTS
//                               _verticalDots(),
//
//                               SizedBox(width: 8.w),
//
//                               // PAGEVIEW CARDS aligned on right
//                               SizedBox(
//                                 width: screenWidth * 0.8, // fit properly
//                                 height: screenHeight * 0.5, // responsive height
//                                 child: PageView.builder(
//                                   controller: c.pageController,
//                                   scrollDirection: Axis.vertical,
//                                   physics: const BouncingScrollPhysics(),
//                                   itemCount: c.cards.length,
//                                   itemBuilder: (context, index) {
//                                     return AnimatedBuilder(
//                                       animation: c.pageController,
//                                       builder: (context, child) {
//                                         double page = 0.0;
//                                         if (c.pageController.hasClients &&
//                                             c.pageController.position.haveDimensions) {
//                                           page = c.pageController.page ?? 0.0;
//                                         }
//                                         final delta = (index - page);
//                                         final translateX = (delta * -36.w);
//                                         final rotate = delta * -0.06;
//                                         final scale = (1 - (delta.abs() * 0.06)).clamp(0.9, 1.0);
//
//                                         return Transform.translate(
//                                           offset: Offset(translateX, 0),
//                                           child: Transform.rotate(
//                                             angle: rotate,
//                                             child: Transform.scale(
//                                               scale: scale,
//                                               child: _card(index),
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//
//                     // BOTTOM: "Go to Dashboard" with arrow
//                     SizedBox(height: AppDimensions.d12.h),
//                     Stack(
//                       clipBehavior: Clip.none,
//                       children: [
//                         _dashboardButton(),
//                         Positioned(
//                           left: 18.w,
//                           top: -14.h,
//                           child: Transform.rotate(
//                             angle: -0.35,
//                             child: CustomSvg(
//                               assetPath: 'assets/images/arrow.svg',
//                               semanticsLabel: 'arrow',
//                               height: 16.h,
//                               width: 16.w,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//
//                     SizedBox(height: AppDimensions.d16.h),
//                   ],
//                 ),
//               ),
//
//               // Tiny profile/avatar (top-right)
//               Positioned(
//                 top: 12.h,
//                 right: 16.w,
//                 child: CircleAvatar(
//                   radius: 18.r, // increased size
//                   backgroundColor: Colors.white,
//                   child: Padding(
//                     padding: EdgeInsets.all(2.r),
//                     child: CustomSvg(
//                       assetPath: 'assets/images/persondashboard.svg',
//                       semanticsLabel: 'profile',
//                       height: 30.h, // slightly larger
//                       width: 30.w,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ===== widgets =====
//   Widget _underlineText(String text) {
//     return Text(
//       text,
//       style: TextStyle(
//         fontSize: AppDimensions.d14.sp,
//         color: AppColors.textSecondary,
//         fontWeight: FontWeight.w700,
//         fontFamily: 'Gotham',
//         decoration: TextDecoration.underline,
//       ),
//     );
//   }
//
//   Widget _chip(String text) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.7),
//         borderRadius: BorderRadius.circular(18.r),
//         border: Border.all(color: const Color(0xFF8FC6F6), width: 1.2),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: AppDimensions.d12.sp,
//           color: const Color(0xFF3E85C9),
//           fontWeight: FontWeight.w700,
//           fontFamily: 'Gotham',
//         ),
//       ),
//     );
//   }
//
//   Widget _verticalDots() {
//     return Obx(() {
//       return SizedBox(
//         width: AppDimensions.d12.w,
//         height: AppDimensions.d140.h,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: List.generate(c.cards.length * 2 - 1, (i) {
//             if (i.isOdd) return SizedBox(height: 6.h);
//             final dotIndex = i ~/ 2;
//             final active = c.selectedCardIndex.value == dotIndex;
//             return Container(
//               width: AppDimensions.d6.w,
//               height: AppDimensions.d6.w,
//               decoration: BoxDecoration(
//                 color: active ? const Color(0xFFC34028) : Colors.black26,
//                 shape: BoxShape.circle,
//               ),
//             );
//           }),
//         ),
//       );
//     });
//   }
//
//   Widget _card(int index) {
//     final m = c.cards[index];
//     final bg = Color(m['bg'] as int);
//     final bg2 = Color(m['bg2'] as int);
//
//     return Align(
//       alignment: Alignment.centerRight,
//       child: Container(
//         width: 0.75.sw,
//         height: 0.28.sh,
//         margin: EdgeInsets.only(bottom: 14.h),
//         padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 16.h),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [bg, bg2],
//           ),
//           borderRadius: BorderRadius.circular(AppDimensions.d26.r),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.20),
//               blurRadius: 16,
//               offset: const Offset(0, 10),
//             ),
//           ],
//         ),
//         child: _cardBody(m),
//       ),
//     );
//   }
//
//   Widget _cardBody(Map<String, dynamic> m) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         RichText(
//           text: TextSpan(
//             children: [
//               TextSpan(
//                 text: '${m['titleTop']}\n',
//                 style: TextStyle(
//                   fontSize: 32.sp,
//                   height: 1.0,
//                   fontWeight: FontWeight.w900,
//                   fontFamily: 'Gotham',
//                   color: Colors.white,
//                 ),
//               ),
//               TextSpan(
//                 text: m['titleBottom'],
//                 style: TextStyle(
//                   fontSize: 28.sp,
//                   fontWeight: FontWeight.w800,
//                   fontFamily: 'Gotham',
//                   color: Colors.black.withOpacity(0.6),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 10.h),
//         Text(
//           m['subtitle'],
//           style: TextStyle(
//             fontSize: 13.sp,
//             height: 1.35,
//             color: Colors.white,
//             fontFamily: 'Gotham',
//           ),
//         ),
//         const Spacer(),
//         GestureDetector(
//           onTap: c.onTapCTA,
//           child: Text(
//             m['cta'],
//             style: TextStyle(
//               fontSize: 14.sp,
//               fontWeight: FontWeight.w700,
//               decoration: TextDecoration.underline,
//               color: Colors.white,
//               fontFamily: 'Gotham',
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _dashboardButton() {
//     return GestureDetector(
//       onTap: () => Get.toNamed('/dashboard'),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             'Go to ',
//             style: TextStyle(
//               fontSize: 15.sp,
//               color: Colors.black87,
//               fontFamily: 'Gotham',
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           SizedBox(height: AppDimensions.d4.h),
//           Text(
//             'Dashboard',
//             style: TextStyle(
//               fontSize: 15.sp,
//               color: Colors.black87,
//               fontFamily: 'Gotham',
//               fontWeight: FontWeight.w800,
//               decoration: TextDecoration.underline,
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
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:flutter_svg/flutter_svg.dart';
// // import 'package:get/get.dart';
// //
// // import '../../../core/app_colors.dart';
// // import '../../../core/app_dimensions.dart';
// // import '../../controllers/home_controller.dart';
// // import '../../widgets/custom_svg.dart';
// //
// // class HomeScreen extends StatelessWidget {
// //   HomeScreen({super.key});
// //
// //   final HomeController c = Get.put(HomeController());
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Container(
// //         width: 1.sw,
// //         height: 1.sh,
// //         decoration: const BoxDecoration(
// //           gradient: LinearGradient(
// //             colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
// //             begin: Alignment.topCenter,
// //             end: Alignment.bottomCenter,
// //           ),
// //         ),
// //         child: SafeArea(
// //           child: Stack(
// //             children: [
// //               Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: AppDimensions.d20.w),
// //                 child: Column(
// //                   children: [
// //                     SizedBox(height: AppDimensions.d20.h),
// //
// //                     // Logo
// //                     Center(
// //                       child: CustomSvg(
// //                         assetPath: 'assets/images/okrnev.svg',
// //                         height: 64.h,
// //                         semanticsLabel: '',
// //                       ),
// //                     ),
// //                     SizedBox(height: AppDimensions.d20.h),
// //
// //                     // Bonus + Certification row
// //                     _bonusAndCertification(),
// //
// //                     SizedBox(height: AppDimensions.d20.h),
// //
// //                     // Cards + Arrows
// //                     Expanded(
// //                       child: Obx(() {
// //                         return Row(
// //                           children: [
// //                             // Left Arrow
// //                             GestureDetector(
// //                               onTap: c.goPrev,
// //                               child: SvgPicture.asset(
// //                                 "assets/images/left.svg",
// //                                 height: AppDimensions.d60.h,
// //                                 width: AppDimensions.d40.w,
// //                               ),
// //                             ),
// //                             SizedBox(width: AppDimensions.d8.w),
// //
// //                             // Swipeable cards
// //                             Expanded(
// //                               child: PageView.builder(
// //                                 controller: c.pageController,
// //                                 itemCount: c.cards.length,
// //                                 itemBuilder: (context, index) {
// //                                   return Obx(() {
// //                                     double currentPage =
// //                                         c.pageController.hasClients
// //                                         ? c.pageController.page ?? 0
// //                                         : 0;
// //                                     double scale =
// //                                         (1 -
// //                                                 ((currentPage - index).abs() *
// //                                                     0.08))
// //                                             .clamp(0.88, 1.0);
// //                                     double translateY =
// //                                         ((currentPage - index).abs() * 20.h)
// //                                             .clamp(0, 40.h);
// //
// //                                     return Transform.translate(
// //                                       offset: Offset(0, translateY),
// //                                       child: Transform.scale(
// //                                         scale: scale,
// //                                         child: _card(index),
// //                                       ),
// //                                     );
// //                                   });
// //                                 },
// //                               ),
// //                             ),
// //                             SizedBox(width: AppDimensions.d8.w),
// //
// //                             // Right Arrow
// //                             GestureDetector(
// //                               onTap: c.goNext,
// //                               child: SvgPicture.asset(
// //                                 "assets/images/right.svg",
// //                                 height: AppDimensions.d60.h,
// //                                 width: AppDimensions.d40.w,
// //                               ),
// //                             ),
// //                           ],
// //                         );
// //                       }),
// //                     ),
// //                     SizedBox(height: AppDimensions.d20.h),
// //
// //                     // Dashboard Button
// //                     _dashboardButton(),
// //                     SizedBox(height: AppDimensions.d10.h),
// //                   ],
// //                 ),
// //               ),
// //
// //               // Profile Icon Top-Right
// //               Positioned(
// //                 top: AppDimensions.d10.h,
// //                 right: AppDimensions.d14.w,
// //                 child: CircleAvatar(
// //                   radius: AppDimensions.d16.r,
// //                   backgroundColor: Colors.white,
// //                   child: Padding(
// //                     padding: EdgeInsets.all(AppDimensions.d2.r),
// //                     child: CustomSvg(
// //                       assetPath: 'assets/images/persondashboard.svg',
// //                       height: AppDimensions.d22.h,
// //                       width: AppDimensions.d22.w,
// //                       semanticsLabel: '',
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _bonusAndCertification() {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.center,
// //       children: [
// //         _underlineText('Bonus mode'),
// //         SizedBox(width: AppDimensions.d25.w),
// //         _chip('Certification'),
// //       ],
// //     );
// //   }
// //
// //   Widget _underlineText(String text) {
// //     return Text(
// //       text,
// //       style: TextStyle(
// //         fontSize: AppDimensions.d14.sp,
// //         fontWeight: FontWeight.w700,
// //         color: AppColors.textSecondary,
// //         decoration: TextDecoration.underline,
// //       ),
// //     );
// //   }
// //
// //   Widget _chip(String text) {
// //     return Container(
// //       padding: EdgeInsets.symmetric(
// //         horizontal: AppDimensions.d12.w,
// //         vertical: AppDimensions.d6.h,
// //       ),
// //       decoration: BoxDecoration(
// //         color: Colors.white.withOpacity(0.7),
// //         borderRadius: BorderRadius.circular(AppDimensions.d18.r),
// //         border: Border.all(color: const Color(0xFF8FC6F6), width: 1.2.w),
// //       ),
// //       child: Text(
// //         text,
// //         style: TextStyle(
// //           fontSize: AppDimensions.d12.sp,
// //           color: const Color(0xFF3E85C9),
// //           fontWeight: FontWeight.w700,
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _card(int index) {
// //     final m = c.cards[index];
// //     return Container(
// //       margin: EdgeInsets.symmetric(
// //         horizontal: AppDimensions.d8.w,
// //         vertical: AppDimensions.d14.h,
// //       ),
// //       padding: EdgeInsets.all(AppDimensions.d18.w),
// //       decoration: BoxDecoration(
// //         gradient: LinearGradient(
// //           colors: [Color(m['bg']), Color(m['bg2'])],
// //           begin: Alignment.topLeft,
// //           end: Alignment.bottomRight,
// //         ),
// //         borderRadius: BorderRadius.circular(AppDimensions.d24.r),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.2),
// //             blurRadius: AppDimensions.d16,
// //             offset: const Offset(0, 10),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // Title
// //           RichText(
// //             text: TextSpan(
// //               children: [
// //                 TextSpan(
// //                   text: "${m['titleTop']}\n",
// //                   style: TextStyle(
// //                     fontSize: AppDimensions.d30.sp,
// //                     fontWeight: FontWeight.w900,
// //                     color: Colors.white,
// //                   ),
// //                 ),
// //                 TextSpan(
// //                   text: m['titleBottom'],
// //                   style: TextStyle(
// //                     fontSize: AppDimensions.d28.sp,
// //                     fontWeight: FontWeight.w800,
// //                     color: Colors.black.withOpacity(0.6),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           SizedBox(height: AppDimensions.d10.h),
// //           Text(
// //             m['subtitle'],
// //             style: TextStyle(
// //               fontSize: AppDimensions.d14.sp,
// //               color: Colors.white,
// //             ),
// //           ),
// //           const Spacer(),
// //           GestureDetector(
// //             onTap: c.onTapCTA,
// //             child: Text(
// //               m['cta'],
// //               style: TextStyle(
// //                 fontSize: AppDimensions.d14.sp,
// //                 fontWeight: FontWeight.w700,
// //                 decoration: TextDecoration.underline,
// //                 color: Colors.white,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _dashboardButton() {
// //     return GestureDetector(
// //       onTap: () => Get.toNamed('/dashboard'),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Text(
// //             'Go to ',
// //             style: TextStyle(
// //               fontSize: AppDimensions.d15.sp,
// //               color: Colors.black87,
// //               fontWeight: FontWeight.w600,
// //             ),
// //           ),
// //           Text(
// //             'Dashboard',
// //             style: TextStyle(
// //               fontSize: AppDimensions.d15.sp,
// //               color: Colors.black87,
// //               fontWeight: FontWeight.w800,
// //               decoration: TextDecoration.underline,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:get/get.dart';
// //
// // import '../../../core/app_colors.dart';
// // import '../../../core/app_dimensions.dart';
// // import '../../controllers/home_controller.dart';
// // import '../../widgets/custom_svg.dart';
// //
// // class HomeScreen extends StatelessWidget {
// //   HomeScreen({super.key});
// //
// //   final HomeController c = Get.put(HomeController());
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Container(
// //         width: double.infinity,
// //         height: double.infinity,
// //         decoration: const BoxDecoration(
// //           gradient: LinearGradient(
// //             begin: Alignment.topCenter,
// //             end: Alignment.bottomCenter,
// //             colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
// //           ),
// //         ),
// //         child: SafeArea(
// //           child: Stack(
// //             children: [
// //               // CONTENT COLUMN
// //               Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: AppDimensions.d24.w),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     SizedBox(height: AppDimensions.d16.h),
// //
// //                     // OKR'Nav logo centered
// //                     Center(
// //                       child: CustomSvg(
// //                         assetPath: 'assets/images/okrnev.svg',
// //                         semanticsLabel: 'OKR',
// //                         height: 64.h,
// //                       ),
// //                     ),
// //
// //                     SizedBox(height: AppDimensions.d18.h),
// //
// //                     // Bonus mode + Certification row
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         // BONUS (underlined) + robot + arrow pointing to it
// //                         Stack(
// //                           clipBehavior: Clip.none,
// //                           children: [
// //                             _underlineText('Bonus mode'),
// //                             Positioned(
// //                               left: -46.w,
// //                               top: -50.h,
// //                               child: CustomSvg(
// //                                 assetPath: 'assets/images/robort.svg',
// //                                 height: 58.h,
// //                                 width: 58.w,
// //                                 semanticsLabel: 'robot',
// //                               ),
// //                             ),
// //                             Positioned(
// //                               right: -14.w,
// //                               top: 4.h,
// //                               child: CustomSvg(
// //                                 assetPath: 'assets/images/arrow.svg',
// //                                 height: 16.h,
// //                                 width: 16.w,
// //                                 semanticsLabel: 'arrow',
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                         SizedBox(width: 22.w),
// //
// //                         // CERTIFICATION (pill) + certificate avatar + arrow
// //                         Stack(
// //                           clipBehavior: Clip.none,
// //                           children: [
// //                             _chip('Certification'),
// //                             Positioned(
// //                               right: -26.w,
// //                               top: -22.h,
// //                               child: CircleAvatar(
// //                                 radius: 16.r,
// //                                 backgroundColor: Colors.white,
// //                                 child: Padding(
// //                                   padding: EdgeInsets.all(3.r),
// //                                   child: CustomSvg(
// //                                     assetPath: 'assets/images/certificate.svg',
// //                                     semanticsLabel: 'certificate',
// //                                     height: 22.h,
// //                                     width: 22.w,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                             Positioned(
// //                               left: -12.w,
// //                               top: 4.h,
// //                               child: Transform.flip(
// //                                 flipX: true,
// //                                 child: CustomSvg(
// //                                   assetPath: 'assets/images/arrow.svg',
// //                                   height: 16.h,
// //                                   width: 16.w,
// //                                   semanticsLabel: 'arrow',
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ],
// //                     ),
// //
// //                     // space before cards
// //                     SizedBox(height: AppDimensions.d18.h),
// //
// //                     // RIGHT-EDGE CARD STACK + VERTICAL DOTS
// //                     Expanded(
// //                       child: Align(
// //                         alignment: Alignment.centerRight,
// //                         child: SizedBox(
// //                           width: 1.sw, // let stack float on right
// //                           child: Row(
// //                             mainAxisAlignment: MainAxisAlignment.end,
// //                             crossAxisAlignment: CrossAxisAlignment.center,
// //                             children: [
// //                               // VERTICAL DOTS (reddish)
// //                               _verticalDots(),
// //
// //                               SizedBox(width: 8.w),
// //
// //                               // VERTICAL PAGEVIEW CARDS aligned on right border
// //                               SizedBox(
// //                                 width: 0.83.sw,
// //                                 height: 0.52.sh,
// //                                 child: PageView.builder(
// //                                   controller: c.pageController,
// //                                   scrollDirection: Axis.vertical,
// //                                   physics: const BouncingScrollPhysics(),
// //                                   itemCount: c.cards.length,
// //                                   itemBuilder: (context, index) {
// //                                     return AnimatedBuilder(
// //                                       animation: c.pageController,
// //                                       builder: (context, child) {
// //                                         double page = 0.0;
// //                                         if (c.pageController.hasClients &&
// //                                             c.pageController.position.haveDimensions) {
// //                                           page = c.pageController.page ?? 0.0;
// //                                         }
// //                                         final delta = (index - page);
// //                                         // Overlap + parallax feel
// //                                         final translateX = (delta * -36.w);
// //                                         final rotate = delta * -0.06; // small tilt for behind cards
// //                                         final scale = 1 - (delta.abs() * 0.06);
// //
// //                                         return Transform.translate(
// //                                           offset: Offset(translateX, 0),
// //                                           child: Transform.rotate(
// //                                             angle: rotate,
// //                                             child: Transform.scale(
// //                                               scale: scale.clamp(0.9, 1.0),
// //                                               child: _card(index),
// //                                             ),
// //                                           ),
// //                                         );
// //                                       },
// //                                     );
// //                                   },
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //
// //                     // BOTTOM: "Go to Dashboard" with arrow pointing to it
// //                     SizedBox(height: AppDimensions.d12.h),
// //                     Stack(
// //                       clipBehavior: Clip.none,
// //                       children: [
// //                         _dashboardButton(),
// //                         Positioned(
// //                           left: 18.w,
// //                           top: -14.h,
// //                           child: Transform.rotate(
// //                             angle: -0.35,
// //                             child: CustomSvg(
// //                               assetPath: 'assets/images/arrow.svg',
// //                               semanticsLabel: 'arrow',
// //                               height: 16.h,
// //                               width: 16.w,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //
// //                     SizedBox(height: AppDimensions.d16.h),
// //                   ],
// //                 ),
// //               ),
// //
// //               // Tiny profile/avatar (top-right)
// //               Positioned(
// //                 top: 10.h,
// //                 right: 14.w,
// //                 child: CircleAvatar(
// //                   radius: 16.r,
// //                   backgroundColor: Colors.white,
// //                   child: Padding(
// //                     padding: EdgeInsets.all(2.r),
// //                     child: CustomSvg(
// //                       assetPath: 'assets/images/persondashboard.svg',
// //                       semanticsLabel: 'profile',
// //                       height: 22.h,
// //                       width: 22.w,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // ===== widgets =====
// //
// //   Widget _underlineText(String text) {
// //     return Text(
// //       text,
// //       style: TextStyle(
// //         fontSize: AppDimensions.d14.sp,
// //         color: AppColors.textSecondary,
// //         fontWeight: FontWeight.w700,
// //         fontFamily: 'Gotham',
// //         decoration: TextDecoration.underline,
// //       ),
// //     );
// //   }
// //
// //   Widget _chip(String text) {
// //     return Container(
// //       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
// //       decoration: BoxDecoration(
// //         color: Colors.white.withOpacity(0.7),
// //         borderRadius: BorderRadius.circular(18.r),
// //         border: Border.all(color: const Color(0xFF8FC6F6), width: 1.2),
// //       ),
// //       child: Text(
// //         text,
// //         style: TextStyle(
// //           fontSize: AppDimensions.d12.sp,
// //           color: const Color(0xFF3E85C9),
// //           fontWeight: FontWeight.w700,
// //           fontFamily: 'Gotham',
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _verticalDots() {
// //     return Obx(() {
// //       return SizedBox(
// //         width: AppDimensions.d12.w,
// //         height: AppDimensions.d140.h,
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: List.generate(c.cards.length * 2 - 1, (i) {
// //             if (i.isOdd) {
// //               return SizedBox(height: 6.h); // spacing between dots
// //             }
// //             final dotIndex = i ~/ 2;
// //             final active = c.selectedCardIndex.value == dotIndex;
// //             return Container(
// //               width: AppDimensions.d6.w,
// //               height: AppDimensions.d6.w,
// //               decoration: BoxDecoration(
// //                 color: active ? const Color(0xFFC34028) : Colors.black26,
// //                 shape: BoxShape.circle,
// //               ),
// //             );
// //           }),
// //         ),
// //       );
// //     });
// //   }
// //
// //   Widget _card(int index) {
// //     final m = c.cards[index];
// //     final bg = Color(m['bg'] as int);
// //     final bg2 = Color(m['bg2'] as int);
// //
// //     return Align(
// //       alignment: Alignment.centerRight,
// //
// //       child: Container(
// //         width: 0.78.sw,
// //         height: 0.28.sh,
// //         margin: EdgeInsets.only(bottom: 14.h),
// //         padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 16.h),
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //             colors: [bg, bg2],
// //           ),
// //           borderRadius: BorderRadius.circular(AppDimensions.d26.r),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.20),
// //               blurRadius: 16,
// //               offset: const Offset(0, 10),
// //             ),
// //           ],
// //         ),
// //         child: _cardBody(m),
// //       ),
// //     );
// //   }
// //
// //   Widget _cardBody(Map<String, dynamic> m) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         // Title like the design: "Start" (bolder/whiter) + "Game" (darker)
// //         RichText(
// //           text: TextSpan(
// //             children: [
// //               TextSpan(
// //                 text: '${m['titleTop']}\n',
// //                 style: TextStyle(
// //                   fontSize: 32.sp,
// //                   height: 1.0,
// //                   fontWeight: FontWeight.w900,
// //                   fontFamily: 'Gotham',
// //                   color: Colors.white,
// //                 ),
// //               ),
// //               TextSpan(
// //                 text: m['titleBottom'],
// //                 style: TextStyle(
// //                   fontSize: 28.sp,
// //                   fontWeight: FontWeight.w800,
// //                   fontFamily: 'Gotham',
// //                   color: Colors.black.withOpacity(0.6),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //         SizedBox(height: 10.h),
// //         Text(
// //           m['subtitle'],
// //           style: TextStyle(
// //             fontSize: 13.sp,
// //             height: 1.35,
// //             color: Colors.white,
// //             fontFamily: 'Gotham',
// //           ),
// //         ),
// //         const Spacer(),
// //         GestureDetector(
// //           onTap: c.onTapCTA,
// //           child: Text(
// //             m['cta'],
// //             style: TextStyle(
// //               fontSize: 14.sp,
// //               fontWeight: FontWeight.w700,
// //               decoration: TextDecoration.underline,
// //               color: Colors.white,
// //               fontFamily: 'Gotham',
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _dashboardButton() {
// //     return GestureDetector(
// //       onTap: () => Get.toNamed('/dashboard'),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Text(
// //             'Go to ',
// //             style: TextStyle(
// //               fontSize: 15.sp,
// //               color: Colors.black87,
// //               fontFamily: 'Gotham',
// //               fontWeight: FontWeight.w600,
// //             ),
// //           ),
// //           SizedBox(height: AppDimensions.d4.h),
// //           Text(
// //             'Dashboard',
// //             style: TextStyle(
// //               fontSize: 15.sp,
// //               color: Colors.black87,
// //               fontFamily: 'Gotham',
// //               fontWeight: FontWeight.w800,
// //               decoration: TextDecoration.underline,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
