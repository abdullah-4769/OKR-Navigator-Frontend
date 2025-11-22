// challange_detail_screen.dart - SIMPLIFIED VERSION
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/strategy_selection_controller.dart';
import '../../../core/api_constants.dart';
import '../../../core/app_colors.dart';
import '../../../data/repositories/storage_repository.dart';
import '../../../data/response/status.dart';
import '../../../services/shared_preference.dart';
import '../../../view_model/challange_view_models/show_challengers_vs_viewmodel.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/global_widgets/arrow_bubble_button.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

class ChallengeDetailsScreen extends StatefulWidget {
  const ChallengeDetailsScreen({super.key});

  @override
  State<ChallengeDetailsScreen> createState() => _ChallengeDetailsScreenState();
}

class _ChallengeDetailsScreenState extends State<ChallengeDetailsScreen> {
  final StorageRepository _storageRepo = Get.find<StorageRepository>();
  String? _currentUserId;
  int? _challengeId;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    if (Get.isRegistered<ShowChallengersVsViewModel>()) {
      Get.delete<ShowChallengersVsViewModel>();
    }
    super.dispose();
  }

  Future<void> _initializeData() async {
    try {
      _currentUserId = _storageRepo.getUserId();

      final prefs = await SharedPreferences.getInstance();

      // Get challenge ID from multiple sources
      String? challengeIdStr = prefs.getString('challengeId');
      if (challengeIdStr == null || challengeIdStr.isEmpty) {
        challengeIdStr = prefs.getString('acceptInviteChallengeId');
      }
      if (challengeIdStr == null || challengeIdStr.isEmpty) {
        challengeIdStr = prefs.getString('joinChallengeId');
      }

      if (challengeIdStr != null) {
        _challengeId = int.tryParse(challengeIdStr);
        print('✅ Loaded challenge ID: $_challengeId');
      }

      if (mounted) setState(() {});
    } catch (e) {
      print('❌ Error initializing challenge data: $e');
    }
  }

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
                currentUserId: _currentUserId,
                challengeId: _challengeId,
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
  final String? currentUserId;
  final int? challengeId;

  const _ResponsiveChallengeDetails({
    required this.constraints,
    required this.orientation,
    required this.currentUserId,
    required this.challengeId,
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
    final vsController = Get.put(ShowChallengersVsViewModel());

    return Obx(() {
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
                        onBackTap: () => Get.back(),
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
    });
  }

  Widget _buildVSSection() {
    final vsController = Get.find<ShowChallengersVsViewModel>();

    return Obx(() {
      final response = vsController.challengers.value;

      if (response.status == Status.loading) {
        return _buildLoadingState();
      }

      if (response.status == Status.error) {
        return _buildErrorState(vsController);
      }

      if (response.status == Status.completed) {
        final players = response.data as List<dynamic>;

        // Check for exactly 2 players max
        if (players.length > 2) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.snackbar(
              'Challenge Full',
              'This challenge already has 2 players',
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
            Future.delayed(Duration(seconds: 2), () => Get.back());
          });
          return _buildFullChallengeMessage();
        }

        return _buildPlayersDisplay(players);
      }

      return const SizedBox.shrink();
    });
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        children: [
          CircularProgressIndicator(color: const Color(0xff24387F)),
          SizedBox(height: 10.h),
          Text(
            'Loading players...',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(ShowChallengersVsViewModel vsController) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            SizedBox(height: 8),
            Text(
              "Error loading players",
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

  Widget _buildFullChallengeMessage() {
    return Center(
      child: Column(
        children: [
          Icon(Icons.block, size: 48, color: Colors.orange),
          SizedBox(height: 16.h),
          Text(
            "Challenge Full",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              "This challenge already has 2 players. Please create a new challenge or join a different one.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayersDisplay(List<dynamic> players) {
    if (players.isEmpty) {
      return _buildWaitingForPlayers();
    }

    // Filter out placeholders to get actual player count
    final actualPlayers = players.where((p) {
      final player = p as Map<String, dynamic>;
      return player['isPlaceholder'] != true;
    }).toList();

    if (kDebugMode) {
      print('🎮 Player Display Debug:');
      print('   Total items: ${players.length}');
      print('   Actual players: ${actualPlayers.length}');
    }

    // Get host player (first in list)
    Map<String, dynamic>? hostPlayer;
    Map<String, dynamic>? joinedPlayer;

    if (actualPlayers.isNotEmpty) {
      hostPlayer = actualPlayers[0] as Map<String, dynamic>;
    }
    if (actualPlayers.length >= 2) {
      joinedPlayer = actualPlayers[1] as Map<String, dynamic>;
    }

    final hostName = hostPlayer != null ? _getPlayerName(hostPlayer, 0) : 'Host';
    final hostAvatar = hostPlayer != null ? _getPlayerAvatar(hostPlayer) : null;

    final joinedName = joinedPlayer != null ? _getPlayerName(joinedPlayer, 1) : 'Waiting...';
    final joinedAvatar = joinedPlayer != null ? _getPlayerAvatar(joinedPlayer) : null;

    if (kDebugMode) {
      print('🎮 Player Display:');
      print('   Host: $hostName');
      print('   Joined: $joinedName');
    }

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
                avatarUrl: hostAvatar,
                playerName: hostName,
                isHost: true,
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
              _buildPlayerCard(
                avatarUrl: joinedAvatar,
                playerName: joinedName,
                isHost: false,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: actualPlayers.length >= 2
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: actualPlayers.length >= 2
                        ? Colors.green
                        : Colors.orange,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      actualPlayers.length >= 2
                          ? Icons.check_circle
                          : Icons.hourglass_empty,
                      size: 16.sp,
                      color: actualPlayers.length >= 2
                          ? Colors.green
                          : Colors.orange,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'Players: ${actualPlayers.length}/2',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: actualPlayers.length >= 2
                            ? Colors.green.shade700
                            : Colors.orange.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (actualPlayers.length < 2) ...[
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    'Waiting for 2nd player...',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStartGameButton() {
    final vsController = Get.find<ShowChallengersVsViewModel>();
    final strategyController = Get.find<StrategySelectionController>();

    return Obx(() {
      final response = vsController.challengers.value;
      final players = response.status == Status.completed
          ? (response.data as List<dynamic>)
          : [];

      // Count only actual players (not placeholders)
      final actualPlayers = players.where((p) {
        final player = p as Map<String, dynamic>;
        return player['isPlaceholder'] != true;
      }).toList();

      final int actualPlayerCount = actualPlayers.length;

      // ✅ SIMPLIFIED: Any player can start when there are 2 real players
      final bool canStart = actualPlayerCount == 2;

      String buttonText;
      if (actualPlayerCount < 2) {
        buttonText = 'Waiting for 2nd Player... ($actualPlayerCount/2)';
      } else {
        buttonText = 'Start Game';
      }

      if (kDebugMode) {
        print('🎮 Start Button State:');
        print('   Can Start: $canStart');
        print('   Actual Players: $actualPlayerCount');
      }

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
          color: canStart ? Color(0xffC43917) : Colors.grey,
          borderRadius: BorderRadius.circular(25),
          boxShadow: canStart
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
          onTap: canStart ? () => _startChallengeGame(vsController) : null,
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: getResponsiveFont(
                mobile: 14,
                tablet: 16,
                desktop: 18,
                largeDesktop: 20,
                ultraWide: 22,
              ),
              fontWeight: FontWeight.bold,
              fontFamily: 'Gotham-Bold',
            ),
          ),
        ),
      );
    });
  }

  Widget _buildWaitingForPlayers() {
    return Center(
      child: Column(
        children: [
          Icon(Icons.group_off, size: 48, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            "Waiting for players...",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  String _getPlayerName(Map<String, dynamic> player, int index) {
    final name = player['name']?.toString();
    if (name != null && name.isNotEmpty && name != 'null') return name;

    final userName = player['userName']?.toString();
    if (userName != null && userName.isNotEmpty && userName != 'null') return userName;

    final displayName = player['displayName']?.toString();
    if (displayName != null && displayName.isNotEmpty && displayName != 'null') return displayName;

    return 'Player ${index + 1}';
  }

  String? _getPlayerAvatar(Map<String, dynamic> player) {
    final avatarPicId = player['avatarPicId']?.toString();

    if (avatarPicId == null || avatarPicId.isEmpty || avatarPicId == 'null') {
      return null;
    }

    // If it's already a full URL (Google avatar)
    if (avatarPicId.startsWith('http')) {
      return avatarPicId;
    }

    // Otherwise, build the URL for uploaded avatar
    return '${ApiConstants.baseUrl}/uploads/$avatarPicId';
  }

  Widget _buildPlayerCard({
    String? avatarUrl,
    required String playerName,
    bool isHost = false,
  }) {
    return Flexible(
      flex: 1,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: 150.w,
            height: 180.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar Image
                ClipOval(
                  child: avatarUrl != null
                      ? Image.network(
                    avatarUrl,
                    width: 80.sp,
                    height: 80.sp,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildDefaultAvatar(playerName),
                  )
                      : _buildDefaultAvatar(playerName),
                ),
                SizedBox(height: 12.h),
                // Player Name Badge
                ArrowBubbleButton(level: playerName),
                if (isHost) ...[
                  SizedBox(height: 6.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Host',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(String playerName) {
    final initials = playerName.isNotEmpty ? playerName[0].toUpperCase() : '?';
    final color = _getAvatarColor(playerName);

    return Container(
      width: 80.sp,
      height: 80.sp,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color _getAvatarColor(String name) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.indigo,
    ];
    final index = name.isNotEmpty ? name.codeUnitAt(0) % colors.length : 0;
    return colors[index];
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
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                controller.selectedCardIndex.value == -1
                    ? 'assets/images/backcard_img.png'
                    : controller.strategyCardAssets[controller.selectedCardIndex.value],
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

  void _startChallengeGame(ShowChallengersVsViewModel vsController) async {
    print('🎯 Starting challenge game flow');

    try {
      await SharedPrefs.saveGameMode('challenge');
      print('✅ Saved game mode: challenge');

      if (challengeId != null) {
        await SharedPrefs.saveChallengeId(challengeId.toString());
        print('✅ Challenge ID confirmed: $challengeId');
      }

      Future.delayed(Duration.zero, () {
        Get.offAllNamed(AppRoutes.roleSelection);
      });
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