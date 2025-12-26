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
import '../../../view_model/bonus_controller/bonus_controller.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_svg.dart';
import '../authentication/profile_screen.dart';
import '../bonus_mode/bonus_mode.dart';
import '../notification/notification_screen.dart';
import '../roles/role_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final HomeController c = Get.put(HomeController(), permanent: true);
  final PageController _stackedCardController = PageController();
  final StorageRepository _storageRepo = Get.find<StorageRepository>();
  final RxBool isBonusLoading = false.obs;

  // User avatar URL - RxString for reactive updates
  final RxString userAvatarUrl = ''.obs;

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
    _startListeningToAvatarChanges(); // ✅ Listen for avatar changes

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
    _topBarSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _topBarController,
            curve: Curves.easeOutCubic,
          ),
        );

    _topBarFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _topBarController, curve: Curves.easeIn));

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

    _cardsFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _cardsController, curve: Curves.easeIn));

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

    // Blink animation (opacity fade in and out)
    _blinkAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );

    // Notification blink animation (scale pulse)
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

  /// ✅ Listen to GetStorage changes
  void _startListeningToAvatarChanges() {
    GetStorage().listenKey('user-data', (value) {
      print('🎯 GetStorage user-data changed, reloading avatar...');
      _loadUserAvatar();
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

  /// ✅ Updated to use RxString for reactive updates
  void _loadUserAvatar() {
    try {
      // Get user data from storage (works for both email and Google login)
      final prefs = GetStorage();
      final json = prefs.read('user-data');

      if (json != null) {
        Map<String, dynamic> userData;

        // Handle both Map and String formats
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
          // Check if it's already a full URL (Google) or just an ID/asset (local)
          if (avatarId.startsWith('http')) {
            userAvatarUrl.value = avatarId; // Google avatar URL
          } else if (avatarId.startsWith('assets/') || avatarId.startsWith('lib/')) {
            // Local asset - store as is
            userAvatarUrl.value = avatarId;
            print('✅ Loaded local asset avatar: $avatarId');
            return;
          } else {
            // Server upload - construct full URL
            userAvatarUrl.value = '${ApiConstants.baseUrl}/uploads/$avatarId';
          }
          print('✅ Loaded avatar: ${userAvatarUrl.value}');
        }
      }
    } catch (e) {
      print('❌ Error loading avatar: $e');
    }
  }

  /// ✅ Helper to get image provider
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
        // Left side: Logo
        CustomSvg(
          assetPath: 'assets/images/okrnev.svg',
          semanticsLabel: 'okr'.tr,
          height: 45.h,
        ),

        // Right side: Icons row
        Row(
          children: [
            // 1. Notification icon with blink
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
                      // Red dot blink
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

            // 2. Language button
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

            // 3. Profile avatar - ✅ REACTIVE
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

  Widget _mainCardsSectionContent() => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Robot arrow with bounce and blink animation
      Center(
        child: Padding(
          padding: EdgeInsets.only(left: 12.w),
          child: AnimatedBuilder(
            animation: Listenable.merge([
              _robotBounceAnimation,
              _blinkAnimation,
            ]),
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
                        isBonusLoading.value = true;

                        try {
                          final controller = Get.put(BonusModeController());

                          // Show a loading dialog/snackbar while checking
                          Get.dialog(
                            const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryRed,
                              ),
                            ),
                            barrierDismissible: false,
                          );

                          // Always check latest status from server
                          await controller.checkPlayedToday();

                          // Close loading dialog
                          Get.back(); // closes the dialog

                          if (controller.hasPlayedToday.value) {
                            // Show dialog with today's score
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
                                        borderRadius: BorderRadius.circular(
                                          20.r,
                                        ),
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

                          // First time today — start bonus mode
                          await SharedPrefs.saveGameMode("bonus");
                          await SharedPrefs.clearGameSessionData();
                          Get.toNamed(
                            AppRoutes.roleSelection,
                            arguments: {"fromBonus": true},
                          );
                        } catch (e) {
                          Get.back(); // close any loading dialog if open
                          Get.snackbar(
                            'error'.tr,
                            '${'failed_start_bonus'.tr}$e',
                          );
                        } finally {
                          // Always stop loading
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
                              fontSize: 14.sp,
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
            ),
          ),
        ),
      ),
      Expanded(
        child: Obx(() {
          final selectedIndex = c.selectedCardIndex.value;
          return StackedCardCarousel(
            initialOffset: 20,
            spaceBetweenItems: 300,
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
        padding: EdgeInsets.only(right: 4.w),
        child: _verticalDots(),
      ),
    ],
  );

  Widget _verticalDots() => Obx(
        () => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(c.cards.length, (index) {
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
      }),
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

class _CardItemState extends State<_CardItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
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
                color: Colors.black.withValues(
                  alpha: widget.isCenter ? 0.25 : 0.15,
                ),
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
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: widget.cardData['titleBottom'].toString().tr,
                      style: TextStyle(
                        fontSize: 27.sp,
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