// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:game_app/presentation/widgets/screens_unique_parts/custom_background.dart';
// import 'package:get/get.dart';
//
// import '../../../controllers/role_selection_controller.dart';
// import '../../../core/app_colors.dart';
// import '../../../core/app_dimensions.dart';
// import '../../routes/app_routes.dart';
// import '../../widgets/custom_button2.dart';
// import '../../widgets/custom_home_navbar.dart';
// import '../../widgets/custom_svg.dart';
// import '../../widgets/screens_unique_parts/custom_header.dart';
//
// // ✅ Global trKey
// String trKey(Object? key) => key != null ? key.toString().tr : '';
//
// class RoleSelectionScreen extends StatelessWidget {
//   RoleSelectionScreen({super.key});
//
//   final RoleSelectionController controller = Get.find<RoleSelectionController>();
//   final RxBool isDropdownOpen = false.obs;
//   bool cameFromBonus = false;
//   final RxInt selectedIndex = (-1).obs;
//
//
//   @override
//   void onInit() {
//     // super.onInit();
//
//     cameFromBonus = (Get.arguments?['fromBonusMode'] == true);
//
//     if (cameFromBonus) {
//       print("🟢 RoleSelection loaded AGAIN from Bonus Mode");
//     }
//   }
//   Widget build(BuildContext context) => OrientationBuilder(
//     builder: (context, orientation) {
//       final screenWidth = MediaQuery.of(context).size.width;
//       final screenHeight = MediaQuery.of(context).size.height;
//
//       return Scaffold(
//         backgroundColor: Colors.white,
//         body: CustomBackground(
//           child: Stack(
//             children: [
//               Positioned.fill(
//                 child: SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   child: Padding(
//                     padding: EdgeInsets.only(top: 0, bottom: AppDimensions.d10.h),
//                     child: Column(
//                       children: [
//                         SizedBox(height: AppDimensions.d20.h),
//                         // ✅ Reusable Header
//                         CustomHeader(
//                           title: trKey('select'),
//                           highlightedText: trKey('role'),
//                           onBackTap: () => Get.back(),
//                         ),
//
//                         // ✅ Welcome Section
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: AppDimensions.d20.w),
//                           child: Column(
//                             children: [
//                               Text(
//                                 trKey('welcome_navigator'),
//                                 style: Theme.of(context).textTheme.displayMedium?.copyWith(
//                                   color: AppColors.primaryRed,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: orientation == Orientation.portrait ? 20.sp : 16.sp,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                               SizedBox(height: AppDimensions.d8.h),
//                               Text(
//                                 trKey('company_crisis_description'),
//                                 style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                                   height: 1.4,
//                                   fontSize: orientation == Orientation.portrait ? 14.sp : 12.sp,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: AppDimensions.d10.h),
//
//                         // ✅ Instruction
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: AppDimensions.d24.w),
//                           child: Align(
//                             child: Text(
//                               trKey('choose_role_instruction'),
//                               style: Theme.of(context).textTheme.displaySmall?.copyWith(
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: orientation == Orientation.portrait ? 15.sp : 13.sp,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: AppDimensions.d14.h),
//
//                         // ✅ Dropdown Container - "Select Your Role"
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: AppDimensions.d16.w),
//                           child: Obx(() => GestureDetector(
//                             onTap: () => isDropdownOpen.toggle(),
//                             child: AnimatedContainer(
//                               duration: const Duration(milliseconds: 300),
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: AppDimensions.d16.w,
//                                 vertical: AppDimensions.d14.h,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(AppDimensions.d12.r),
//                                 border: Border.all(
//                                   color: isDropdownOpen.value
//                                       ? AppColors.primaryRed
//                                       : AppColors.grey.withOpacity(0.3),
//                                   width: 1.5,
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.08),
//                                     blurRadius: 8,
//                                     offset: const Offset(0, 3),
//                                   ),
//                                 ],
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     controller.selectedIndex.value >= 0
//                                         ? trKey(controller.roles[controller.selectedIndex.value]['title'])
//                                         : 'select_your_role'.tr,
//                                     style: TextStyle(
//                                       fontSize: 16.sp,//
//                                       fontWeight: FontWeight.w600,
//                                       color: controller.selectedIndex.value >= 0
//                                           ? AppColors.primaryRed
//                                          : Colors.black87,
//                                     ),
//                                   ),
//                                   AnimatedRotation(
//                                     turns: isDropdownOpen.value ? 0.5 : 0,
//                                     duration: const Duration(milliseconds: 300),
//                                     child: Icon(
//                                       Icons.keyboard_arrow_down_rounded,
//                                       color: AppColors.primaryRed,
//                                       size: 28.sp,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )),
//                         ),
//
//                         SizedBox(height: AppDimensions.d12.h),
//
//                         // ✅ Roles ListView (Dropdown Content)
//                         Obx(() => AnimatedSize(
//                           duration: const Duration(milliseconds: 400),
//                           curve: Curves.easeInOut,
//                           child: isDropdownOpen.value
//                               ? Padding(
//                             padding: EdgeInsets.symmetric(horizontal: AppDimensions.d16.w),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(AppDimensions.d12.r),
//                                 border: Border.all(
//                                   color: AppColors.grey.withOpacity(0.2),
//                                   width: 1,
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.06),
//                                     blurRadius: 10,
//                                     offset: const Offset(0, 4),
//                                   ),
//                                 ],
//                               ),
//                               child: ListView.separated(
//                                 shrinkWrap: true,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 itemCount: controller.roles.length,
//                                 separatorBuilder: (context, index) => Divider(
//                                   height: 1,
//                                   thickness: 1,
//                                   color: AppColors.grey.withOpacity(0.15),
//                                 ),
//                                 itemBuilder: (context, index) {
//                                   final role = controller.roles[index];
//                                   return _RoleListTile(
//                                     index: index,
//                                     role: role,
//                                     controller: controller,
//                                     onTap: () {
//                                       controller.selectRole(index);
//                                       isDropdownOpen.value = false;
//                                     },
//                                   );
//                                 },
//                               ),
//                             ),
//                           )
//                               : const SizedBox.shrink(),
//                         )),
//
//                         SizedBox(height: AppDimensions.d20.h),
//
//                         // ✅ Continue Button & Tutorial
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: AppDimensions.d18.w),
//                           child: Column(
//                             children: [
//                               CustomButton2(
//                                 text: trKey('select_continue'),
//                                 onPressed: controller.continueWithSelection,
//                               ),
//                               SizedBox(height: AppDimensions.d12.h),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     trKey('first_time_playing'),
//                                     style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                                       color: Colors.black,
//                                       fontSize: orientation == Orientation.portrait ? 12.sp : 11.sp,
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.symmetric(horizontal: 8.w),
//                                     child: GestureDetector(
//                                       onTap: controller.openTutorial,
//                                       child: Text(
//                                         trKey('watch_tutorial'),
//                                         style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                                           color: AppColors.primaryRed,
//                                           fontWeight: FontWeight.bold,
//                                           decoration: TextDecoration.underline,
//                                           fontSize: orientation == Orientation.portrait ? 12.sp : 11.sp,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: AppDimensions.d18.h),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               // ✅ Floating NavBar
//               Positioned(
//                 right: screenWidth * -0.07,
//                 top: screenHeight * 0.50,
//                 child: const CustomHomeNavBar(),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
//
// // ✅ Role ListTile (NEW - replaces _RoleCard)
// class _RoleListTile extends StatelessWidget {
//   final int index;
//   final Map<String, dynamic> role;
//   final RoleSelectionController controller;
//   final VoidCallback onTap;
//
//   const _RoleListTile({
//     required this.index,
//     required this.role,
//     required this.controller,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) => Obx(() {
//       final selected = controller.selectedIndex.value == index;
//
//       return InkWell(
//         onTap: onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 250),
//           padding: EdgeInsets.symmetric(
//             horizontal: AppDimensions.d14.w,
//             vertical: AppDimensions.d12.h,
//           ),
//           decoration: BoxDecoration(
//             color: selected
//                 ? AppColors.primaryRed.withOpacity(0.05)
//                 : Colors.transparent,
//             borderRadius: BorderRadius.circular(AppDimensions.d8.r),
//           ),
//           child: Row(
//             children: [
//               // Leading - Avatar Icon
//               Container(
//                 width: 56.sp,
//                 height: 56.sp,
//                 padding: EdgeInsets.all(AppDimensions.d10.w),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: selected
//                       ? AppColors.primaryRed.withOpacity(0.1)
//                       : Colors.grey.shade100,
//                   border: Border.all(
//                     color: selected
//                         ? AppColors.primaryRed.withOpacity(0.3)
//                         : Colors.transparent,
//                     width: 2,
//                   ),
//                 ),
//                 child: CustomSvg(
//                   assetPath: role['asset'],
//                   semanticsLabel: trKey(role['title']),
//                 ),
//               ),
//
//               SizedBox(width: AppDimensions.d12.w),
//
//               // Title & Subtitle
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       trKey(role['title']),
//                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                         color: selected ? AppColors.primaryRed : Colors.black87,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16.sp,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: 2.h),
//                     Text(
//                       trKey(role['subtitle']),
//                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         color: Colors.black87,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 13.sp,
//                         height: 1.3,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     if (role['extra'] != null && role['extra'].toString().isNotEmpty)
//                       Padding(
//                         padding: EdgeInsets.only(top: 2.h),
//                         child: Text(
//                           trKey(role['extra']),
//                           style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                             color: AppColors.grey,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 11.sp,
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//
//               SizedBox(width: AppDimensions.d8.w),
//
//               // Trailing - Icon
//               Container(
//                 padding: EdgeInsets.all(AppDimensions.d8.w),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: role['iconBg'],
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 4,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Icon(
//                   role['icon'],
//                   color: Colors.white,
//                   size: 20.sp,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
// }
//
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

class RoleSelectionScreen extends StatefulWidget {
  RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  final RoleSelectionController controller = Get.put(RoleSelectionController());
  final RxBool isDropdownOpen = false.obs;
  late RxBool cameFromBonus;

  @override
  void initState() {
    super.initState();
    cameFromBonus = false.obs;

    // Check if coming from bonus mode
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = Get.arguments;
      if (args != null && args['fromBonusMode'] == true) {
        cameFromBonus.value = true;
        print("🟢 Bonus mode detected in RoleSelection");
      }
    });
  }

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
                          onBackTap: () => Get.back(),
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

                        // ✅ Dropdown Container - "Select Your Role"
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppDimensions.d16.w),
                          child: Obx(() => GestureDetector(
                            onTap: () => isDropdownOpen.toggle(),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.d16.w,
                                vertical: AppDimensions.d14.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(AppDimensions.d12.r),
                                border: Border.all(
                                  color: isDropdownOpen.value
                                      ? AppColors.primaryRed
                                      : AppColors.grey.withOpacity(0.3),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    controller.selectedIndex.value >= 0
                                        ? trKey(controller.roles[controller.selectedIndex.value]['title'])
                                        : 'select_your_role'.tr,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: controller.selectedIndex.value >= 0
                                          ? AppColors.primaryRed
                                          : Colors.black87,
                                    ),
                                  ),
                                  AnimatedRotation(
                                    turns: isDropdownOpen.value ? 0.5 : 0,
                                    duration: const Duration(milliseconds: 300),
                                    child: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: AppColors.primaryRed,
                                      size: 28.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                        ),

                        SizedBox(height: AppDimensions.d12.h),

                        // ✅ Roles ListView (Dropdown Content)
                        Obx(() => AnimatedSize(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                          child: isDropdownOpen.value
                              ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: AppDimensions.d16.w),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(AppDimensions.d12.r),
                                border: Border.all(
                                  color: AppColors.grey.withOpacity(0.2),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.roles.length,
                                separatorBuilder: (context, index) => Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: AppColors.grey.withOpacity(0.15),
                                ),
                                itemBuilder: (context, index) {
                                  final role = controller.roles[index];
                                  return _RoleListTile(
                                    index: index,
                                    role: role,
                                    controller: controller,
                                    onTap: () {
                                      controller.selectRole(index);
                                      isDropdownOpen.value = false;
                                    },
                                  );
                                },
                              ),
                            ),
                          )
                              : const SizedBox.shrink(),
                        )),

                        SizedBox(height: AppDimensions.d20.h),

                        // ✅ Continue Button & Tutorial
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppDimensions.d18.w),
                          child: Column(
                            children: [
                              CustomButton2(
                                text: trKey('select_continue'),
                                onPressed: () => _handleContinue(),
                              ),
                              SizedBox(height: AppDimensions.d12.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    trKey('first_time_playing'),
                                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: Colors.black,
                                      fontSize: orientation == Orientation.portrait ? 12.sp : 11.sp,
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
                                          fontSize: orientation == Orientation.portrait ? 12.sp : 11.sp,
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

// 3. Update RoleSelectionScreen.dart (_handleContinue)
  void _handleContinue() {
    if (controller.selectedIndex.value == -1) {
      Get.snackbar('Error'.tr, 'Please select a role'.tr, backgroundColor: AppColors.primaryRed, colorText: Colors.white);
      return;
    }

    final selectedRole = controller.roles[controller.selectedIndex.value];
    final args = Get.arguments ?? {};
    final fromBonus = args['fromBonus'] as bool? ?? false;

    Get.toNamed(AppRoutes.chooseIndustry, arguments: {
      'selectedRole': selectedRole,
      'fromBonus': fromBonus,
    });
  }}

// ✅ Role ListTile (NEW - replaces _RoleCard)
class _RoleListTile extends StatelessWidget {
  final int index;
  final Map<String, dynamic> role;
  final RoleSelectionController controller;
  final VoidCallback onTap;

  const _RoleListTile({
    required this.index,
    required this.role,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Obx(() {
    final selected = controller.selectedIndex.value == index;

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.d14.w,
          vertical: AppDimensions.d12.h,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryRed.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.d8.r),
        ),
        child: Row(
          children: [
            // Leading - Avatar Icon
            Container(
              width: 56.sp,
              height: 56.sp,
              padding: EdgeInsets.all(AppDimensions.d10.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? AppColors.primaryRed.withOpacity(0.1)
                    : Colors.grey.shade100,
                border: Border.all(
                  color: selected
                      ? AppColors.primaryRed.withOpacity(0.3)
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: CustomSvg(
                assetPath: role['asset'],
                semanticsLabel: trKey(role['title']),
              ),
            ),

            SizedBox(width: AppDimensions.d12.w),

            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trKey(role['title']),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: selected ? AppColors.primaryRed : Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    trKey(role['subtitle']),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (role['extra'] != null && role['extra'].toString().isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: Text(
                        trKey(role['extra']),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(width: AppDimensions.d8.w),

            // Trailing - Icon
            Container(
              padding: EdgeInsets.all(AppDimensions.d8.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: role['iconBg'],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                role['icon'],
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  });
}