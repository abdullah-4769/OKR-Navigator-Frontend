import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/role_selection_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_curved_arrow.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_svg.dart';

class RoleSelectionScreen extends StatelessWidget {
  RoleSelectionScreen({super.key});

  final RoleSelectionController controller = Get.put(RoleSelectionController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.backgroundTop,
                      AppColors.backgroundBottom,
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(bottom: AppDimensions.d90.h),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.d0.w,
                          vertical: AppDimensions.d12.h,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: CustomCurvedArrow(
                                isLeft: true,
                                onTap: () =>
                                    Get.offAllNamed(AppRoutes.pricingScreen),
                                width: AppDimensions.d55.w,
                                height: AppDimensions.d130.h,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(height: AppDimensions.d2.h),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'select'.tr,
                                          style: TextStyle(
                                            fontFamily: 'Gotham-Bold',
                                            fontSize: (screenWidth * 0.12).sp,
                                            color: AppColors.primaryRed,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '\nrole'.tr,
                                          style: TextStyle(
                                            fontFamily: 'Gotham-Bold',
                                            fontSize: (screenWidth * 0.07).sp,
                                            color: AppColors.primaryBlue,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: CircleAvatar(
                                radius: AppDimensions.d22.r,
                                backgroundColor: AppColors.white,
                                child: Padding(
                                  padding: EdgeInsets.all(2.r),
                                  child: CustomSvg(
                                    assetPath:
                                    'assets/images/persondashboard.svg',
                                    semanticsLabel: 'profile'.tr,
                                    height: AppDimensions.d60.h,
                                    width: AppDimensions.d60.w,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.d20.w,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'welcome_navigator'.tr,
                              style: TextStyle(
                                fontFamily: 'Gotham-Bold',
                                fontSize: (screenWidth * 0.05).sp,
                                color: AppColors.primaryRed,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: AppDimensions.d8.h),
                            Text(
                              'company_crisis_description'.tr,
                              style: TextStyle(
                                fontSize: (screenWidth * 0.04).sp,
                                color: AppColors.textSecondary,
                                fontFamily: 'Gotham',
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppDimensions.d10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.d24.w,
                        ),
                        child: Align(
                          child: Text(
                            'choose_role_instruction'.tr,
                            style: TextStyle(
                              fontSize: (screenWidth * 0.05).sp,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Gotham',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(height: AppDimensions.d14.h),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.d24.w,
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            int crossAxisCount = 2;
                            if (constraints.maxWidth > 1200) {
                              crossAxisCount = 4;
                            } else if (constraints.maxWidth > 800) {
                              crossAxisCount = 3;
                            }
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.roles.length,
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: AppDimensions.d20.w,
                                mainAxisSpacing: AppDimensions.d20.h,
                                childAspectRatio: 0.80,
                              ),
                              itemBuilder: (context, index) {
                                final role = controller.roles[index];
                                return _RoleCard(
                                  index: index,
                                  role: role,
                                  controller: controller,
                                );
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(height: AppDimensions.d20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.d40.w,
                        ),
                        child: Column(
                          children: [
                            CustomButton2(
                              text: 'select_continue'.tr,
                              onPressed: controller.continueWithSelection,
                            ),
                            SizedBox(height: AppDimensions.d12.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'first_time_playing'.tr,
                                  style: TextStyle(
                                    fontSize: (screenWidth * 0.035).sp,
                                    color: Colors.black,
                                    fontFamily: 'Gotham',
                                  ),
                                ),
                                GestureDetector(
                                  onTap: controller.openTutorial,
                                  child: Text(
                                    'watch_tutorial'.tr,
                                    style: TextStyle(
                                      fontSize: (screenWidth * 0.035).sp,
                                      color: AppColors.primaryRed,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Gotham',
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppDimensions.d18.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: screenWidth * -0.07000001,
              top: screenHeight * 0.50,
              child: const CustomHomeNavBar(),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final int index;
  final Map<String, dynamic> role;
  final RoleSelectionController controller;

  const _RoleCard({
    required this.index,
    required this.role,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Obx(() {
      final selected = controller.selectedIndex.value == index;
      return GestureDetector(
        onTap: () => controller.selectRole(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          padding: EdgeInsets.all(AppDimensions.d12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppDimensions.d16.r),
            border: Border.all(
              color: selected
                  ? AppColors.primaryRed
                  : AppColors.grey.withValues(alpha: 0.2),
              width: selected ? 2.2 : 1,
            ),
            boxShadow: selected
                ? [
              BoxShadow(
                color: AppColors.primaryRed.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ]
                : [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(AppDimensions.d8.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected
                          ? AppColors.primaryRed.withValues(alpha: 0.06)
                          : Colors.grey.shade50,
                    ),
                    child: Center(
                      child: CustomSvg(
                        assetPath: role['asset'],
                        semanticsLabel: role['title'].tr,
                        width: screenWidth * 0.18,
                        height: screenWidth * 0.16,
                      ),
                    ),
                  ),
                  SizedBox(height: AppDimensions.d12.h),
                  Center(
                    child: Text(
                      role['title'].tr,
                      style: TextStyle(
                        fontSize: (screenWidth * 0.045).sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryRed,
                        fontFamily: 'Gotham',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: AppDimensions.d4.h),
                  Center(
                    child: Text(
                      role['subtitle'].tr,
                      style: TextStyle(
                        fontSize: (screenWidth * 0.035).sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Gotham',
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (role['extra'] != null && role['extra'].toString().isNotEmpty)
                    Center(
                      child: Text(
                        role['extra'].tr,
                        style: TextStyle(
                          fontSize: (screenWidth * 0.03).sp,
                          color: AppColors.grey,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gotham',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: EdgeInsets.all(AppDimensions.d6.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: role['iconBg'],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 4,
                        offset: const Offset(1, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    role['icon'],
                    color: Colors.white,
                    size: (screenWidth * 0.04).sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
