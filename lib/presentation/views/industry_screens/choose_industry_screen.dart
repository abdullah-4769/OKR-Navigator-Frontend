// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import '../../../controllers/choose_industry_controller.dart';
// import '../../../controllers/key_results_controller.dart';
// import '../../../core/app_colors.dart';
// import '../../../core/app_dimensions.dart';
// import '../../../services/shared_preference.dart';          // ← ADD THIS
// import '../../routes/app_routes.dart';
// import '../../widgets/custom_button2.dart';
// import '../../widgets/custom_home_navbar.dart';
// import '../../widgets/custom_industry_container.dart';
// import '../../widgets/screens_unique_parts/custom_background.dart';
// import '../../widgets/screens_unique_parts/custom_header.dart';
// import '../bonus_mode/bonus_mode.dart';
// import '../roles/role_selection_screen.dart';
//
// class ChooseIndustryScreen extends StatelessWidget {
//   final Map<String, dynamic>? selectedRole;
//
//   ChooseIndustryScreen({super.key, this.selectedRole});
//
//   final ChooseIndustryController controller = Get.put(ChooseIndustryController());
//
//   @override
//   Widget build(BuildContext context) => OrientationBuilder(
//     builder: (context, orientation) {
//       final screenWidth = MediaQuery.of(context).size.width;
//       final screenHeight = MediaQuery.of(context).size.height;
//       Get.lazyPut(() => KeyResultsController());
//
//       return Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: CustomBackground(
//             child: Stack(
//               children: [
//                 Positioned.fill(
//                   child: SingleChildScrollView(
//                     physics: const BouncingScrollPhysics(),
//                     child: Padding(
//                       padding: EdgeInsets.only(bottom: AppDimensions.d20.h),
//                       child: Column(
//                         children: [
//                           SizedBox(height: screenHeight * 0.03),
//                           CustomHeader(
//                             title: trKey('choose'),
//                             highlightedText: trKey('your_industry'),
//                             onBackTap: () => Get.offAllNamed(AppRoutes.roleSelection),
//                           ),
//                           SizedBox(height: screenHeight * 0.02),
//
//                           // Search Field
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
//                             child: TextField(
//                               onChanged: controller.filterIndustries,
//                               decoration: InputDecoration(
//                                 hintText: 'search_industry'.tr,
//                                 prefixIcon: const Icon(Icons.search),
//                                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
//                                 contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: screenHeight * 0.02),
//
//                           // Industries List
//                           Padding(
//                             padding: EdgeInsets.symmetric(
//                               vertical: screenHeight * 0.01,
//                               horizontal: screenWidth * 0.04,
//                             ),
//                             child: Container(
//                               height: screenHeight * 0.45,
//                               decoration: BoxDecoration(
//                                 color: Colors.transparent,
//                                 border: Border.all(color: AppColors.accentRed, width: 2),
//                                 borderRadius: BorderRadius.circular(16.r),
//                                 boxShadow: [
//                                   BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 2, offset: const Offset(0, 1)),
//                                 ],
//                               ),
//                               child: Obx(() {
//                                 final filteredList = controller.filteredIndustries;
//                                 return Scrollbar(
//                                   radius: const Radius.circular(8),
//                                   child: ListView.builder(
//                                     padding: EdgeInsets.all(12.w),
//                                     itemCount: filteredList.length,
//                                     itemBuilder: (context, index) {
//                                       final industry = filteredList[index];
//                                       final title = (industry['titleKey']?.toString() ?? '').tr;
//                                       final description = (industry['descriptionKey']?.toString() ?? '').tr;
//
//                                       return Padding(
//                                         padding: EdgeInsets.only(bottom: 8.h),
//                                         child: Obx(() => CustomIndustryContainer(
//                                           title: title,
//                                           description: description,
//                                           icon: industry['icon'] as IconData? ?? Icons.business,
//                                           isSelected: controller.selectedIndex.value == index,
//                                           onTap: () => controller.selectIndustry(index),
//                                         )),
//                                       );
//                                     },
//                                   ),
//                                 );
//                               }),
//                             ),
//                           ),
//
//                           SizedBox(height: screenHeight * 0.03),
//
//                           // Continue Button + Tutorial Link
//                           Padding(
//                             padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
//                             child: Column(
//                               children: [
//                                 CustomButton2(
//                                   text: 'select_continue'.tr,
//                                   onPressed: () async {
//                                     if (controller.selectedIndex.value == -1) {
//                                       Get.snackbar('Error', 'Please select an industry', backgroundColor: AppColors.primaryRed, colorText: Colors.white);
//                                       return;
//                                     }
//
//                                     final selectedIndustry = controller.filteredIndustries[controller.selectedIndex.value];
//                                     await SharedPrefs.saveSelectedIndustry(selectedIndustry);
//
//                                     final gameMode = await SharedPrefs.getGameMode();
//
//                                     if (gameMode == 'bonus') {
//                                       // Fake AI loading → then go to handling screen
//                                       Get.to(() => DailyTrainingHomeScreen(), arguments: {
//                                         'selectedRole': selectedRole,
//                                         'selectedIndustry': selectedIndustry,
//                                       });
//                                     } else {
//                                       Get.toNamed(AppRoutes.selectStrategy, arguments: {
//                                         'selectedRole': selectedRole,
//                                         'selectedIndustry': selectedIndustry,
//                                       });
//                                     }
//                                   },
//                                 ),                                SizedBox(height: screenHeight * 0.015),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         'first_time_playing'.tr,
//                                         style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
//                                         overflow: TextOverflow.ellipsis,
//                                         maxLines: 1,
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: EdgeInsets.symmetric(horizontal: 2.w),
//                                       child: GestureDetector(
//                                         onTap: controller.openTutorial,
//                                         child: Text(
//                                           'watch_tutorial_video'.tr,
//                                           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                                             color: AppColors.primaryRed,
//                                             decoration: TextDecoration.underline,
//                                           ),
//                                           overflow: TextOverflow.ellipsis,
//                                           maxLines: 1,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 // Floating Home Button
//                 Positioned(
//                   right: screenWidth * -0.07,
//                   top: screenHeight * 0.50,
//                   child: const CustomHomeNavBar(),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:game_app/core/app_colors.dart';
import 'package:game_app/core/app_dimensions.dart';
import 'package:game_app/services/shared_preference.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:game_app/controllers/choose_industry_controller.dart';
import 'package:game_app/presentation/widgets/custom_button2.dart';
import 'package:game_app/presentation/widgets/custom_industry_container.dart';
import 'package:game_app/presentation/widgets/screens_unique_parts/custom_background.dart';
import 'package:game_app/presentation/widgets/screens_unique_parts/custom_header.dart';

