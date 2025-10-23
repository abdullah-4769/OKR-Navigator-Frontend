import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/choose_industry_controller.dart';
import '../../../controllers/key_results_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_industry_container.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import '../roles/role_selection_screen.dart';

class ChooseIndustryScreen extends StatelessWidget {
  final Map<String, dynamic>? selectedRole;

  ChooseIndustryScreen({super.key, this.selectedRole});

  final ChooseIndustryController controller =
  Get.put(ChooseIndustryController());

  @override
  Widget build(BuildContext context) => OrientationBuilder(
    builder: (context, orientation) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      Get.lazyPut(() => KeyResultsController());

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
                          CustomHeader(
                            title: trKey('choose'),
                            highlightedText: trKey('your_industry'),
                            onBackTap: () =>
                                Get.offAllNamed(AppRoutes.roleSelection),
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          // 👇 Search Field
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.06,
                            ),
                            child: TextField(
                              onChanged: controller.filterIndustries,
                              decoration: InputDecoration(
                                hintText: 'search_industry'.tr,
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.h,
                                  horizontal: 10.w,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          // 👇 Scrollable List inside Container
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01,
                              horizontal: screenWidth * 0.04,
                            ),
                            child: Container(
                              height: screenHeight * 0.45,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(color: AppColors.accentRed,width: 2),
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.1),
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Obx(() {
                                final filteredList =
                                    controller.filteredIndustries;
                                return Scrollbar(
                                  radius: const Radius.circular(8),
                                  child: ListView.builder(
                                    padding: EdgeInsets.all(12.w),
                                    itemCount: filteredList.length,
                                    itemBuilder: (context, index) {
                                      final industry =
                                      filteredList[index];
                                      final titleKey =
                                      industry['titleKey']?.toString();
                                      final descriptionKey = industry[
                                      'descriptionKey']
                                          ?.toString();

                                      final title = titleKey != null
                                          ? titleKey.tr
                                          : 'Unknown Industry';
                                      final description =
                                      descriptionKey != null
                                          ? descriptionKey.tr
                                          : 'No description available';

                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom: 8.h,
                                        ),
                                        child: Obx(() => CustomIndustryContainer(
                                          title: title,
                                          description: description,
                                          icon: industry['icon']
                                          as IconData? ??
                                              Icons.business,
                                          isSelected: controller
                                              .selectedIndex
                                              .value ==
                                              index,
                                          onTap: () =>
                                              controller.selectIndustry(
                                                  index),
                                        )),
                                      );
                                    },
                                  ),
                                );
                              }),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          // 👇 Continue Button
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
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'first_time_playing'.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.black),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 4.w,
                                      ),
                                      child: GestureDetector(
                                        onTap: controller.openTutorial,
                                        child: Text(
                                          'watch_tutorial_video'.tr,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                            color:
                                            AppColors.primaryRed,
                                            fontWeight: FontWeight.bold,
                                            decoration: TextDecoration
                                                .underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 👇 Floating Home Button
                Positioned(
                  right: screenWidth * -0.07,
                  top: screenHeight * 0.50,
                  child: const CustomHomeNavBar(),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
