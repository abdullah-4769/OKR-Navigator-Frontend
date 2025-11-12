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
      // Initialize view model only if not already registered
      if (!Get.isRegistered<ShowChallengersVsViewModel>()) {
        Get.put(ShowChallengersVsViewModel());
      }

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

    bool get isPortrait => orientation == Orientation.portrait;
    bool get isMobile => deviceType == DeviceType.mobile;
    bool get isWeb => deviceType == DeviceType.largeDesktop || deviceType == DeviceType.ultraWide;
    bool get isDesktop => deviceType == DeviceType.desktop || deviceType == DeviceType.largeDesktop || deviceType == DeviceType.ultraWide;

    double getResponsiveFont({
      required double mobile,
      required double tablet,
      required double desktop,
      required double largeDesktop,
      required double ultraWide,
    }) {
      switch (deviceType) {
        case DeviceType.mobile: return mobile.sp;
        case DeviceType.tablet: return tablet.sp;
        case DeviceType.desktop: return desktop.sp;
        case DeviceType.largeDesktop: return largeDesktop.sp;
        case DeviceType.ultraWide: return ultraWide.sp;
      }
    }

    double getResponsiveSpacing({
      required double mobile,
      required double tablet,
      required double desktop,
      required double largeDesktop,
      required double ultraWide,
    }) {
      switch (deviceType) {
        case DeviceType.mobile: return mobile.h;
        case DeviceType.tablet: return tablet.h;
        case DeviceType.desktop: return desktop;
        case DeviceType.largeDesktop: return largeDesktop;
        case DeviceType.ultraWide: return ultraWide;
      }
    }

    double getResponsiveWidth({
      required double mobile,
      required double tablet,
      required double desktop,
      required double largeDesktop,
      required double ultraWide,
    }) {
      switch (deviceType) {
        case DeviceType.mobile: return mobile.w;
        case DeviceType.tablet: return tablet.w;
        case DeviceType.desktop: return desktop;
        case DeviceType.largeDesktop: return largeDesktop;
        case DeviceType.ultraWide: return ultraWide;
      }
    }

    double getResponsiveHeight({
      required double mobile,
      required double tablet,
      required double desktop,
      required double largeDesktop,
      required double ultraWide,
      double landscapeAdjustment = 1.0,
    }) {
      switch (deviceType) {
        case DeviceType.mobile: return mobile.h * landscapeAdjustment;
        case DeviceType.tablet: return tablet.h * landscapeAdjustment;
        case DeviceType.desktop: return desktop.h * landscapeAdjustment;
        case DeviceType.largeDesktop: return largeDesktop.h * landscapeAdjustment;
        case DeviceType.ultraWide: return ultraWide.h * landscapeAdjustment;
      }
    }

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
                  padding: EdgeInsets.symmetric(
                    vertical: getResponsiveSpacing(
                      mobile: 20,
                      tablet: 24,
                      desktop: 28,
                      largeDesktop: 32,
                      ultraWide: 36,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomHeader(
                        title: 'start'.tr,
                        highlightedText: 'challenge'.tr,
                        onBackTap: () {
                          Get.back();
                        },
                      ),
                      SizedBox(
                        height: getResponsiveSpacing(
                          mobile: 20,
                          tablet: 25,
                          desktop: 30,
                          largeDesktop: 35,
                          ultraWide: 40,
                        ),
                      ),
                      _buildVSSection(),
                      SizedBox(
                        height: getResponsiveSpacing(
                          mobile: 30,
                          tablet: 35,
                          desktop: 40,
                          largeDesktop: 45,
                          ultraWide: 50,
                        ),
                      ),
                      Stack(
                        children: [
                          _buildStrategyCard(),
                          Positioned(
                            top: 100,
                            left: 0,
                            right: -18,
                            child: CustomHomeNavBar(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getResponsiveSpacing(
                          mobile: 25,
                          tablet: 30,
                          desktop: 35,
                          largeDesktop: 40,
                          ultraWide: 45,
                        ),
                      ),
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
      final vsController = Get.find<ShowChallengersVsViewModel>();

      return Obx(() {
        final response = vsController.challengers.value;

        if (response.status == Status.loading) {
          return Center(
            child: Column(
              children: [
                CircularProgressIndicator(
                  color: const Color(0xff24387F),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Loading players...',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        if (response.status == Status.error) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  SizedBox(height: 8),
                  Text(
                    response.message ?? "Error loading players",
                    style: TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (vsController.challengeId != null) {
                        vsController.fetchChallengePlayers(vsController.challengeId!);
                      }
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (response.status == Status.completed) {
          final players = response.data as List<dynamic>;

          if (players.isEmpty) {
            return Center(
              child: Column(
                children: [
                  Icon(Icons.group_off, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    "No players found for this challenge",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Waiting for players to join...",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Player data extraction with fallbacks
          String getPlayerName(Map<String, dynamic> player, int index) {
            final name = player['name']?.toString();
            if (name != null && name.isNotEmpty && name != 'null') {
              return name;
            }

            final userName = player['userName']?.toString();
            if (userName != null && userName.isNotEmpty && userName != 'null') {
              return userName;
            }

            final displayName = player['displayName']?.toString();
            if (displayName != null && displayName.isNotEmpty && displayName != 'null') {
              return displayName;
            }

            return 'Player ${index + 1}';
          }

          final player1 = players[0] as Map<String, dynamic>;
          final player2 = players.length > 1 ? players[1] as Map<String, dynamic> : null;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getResponsiveWidth(
                mobile: 16,
                tablet: 20,
                desktop: 24,
                largeDesktop: 28,
                ultraWide: 32,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPlayerCard(
                      imagePath: 'assets/images/solo_image.png',
                      playerName: getPlayerName(player1, 0),
                    ),
                    Text(
                      'Vs',
                      style: TextStyle(
                        fontSize: getResponsiveFont(
                          mobile: 28,
                          tablet: 32,
                          desktop: 36,
                          largeDesktop: 40,
                          ultraWide: 44,
                        ),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff24387F),
                        fontFamily: 'Gotham-Bold',
                      ),
                    ),
                    if (player2 != null)
                      _buildPlayerCard(
                        imagePath: 'assets/images/solo_image.png',
                        playerName: getPlayerName(player2, 1),
                      )
                    else
                      _buildPlayerCard(
                        imagePath: 'assets/images/solo_image.png',
                        playerName: 'Waiting...',
                      ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  'Players: ${players.length}/2',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: players.length >= 2 ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      });
    }

    Widget _buildPlayerCard({
      required String imagePath,
      required String playerName,
    }) {
      return Flexible(
        flex: 1,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CustomScoreCard(
              title: '',
              showBackground: false,
              imagePath: imagePath,
            ),
            Positioned(
              top: getResponsiveSpacing(
                mobile: 130,
                tablet: 55,
                desktop: 60,
                largeDesktop: 65,
                ultraWide: 70,
              ),
              left: getResponsiveWidth(
                mobile: 30,
                tablet: 65,
                desktop: 70,
                largeDesktop: 75,
                ultraWide: 80,
              ),
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
        margin: EdgeInsets.symmetric(
          horizontal: getResponsiveWidth(
            mobile: 24,
            tablet: 32,
            desktop: 40,
            largeDesktop: 48,
            ultraWide: 56,
          ),
        ),
        child: CustomPaint(
          painter: _GradientBorderPainter(
            borderRadius: containerBorderRadius,
            strokeWidth: strokeWidth,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryRed,
                AppColors.primaryRed.withValues(alpha: 0.15),
              ],
            ),
          ),
          child: Container(
            height: getResponsiveHeight(
              mobile: 400,
              tablet: 480,
              desktop: 560,
              largeDesktop: 620,
              ultraWide: 680,
              landscapeAdjustment: 0.75,
            ),
            width: double.infinity,
            padding: EdgeInsets.all(strokeWidth + 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(containerBorderRadius),
            ),
            child: Container(
              padding: EdgeInsets.all(
                getResponsiveWidth(
                  mobile: 16,
                  tablet: 20,
                  desktop: 24,
                  largeDesktop: 28,
                  ultraWide: 32,
                ),
              ),
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(
                  containerBorderRadius - (strokeWidth + 2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: isDesktop ? 0.12 : 0.08,
                    ),
                    blurRadius: isDesktop ? 12 : 8,
                    offset: Offset(0, isDesktop ? 6 : 4),
                    spreadRadius: isDesktop ? 1 : 0,
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  controller.selectedCardIndex.value == -1
                      ? 'assets/images/backcard_img.png'
                      : controller.cardAssets[controller.selectedCardIndex.value],
                  key: ValueKey<int>(controller.selectedCardIndex.value),
                  height: getResponsiveHeight(
                    mobile: 350,
                    tablet: 420,
                    desktop: 480,
                    largeDesktop: 540,
                    ultraWide: 600,
                    landscapeAdjustment: 0.7,
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      );
    }
    Widget _buildStartGameButton() {
      final vsController = Get.find<ShowChallengersVsViewModel>();

      return Obx(() {
        final response = vsController.challengers.value;
        final bool canStartGame = response.status == Status.completed &&
            (response.data as List<dynamic>).length >= 2;

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.symmetric(
            vertical: getResponsiveSpacing(
              mobile: 16,
              tablet: 18,
              desktop: 20,
              largeDesktop: 22,
              ultraWide: 24,
            ),
          ),
          decoration: BoxDecoration(
            color: canStartGame ? Color(0xffC43917) : Colors.grey,
            borderRadius: BorderRadius.circular(25),
            boxShadow: canStartGame
                ? [
              BoxShadow(
                color: Colors.red.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ]
                : [],
          ),
          child: InkWell(
            onTap: canStartGame ? () => _startChallengeGame(vsController) : null,
            child: Text(
              canStartGame ? 'Accept Match & Start Game' : 'Waiting for Opponent...',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: getResponsiveFont(
                  mobile: 16,
                  tablet: 18,
                  desktop: 20,
                  largeDesktop: 22,
                  ultraWide: 24,
                ),
                fontWeight: FontWeight.bold,
                fontFamily: 'Gotham-Bold',
              ),
            ),
          ),
        );
      });
    }
  // ✅ Safe start challenge method
    void _startChallengeGame(ShowChallengersVsViewModel vsController) async {
      print('🎯 Starting challenge game flow');

      try {
        final response = vsController.challengers.value;

        if (response.status == Status.completed) {
          final players = response.data as List<dynamic>;

          if (players.isEmpty) {
            Get.snackbar(
              'Error',
              'No players found',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            return;
          }

          final challengeId = players[0]['challengeId']?.toString();
          if (challengeId != null) {
            await SharedPrefs.saveChallengeId(challengeId);
            print('✅ Saved challenge ID: $challengeId');
          }

          await SharedPrefs.saveGameMode('challenge');
          print('✅ Saved game mode: challenge');

          // ✅ SCHEDULE NAVIGATION AFTER CURRENT TASK
          Future.delayed(Duration.zero, () {
            Get.toNamed(AppRoutes.roleSelection);
          });
        } else {
          Get.snackbar(
            'Error',
            'Unable to load challenge data',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e, st) {
        print('❌ Error starting challenge: $e');
        print(st);
        Get.snackbar(
          'Error',
          'Failed to start challenge: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }

  }

  enum DeviceType { mobile, tablet, desktop, largeDesktop, ultraWide }

   class _GradientBorderPainter extends CustomPainter {
    final double borderRadius;
    final double strokeWidth;
    final Gradient gradient;

    _GradientBorderPainter({
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

