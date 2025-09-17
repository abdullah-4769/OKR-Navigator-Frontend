import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/widgets/screens_unique_parts/custom_header.dart';
import 'package:get/get.dart';

import '../../../controllers/choose_industry_controller.dart';
import '../../../controllers/key_results_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_curved_arrow.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_svg.dart';
import '../../widgets/custom_industry_container.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../roles/role_selection_screen.dart';
// ... (other imports remain the same)

class ChooseIndustryScreen extends StatelessWidget {
  final Map<String, dynamic>? selectedRole;

  ChooseIndustryScreen({super.key, this.selectedRole});

  final ChooseIndustryController controller = Get.put(ChooseIndustryController());

  @override
  Widget build(BuildContext context) => OrientationBuilder(
      builder: (context, orientation) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        Get.lazyPut(()=>KeyResultsController());
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: CustomBackground(
              child: Stack(
              children: [

                Positioned.fill(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: AppDimensions.d20.h),
                      child: Column(

                        children: [
                          SizedBox(height: screenHeight * 0.03),
                          CustomHeader(title:
                      trKey('choose'),
                        highlightedText: trKey('your_industry'), onBackTap: () => Get.offAllNamed(AppRoutes.roleSelection),),



                          SizedBox(height: screenHeight * 0.01),
                          // Welcome Text
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                            child: Column(
                              children: [
                                Text(
                                  'welcome_role'.trParams({'role': selectedRole?['title']?.toString() ?? 'Navigator'}),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.copyWith(
                                    color: AppColors.primaryRed,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                Text(
                                  'entered_company_crisis'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                Text(
                                  'own_industry'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                    color: AppColors.black,
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.025),
                          // Industry List
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                            child: Obx(
                                  () => Column(
                                children: List.generate(
                                  controller.industries.length,
                                      (index) {
                                    final industry = controller.industries[index];
                                    final titleKey = industry['titleKey']?.toString();
                                    final descriptionKey = industry['descriptionKey']?.toString();

                                    // Null safety check - provide default values if keys are null
                                    final title = titleKey != null ? titleKey.tr : 'Unknown Industry';
                                    final description = descriptionKey != null ? descriptionKey.tr : 'No description available';

                                    return CustomIndustryContainer(
                                      title: title,
                                      description: description,
                                      icon: industry['icon'] as IconData? ?? Icons.business,
                                      isSelected: controller.selectedIndex.value == index,
                                      onTap: () => controller.selectIndustry(index),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          // Continue Button & Tutorial
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                            child: Column(
                              children: [
                                CustomButton2(
                                  text: 'select_continue'.tr,
                                  onPressed: () => controller.continueWithSelection(selectedRole),
                                ),
                                SizedBox(height: screenHeight * 0.015),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'first_time_playing'.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.black),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: 4.w),
                                      child: GestureDetector(
                                        onTap: controller.openTutorial,
                                        child: Text(
                                          'watch_tutorial_video'.tr,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                            color: AppColors.primaryRed,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                               // SizedBox(height: screenHeight * 0.0009),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Home NavBar
                Positioned(
                  right: screenWidth * -0.07,
                  top: screenHeight * 0.50,
                  child: const CustomHomeNavBar(),
                ),
              ],)
            ),
          ),
        );
      },
    );
}