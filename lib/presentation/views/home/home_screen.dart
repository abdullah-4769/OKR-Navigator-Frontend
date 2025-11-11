import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/generated/assets.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:game_app/presentation/widgets/bubble_button.dart';
import 'package:get/get.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

import '../../../controllers/home_controller.dart';
import '../../../core/app_colors.dart';
import '../../../services/shared_preference.dart';
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
    _clearGameData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      c.resetPageController();
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

  @override
  void dispose() {
    _stackedCardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              _topBar(),
              SizedBox(height: 6.h),
              CustomBubbleButton(
                text: 'certificate'.tr,
                width: 90,
                height: 30,
                onTap: () => Get.toNamed(AppRoutes.certificationScreen),
              ),
              SizedBox(height: 8.h),
              _mainCardsSection(),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
                child: _dashboardButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
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
              _circleIcon(
                child: Icon(
                  Icons.notifications_outlined,
                  color: AppColors.primaryRed,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 8.w),
              _circleIcon(
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
    );
  }

  Widget _circleIcon({required Widget child}) {
    return Container(
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
  }

  Widget _mainCardsSection() {
    return Expanded(
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12.w, bottom: 60.h),
            child: Image.asset(
              'assets/images/robortarrow.png',
              height: 90.h,
              fit: BoxFit.contain,
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
      ),
    );
  }

  Widget _verticalDots() => Obx(
        () => Column(
      mainAxisAlignment: MainAxisAlignment.center,
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

  Widget _dashboardButton() => GestureDetector(
    onTap: () => Get.toNamed(AppRoutes.scoreboardScreen),
    child: Row(
      children: [
        Image.asset(
          'assets/images/arrow.png',
          height: 22.h,
          fit: BoxFit.contain,
        ),
        SizedBox(width: 6.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'go_to'.tr,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
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
      ],
    ),
  );
}

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
    final bg = Color(cardData['bg']);
    final bg2 = Color(cardData['bg2']);

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${cardData['titleTop'].toString().tr}\n',
                    style: TextStyle(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: cardData['titleBottom'].toString().tr,
                    style: TextStyle(
                      fontSize: 34.sp,
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
                fontSize: 13.sp,
                height: 1.4,
                color: Colors.white.withValues(alpha: 0.95),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              cardData['cta'].toString().tr,
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
    );
  }
}






