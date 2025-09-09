import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/home_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';

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
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.d8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppDimensions.d26.h),

                    // LOGO
                    CustomSvg(
                      assetPath: 'assets/images/okrnev.svg',
                      semanticsLabel: 'OKR',
                      height: 50.h,
                    ),

                    SizedBox(height: AppDimensions.d40.h),

                    // Bonus + Certification
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: -70.w,
                              top: -40.h,
                              child: CustomSvg(
                                assetPath: 'assets/images/robot.svg',
                                height: 64.h,
                                width: 58.w,
                                semanticsLabel: 'robot',
                              ),
                            ),
                            const SizedBox(height: 48),
                            _underlineText('bonus_mode'.tr),
                          ],
                        ),
                        SizedBox(width: 22.w),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            _chip('certification'.tr),
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
                                  itemBuilder: (context, index) =>
                                      AnimatedBuilder(
                                        animation: c.pageController,
                                        builder: (context, child) {
                                          final double page =
                                          c.pageController.hasClients
                                              ? (c.pageController.page ?? 0.0)
                                              : 0.0;
                                          final delta = (index - page);
                                          final translateX = delta * -40.w;
                                          final rotate = delta * -0.09;
                                          final scale =
                                          (1 - (delta.abs() * 0.1)).clamp(
                                            0.9,
                                            1.0,
                                          );

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
                                      ),
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
  Widget _underlineText(String text) => Text(
    text,
    style: TextStyle(
      fontSize: AppDimensions.d14.sp,
      color: Colors.grey.shade700,
      fontWeight: FontWeight.w700,
      fontFamily: 'Gotham',
      decoration: TextDecoration.underline,
    ),
  );

  Widget _chip(String text) => Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.7),
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

  Widget _verticalDots() => Obx(
        () => SizedBox(
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
    ),
  );

  Widget _card(int index) {
    final m = c.cards[index];
    final bg = Color(m['bg'] as int);
    final bg2 = Color(m['bg2'] as int);

    return GestureDetector(
      onTap: c.onTapCTA,
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
                color: Colors.black.withValues(alpha: 0.20),
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

  Widget _cardBody(Map<String, dynamic> m) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '${m['titleTop']?.tr}\n',
              style: TextStyle(
                fontSize: 32.sp,
                height: 1.0,
                fontWeight: FontWeight.w900,
                fontFamily: 'Gotham',
                color: Colors.white,
              ),
            ),
            TextSpan(
              text: m['titleBottom']?.tr,
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.w800,
                fontFamily: 'Gotham',
                color: Colors.black.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 10.h),
      Text(
        m['subtitle']?.tr,
        style: TextStyle(
          fontSize: 13.sp,
          height: 1.35,
          color: Colors.white,
          fontFamily: 'Gotham',
        ),
      ),
      const Spacer(),
      Text(
        m['cta']?.tr,
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

  Widget _dashboardButton() => GestureDetector(
    onTap: () => Get.toNamed('/dashboard'),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'go_to'.tr,
          style: TextStyle(
            fontSize: 15.sp,
            color: Colors.black87,
            fontFamily: 'Gotham',
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'dashboard'.tr,
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
