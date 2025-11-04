import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/generated/assets.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:game_app/presentation/widgets/bubble_button.dart';
import 'package:get/get.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

import '../../../controllers/home_controller.dart';
import '../../../core/app_colors.dart';
import '../../widgets/custom_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController c = Get.put(HomeController(), permanent: true);
  final PageController _stackedCardController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _stackedCardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo
                    CustomSvg(
                      assetPath: 'assets/images/okrnev.svg',
                      semanticsLabel: 'okr'.tr,
                      height: 45.h,
                    ),
                    // Right side icons
                    Row(
                      children: [
                        Container(
                          height: 46.sp,
                          width: 46.sp,
                          margin: EdgeInsets.only(right: 8.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primaryRed,
                              width: 1.5,
                            ),
                            color: AppColors.softRed.withValues(alpha: 0.4),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.notifications_outlined,
                              color: AppColors.primaryRed,
                              size: 22.sp,
                            ),
                          ),
                        ),
                        Container(
                          height: 46.sp,
                          width: 46.sp,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primaryRed,
                              width: 1.5,
                            ),
                            color: AppColors.imageBackgroundColor.withValues(alpha: 0.4),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              "assets/images/solo_image.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Certification button
              SizedBox(height: 6.h),
              CustomBubbleButton(
                text: 'certificate'.tr,
                width: 90,
                height: 30,
                onTap: () {
                  Get.toNamed(AppRoutes.certificationScreen);
                },
              ),

              SizedBox(height: 8.h),

              // Cards section with robot and dots
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Left side - Robot
                    Padding(
                      padding: EdgeInsets.only(left: 12.w, bottom: 60.h),
                      child: Image.asset(
                        'assets/images/robortarrow.png',
                        height: 90.h,
                        fit: BoxFit.contain,
                      ),
                    ),

                    // Stacked Card Carousel
                    Expanded(
                      child: Obx(() {
                        final selectedIndex = c.selectedCardIndex.value;
                        return StackedCardCarousel(
                          initialOffset: 20,
                          spaceBetweenItems: 320,
                          items: List.generate(c.cards.length, (index) {
                            return _CardItem(
                              index: index,
                              cardData: c.cards[index],
                              isCenter: index == selectedIndex,
                              onTap: () {
                                if (index == selectedIndex) {
                                  c.onTapCTA();
                                } else {
                                  _stackedCardController.animateToPage(
                                    index,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                  c.selectedCardIndex.value = index;
                                }
                              },
                            );
                          }),
                          pageController: _stackedCardController,
                          onPageChanged: (index) {
                            c.selectedCardIndex.value = index;
                          },
                        );
                      }),
                    ),

                    // Right side - Vertical dots
                    Padding(
                      padding: EdgeInsets.only(right: 14.w),
                      child: _verticalDots(c),
                    ),
                  ],
                ),
              ),

              // Dashboard button at bottom
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
                child: _dashboardButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _verticalDots(HomeController c) => Obx(
        () => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        c.cards.length,
            (index) {
          final active = c.selectedCardIndex.value == index;
          return Container(
            width: 8.w,
            height: 8.w,
            margin: EdgeInsets.symmetric(vertical: 4.h),
            decoration: BoxDecoration(
              color: active ? const Color(0xFFC34028) : Colors.black26,
              shape: BoxShape.circle,
            ),
          );
        },
      ),
    ),
  );

  Widget _dashboardButton(BuildContext context) => GestureDetector(
    onTap: () => Get.toNamed(AppRoutes.personalDashboardScreen),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/arrow.png',
          height: 22.h,
          fit: BoxFit.contain,
        ),
        SizedBox(width: 6.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'go_to'.tr,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                height: 1.1,
              ),
            ),
            Text(
              'dashboard'.tr,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
                decoration: TextDecoration.underline,
                color: Colors.black87,
                height: 1.1,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// Card Item Widget
class _CardItem extends StatelessWidget {
  final int index;
  final Map<String, dynamic> cardData;
  final bool isCenter;
  final VoidCallback onTap;

  const _CardItem({
    required this.index,
    required this.cardData,
    required this.isCenter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = Color(cardData['bg'] as int);
    final bg2 = Color(cardData['bg2'] as int);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [bg, bg2],
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isCenter ? 0.25 : 0.15),
              blurRadius: isCenter ? 20 : 12,
              offset: Offset(0, isCenter ? 8 : 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${(cardData['titleTop'] ?? '').toString().tr}\n',
                        style: TextStyle(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.0,
                        ),
                      ),
                      TextSpan(
                        text: (cardData['titleBottom'] ?? '').toString().tr,
                        style: TextStyle(
                          fontSize: 34.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.black.withValues(alpha: 0.5),
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  (cardData['subtitle'] ?? '').toString().tr,
                  style: TextStyle(
                    fontSize: 13.sp,
                    height: 1.4,
                    color: Colors.white.withValues(alpha: 0.95),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Text(
                (cardData['cta'] ?? '').toString().tr,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                  color: Colors.white,
                ),
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
// import 'package:game_app/generated/assets.dart';
// import 'package:game_app/presentation/routes/app_routes.dart';
// import 'package:game_app/presentation/widgets/bubble_button.dart';
// import 'package:game_app/presentation/widgets/custom_button2.dart';
// import 'package:get/get.dart';
//
// import '../../../controllers/home_controller.dart';
// import '../../../core/app_colors.dart';
// import '../../../core/app_dimensions.dart';
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
//     return OrientationBuilder(
//       builder: (context, orientation) => Scaffold(
//         body: Container(
//           width: double.infinity,
//           height: double.infinity,
//           decoration:  BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [AppColors.backgroundTop, AppColors.backgroundBottom],
//             ),
//           ),
//           child: SafeArea(
//             child: Stack(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: AppDimensions.d8.w),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: AppDimensions.d26.h),
//
//                       // LOGO
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           CustomSvg(
//                             assetPath: 'assets/images/okrnev.svg',
//                             semanticsLabel: 'okr'.tr,
//                             height: 50.h,
//                           ),
//                           Row(
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.only(top: 40.h),
//                                 child: SizedBox(
//                                   child: Image.asset(
//                                     Assets.imagesNavigationImage,
//                                     scale: 2.9,
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 height: 49.sp,
//                                 width: 49.sp,
//                                 margin: EdgeInsets.only(right: 10.w),
//                                 padding: EdgeInsets.all(5),
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color: AppColors.primaryRed,
//                                   ),
//                                   color: AppColors.softRed.withValues(
//                                     alpha: 0.4,
//                                   ),
//                                 ),
//                                 child: ClipOval(
//                                   child: Image.asset(
//                                     Assets.imagesCertificateImage,
//                                     fit: BoxFit.cover,
//                                     scale: 1.8,
//                                   ),
//                                 ),
//                               ),
//
//                               Container(
//                                 height: 49.sp,
//                                 width: 49.sp,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                     color: AppColors.primaryRed,
//                                   ),
//                                   color: AppColors.imageBackgroundColor
//                                       .withValues(alpha: 0.4),
//                                 ),
//                                 child: ClipOval(
//                                   child: Image.asset(
//                                     "assets/images/solo_image.png",
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       Center(
//                         child: CustomBubbleButton(
//                           text: 'certificate'.tr,
//                           width: 90,
//                           height: 30,
//                           onTap: () {
//                             Get.toNamed(AppRoutes.certificationScreen);
//                           },
//                         ),
//                       ),
//
//                       // Bonus + Certification
//                       SizedBox(height: AppDimensions.d18.h),
//
//                       // Cards + vertical dots
//                       Expanded(
//                         child: Align(
//                           alignment: Alignment.centerRight,
//                           child: SizedBox(
//                             width: screenWidth,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//
//                                 Align( alignment: Alignment.centerRight,
//                                     child: _verticalDots()),
//                                 SizedBox(width: 30.w),
//                                 SizedBox(
//                                   width: screenWidth * 0.8,
//                                   height: screenHeight * 0.5,
//                                   child: PageView.builder(
//                                     controller: c.pageController,
//                                     scrollDirection: Axis.vertical,
//                                     physics: const BouncingScrollPhysics(),
//                                     itemCount: c.cards.length,
//                                     itemBuilder: (context, index) =>
//                                         AnimatedBuilder(
//                                           animation: c.pageController,
//                                           builder: (context, child) {
//                                             final double page =
//                                                 c.pageController.hasClients
//                                                 ? (c.pageController.page ?? 0.0)
//                                                 : 0.0;
//                                             final delta = (index - page);
//                                             final translateX = delta * -40.w;
//                                             final rotate = delta * -0.09;
//                                             final scale =
//                                                 (1 - (delta.abs() * 0.1)).clamp(
//                                                   0.9,
//                                                   1.0,
//                                                 );
//
//                                             return Transform.translate(
//                                               offset: Offset(translateX, 0),
//                                               child: Transform.rotate(
//                                                 angle: rotate,
//                                                 child: Transform.scale(
//                                                   scale: scale,
//                                                   child: _card(index, context),
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//
//                       SizedBox(height: AppDimensions.d12.h),
//                       _dashboardButton(context),
//                       SizedBox(height: AppDimensions.d16.h),
//                     ],
//                   ),
//                 ),
//
//                 // Top-right profile
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ===== Widgets =====
//   Widget _underlineText(String text, BuildContext context) => Text(
//     text,
//     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//       color: Colors.grey.shade700,
//       fontWeight: FontWeight.w700,
//       decoration: TextDecoration.underline,
//     ),
//   );
//
//   Widget _chip(String text, BuildContext context) => Container(
//     padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//     decoration: BoxDecoration(
//       color: Colors.white.withValues(alpha: 0.7),
//       borderRadius: BorderRadius.circular(18.r),
//       border: Border.all(color: const Color(0xFF8FC6F6), width: 1.2),
//     ),
//     child: Text(
//       text,
//       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//         fontSize: 12.sp,
//         color: const Color(0xFF3E85C9),
//         fontWeight: FontWeight.w700,
//       ),
//     ),
//   );
//
//   Widget _verticalDots() => Obx(
//     () => SizedBox(
//       width: 12.w,
//       height: 140.h,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: List.generate(c.cards.length * 2 - 1, (i) {
//           if (i.isOdd) return SizedBox(height: 6.h);
//           final dotIndex = i ~/ 2;
//           final active = c.selectedCardIndex.value == dotIndex;
//           return Container(
//             width: 7.w,
//             height: 9.w,
//             decoration: BoxDecoration(
//               color: active ? const Color(0xFFC34028) : Colors.black26,
//               shape: BoxShape.circle,
//             ),
//           );
//         }),
//       ),
//     ),
//   );
//
//   Widget _card(int index, BuildContext context) {
//     final m = c.cards[index];
//     final bg = Color(m['bg'] as int);
//     final bg2 = Color(m['bg2'] as int);
//
//     return GestureDetector(
//       onTap: c.onTapCTA,
//       child: Align(
//         alignment: Alignment.centerRight,
//         child: Container(
//           width: 0.80.sw,
//           height: 0.32.sh,
//           margin: EdgeInsets.only(bottom: 14.h),
//           padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 16.h),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [bg, bg2],
//             ),
//             borderRadius: BorderRadius.circular(26.r),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withValues(alpha: 0.20),
//                 blurRadius: 16,
//                 offset: const Offset(0, 10),
//               ),
//             ],
//           ),
//           child: _cardBody(m, context),
//         ),
//       ),
//     );
//   }
//
//   Widget _cardBody(Map<String, dynamic> m, BuildContext context) => Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       RichText(
//         text: TextSpan(
//           children: [
//             TextSpan(
//               text: '${(m['titleTop'] ?? '').toString().tr}\n',
//               style: Theme.of(context).textTheme.displayLarge?.copyWith(
//                 fontSize: 32.sp,
//                 color: Colors.white,
//               ),
//             ),
//             TextSpan(
//               text: (m['titleBottom'] ?? '').toString().tr,
//               style: Theme.of(context).textTheme.headlineLarge?.copyWith(
//                 fontSize: 28.sp,
//                 color: Colors.black.withValues(alpha: 0.6),
//               ),
//             ),
//           ],
//         ),
//       ),
//       SizedBox(height: 6.h),
//       Text(
//         (m['subtitle'] ?? '').toString().tr,
//         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//           fontSize: 13.sp,
//           height: 1.35,
//           color: Colors.white,
//         ),
//       ),
//        Spacer(flex: 1,),
//
//       Text(
//         (m['cta'] ?? '').toString().tr,
//         style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//           fontSize: 14.sp,
//           fontWeight: FontWeight.w700,
//           decoration: TextDecoration.none,
//           color: Colors.white,
//         ),
//       ),
//     ],
//   );
//
//   Widget _dashboardButton(BuildContext context) => GestureDetector(
//     onTap: () => Get.toNamed(AppRoutes.personalDashboardScreen),
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(
//           'go_to'.tr,
//           style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//             fontSize: 15.sp,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//         SizedBox(height: 1.h),
//         Text(
//           'dashboard'.tr,
//           style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//             fontSize: 15.sp,
//             fontWeight: FontWeight.w800,
//             decoration: TextDecoration.underline,
//             color: Colors.black87,
//           ),
//         ),
//       ],
//     ),
//   );
// }
