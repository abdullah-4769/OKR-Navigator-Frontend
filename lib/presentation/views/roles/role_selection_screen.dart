import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/widgets/screens_unique_parts/custom_background.dart';
import 'package:get/get.dart';

import '../../../controllers/role_selection_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_svg.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

// ✅ Global trKey
String trKey(Object? key) => key != null ? key.toString().tr : '';

class RoleSelectionScreen extends StatelessWidget {
  RoleSelectionScreen({super.key});

  final RoleSelectionController controller = Get.put(RoleSelectionController());

  @override
  Widget build(BuildContext context) => OrientationBuilder(
    builder: (context, orientation) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;

      return Scaffold(
        backgroundColor: Colors.white,
        body: CustomBackground(
          child: Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(top: 0, bottom: AppDimensions.d10.h),
                    child: Column(
                      children: [
                        SizedBox(height: AppDimensions.d20.h),
                        // ✅ Reusable Header
                        CustomHeader(
                          title: trKey('select'),
                          highlightedText: trKey('role'),
                          onBackTap: () => Get.offAllNamed(AppRoutes.pricingScreen),
                        ),

                        // ✅ Welcome Section
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppDimensions.d20.w),
                          child: Column(
                            children: [
                              Text(
                                trKey('welcome_navigator'),
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: AppColors.primaryRed,
                                  fontWeight: FontWeight.bold,
                                  fontSize: orientation == Orientation.portrait ? 20.sp : 16.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: AppDimensions.d8.h),
                              Text(
                                trKey('company_crisis_description'),
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  height: 1.4,
                                  fontSize: orientation == Orientation.portrait ? 14.sp : 12.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppDimensions.d10.h),

                        // ✅ Instruction
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppDimensions.d24.w),
                          child: Align(
                            child: Text(
                              trKey('choose_role_instruction'),
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: orientation == Orientation.portrait ? 15.sp : 13.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(height: AppDimensions.d14.h),

                        // ✅ Roles Grid
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppDimensions.d16.w),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final screenWidth = MediaQuery.of(context).size.width;
                              final screenHeight = MediaQuery.of(context).size.height;

                              int crossAxisCount = 2;
                              if (screenWidth > 1200) {
                                crossAxisCount = 4;
                              } else if (screenWidth > 800) {
                                crossAxisCount = 3;
                              }

                              double childAspectRatio = (screenWidth / crossAxisCount) / (screenHeight * (orientation == Orientation.portrait ? 0.38 : 0.55));

                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.roles.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: AppDimensions.d10.w,
                                  mainAxisSpacing: AppDimensions.d10.h,
                                  childAspectRatio: childAspectRatio.clamp(0.72, 0.95),
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

                        // ✅ Continue Button & Tutorial
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppDimensions.d18.w),
                          child: Column(
                            children: [
                              CustomButton2(
                                text: trKey('select_continue'),
                                onPressed: controller.continueWithSelection,
                              ),
                              SizedBox(height: AppDimensions.d12.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    trKey('first_time_playing'),
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: Colors.black,
                                      fontSize: orientation == Orientation.portrait ? 13.sp : 11.sp,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                                    child: GestureDetector(
                                      onTap: controller.openTutorial,
                                      child: Text(
                                        trKey('watch_tutorial'),
                                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          color: AppColors.primaryRed,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                          fontSize: orientation == Orientation.portrait ? 13.sp : 11.sp,
                                        ),
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

              // ✅ Floating NavBar
              Positioned(
                right: screenWidth * -0.07,
                top: screenHeight * 0.50,
                child: const CustomHomeNavBar(),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// ✅ Role Card (unchanged)
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
              color: selected ? AppColors.primaryRed : AppColors.grey.withOpacity(0.2),
              width: selected ? 2.2 : 1,
            ),
            boxShadow: selected
                ? [
              BoxShadow(
                color: AppColors.primaryRed.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ]
                : [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
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
                  // Avatar Icon
                  Container(
                    padding: EdgeInsets.all(AppDimensions.d8.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected ? AppColors.primaryRed.withOpacity(0.06) : Colors.grey.shade50,
                    ),
                    child: Center(
                      child: CustomSvg(
                        assetPath: role['asset'],
                        semanticsLabel: trKey(role['title']),
                        width: screenWidth * 0.18,
                        height: screenWidth * 0.16,
                      ),
                    ),
                  ),
                  SizedBox(height: AppDimensions.d12.h),

                  // Role Title
                  Text(
                    trKey(role['title']),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primaryRed,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppDimensions.d4.h),

                  // Role Subtitle
                  Text(
                    trKey(role['subtitle']),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Extra Info
                  if (role['extra'] != null && role['extra'].toString().isNotEmpty)
                    Text(
                      trKey(role['extra']),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),

              // Top-Right Icon
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
                        color: Colors.black.withOpacity(0.15),
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