import '../bonus_mode/case_presentation_screen.dart';

class ChooseIndustryScreen extends StatefulWidget {
  final Map? selectedRole;

  const ChooseIndustryScreen({super.key, this.selectedRole});

  @override
  State<ChooseIndustryScreen> createState() => _ChooseIndustryScreenState();
}

class _ChooseIndustryScreenState extends State<ChooseIndustryScreen> {
  final ChooseIndustryController controller = Get.put(ChooseIndustryController());
  late final bool fromBonus;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    fromBonus = args != null && args['fromBonus'] == true;

    if (fromBonus) {
      print('🟢 ChooseIndustryScreen: Bonus mode detected');
    }
  }

  @override
  Widget build(BuildContext context) => OrientationBuilder(
    builder: (context, orientation) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;

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
                            title: 'choose'.tr,
                            highlightedText: 'your_industry'.tr,
                            onBackTap: () => Get.back(),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          // Search Field
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
                          // Industries List
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01,
                              horizontal: screenWidth * 0.04,
                            ),
                            child: Container(
                              height: screenHeight * 0.45,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                  color: AppColors.accentRed,
                                  width: 2,
                                ),
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
                                final filteredList = controller.filteredIndustries;
                                return Scrollbar(
                                  radius: const Radius.circular(8),
                                  child: ListView.builder(
                                    padding: EdgeInsets.all(12.w),
                                    itemCount: filteredList.length,
                                    itemBuilder: (context, index) {
                                      final industry = filteredList[index];
                                      final title = (industry['titleKey']
                                          ?.toString() ??
                                          '')
                                          .tr;
                                      final description = (industry[
                                      'descriptionKey']
                                          ?.toString() ??
                                          '')
                                          .tr;

                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 8.h),
                                        child: Obx(() =>
                                            CustomIndustryContainer(
                                              title: title,
                                              description: description,
                                              icon: industry['icon']
                                              as IconData? ??
                                                  Icons.business,
                                              isSelected:
                                              controller.selectedIndex
                                                  .value ==
                                                  index,
                                              onTap: () => controller
                                                  .selectIndustry(index),
                                            )),
                                      );
                                    },
                                  ),
                                );
                              }),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          // Continue Button
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.06,
                            ),
                            child: Column(
                              children: [
                                CustomButton2(
                                  text: 'select_continue'.tr,
                                  onPressed: () async {
                                    if (controller.selectedIndex.value == -1) {
                                      Get.snackbar(
                                        'Error'.tr,
                                        'Please select an industry'.tr,
                                        backgroundColor: AppColors.primaryRed,
                                        colorText: Colors.white,
                                      );
                                      return;
                                    }

                                    final selectedIndustry = controller
                                        .filteredIndustries[
                                    controller.selectedIndex.value];

                                    await SharedPrefs.saveSelectedIndustry(
                                      selectedIndustry,
                                    );

                                    print('✅ Industry selected: ${selectedIndustry['titleKey']}');

                                    // اگر bonus mode ہو تو DailyTrainingHomeScreen پر جائیں
                                    if (fromBonus) {
                                      print('🟢 Navigating to Bonus Mode...');
                                      Get.to(
                                            () => CasePresentationScreen(
                                          selectedIndustry: selectedIndustry,
                                        ),
                                      );
                                    } else {
                                      // Regular mode
                                      print('🔵 Navigating to Strategy Selection...');
                                      Get.toNamed(
                                        AppRoutes.selectStrategy,
                                        arguments: {
                                          'selectedRole':
                                          widget.selectedRole ?? Get.arguments?['selectedRole'],
                                          'selectedIndustry': selectedIndustry,
                                        },
                                      );
                                    }
                                  },
                                ),
                                SizedBox(height: screenHeight * 0.015),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'first_time_playing'.tr,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 2.w),
                                      child: GestureDetector(
                                        onTap: controller.openTutorial,
                                        child: Text(
                                          'watch_tutorial_video'.tr,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                            color: AppColors.primaryRed,
                                            decoration:
                                            TextDecoration.underline,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
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
              ],
            ),
          ),
        ),
      );
    },
  );
}