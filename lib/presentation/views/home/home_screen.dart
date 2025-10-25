import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/generated/assets.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:game_app/presentation/widgets/bubble_button.dart';
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. TOP HEADER SECTION (LOGO + PROFILE)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.d16.w, vertical: AppDimensions.d12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomSvg(
                      assetPath: 'assets/images/okrnev.svg',
                      semanticsLabel: 'OKR',
                      height: 40.h,
                    ),
                    Row(
                      children: [
                        // Certification Button (small circle badge)
                        Container(
                          height: 49.sp,
                          width: 49.sp,
                          margin: EdgeInsets.only(right: 10.w),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primaryRed),
                            color: AppColors.softRed.withOpacity(0.4),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              Assets.imagesCertificateImage,
                              fit: BoxFit.cover,
                              scale: 1.8,
                            ),
                          ),
                        ),
                        // User Avatar (Rightmost)
                        Container(
                          height: 49.sp,
                          width: 49.sp,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primaryRed),
                            color: AppColors.imageBackgroundColor.withOpacity(0.4),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQPfO37MK81JIyR1ptwqr_vYO3w4VR-iC2wqQ&s",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Certificate Bubble Button
              Center(
                child: CustomBubbleButton(
                  text: 'Certificate',
                  width: 100,
                  height: 35,
                  onTap: () {},
                ),
              ),

              SizedBox(height: AppDimensions.d18.h),

              // 2. MAIN CAROUSEL AREA
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.55, // Set height high enough for cards to fit
                      child: PageView.builder(
                        controller: c.pageController,
                        scrollDirection: Axis.horizontal, // ✅ Horizontal scroll
                        physics: const BouncingScrollPhysics(),
                        itemCount: c.cards.length,
                        onPageChanged: c.onPageChanged, // ✅ FIX: Added onPageChanged
                        itemBuilder: (context, index) {
                          // Dynamic scaling logic
                          final num page = c.pageController.hasClients ? (c.pageController.page ?? index) : index.toDouble();
                          final double scale = 1.0 - (page - index).abs() * 0.15; // Scale center card up

                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Transform.scale(
                              scale: scale.clamp(0.85, 1.0), // Scale range
                              alignment: Alignment.center,
                              child: _buildCard(index, context),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: AppDimensions.d16.h),

                    // 3. INDICATOR DOTS
                    _horizontalDots(),

                    SizedBox(height: AppDimensions.d24.h),
                  ],
                ),
              ),

              // 4. BOTTOM DASHBOARD BUTTON
              Padding(
                padding: EdgeInsets.only(left: AppDimensions.d24.w, bottom: AppDimensions.d16.h),
                child: _dashboardButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== Widgets =====

  Widget _horizontalDots() => Obx(
    () => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(c.cards.length, (index) {
        final active = c.selectedCardIndex.value == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: active ? 16.w : 6.w,
          height: 6.w,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: active ? AppColors.primaryRed : Colors.black26,
            borderRadius: BorderRadius.circular(3.r),
          ),
        );
      }),
    ),
  );

  Widget _buildCard(int index, BuildContext context) {
    final m = c.cards[index];
    final bg = Color(m['bg'] as int);
    final bg2 = Color(m['bg2'] as int);
    final theme = Theme.of(context);

    // Dynamic style based on card index to match the image colors
    Color topTitleColor = Colors.white;
    Color bottomTitleColor = Colors.black.withOpacity(0.6);
    Color ctaColor = Colors.white;
    String bonusText = index == 2 ? 'Bonus mode'.tr : ''; // Added bonus mode label

    if (index == 0) { // Red Card
      // Styles are mostly good (default white/black)
    } else if (index == 1) { // Green/Blue Card
      topTitleColor = AppColors.textPrimary;
      bottomTitleColor = Colors.white;
      ctaColor = AppColors.textPrimary;
    } else if (index == 2) { // Dark Blue Card
      topTitleColor = Colors.white;
      bottomTitleColor = AppColors.primaryRed;
      ctaColor = Colors.white;
    }

    return GestureDetector(
      onTap: c.onTapCTA,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 0.75.sw,
            height: 0.4.sh, // Set a consistent height relative to screen height
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Title
                Text(
                  (m['titleTop'] ?? '').toString().tr,
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 32.sp,
                    color: topTitleColor,
                  ),
                ),
                // Bottom Title
                Text(
                  (m['titleBottom'] ?? '').toString().tr,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontSize: 28.sp,
                    color: bottomTitleColor,
                  ),
                ),
                SizedBox(height: 10.h),
                // Subtitle
                Text(
                  (m['subtitle'] ?? '').toString().tr,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 13.sp,
                    height: 1.35,
                    color: ctaColor,
                  ),
                ),
                const Spacer(),
                // CTA Text
                Text(
                  (m['cta'] ?? '').toString().tr,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    color: ctaColor,
                  ),
                ),
              ],
            ),
          ),
          // Bonus Mode Label (Only for Scoreboard card)
          if (bonusText.isNotEmpty)
            Positioned(
              top: -15.h,
              left: 10.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryRed,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  bonusText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _dashboardButton(BuildContext context) => GestureDetector(
    onTap: () => Get.toNamed(AppRoutes.personalDashboardScreen),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'go_to'.tr,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'dashboard'.tr,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 15.sp,
            fontWeight: FontWeight.w800,
            decoration: TextDecoration.underline,
            color: Colors.black87,
          ),
        ),
      ],
    ),
  );
}