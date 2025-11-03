import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/strategy_selection_controller.dart';
import '../../../core/app_colors.dart';
import '../../../data/response/status.dart';
import '../../../services/shared_preference.dart';
import '../../../view_model/challange_view_models/show_challengers_vs_viewmodel.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/global_widgets/arrow_bubble_button.dart';
import '../../widgets/game_complete_widgets/custom_score_card.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

class ChallengeDetailsScreen extends StatelessWidget {
  const ChallengeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return OrientationBuilder(
            builder: (context, orientation) {
              return _ResponsiveChallengeDetails(
                constraints: constraints,
                orientation: orientation,
              );
            },
          );
        },
      ),
    );
  }
}

class _ResponsiveChallengeDetails extends StatelessWidget {
  final BoxConstraints constraints;
  final Orientation orientation;

  const _ResponsiveChallengeDetails({
    required this.constraints,
    required this.orientation,
  });

  double get screenWidth => constraints.maxWidth;
  double get screenHeight => constraints.maxHeight;

  DeviceType get deviceType {
    if (screenWidth < 600) return DeviceType.mobile;
    if (screenWidth >= 600 && screenWidth < 900) return DeviceType.tablet;
    if (screenWidth >= 900 && screenWidth < 1200) return DeviceType.desktop;
    if (screenWidth >= 1200 && screenWidth < 1920) return DeviceType.largeDesktop;
    return DeviceType.ultraWide;
  }

