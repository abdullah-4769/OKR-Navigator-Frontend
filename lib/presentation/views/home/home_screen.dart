import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/generated/assets.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:game_app/presentation/widgets/bubble_button.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../controllers/home_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/api_constants.dart';
import '../../../data/repositories/storage_repository.dart';
import '../../../services/shared_preference.dart';
import '../../../view_model/bonus_controller/bonus_controller.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_svg.dart';
import '../authentication/profile_screen.dart';
import '../bonus_mode/bonus_mode.dart';
import '../notification/notification_screen.dart';
import '../roles/role_selection_screen.dart';
import '../team_mode/team_chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final HomeController c = Get.put(HomeController(), permanent: true);
  final StorageRepository _storageRepo = Get.find<StorageRepository>();
  final RxBool isBonusLoading = false.obs;
  final RxString userAvatarUrl = ''.obs;

  late AnimationController _topBarController;
  late AnimationController _certificateController;
  late AnimationController _cardsController;
  late AnimationController _dashboardController;
  late AnimationController _robotController;
  late AnimationController _blinkController;
  late AnimationController _notificationBlinkController;

  late Animation<Offset> _topBarSlideAnimation;
  late Animation<double> _topBarFadeAnimation;
  late Animation<double> _certificateScaleAnimation;
  late Animation<double> _certificateFadeAnimation;
  late Animation<Offset> _cardsSlideAnimation;
  late Animation<double> _cardsFadeAnimation;
  late Animation<Offset> _dashboardSlideAnimation;
  late Animation<double> _dashboardFadeAnimation;
  late Animation<double> _robotBounceAnimation;
  late Animation<double> _blinkAnimation;
  late Animation<double> _notificationBlinkAnimation;

  Color _getBadgeColor(String badge) {
    switch (badge.toLowerCase()) {
      case 'gold':
        return Colors.amber;
      case 'silver':
        return Colors.grey;
      case 'bronze':
        return Colors.brown;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  void initState() {
    super.initState();
    _clearGameData();
    _loadUserAvatar();
    _startListeningToAvatarChanges();

    _topBarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _certificateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _cardsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _dashboardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _robotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _notificationBlinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _topBarSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _topBarController,
            curve: Curves.easeOutCubic,
          ),
        );

    _topBarFadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _topBarController, curve: Curves.easeIn));

    _certificateScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _certificateController, curve: Curves.elasticOut),
    );

    _certificateFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _certificateController, curve: Curves.easeIn),
    );

    _cardsSlideAnimation =
        Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: _cardsController, curve: Curves.easeOutCubic),
        );

    _cardsFadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _cardsController, curve: Curves.easeIn));

    _dashboardSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _dashboardController,
            curve: Curves.easeOutCubic,
          ),
        );

    _dashboardFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _dashboardController, curve: Curves.easeIn),
    );

    _robotBounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _robotController, curve: Curves.bounceOut),
    );

    _blinkAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );

    _notificationBlinkAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _notificationBlinkController,
        curve: Curves.easeInOut,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      c.resetPageController();
      _startAnimations();
    });
  }

  void _startListeningToAvatarChanges() {
    GetStorage().listenKey('user-data', (value) {
      print('🎯 GetStorage user-data changed, reloading avatar...');
      _loadUserAvatar();
    });
  }

  void _startAnimations() {
    _topBarController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _certificateController.forward();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _cardsController.forward();
      _robotController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _dashboardController.forward();
    });
  }

  Future<void> _clearGameData() async {
    try {
      await SharedPrefs.clearGameSessionData();
      print('✅ Home screen: Cleared previous game data');
    } catch (e) {
      print('❌ Error clearing game data: $e');
    }
  }

  void _loadUserAvatar() {
    try {
      final prefs = GetStorage();
      final json = prefs.read('user-data');

      if (json != null) {
        Map<String, dynamic> userData;
        if (json is String) {
          userData = jsonDecode(json);
        } else if (json is Map) {
          userData = Map<String, dynamic>.from(json);
        } else {
          print('⚠️ Unexpected data type: ${json.runtimeType}');
          return;
        }

        final avatarId = userData['avatarPicId']?.toString();

        if (avatarId != null && avatarId.isNotEmpty) {
          if (avatarId.startsWith('http')) {
            userAvatarUrl.value = avatarId;
          } else if (avatarId.startsWith('assets/') || avatarId.startsWith('lib/')) {
            userAvatarUrl.value = avatarId;
            print('✅ Loaded local asset avatar: $avatarId');
            return;
          } else {
            userAvatarUrl.value = '${ApiConstants.baseUrl}/uploads/$avatarId';
          }
          print('✅ Loaded avatar: ${userAvatarUrl.value}');
        }
      }
    } catch (e) {
      print('❌ Error loading avatar: $e');
    }
  }

  ImageProvider _getImageProvider(String imagePath) {
    if (imagePath.startsWith('assets/') || imagePath.startsWith('lib/')) {
      return AssetImage(imagePath);
    } else if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath);
    } else {
      return NetworkImage('${ApiConstants.baseUrl}/uploads/$imagePath');
    }
  }

  @override
  void dispose() {
    _topBarController.dispose();
    _certificateController.dispose();
    _cardsController.dispose();
    _dashboardController.dispose();
    _robotController.dispose();
    _blinkController.dispose();
    _notificationBlinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
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
            SlideTransition(
              position: _topBarSlideAnimation,
              child: FadeTransition(
                opacity: _topBarFadeAnimation,
                child: _topBar(),
              ),
            ),
            SizedBox(height: 10.h),
            ScaleTransition(
              scale: _certificateScaleAnimation,
              child: FadeTransition(
                opacity: _certificateFadeAnimation,
                child: CustomBubbleButton(
                  text: 'certificate'.tr,
                  width: 110,
                  height: 30,
                  onTap: () => Get.toNamed(AppRoutes.certificationScreen),
                ),
              ),
            ),
            SizedBox(height: 8.h),
            Expanded(
              child: SlideTransition(
                position: _cardsSlideAnimation,
                child: FadeTransition(
                  opacity: _cardsFadeAnimation,
                  child: _mainCardsSectionContent(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
              child: SlideTransition(
                position: _dashboardSlideAnimation,
                child: FadeTransition(
                  opacity: _dashboardFadeAnimation,
                  child: _dashboardButton(),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _topBar() => Padding(
    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomSvg(
          assetPath: 'assets/images/okrnev.svg',
          semanticsLabel: 'okr'.tr,
          height: 45.h,
        ),
        Row(
          children: [
            AnimatedBuilder(
              animation: _notificationBlinkAnimation,
              builder: (context, child) => Transform.scale(
                scale: _notificationBlinkAnimation.value,
                child: _circleIcon(
                  child: Stack(
                    children: [
                      InkWell(
                        onTap: () async {
                          Get.to(const NotificationScreen());
                        },
                        child: Icon(
                          Icons.notifications_outlined,
                          color: AppColors.primaryRed,
                          size: 22.sp,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: FadeTransition(
                          opacity: _blinkAnimation,
                          child: Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              color: AppColors.primaryRed,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 1.5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            _circleIcon(
              child: InkWell(
                onTap: () {
                  Get.toNamed(
                    AppRoutes.language,
                    parameters: {'from': Get.currentRoute},
                  );
                },
                child: Icon(
                  Icons.language,
                  color: AppColors.primaryBlue,
                  size: 22.sp,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            InkWell(
              onTap: () {
                Get.to(ProfileScreen());
              },
              child: Obx(
                    () => _circleIcon(
                  child: ClipOval(
                    child: userAvatarUrl.value.isNotEmpty
                        ? Image(
                      image: _getImageProvider(userAvatarUrl.value),
                      fit: BoxFit.cover,
                      width: 46.sp,
                      height: 46.sp,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset("assets/images/solo_image.png");
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: AppColors.imageBackgroundColor,
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primaryRed,
                              ),
                            ),
                          ),
                        );
                      },
                    )
                        : Image.asset("assets/images/solo_image.png"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _circleIcon({required Widget child}) => Container(
    height: 46.sp,
    width: 46.sp,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: AppColors.primaryRed, width: 1.5),
      color: AppColors.imageBackgroundColor.withValues(alpha: 0.4),
    ),
    child: Center(child: child),
  );

  Widget _mainCardsSectionContent() => Obx(() {
    final selectedIndex = c.selectedCardIndex.value;
    final cardCount = c.cards.length;

    // Create list of cards sorted by z-index (bottom first, top last)
    final cardIndices = List.generate(cardCount, (i) => i);
    cardIndices.sort((a, b) {
      int posA = a - selectedIndex;
      int posB = b - selectedIndex;
      if (posA > 1.5) posA -= cardCount;
      if (posA < -1.5) posA += cardCount;
      if (posB > 1.5) posB -= cardCount;
      if (posB < -1.5) posB += cardCount;

      final zIndexA = (10 - posA.abs());
      final zIndexB = (10 - posB.abs());
      return zIndexA.compareTo(zIndexB);
    });

    return Stack(
      alignment: Alignment.center,
      children: [
        // Stacked cards - render by z-index order (lowest to highest)
        ...cardIndices.map((index) {
          // Calculate position exactly like HTML version
          int position = index - selectedIndex;
          if (position > 1.5) position -= cardCount;
          if (position < -1.5) position += cardCount;

          // Calculate all transforms
          final rotation = position * 15.0;
          final translateY = position * 120.0;
          final translateX = -position.abs() * 30.0;
          final scale = index == selectedIndex ? 1.0 : 0.85;
          final zIndex = (10 - position.abs()).toInt();
          final opacity = position.abs() > 1 ? 0.5 : 1.0;

          return _buildStackedCard(
            cardData: c.cards[index],
            position: position,
            index: index,
            isSelected: index == selectedIndex,
            rotation: rotation,
            translateX: translateX,
            translateY: translateY,
            scale: scale,
            opacity: opacity,
            zIndex: zIndex,
          );
        }).toList(),

        // Bonus mode button (fixed bottom right)
        Positioned(
          bottom: 16.h,
          right: 16.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/robortarrow.png',
                height: 70.h,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 8.h),
              InkWell(
                onTap: () async {
                  isBonusLoading.value = true;
                  try {
                    final controller = Get.put(BonusModeController());
                    Get.dialog(
                      const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryRed,
                        ),
                      ),
                      barrierDismissible: false,
                    );
                    await controller.checkPlayedToday();
                    Get.back();

                    if (controller.hasPlayedToday.value) {
                      Get.dialog(
                        AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          contentPadding: EdgeInsets.all(24.w),
                          title: Row(
                            children: [
                              Icon(
                                Icons.emoji_events,
                                color: Colors.amber,
                                size: 32.sp,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                'daily_bonus_complete'.tr,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'already_played_today'.tr,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20.h),
                              Container(
                                padding: EdgeInsets.all(20.w),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green.shade400,
                                      Colors.green.shade600,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'your_score_today'.tr,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Obx(
                                          () => Text(
                                        '${controller.evaluationScore.value}',
                                        style: TextStyle(
                                          fontSize: 48.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Obx(
                                          () => Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20.w,
                                          vertical: 8.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getBadgeColor(
                                            controller.badgeName.value,
                                          ),
                                          borderRadius:
                                          BorderRadius.circular(30.r),
                                        ),
                                        child: Text(
                                          controller.badgeName.value
                                              .toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                'come_back_tomorrow'.tr,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: Text(
                                'ok'.tr,
                                style: TextStyle(
                                  color: AppColors.primaryRed,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        barrierDismissible: true,
                      );
                      return;
                    }

                    await SharedPrefs.saveGameMode("bonus");
                    await SharedPrefs.clearGameSessionData();
                    Get.toNamed(
                      AppRoutes.roleSelection,
                      arguments: {"fromBonus": true},
                    );
                  } catch (e) {
                    Get.back();
                    Get.snackbar(
                      'error'.tr,
                      '${'failed_start_bonus'.tr}$e',
                    );
                  } finally {
                    isBonusLoading.value = false;
                  }
                },
                child: Obx(
                      () => Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD700).withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: isBonusLoading.value
                        ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    )
                        : Text(
                      "bonus_mode".tr,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  });

  Widget _buildStackedCard({
    required Map<String, dynamic> cardData,
    required int position,
    required int index,
    required bool isSelected,
    required double rotation,
    required double translateX,
    required double translateY,
    required double scale,
    required double opacity,
    required int zIndex,
  }) {
    final bg = Color(cardData['bg']);
    final bg2 = Color(cardData['bg2']);

    return Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: Center(
          child: GestureDetector(
            onTap: () {
              if (!isSelected) {
                c.selectedCardIndex.value = index;
              } else {
                c.onTapCTA();
              }
            },
            child: AnimatedTransform(
              rotation: rotation,
              translateX: translateX,
              translateY: translateY,
              scale: scale,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: 280.w,
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
                        color: Colors.black.withValues(
                          alpha: isSelected ? 0.25 : 0.15,
                        ),
                        blurRadius: isSelected ? 20 : 12,
                        offset: Offset(0, isSelected ? 8 : 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${cardData['titleTop'].toString().tr}\n',
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: cardData['titleBottom'].toString().tr,
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.black.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        cardData['subtitle'].toString().tr,
                        style: TextStyle(
                          fontSize: 12.sp,
                          height: 1.4,
                          color: Colors.white.withValues(alpha: 0.95),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        cardData['cta'].toString().tr,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
        );
    }

  Widget _dashboardButton() => GestureDetector(
    onTap: () => Get.toNamed(AppRoutes.scoreboardScreen),
    child: Row(
      children: [
        SizedBox(width: 6.w),
        FadeTransition(
          opacity: _blinkAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap:(){
                      Get.to(TeamChatScreen());
                       },
                    child: Text(
                      'go_to'.tr,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  FadeTransition(
                    opacity: _blinkAnimation,
                    child: Image.asset(
                      'assets/images/arrow.png',
                      height: 22.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              Text(
                'dashboard'.tr,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                  decoration: TextDecoration.underline,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Custom animated transform widget
class AnimatedTransform extends StatefulWidget {
  final Widget child;
  final double rotation;
  final double translateX;
  final double translateY;
  final double scale;
  final Duration duration;
  final Curve curve;

  const AnimatedTransform({
    required this.child,
    required this.rotation,
    required this.translateX,
    required this.translateY,
    required this.scale,
    required this.duration,
    required this.curve,
    super.key,
  });

  @override
  State<AnimatedTransform> createState() => _AnimatedTransformState();
}

class _AnimatedTransformState extends State<AnimatedTransform>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _translateXAnimation;
  late Animation<double> _translateYAnimation;
  late Animation<double> _scaleAnimation;

  double _previousRotation = 0;
  double _previousTranslateX = 0;
  double _previousTranslateY = 0;
  double _previousScale = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _setupAnimations();
    _controller.forward();
  }

  void _setupAnimations() {
    _rotationAnimation = Tween<double>(
      begin: _previousRotation,
      end: widget.rotation,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _translateXAnimation = Tween<double>(
      begin: _previousTranslateX,
      end: widget.translateX,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _translateYAnimation = Tween<double>(
      begin: _previousTranslateY,
      end: widget.translateY,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _scaleAnimation = Tween<double>(
      begin: _previousScale,
      end: widget.scale,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
  }

  @override
  void didUpdateWidget(AnimatedTransform oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.rotation != widget.rotation ||
        oldWidget.translateX != widget.translateX ||
        oldWidget.translateY != widget.translateY ||
        oldWidget.scale != widget.scale) {
      _previousRotation = oldWidget.rotation;
      _previousTranslateX = oldWidget.translateX;
      _previousTranslateY = oldWidget.translateY;
      _previousScale = oldWidget.scale;

      _controller.reset();
      _setupAnimations();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _rotationAnimation,
        _translateXAnimation,
        _translateYAnimation,
        _scaleAnimation,
      ]),
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translate(_translateXAnimation.value, _translateYAnimation.value)
            ..rotateZ(_rotationAnimation.value * 3.14159 / 180)
            ..scale(_scaleAnimation.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}