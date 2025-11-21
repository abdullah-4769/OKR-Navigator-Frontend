import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/generated/assets.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:game_app/presentation/widgets/bubble_button.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

import '../../../controllers/home_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/api_constants.dart';
import '../../../data/repositories/storage_repository.dart';
import '../../../services/shared_preference.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_svg.dart';
import '../authentication/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final HomeController c = Get.put(HomeController(), permanent: true);
  final PageController _stackedCardController = PageController();
  final StorageRepository _storageRepo = Get.find<StorageRepository>();

  // User avatar URL
  String? userAvatarUrl;

  // Animation controllers
  late AnimationController _topBarController;
  late AnimationController _certificateController;
  late AnimationController _cardsController;
  late AnimationController _dashboardController;
  late AnimationController _robotController;
  late AnimationController _blinkController;
  late AnimationController _notificationBlinkController;

  // Animations
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

  @override
  void initState() {
    super.initState();
    _clearGameData();
    _loadUserAvatar();

    // Initialize animation controllers
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

    // Blink animation controller (repeating)
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Notification blink controller (repeating)
    _notificationBlinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    // Initialize animations
    _topBarSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _topBarController,
      curve: Curves.easeOutCubic,
    ));

    _topBarFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _topBarController,
      curve: Curves.easeIn,
    ));

    _certificateScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _certificateController,
      curve: Curves.elasticOut,
    ));

    _certificateFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _certificateController,
      curve: Curves.easeIn,
    ));

    _cardsSlideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _cardsController,
      curve: Curves.easeOutCubic,
    ));

    _cardsFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardsController,
      curve: Curves.easeIn,
    ));

    _dashboardSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _dashboardController,
      curve: Curves.easeOutCubic,
    ));

    _dashboardFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _dashboardController,
      curve: Curves.easeIn,
    ));

    _robotBounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _robotController,
      curve: Curves.bounceOut,
    ));

    // Blink animation (opacity fade in and out)
    _blinkAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _blinkController,
      curve: Curves.easeInOut,
    ));

    // Notification blink animation (scale pulse)
    _notificationBlinkAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _notificationBlinkController,
      curve: Curves.easeInOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      c.resetPageController();
      _startAnimations();
    });
  }

  void _startAnimations() {
    // Stagger the animations
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
      // Get user data from storage (works for both email and Google login)
      final prefs = GetStorage();
      final json = prefs.read('user-data');

      if (json != null) {
        final userData = jsonDecode(json);
        final avatarId = userData['avatarPicId']?.toString();

        if (avatarId != null && avatarId.isNotEmpty) {
          setState(() {
            // Check if it's already a full URL (Google) or just an ID (local)
            if (avatarId.startsWith('http')) {
              userAvatarUrl = avatarId; // Google avatar URL
            } else {
              userAvatarUrl = '${ApiConstants.baseUrl}/uploads/$avatarId'; // Local avatar
            }
          });
          print('✅ Loaded avatar: $userAvatarUrl');
        }
      }
    } catch (e) {
      print('❌ Error loading avatar: $e');
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
    _stackedCardController.dispose();
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
            SizedBox(height: 6.h),
            ScaleTransition(
              scale: _certificateScaleAnimation,
              child: FadeTransition(
                opacity: _certificateFadeAnimation,
                child: CustomBubbleButton(
                  text: 'certificate'.tr,
                  width: 90,
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
            // Notification with blink animation
            AnimatedBuilder(
              animation: _notificationBlinkAnimation,
              builder: (context, child) => Transform.scale(
                scale: _notificationBlinkAnimation.value,
                child: _circleIcon(
                  child: Stack(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        color: AppColors.primaryRed,
                        size: 22.sp,
                      ),
                      // Red dot indicator with opacity blink
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
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            // UPDATED: Dynamic profile avatar
            InkWell(
              onTap: () {
                Get.to(ProfileScreen());
              },
              child: _circleIcon(
                child: ClipOval(
                  child: userAvatarUrl != null && userAvatarUrl!.isNotEmpty
                      ? Image.network(
                    userAvatarUrl!,
                    fit: BoxFit.cover,
                    width: 46.sp,
                    height: 46.sp,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/images/solo_image.png",
                        fit: BoxFit.cover,
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: AppColors.imageBackgroundColor,
                        child: Center(
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
                      : Image.asset(
                    "assets/images/solo_image.png",
                    fit: BoxFit.cover,
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
      border: Border.all(
        color: AppColors.primaryRed,
        width: 1.5,
      ),
      color: AppColors.imageBackgroundColor.withValues(alpha: 0.4),
    ),
    child: Center(child: child),
  );

  Widget _mainCardsSectionContent() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // Robot arrow with bounce and blink animation
      Center(
        child: Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: AnimatedBuilder(
            animation: Listenable.merge([_robotBounceAnimation, _blinkAnimation]),
            builder: (context, child) => Transform.translate(
              offset: Offset(0, -10 * _robotBounceAnimation.value),
              child: Opacity(
                opacity: _blinkAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/robortarrow.png',
                      height: 90.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 8.h),
                    InkWell(
                      onTap: () async {
                        // Clear previous session data
                        await SharedPrefs.clearGameSessionData();

                        // Set bonus mode
                        await SharedPrefs.saveGameMode("bonus");
                        print("BONUS MODE ACTIVATED");

                        // Show bonus mode dialog
                        Get.dialog(
                          Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(24.w),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFFD700),
                                    Color(0xFFFFA500),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'bonus_mode_title'.tr,
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'GothamBold',
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    'bonus_mode_description'.tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.white,
                                      fontFamily: 'Gotham',
                                    ),
                                  ),
                                  SizedBox(height: 24.h),
                                  CustomButton2(
                                    text: 'start_bonus_mode'.tr,
                                    onPressed: () {
                                      Get.back();
                                      Get.toNamed(
                                        AppRoutes.roleSelection,
                                        arguments: {"fromBonus": true},
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          barrierDismissible: false,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFFD700).withOpacity(0.4),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "bonus_mode_label".tr,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'GothamBold',
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      Expanded(
        child: Obx(() {
          final selectedIndex = c.selectedCardIndex.value;
          return StackedCardCarousel(
            initialOffset: 20,
            spaceBetweenItems: 320,
            pageController: _stackedCardController,
            items: List.generate(
              c.cards.length,
                  (index) => _CardItem(
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
              ),
            ),
            onPageChanged: (index) {
              c.selectedCardIndex.value = index;
            },
          );
        }),
      ),
      Padding(
        padding: EdgeInsets.only(right: 14.w),
        child: _verticalDots(),
      )
    ],
  );

  Widget _verticalDots() => Obx(
        () => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        c.cards.length,
            (index) {
          final active = c.selectedCardIndex.value == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: active ? 10.w : 8.w,
            height: active ? 10.w : 8.w,
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
                  Text(
                    'go_to'.tr,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
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

class _CardItem extends StatefulWidget {
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
  State<_CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<_CardItem> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = Color(widget.cardData['bg']);
    final bg2 = Color(widget.cardData['bg2']);

    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
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
                color: Colors.black.withValues(alpha: widget.isCenter ? 0.25 : 0.15),
                blurRadius: widget.isCenter ? 20 : 12,
                offset: Offset(0, widget.isCenter ? 8 : 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${widget.cardData['titleTop'].toString().tr}\n',
                      style: TextStyle(
                        fontSize: 34.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: widget.cardData['titleBottom'].toString().tr,
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                widget.cardData['subtitle'].toString().tr,
                style: TextStyle(
                  fontSize: 13.sp,
                  height: 1.4,
                  color: Colors.white.withValues(alpha: 0.95),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                widget.cardData['cta'].toString().tr,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.underline,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}