  bool get isWeb => deviceType == DeviceType.largeDesktop || deviceType == DeviceType.ultraWide;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: isWeb ? 500 : double.infinity,
                ),
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomHeader(
                      title: 'Start',
                      highlightedText: "Challenge",
                      onBackTap: () => Get.back(),
                    ),
                    SizedBox(height: 20.h),
                    _buildVSSection(),
                    SizedBox(height: 30.h),
                    Stack(
                      children: [
                        _buildStrategyCard(),
                        Positioned(
                          top: 100.h,
                          left: 0,
                          right: -50.w,
                          child: const CustomHomeNavBar(),
                        ),
                      ],
                    ),
                    SizedBox(height: 25.h),
                    _buildStartGameButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVSSection() {
    final vsController = Get.put(ShowChallengersVsViewModel());

    return Obx(() {
      final response = vsController.challengers.value;

      if (response.status == Status.loading) {
        return _buildDefaultPlayerCards();
      }

      if (response.status == Status.error) {
        print('⚠️ Error loading players, using fallback: ${response.message}');
        return _buildDefaultPlayerCards();
      }

      if (response.status == Status.completed) {
        final players = response.data as List<dynamic>?;

        if (players == null || players.isEmpty) {
          print('⚠️ No players found, using fallback data');
          return _buildDefaultPlayerCards();
        }

        // Use actual player data if available
        final player1 = players[0] as Map<String, dynamic>;
        final player2 = players.length > 1 ? players[1] as Map<String, dynamic> : null;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPlayerCard(
                playerName: player1['name']?.toString() ?? 'Test',
              ),
              Text(
                'Vs',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff24387F),
                ),
              ),
              _buildPlayerCard(
                playerName: player2?['name']?.toString() ?? 'Test',
              ),
            ],
          ),
        );
      }

      return _buildDefaultPlayerCards();
    });
  }

  Widget _buildDefaultPlayerCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPlayerCard(playerName: 'Test'),
          Text(
            'Vs',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xff24387F),
            ),
          ),
          _buildPlayerCard(playerName: 'Test'),
        ],
      ),
    );
  }

  Widget _buildPlayerCard({required String playerName}) {
    return Flexible(
      flex: 1,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          const CustomScoreCard(
            title: '',
            showBackground: false,
            imagePath: 'assets/images/solo_image.png',
          ),
          Positioned(
            top: 130.h,
            left: 30.w,
            child: ArrowBubbleButton(level: playerName),
          ),
        ],
      ),
    );
  }

  Widget _buildStrategyCard() {
    final controller = Get.find<StrategySelectionController>();
    const double containerBorderRadius = 20.0;
    const double strokeWidth = 4.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      child: CustomPaint(
        painter: _GradientBorderPainter(
          borderRadius: containerBorderRadius,
          strokeWidth: strokeWidth,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryRed,
              AppColors.primaryRed.withOpacity(0.15),
            ],
          ),
        ),
        child: Container(
          height: 400.h,
          width: double.infinity,
          padding: EdgeInsets.all(strokeWidth + 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(containerBorderRadius),
          ),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withOpacity(0.08),
              borderRadius: BorderRadius.circular(containerBorderRadius - (strokeWidth + 2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                controller.selectedCardIndex.value == -1
                    ? 'assets/images/backcard_img.png'
                    : controller.cardAssets[controller.selectedCardIndex.value],
                height: 350.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStartGameButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: const Color(0xffC43917),
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: _startChallengeGame,
        borderRadius: BorderRadius.circular(25.r),
        child: Text(
          'Accept Match & Start Game',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _startChallengeGame() async {
    print('🎯 Starting challenge game flow');

    try {
      final vsController = Get.find<ShowChallengersVsViewModel>();
      final response = vsController.challengers.value;

      // Always save challenge mode and proceed
      await SharedPrefs.saveGameMode('challenge');
      print('✅ Saved game mode: challenge');

      // Try to get challenge ID if available
      if (response.status == Status.completed) {
        final players = response.data as List<dynamic>? ?? [];
        if (players.isNotEmpty && players[0]['challengeId'] != null) {
          final challengeId = players[0]['challengeId'].toString();
          await SharedPrefs.saveChallengeId(challengeId);
          print('✅ Saved challenge ID: $challengeId');
        } else {
          print('⚠️ No challenge ID found, using default');
        }
      } else {
        print('⚠️ Using fallback challenge data');
      }

      // Navigate to role selection
      Get.toNamed(AppRoutes.roleSelection);

    } catch (e) {
      print('❌ Error starting challenge: $e');
      // Even if there's an error, still proceed with the game flow
      await SharedPrefs.saveGameMode('challenge');
      Get.toNamed(AppRoutes.roleSelection);
    }
  }
}

enum DeviceType { mobile, tablet, desktop, largeDesktop, ultraWide }

class _GradientBorderPainter extends CustomPainter {
  final double borderRadius;
  final double strokeWidth;
  final Gradient gradient;

  const _GradientBorderPainter({
    required this.borderRadius,
    required this.strokeWidth,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}









// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import '../../../controllers/strategy_selection_controller.dart';
// import '../../../core/app_assets.dart';
// import '../../../core/app_colors.dart';
// import '../../../data/response/status.dart';
// import '../../../services/shared_preference.dart';
// import '../../../view_model/challange_view_models/show_challengers_vs_viewmodel.dart';
// import '../../routes/app_routes.dart';
// import '../../widgets/custom_circular_avatar.dart';
// import '../../widgets/custom_curved_arrow.dart';
// import '../../widgets/custom_home_navbar.dart';
// import '../../widgets/global_widgets/arrow_bubble_button.dart';
// import '../../widgets/game_complete_widgets/custom_score_card.dart';
// import '../../widgets/screens_unique_parts/custom_background.dart';
// import '../../widgets/screens_unique_parts/custom_header.dart';
// import 'game_result_screen.dart';
//
// class ChallengeDetailsScreen extends StatelessWidget {
//   const ChallengeDetailsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return OrientationBuilder(
//             builder: (context, orientation) {
//               return _ResponsiveChallengeDetails(
//                 constraints: constraints,
//                 orientation: orientation,
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
// class _ResponsiveChallengeDetails extends StatelessWidget {
//   final BoxConstraints constraints;
//   final Orientation orientation;
//
//   const _ResponsiveChallengeDetails({
//     required this.constraints,
//     required this.orientation,
//   });
//
//   double get screenWidth => constraints.maxWidth;
//
//   double get screenHeight => constraints.maxHeight;
//
//   DeviceType get deviceType {
//     if (screenWidth < 600) return DeviceType.mobile;
//     if (screenWidth >= 600 && screenWidth < 900) return DeviceType.tablet;
//     if (screenWidth >= 900 && screenWidth < 1200) return DeviceType.desktop;
//     if (screenWidth >= 1200 && screenWidth < 1920)
//       return DeviceType.largeDesktop;
//     return DeviceType.ultraWide;
//   }
//
//   bool get isPortrait => orientation == Orientation.portrait;
//
//   bool get isMobile => deviceType == DeviceType.mobile;
//
//   bool get isWeb =>
//       deviceType == DeviceType.largeDesktop ||
//           deviceType == DeviceType.ultraWide;
//
//   bool get isDesktop =>
//       deviceType == DeviceType.desktop ||
//           deviceType == DeviceType.largeDesktop ||
//           deviceType == DeviceType.ultraWide;
//
//   double getResponsiveFont({
//     required double mobile,
//     required double tablet,
//     required double desktop,
//     required double largeDesktop,
//     required double ultraWide,
//   }) {
//     switch (deviceType) {
//       case DeviceType.mobile:
//         return mobile.sp;
//       case DeviceType.tablet:
//         return tablet.sp;
//       case DeviceType.desktop:
//         return desktop.sp;
//       case DeviceType.largeDesktop:
//         return largeDesktop.sp;
//       case DeviceType.ultraWide:
//         return ultraWide.sp;
//     }
//   }
//
//   double getResponsiveSpacing({
//     required double mobile,
//     required double tablet,
//     required double desktop,
//     required double largeDesktop,
//     required double ultraWide,
//   }) {
//     switch (deviceType) {
//       case DeviceType.mobile:
//         return mobile.h;
//       case DeviceType.tablet:
//         return tablet.h;
//       case DeviceType.desktop:
//         return desktop;
//       case DeviceType.largeDesktop:
//         return largeDesktop;
//       case DeviceType.ultraWide:
//         return ultraWide;
//     }
//   }
//
//   double getResponsiveWidth({
//     required double mobile,
//     required double tablet,
//     required double desktop,
//     required double largeDesktop,
//     required double ultraWide,
//   }) {
//     switch (deviceType) {
//       case DeviceType.mobile:
//         return mobile.w;
//       case DeviceType.tablet:
//         return tablet.w;
//       case DeviceType.desktop:
//         return desktop;
//       case DeviceType.largeDesktop:
//         return largeDesktop;
//       case DeviceType.ultraWide:
//         return ultraWide;
//     }
//   }
//
//   double getResponsiveHeight({
//     required double mobile,
//     required double tablet,
//     required double desktop,
//     required double largeDesktop,
//     required double ultraWide,
//     double landscapeAdjustment = 1.0,
//   }) {
//     switch (deviceType) {
//       case DeviceType.mobile:
//         return mobile.h * landscapeAdjustment;
//       case DeviceType.tablet:
//         return tablet.h * landscapeAdjustment;
//       case DeviceType.desktop:
//         return desktop.h * landscapeAdjustment;
//       case DeviceType.largeDesktop:
//         return largeDesktop.h * landscapeAdjustment;
//       case DeviceType.ultraWide:
//         return ultraWide.h * landscapeAdjustment;
//     }
//   }
//
//   Widget _buildSingleStrategyCard(BuildContext context) {
//     final controller = Get.find<StrategySelectionController>();
//     const double containerBorderRadius = 20.0;
//     const double strokeWidth = 4.0;
//
//     return Container(
//       margin: EdgeInsets.symmetric(
//         horizontal: getResponsiveWidth(
//           mobile: 24,
//           tablet: 32,
//           desktop: 40,
//           largeDesktop: 48,
//           ultraWide: 56,
//         ),
//       ),
//       child: CustomPaint(
//         painter: _GradientBorderPainter(
//           borderRadius: containerBorderRadius,
//           strokeWidth: strokeWidth,
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               AppColors.primaryRed,
//               AppColors.primaryRed.withValues(alpha: 0.15),
//             ],
//           ),
//         ),
//         child: Container(
//           height: getResponsiveHeight(
//             mobile: 400,
//             tablet: 480,
//             desktop: 560,
//             largeDesktop: 620,
//             ultraWide: 680,
//             landscapeAdjustment: 0.75,
//           ),
//           width: double.infinity,
//           padding: EdgeInsets.all(strokeWidth + 4),
//           // Border width + extra spacing
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(containerBorderRadius),
//           ),
//           child: Container(
//             padding: EdgeInsets.all(
//               getResponsiveWidth(
//                 mobile: 16,
//                 tablet: 20,
//                 desktop: 24,
//                 largeDesktop: 28,
//                 ultraWide: 32,
//               ),
//             ),
//             decoration: BoxDecoration(
//               color: AppColors.primaryRed.withValues(alpha: 0.08),
//               borderRadius: BorderRadius.circular(
//                 containerBorderRadius - (strokeWidth + 2),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(
//                     alpha: isDesktop ? 0.12 : 0.08,
//                   ),
//                   blurRadius: isDesktop ? 12 : 8,
//                   offset: Offset(0, isDesktop ? 6 : 4),
//                   spreadRadius: isDesktop ? 1 : 0,
//                 ),
//               ],
//             ),
//             child: Center(
//               child: Image.asset(
//                 controller.selectedCardIndex.value == -1
//                     ? 'assets/images/backcard_img.png'
//                     : controller.cardAssets[controller.selectedCardIndex.value],
//                 key: ValueKey<int>(controller.selectedCardIndex.value),
//                 height: getResponsiveHeight(
//                   mobile: 350,
//                   tablet: 420,
//                   desktop: 480,
//                   largeDesktop: 540,
//                   ultraWide: 600,
//                   landscapeAdjustment: 0.7,
//                 ),
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomBackground(
//         child: SafeArea(
//           child: SingleChildScrollView(
//             child: Center(
//               child: Container(
//                 constraints: BoxConstraints(
//                   maxWidth: isWeb ? 500 : double.infinity,
//                 ),
//                 padding: EdgeInsets.symmetric(
//                   vertical: getResponsiveSpacing(
//                     mobile: 20,
//                     tablet: 24,
//                     desktop: 28,
//                     largeDesktop: 32,
//                     ultraWide: 36,
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     CustomHeader(
//                       title: 'Start',
//                       highlightedText: "Challenge",
//                       onBackTap: () {
//                         Get.back();
//                       },
//                     ),
//                     SizedBox(
//                       height: getResponsiveSpacing(
//                         mobile: 20,
//                         tablet: 25,
//                         desktop: 30,
//                         largeDesktop: 35,
//                         ultraWide: 40,
//                       ),
//                     ),
//                     _buildVSSection(),
//                     SizedBox(
//                       height: getResponsiveSpacing(
//                         mobile: 30,
//                         tablet: 35,
//                         desktop: 40,
//                         largeDesktop: 45,
//                         ultraWide: 50,
//                       ),
//                     ),
//                     Stack(
//                       children: [
//                         _buildSingleStrategyCard(context),
//                         Positioned(
//                           top: 100,
//                           left: 0,
//                           right: -50,
//                           child: CustomHomeNavBar(),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: getResponsiveSpacing(
//                         mobile: 25,
//                         tablet: 30,
//                         desktop: 35,
//                         largeDesktop: 40,
//                         ultraWide: 45,
//                       ),
//                     ),
//                     _buildStartGameButton(context),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   Widget _buildVSSection() {
//     final vsController = Get.put(ShowChallengersVsViewModel());
//
//     return Obx(() {
//       final response = vsController.challengers.value;
//
//       if (response.status == Status.loading) {
//         return Center(
//           child: CircularProgressIndicator(
//             color: const Color(0xff24387F),
//           ),
//         );
//       }
//
//       if (response.status == Status.error) {
//         return Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.error_outline, color: Colors.red, size: 48),
//                 SizedBox(height: 8),
//                 Text(
//                   response.message ?? "Error loading players",
//                   style: TextStyle(color: Colors.red, fontSize: 14),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           ),
//         );
//       }
//
//       if (response.status == Status.completed) {
//         final players = response.data as List<dynamic>;
//
//         if (players.isEmpty) {
//           return const Center(
//             child: Text(
//               "No players found for this challenge",
//               style: TextStyle(fontSize: 16),
//             ),
//           );
//         }
//
//         // Extract player data based on your API response
//         final player1 = players[0] as Map<String, dynamic>;
//         final player2 = players.length > 1 ? players[1] as Map<String, dynamic> : null;
//
//         return Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: getResponsiveWidth(
//               mobile: 16,
//               tablet: 20,
//               desktop: 24,
//               largeDesktop: 28,
//               ultraWide: 32,
//             ),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildPlayerCard(
//                 imagePath: 'assets/images/solo_image.png',
//                 playerName: player1['name'] ?? 'Unknown',
//               ),
//               Text(
//                 'Vs',
//                 style: TextStyle(
//                   fontSize: getResponsiveFont(
//                     mobile: 28,
//                     tablet: 32,
//                     desktop: 36,
//                     largeDesktop: 40,
//                     ultraWide: 44,
//                   ),
//                   fontWeight: FontWeight.bold,
//                   color: const Color(0xff24387F),
//                   fontFamily: 'Gotham-Bold',
//                 ),
//               ),
//               if (player2 != null)
//                 _buildPlayerCard(
//                   imagePath: 'assets/images/solo_image.png',
//                   playerName: player2['name'] ?? 'Unknown',
//                 )
//               else
//                 _buildPlayerCard(
//                   imagePath: 'assets/images/solo_image.png',
//                   playerName: 'Waiting...',
//                 ),
//             ],
//           ),
//         );
//       }
//
//       return const SizedBox.shrink();
//     });
//   }
//
//   Widget _buildPlayerCard({
//     required String imagePath,
//     required String playerName,
//   }) {
//     return Flexible(
//       flex: 1,
//       child: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           CustomScoreCard(
//             title: '',
//             showBackground: false,
//             imagePath: imagePath,
//           ),
//           Center(
//             child: Positioned(
//               top: getResponsiveSpacing(
//                 mobile: 130,
//                 tablet: 55,
//                 desktop: 60,
//                 largeDesktop: 65,
//                 ultraWide: 70,
//               ),
//               left: getResponsiveWidth(
//                 mobile: 30,
//                 tablet: 65,
//                 desktop: 70,
//                 largeDesktop: 75,
//                 ultraWide: 80,
//               ),
//               child: Center(child: ArrowBubbleButton(level: playerName)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStartGameButton(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: EdgeInsets.symmetric(
//         vertical: getResponsiveSpacing(
//           mobile: 16,
//           tablet: 18,
//           desktop: 20,
//           largeDesktop: 22,
//           ultraWide: 24,
//         ),
//       ),
//       decoration: BoxDecoration(
//         color: Color(0xffC43917),
//         borderRadius: BorderRadius.circular(25),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.red.withOpacity(0.3),
//             blurRadius: 8,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: InkWell(
//         onTap: () {
//           // ✅ Navigate to role selection screen for solo game flow
//           _startChallengeGame();
//         },
//         child: Text(
//           'Accept Match & Start Game',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: getResponsiveFont(
//               mobile: 16,
//               tablet: 18,
//               desktop: 20,
//               largeDesktop: 22,
//               ultraWide: 24,
//             ),
//             fontWeight: FontWeight.bold,
//             fontFamily: 'Gotham-Bold',
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _startChallengeGame() async {
//     print('🎯 Starting challenge game flow');
//
//     try {
//       // Get the challenge ID from the VS controller
//       final vsController = Get.find<ShowChallengersVsViewModel>();
//       final response = vsController.challengers.value;
//
//       if (response.status == Status.completed) {
//         final players = response.data as List<dynamic>;
//
//         // Save challenge ID to SharedPreferences
//         if (players.isNotEmpty && players[0]['challengeId'] != null) {
//           final challengeId = players[0]['challengeId'].toString();
//           await SharedPrefs.saveChallengeId(challengeId);
//           print('✅ Saved challenge ID: $challengeId');
//         }
//
//         // Save game mode as challenge
//         await SharedPrefs.saveGameMode('challenge');
//         print('✅ Saved game mode: challenge');
//
//         // Navigate to role selection (start of game flow)
//         Get.toNamed(AppRoutes.roleSelection);
//       } else {
//         Get.snackbar(
//           'Error',
//           'Unable to load challenge data',
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     } catch (e) {
//       print('❌ Error starting challenge: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to start challenge: $e',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
//   //
//   // // ✅ Start challenge game - goes to role selection then solo flow
//   // void _startChallengeGame() {
//   //   print('🎯 Starting challenge game flow');
//   //
//   //   // Save challenge context for later use in results
//   //   _saveChallengeContext();
//   //
//   //   // Navigate to role selection screen (same as solo)
//   //   Get.toNamed(AppRoutes.roleSelection);
//   // }
//
//   // ✅ Save challenge context for results screen
//   void _saveChallengeContext() async {
//     try {
//       final vsController = Get.find<ShowChallengersVsViewModel>();
//       final response = vsController.challengers.value;
//
//       if (response.status == Status.completed) {
//         final players = response.data as List<dynamic>;
//         final player1 = players[0] as Map<String, dynamic>;
//         final player2 = players.length > 1 ? players[1] as Map<String, dynamic> : null;
//
//         // Save challenge data to use in results screen
//         // You can use SharedPreferences or GetStorage for this
//         // Example:
//         // await SharedPrefs.saveChallengeData({
//         //   'player1': player1,
//         //   'player2': player2,
//         //   'challengeId': 'your_challenge_id_here',
//         // });
//
//         print('🎯 Challenge context saved: ${player1['name']} vs ${player2?['name'] ?? 'Waiting'}');
//       }
//     } catch (e) {
//       print('❌ Error saving challenge context: $e');
//     }
//   }
// }
//
// enum DeviceType { mobile, tablet, desktop, largeDesktop, ultraWide }
//
// class _GradientBorderPainter extends CustomPainter {
//   final double borderRadius;
//   final double strokeWidth;
//   final Gradient gradient;
//
//   _GradientBorderPainter({
//     required this.borderRadius,
//     required this.strokeWidth,
//     required this.gradient,
//   });
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final rect = Rect.fromLTWH(0, 0, size.width, size.height);
//     final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
//
//     final paint = Paint()
//       ..shader = gradient.createShader(rect)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = strokeWidth;
//
//     canvas.drawRRect(rrect, paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
