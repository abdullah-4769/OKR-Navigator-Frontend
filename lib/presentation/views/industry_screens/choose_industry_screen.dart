import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/choose_industry_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';

import '../../routes/app_routes.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_curved_arrow.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_svg.dart';
import '../../widgets/custom_industry_container.dart';

class ChooseIndustryScreen extends StatelessWidget {
  final Map<String, dynamic>? selectedRole;

  ChooseIndustryScreen({super.key, this.selectedRole});

  final ChooseIndustryController controller = Get.put(
    ChooseIndustryController(),
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => Stack(
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
                                      Get.offAllNamed(AppRoutes.roleSelection),
                                  width: screenWidth * 0.14,
                                  height: screenHeight * 0.18,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    SizedBox(height: screenHeight * 0.01),
                                    RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'choose'.tr,
                                            style: TextStyle(
                                              fontFamily: 'Gotham-Bold',
                                              fontSize: (screenWidth * 0.09).sp,
                                              color: AppColors.primaryRed,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '\n${'your_industry'.tr}',
                                            style: TextStyle(
                                              fontFamily: 'Gotham-Bold',
                                              fontSize: (screenWidth * 0.06).sp,
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
                                  radius: screenWidth * 0.06,
                                  backgroundColor: AppColors.white,
                                  child: Padding(
                                    padding: EdgeInsets.all(2.r),
                                    child: CustomSvg(
                                      assetPath: 'assets/images/solo.svg',
                                      semanticsLabel: 'profile',
                                      height: screenWidth * 0.12,
                                      width: screenWidth * 0.12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.0001),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.06,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'welcome_role'
                                    .trParams({'role': selectedRole?['title'] ?? 'Navigator'}),
                                style: TextStyle(
                                  fontFamily: 'Gotham-Bold',
                                  fontSize: (screenWidth * 0.05).sp,
                                  color: AppColors.primaryRed,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                'entered_company_crisis'.tr,
                                style: TextStyle(
                                  fontSize: (screenWidth * 0.036).sp,
                                  color: AppColors.textSecondary,
                                  fontFamily: 'Gotham',
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.025),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.06,
                          ),
                          child: Obx(
                                () => Column(
                              children: List.generate(
                                controller.industries.length,
                                    (index) {
                                  final industry = controller.industries[index];
                                  return CustomIndustryContainer(
                                    title: industry['title']?.tr,
                                    description: industry['description']?.tr,
                                    icon: industry['icon'],
                                    isSelected:
                                    controller.selectedIndex.value == index,
                                    onTap: () =>
                                        controller.selectIndustry(index),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.1,
                          ),
                          child: Column(
                            children: [
                              CustomButton2(
                                text: 'select_continue'.tr,
                                onPressed: () => controller
                                    .continueWithSelection(selectedRole),
                              ),
                              SizedBox(height: screenHeight * 0.015),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'first_time_playing'.tr,
                                    style: TextStyle(
                                      fontSize: (screenWidth * 0.036).sp,
                                      color: Colors.black,
                                      fontFamily: 'Gotham',
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: controller.openTutorial,
                                    child: Text(
                                      'watch_tutorial_video'.tr,
                                      style: TextStyle(
                                        fontSize: (screenWidth * 0.036).sp,
                                        color: AppColors.primaryRed,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Gotham',
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.025),
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
      ),
    );
  }
}
