import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/utils/snackbar_helper.dart';
import 'package:get/get.dart';
import 'dart:developer';

import '../../../controllers/journey_controller.dart';
import '../../../controllers/key_objective_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../generated/models/responses/objectives/objectives_response.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_industry_container.dart';
import '../../widgets/custom_journey_map.dart';
import '../../widgets/custom_objective_container.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

class KeyObjectiveSelectedScreen extends StatefulWidget {
  const KeyObjectiveSelectedScreen({super.key});

  @override
  State<KeyObjectiveSelectedScreen> createState() => _KeyObjectiveSelectedScreenState();
}

class _KeyObjectiveSelectedScreenState extends State<KeyObjectiveSelectedScreen> {
  final TextEditingController searchController = TextEditingController();
  final RxList<Objective> filteredObjectives = RxList<Objective>();
  final KeyObjectiveController controller = Get.find<KeyObjectiveController>();
  final JourneyController journeyController = Get.find<JourneyController>();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    // Initialize filteredObjectives with controller.objectives
    filteredObjectives.assignAll(controller.objectives);
    // Update filteredObjectives when controller.objectives changes
    ever(controller.objectives, (_) {
      filteredObjectives.assignAll(controller.objectives);
      // Apply current search filter if search text exists
      if (searchController.text.isNotEmpty) {
        filterObjectives(searchController.text);
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _initializeControllers() {
    if (!Get.isRegistered<JourneyController>()) {
      Get.put(JourneyController(), permanent: true);
    }
    if (!Get.isRegistered<KeyObjectiveController>()) {
      Get.put(KeyObjectiveController(), permanent: true);
    }
  }

  String _safeTranslate(String? key, {String fallback = ''}) {
    if (key == null) {
      debugPrint('Translation key is null, returning fallback: $fallback');
      return fallback;
    }
    try {
      return key.tr;
    } catch (e) {
      debugPrint('Translation failed for key: $key, error: $e');
      return fallback;
    }
  }

  void filterObjectives(String query) {
    if (query.isEmpty) {
      filteredObjectives.assignAll(controller.objectives);
    } else {
      filteredObjectives.assignAll(
        controller.objectives.where((obj) {
          final translatedTitle = obj.title?.tr ?? '';
          final translatedDescription = obj.description?.tr ?? '';
          return translatedTitle.toLowerCase().contains(query.toLowerCase()) ||
              translatedDescription.toLowerCase().contains(query.toLowerCase());
        }).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final selectedRole = args?['selectedRole'] as Map<String, dynamic>?;
    final selectedIndustry = args?['selectedIndustry'] as Map<String, dynamic>?;
    final isCampaignMode = args?['isCampaignMode'] as bool? ?? false;

    log('════════════════════════════════════════');
    log('📦 KeyObjectiveScreen BUILD CALLED');
    log('Arguments: $args');
    log('Role: $selectedRole');
    log('Industry: $selectedIndustry');
    log('Campaign Mode: $isCampaignMode');
    log('Current Route: ${Get.currentRoute}');
    log('════════════════════════════════════════');

    // ✅ Handle campaign mode - use organization as industry
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      journeyController.setStep(0, true);

      if (isCampaignMode) {
        log('🎯 Campaign mode detected - using organization as industry');
        // In campaign mode, we should have both role and organization
        if (selectedRole != null && selectedIndustry != null) {
          log('✅ Campaign mode: Fetching objectives with role and organization');
          await controller.getObjectives(selectedRole, selectedIndustry);
        } else {
          log('❌ Campaign mode: Missing role or organization data');
          SnackbarHelper.error('Missing campaign data. Please restart the campaign.');
        }
      } else {
        // Original solo mode logic
        if (selectedRole != null && selectedIndustry != null) {
          log('✅ Solo mode: Fetching objectives with valid role and industry');
          await controller.getObjectives(selectedRole, selectedIndustry);
        } else {
          log('❌ Solo mode: Missing role or industry - navigating back');
          SnackbarHelper.error('Please select both a role and an industry.');
          await Future.delayed(const Duration(seconds: 1));
          Get.offAllNamed(AppRoutes.selectStrategy, arguments: {
            'selectedRole': selectedRole,
            'selectedIndustry': selectedIndustry,
          });
        }
      }
    });

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 900;

    return Scaffold(
      body: CustomBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: _getResponsiveSpacing(screenHeight, 0.025),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.03),
                        CustomHeader(
                          title: _safeTranslate('choose'),
                          highlightedText: _safeTranslate('objective'),
                          onBackTap: () => Get.offAllNamed(
                            AppRoutes.selectStrategy,
                            arguments: {
                              'selectedRole': selectedRole,
                              'selectedIndustry': selectedIndustry,
                              'isCampaignMode': isCampaignMode, // ✅ Pass campaign mode flag back
                            },
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _getHorizontalPadding(screenWidth),
                          ),
                          child: CustomObjectiveContainer(
                            title: _safeTranslate('selected_strategy'),
                            icon: Icons.emoji_objects,

                          ),
                        ),
                        SizedBox(height: _getResponsiveSpacing(screenHeight, 0.025)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _getHorizontalPadding(screenWidth),
                          ),
                          child: Column(
                            children: [
                              Text(
                                _safeTranslate('choose_your_objective'),
                                style: TextStyle(
                                  fontSize: _getTitleFontSize(screenWidth, isTablet, isDesktop),
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryRed,
                                  fontFamily: 'GothamBold',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                _safeTranslate('select_one_objective'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: _getSubtitleFontSize(screenWidth, isTablet, isDesktop),
                                  color: AppColors.textSecondary,
                                  fontFamily: 'Gotham',
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: _getResponsiveSpacing(screenHeight, 0.02)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _getContentPadding(screenWidth, isTablet),
                          ),
                          child: Obx(() {
                            if (controller.loading.value) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (controller.objectives.isEmpty) {
                              return const Center(child: Text('No objectives available'));
                            }
                            return _buildObjectivesList(screenWidth, isTablet);
                          }),
                        ),
                        SizedBox(height: _getResponsiveSpacing(screenHeight, 0.03)),
                        Obx(
                              () => CustomJourneyMap(
                            progress: journeyController.progress.value,
                            steps: journeyController.steps,
                            completedSteps: journeyController.completedSteps,
                            onToggle: journeyController.toggleJourneyDetails,
                            showDetails: journeyController.showDetails.value,
                          ),
                        ),
                        SizedBox(height: _getResponsiveSpacing(screenHeight, 0.03)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _getButtonPadding(screenWidth, isTablet, isDesktop),
                          ),
                          child: Obx(
                                () => CustomButton2(
                              text: _safeTranslate('complete_selection'),
                              onPressed: controller.isButtonEnabled
                                  ? () => Get.offAllNamed(AppRoutes.keyResultsScreen)
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(height: _getResponsiveSpacing(screenHeight, 0.025)),
                      ],
                    ),
                  ),
                ),
              ),
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
  }

  Widget _buildObjectivesList(double screenWidth, bool isTablet) {
    final maxWidth = screenWidth > 1200 ? 1200.0 : screenWidth;

    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.accentRed,width: 2),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          SizedBox(height: 16.h),
          // Scrollable Objectives List
          Container(
            constraints: BoxConstraints(maxHeight: 400.h),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Obx(() => isTablet && screenWidth > 800
                  ? GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: AppDimensions.d16.w,
                  mainAxisSpacing: AppDimensions.d16.h,
                ),
                itemCount: filteredObjectives.length,
                itemBuilder: (context, index) => _buildObjectiveItem(index),
              )
                  : Column(
                children: List.generate(
                  filteredObjectives.length,
                      (index) => Padding(
                    padding: EdgeInsets.only(bottom: AppDimensions.d16.h),
                    child: _buildObjectiveItem(index),
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildObjectiveItem(int index) {
    final obj = filteredObjectives[index];
    final titleKey = obj.title;
    final descriptionKey = obj.description;

    // ✅ Make sure to return a Widget
    return CustomIndustryContainer(
      title: _safeTranslate(titleKey, fallback: 'Unknown'),
      description: _safeTranslate(descriptionKey, fallback: 'No description available'),
      icon: Icons.not_interested_outlined,
      isSelected: controller.isSelected(obj),
      onTap: () {
        controller.selectObjective(obj);
        if (controller.isSelected(obj)) {
          journeyController.progress.value = 40;
          journeyController.completeStep(0);
        } else {
          journeyController.progress.value = 20;
          journeyController.completedSteps[0] = false;
        }
      },
    );
  }

  double _getResponsiveSpacing(double dimension, double factor) => dimension * factor;

  double _getHorizontalPadding(double screenWidth) {
    if (screenWidth > 1200) return screenWidth * 0.08;
    if (screenWidth > 900) return screenWidth * 0.06;
    if (screenWidth > 600) return screenWidth * 0.05;
    return screenWidth * 0.04;
  }

  double _getContentPadding(double screenWidth, bool isTablet) =>
      isTablet ? screenWidth * 0.07 : screenWidth * 0.03;

  double _getButtonPadding(double screenWidth, bool isTablet, bool isDesktop) {
    if (isDesktop) return screenWidth * 0.25;
    if (isTablet) return screenWidth * 0.15;
    return screenWidth * 0.1;
  }

  double _getTitleFontSize(double screenWidth, bool isTablet, bool isDesktop) {
    if (isDesktop) return (screenWidth * 0.035).sp;
    if (isTablet) return (screenWidth * 0.04).sp;
    return (screenWidth * 0.055).sp;
  }

  double _getSubtitleFontSize(double screenWidth, bool isTablet, bool isDesktop) {
    if (isDesktop) return (screenWidth * 0.022).sp;
    if (isTablet) return (screenWidth * 0.026).sp;
    return (screenWidth * 0.038).sp;
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:game_app/utils/snackbar_helper.dart';
// import 'package:get/get.dart';
// import 'dart:developer';
//
// import '../../../controllers/journey_controller.dart';
// import '../../../controllers/key_objective_controller.dart';
// import '../../../core/app_colors.dart';
// import '../../../core/app_dimensions.dart';
// import '../../routes/app_routes.dart';
// import '../../widgets/custom_button2.dart';
// import '../../widgets/custom_home_navbar.dart';
// import '../../widgets/custom_industry_container.dart';
// import '../../widgets/custom_journey_map.dart';
// import '../../widgets/custom_objective_container.dart';
// import '../../widgets/screens_unique_parts/custom_background.dart';
// import '../../widgets/screens_unique_parts/custom_header.dart';
//
// class KeyObjectiveSelectedScreen extends StatelessWidget {
//   // ✅ REMOVED constructor parameters
//   KeyObjectiveSelectedScreen({super.key}) {
//     // Initialize controllers if not already registered
//     _initializeControllers();
//   }
//
//   // Initialize required controllers if not already registered
//   void _initializeControllers() {
//     if (!Get.isRegistered<JourneyController>()) {
//       Get.put(JourneyController(), permanent: true);
//     }
//     if (!Get.isRegistered<KeyObjectiveController>()) {
//       Get.put(KeyObjectiveController(), permanent: true);
//     }
//   }
//
//   // Get controllers using Get.find()
//   KeyObjectiveController get controller => Get.find<KeyObjectiveController>();
//   JourneyController get journeyController => Get.find<JourneyController>();
//
//   // Safely translate text with logging for debugging
//   String _safeTranslate(String? key, {String fallback = ''}) {
//     if (key == null) {
//       debugPrint('Translation key is null, returning fallback: $fallback');
//       return fallback;
//     }
//     try {
//       return key.tr;
//     } catch (e) {
//       debugPrint('Translation failed for key: $key, error: $e');
//       return fallback;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // ✅ GET ARGUMENTS FROM GETX
//     final args = Get.arguments as Map<String, dynamic>?;
//     final selectedRole = args?['selectedRole'] as Map<String, dynamic>?;
//     final selectedIndustry = args?['selectedIndustry'] as Map<String, dynamic>?;
//     // final strategy = args?['strategy'];
//
//     // Debug logs
//     log('════════════════════════════════════════');
//     log('📦 KeyObjectiveScreen BUILD CALLED');
//     log('Arguments: $args');
//     log('Role: $selectedRole');
//     log('Industry: $selectedIndustry');
//     // log('Strategy: $strategy');
//     log('Current Route: ${Get.currentRoute}');
//     log('════════════════════════════════════════');
//
//     // Initialize journey step and fetch objectives after widget is built
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       journeyController.setStep(0, true);
//
//       // ✅ FIXED: Check arguments properly
//       if (selectedRole != null && selectedIndustry != null) {
//         log('✅ Fetching objectives with valid role and industry');
//         await controller.getObjectives(selectedRole, selectedIndustry);
//       } else {
//         log('❌ Missing role or industry - navigating back');
//         SnackbarHelper.error('Please select both a role and an industry.');
//         // Navigate back to selection screen
//         await Future.delayed(const Duration(seconds: 1));
//         Get.offAllNamed(AppRoutes.selectStrategy, arguments: {
//           'selectedRole': selectedRole,
//           'selectedIndustry': selectedIndustry,
//         });
//       }
//     });
//
//     final mediaQuery = MediaQuery.of(context);
//     final screenWidth = mediaQuery.size.width;
//     final screenHeight = mediaQuery.size.height;
//
//     // Responsive calculations
//     final isTablet = screenWidth > 600;
//     final isDesktop = screenWidth > 900;
//
//     return Scaffold(
//       body: CustomBackground(
//         child: SafeArea(
//           child: Stack(
//             children: [
//               // Scrollable Content
//               Positioned.fill(
//                 child: SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   child: Padding(
//                     padding: EdgeInsets.only(
//                       bottom: _getResponsiveSpacing(screenHeight, 0.025),
//                     ),
//                     child: Column(
//                       children: [
//                         SizedBox(height: screenHeight * 0.03),
//
//                         // Custom Header
//                         CustomHeader(
//                           title: _safeTranslate('choose'),
//                           highlightedText: _safeTranslate('objective'),
//                           onBackTap: () => Get.offAllNamed(
//                             AppRoutes.selectStrategy,
//                             arguments: {
//                               'selectedRole': selectedRole,
//                               'selectedIndustry': selectedIndustry,
//                             },
//                           ),
//                         ),
//
//                         SizedBox(height: screenHeight * 0.02),
//
//                         // Selected Strategy Container
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: _getHorizontalPadding(screenWidth),
//                           ),
//                           child: CustomObjectiveContainer(
//                             title: _safeTranslate('selected_strategy'),
//                             // subtitle: strategy?.strategy ?? _safeTranslate('development_new_markets'),
//                             // description: strategy?.description ?? _safeTranslate('objective_description'),
//                             icon: Icons.emoji_objects,
//                           ),
//                         ),
//
//                         SizedBox(height: _getResponsiveSpacing(screenHeight, 0.025)),
//
//                         // Choose Your Objective Title
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: _getHorizontalPadding(screenWidth),
//                           ),
//                           child: Column(
//                             children: [
//                               Text(
//                                 _safeTranslate('choose_your_objective'),
//                                 style: TextStyle(
//                                   fontSize: _getTitleFontSize(screenWidth, isTablet, isDesktop),
//                                   fontWeight: FontWeight.bold,
//                                   color: AppColors.primaryRed,
//                                   fontFamily: 'GothamBold',
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                               SizedBox(height: screenHeight * 0.01),
//                               Text(
//                                 _safeTranslate('select_one_objective'),
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontSize: _getSubtitleFontSize(screenWidth, isTablet, isDesktop),
//                                   color: AppColors.textSecondary,
//                                   fontFamily: 'Gotham',
//                                   height: 1.4,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         SizedBox(height: _getResponsiveSpacing(screenHeight, 0.02)),
//
//                         // Objectives List
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: _getContentPadding(screenWidth, isTablet),
//                           ),
//                           child: Obx(() {
//                             if (controller.loading.value) {
//                               return const Center(child: CircularProgressIndicator());
//                             }
//                             if (controller.objectives.isEmpty) {
//                               return const Center(child: Text('No objectives available'));
//                             }
//                             return _buildObjectivesList(screenWidth, isTablet);
//                           }),
//                         ),
//
//                         SizedBox(height: _getResponsiveSpacing(screenHeight, 0.03)),
//
//                         // Journey Map
//                         Obx(
//                               () => CustomJourneyMap(
//                             progress: journeyController.progress.value,
//                             steps: journeyController.steps,
//                             completedSteps: journeyController.completedSteps,
//                             onToggle: journeyController.toggleJourneyDetails,
//                             showDetails: journeyController.showDetails.value,
//                           ),
//                         ),
//
//                         SizedBox(height: _getResponsiveSpacing(screenHeight, 0.03)),
//
//                         // Complete Selection Button
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: _getButtonPadding(screenWidth, isTablet, isDesktop),
//                           ),
//                           child: Obx(
//                                 () => CustomButton2(
//                               text: _safeTranslate('complete_selection'),
//                               onPressed: controller.isButtonEnabled
//                                   ? () => Get.offAllNamed(AppRoutes.keyResultsScreen)
//                                   : null,
//                             ),
//                           ),
//                         ),
//
//                         SizedBox(height: _getResponsiveSpacing(screenHeight, 0.025)),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Floating Navigation Bar
//               Positioned(
//                 right: screenWidth * -0.07,
//                 top: screenHeight * 0.50,
//                 child: const CustomHomeNavBar(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Build objectives list with responsive layout
//   Widget _buildObjectivesList(double screenWidth, bool isTablet) {
//     final maxWidth = screenWidth > 1200 ? 1200.0 : screenWidth;
//     if (isTablet && screenWidth > 800) {
//       return Container(
//         constraints: BoxConstraints(maxWidth: maxWidth),
//         child: GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             childAspectRatio: 1.2,
//             crossAxisSpacing: AppDimensions.d16.w,
//             mainAxisSpacing: AppDimensions.d16.h,
//           ),
//           itemCount: controller.objectives.length,
//           itemBuilder: (context, index) => _buildObjectiveItem(index),
//         ),
//       );
//     }
//
//     return Container(
//       constraints: BoxConstraints(maxWidth: maxWidth),
//       child: Column(
//         children: List.generate(
//           controller.objectives.length,
//               (index) => Padding(
//             padding: EdgeInsets.only(bottom: AppDimensions.d16.h),
//             child: _buildObjectiveItem(index),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Build individual objective item
//   Widget _buildObjectiveItem(int index) {
//     final obj = controller.objectives[index];
//     final titleKey = obj.title;
//     final descriptionKey = obj.description;
//
//     return CustomIndustryContainer(
//       title: _safeTranslate(titleKey, fallback: 'Unknown'),
//       description: _safeTranslate(descriptionKey, fallback: 'No description available'),
//       icon: Icons.not_interested_outlined,
//       isSelected: controller.isSelected(obj),
//       onTap: () {
//         controller.selectObjective(obj);
//         if (controller.isSelected(obj)) {
//           journeyController.progress.value = 40;
//           journeyController.completeStep(0);
//         } else {
//           journeyController.progress.value = 20;
//           journeyController.completedSteps[0] = false;
//         }
//       },
//     );
//   }
//
//   // Responsive spacing and padding helpers
//   double _getResponsiveSpacing(double dimension, double factor) => dimension * factor;
//
//   double _getHorizontalPadding(double screenWidth) {
//     if (screenWidth > 1200) return screenWidth * 0.08;
//     if (screenWidth > 900) return screenWidth * 0.06;
//     if (screenWidth > 600) return screenWidth * 0.05;
//     return screenWidth * 0.04;
//   }
//
//   double _getContentPadding(double screenWidth, bool isTablet) =>
//       isTablet ? screenWidth * 0.07 : screenWidth * 0.03;
//
//   double _getButtonPadding(double screenWidth, bool isTablet, bool isDesktop) {
//     if (isDesktop) return screenWidth * 0.25;
//     if (isTablet) return screenWidth * 0.15;
//     return screenWidth * 0.1;
//   }
//
//   double _getTitleFontSize(double screenWidth, bool isTablet, bool isDesktop) {
//     if (isDesktop) return (screenWidth * 0.035).sp;
//     if (isTablet) return (screenWidth * 0.04).sp;
//     return (screenWidth * 0.055).sp;
//   }
//
//   double _getSubtitleFontSize(double screenWidth, bool isTablet, bool isDesktop) {
//     if (isDesktop) return (screenWidth * 0.022).sp;
//     if (isTablet) return (screenWidth * 0.026).sp;
//     return (screenWidth * 0.038).sp;
//   }
// }
// // code comment kia ha to ye chal rha ha
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:game_app/utils/snackbar_helper.dart';
// // import 'package:get/get.dart';
// // import '../../../controllers/journey_controller.dart';
// // import '../../../controllers/key_objective_controller.dart';
// // import '../../../core/app_colors.dart';
// // import '../../../core/app_dimensions.dart';
// // import '../../routes/app_routes.dart';
// // import '../../widgets/custom_button2.dart';
// // import '../../widgets/custom_home_navbar.dart';
// // import '../../widgets/custom_industry_container.dart';
// // import '../../widgets/custom_journey_map.dart';
// // import '../../widgets/custom_objective_container.dart';
// // import '../../widgets/screens_unique_parts/custom_background.dart';
// // import '../../widgets/screens_unique_parts/custom_header.dart';
// //
// // class KeyObjectiveSelectedScreen extends StatelessWidget {
// //   final Map<String, dynamic>? selectedRole;
// //   final Map<String, dynamic>? selectedIndustry;
// //
// //   KeyObjectiveSelectedScreen({
// //     super.key,
// //     this.selectedRole,
// //     this.selectedIndustry,
// //   }) {
// //     // Initialize controllers if not already registered (fallback in case main.dart setup is missed)
// //     _initializeControllers();
// //   }
// //
// //   // Initialize required controllers if not already registered
// //   void _initializeControllers() {
// //     if (!Get.isRegistered<JourneyController>()) {
// //       Get.put(JourneyController(), permanent: true);
// //     }
// //     if (!Get.isRegistered<KeyObjectiveController>()) {
// //       Get.put(KeyObjectiveController(), permanent: true);
// //     }
// //   }
// //
// //   // Get controllers using Get.find()
// //   KeyObjectiveController get controller => Get.find<KeyObjectiveController>();
// //   JourneyController get journeyController => Get.find<JourneyController>();
// //
// //   // Safely translate text with logging for debugging
// //   String _safeTranslate(String? key, {String fallback = ''}) {
// //     if (key == null) {
// //       debugPrint('Translation key is null, returning fallback: $fallback');
// //       return fallback;
// //     }
// //     try {
// //       return key.tr;
// //     } catch (e) {
// //       debugPrint('Translation failed for key: $key, error: $e');
// //       return fallback;
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     // Initialize journey step and fetch objectives after widget is built
// //     WidgetsBinding.instance.addPostFrameCallback((_) async {
// //       journeyController.setStep(0, true);
// //       if (selectedRole != null && selectedIndustry != null) {
// //         await controller.getObjectives(selectedRole!, selectedIndustry!);
// //       } else {
// //         SnackbarHelper.error('Please select both a role and an industry.');
// //         // Navigate back to selection screen to prevent invalid state
// //         await Future.delayed(const Duration(seconds: 1));
// //         Get.offAllNamed(AppRoutes.selectStrategy);
// //       }
// //     });
// //
// //     final mediaQuery = MediaQuery.of(context);
// //     final screenWidth = mediaQuery.size.width;
// //     final screenHeight = mediaQuery.size.height;
// //
// //     // Responsive calculations
// //     final isTablet = screenWidth > 600;
// //     final isDesktop = screenWidth > 900;
// //
// //     return Scaffold(
// //       body: CustomBackground(
// //         child: SafeArea(
// //           child: Stack(
// //             children: [
// //               // Scrollable Content
// //               Positioned.fill(
// //                 child: SingleChildScrollView(
// //                   physics: const BouncingScrollPhysics(),
// //                   child: Padding(
// //                     padding: EdgeInsets.only(
// //                       bottom: _getResponsiveSpacing(screenHeight, 0.025),
// //                     ),
// //                     child: Column(
// //                       children: [
// //                         SizedBox(height: screenHeight * 0.03),
// //
// //                         // Custom Header
// //                         CustomHeader(
// //                           title: _safeTranslate('choose'),
// //                           highlightedText: _safeTranslate('objective'),
// //                           onBackTap: () => Get.offAllNamed(AppRoutes.selectStrategy),
// //                         ),
// //
// //                         SizedBox(height: screenHeight * 0.02),
// //
// //                         // Selected Strategy Container
// //                         Padding(
// //                           padding: EdgeInsets.symmetric(
// //                             horizontal: _getHorizontalPadding(screenWidth),
// //                           ),
// //                           child: CustomObjectiveContainer(
// //                             title: _safeTranslate('selected_strategy'),
// //                             subtitle: _safeTranslate('development_new_markets'),
// //                             description: _safeTranslate('objective_description'),
// //                             icon: Icons.emoji_objects,
// //                           ),
// //                         ),
// //
// //                         SizedBox(height: _getResponsiveSpacing(screenHeight, 0.025)),
// //
// //                         // Choose Your Objective Title
// //                         Padding(
// //                           padding: EdgeInsets.symmetric(
// //                             horizontal: _getHorizontalPadding(screenWidth),
// //                           ),
// //                           child: Column(
// //                             children: [
// //                               Text(
// //                                 _safeTranslate('choose_your_objective'),
// //                                 style: TextStyle(
// //                                   fontSize: _getTitleFontSize(screenWidth, isTablet, isDesktop),
// //                                   fontWeight: FontWeight.bold,
// //                                   color: AppColors.primaryRed,
// //                                   fontFamily: 'GothamBold',
// //                                 ),
// //                                 textAlign: TextAlign.center,
// //                               ),
// //                               SizedBox(height: screenHeight * 0.01),
// //                               Text(
// //                                 _safeTranslate('select_one_objective'),
// //                                 textAlign: TextAlign.center,
// //                                 style: TextStyle(
// //                                   fontSize: _getSubtitleFontSize(screenWidth, isTablet, isDesktop),
// //                                   color: AppColors.textSecondary,
// //                                   fontFamily: 'Gotham',
// //                                   height: 1.4,
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),
// //
// //                         SizedBox(height: _getResponsiveSpacing(screenHeight, 0.02)),
// //
// //                         // Objectives List
// //                         Padding(
// //                           padding: EdgeInsets.symmetric(
// //                             horizontal: _getContentPadding(screenWidth, isTablet),
// //                           ),
// //                           child: Obx(() {
// //                             if (controller.loading.value) {
// //                               return const Center(child: CircularProgressIndicator());
// //                             }
// //                             if (controller.objectives.isEmpty) {
// //                               return const Center(child: Text('No objectives available'));
// //                             }
// //                             return _buildObjectivesList(screenWidth, isTablet);
// //                           }),
// //                         ),
// //
// //                         SizedBox(height: _getResponsiveSpacing(screenHeight, 0.03)),
// //
// //                         // Journey Map
// //                         Obx(
// //                               () => CustomJourneyMap(
// //                             progress: journeyController.progress.value,
// //                             steps: journeyController.steps,
// //                             completedSteps: journeyController.completedSteps,
// //                             onToggle: journeyController.toggleJourneyDetails,
// //                             showDetails: journeyController.showDetails.value,
// //                           ),
// //                         ),
// //
// //                         SizedBox(height: _getResponsiveSpacing(screenHeight, 0.03)),
// //
// //                         // Complete Selection Button
// //                         Padding(
// //                           padding: EdgeInsets.symmetric(
// //                             horizontal: _getButtonPadding(screenWidth, isTablet, isDesktop),
// //                           ),
// //                           child: Obx(
// //                                 () => CustomButton2(
// //                               text: _safeTranslate('complete_selection'),
// //                               onPressed: controller.isButtonEnabled
// //                                   ? () => Get.offAllNamed(AppRoutes.keyResultsScreen)
// //                                   : null,
// //                             ),
// //                           ),
// //                         ),
// //
// //                         SizedBox(height: _getResponsiveSpacing(screenHeight, 0.025)),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //
// //               // Floating Navigation Bar
// //               Positioned(
// //                 right: screenWidth * -0.07,
// //                 top: screenHeight * 0.50,
// //                 child: const CustomHomeNavBar(),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // Build objectives list with responsive layout
// //   Widget _buildObjectivesList(double screenWidth, bool isTablet) {
// //     final maxWidth = screenWidth > 1200 ? 1200.0 : screenWidth;
// //     if (isTablet && screenWidth > 800) {
// //       return Container(
// //         constraints: BoxConstraints(maxWidth: maxWidth),
// //         child: GridView.builder(
// //           shrinkWrap: true,
// //           physics: const NeverScrollableScrollPhysics(),
// //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //             crossAxisCount: 2,
// //             childAspectRatio: 1.2,
// //             crossAxisSpacing: AppDimensions.d16.w,
// //             mainAxisSpacing: AppDimensions.d16.h,
// //           ),
// //           itemCount: controller.objectives.length,
// //           itemBuilder: (context, index) => _buildObjectiveItem(index),
// //         ),
// //       );
// //     }
// //
// //     return Container(
// //       constraints: BoxConstraints(maxWidth: maxWidth),
// //       child: Column(
// //         children: List.generate(
// //           controller.objectives.length,
// //               (index) => Padding(
// //             padding: EdgeInsets.only(bottom: AppDimensions.d16.h),
// //             child: _buildObjectiveItem(index),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // Build individual objective item
// //   Widget _buildObjectiveItem(int index) {
// //     final obj = controller.objectives[index];
// //     final titleKey = obj.title;
// //     final descriptionKey = obj.description;
// //
// //     return CustomIndustryContainer(
// //       title: _safeTranslate(titleKey, fallback: 'Unknown'),
// //       description: _safeTranslate(descriptionKey, fallback: 'No description available'),
// //       icon: Icons.not_interested_outlined,
// //       isSelected: controller.isSelected(obj),
// //       onTap: () {
// //         controller.selectObjective(obj);
// //         if (controller.isSelected(obj)) {
// //           journeyController.progress.value = 40;
// //           journeyController.completeStep(0);
// //         } else {
// //           journeyController.progress.value = 20;
// //           journeyController.completedSteps[0] = false;
// //         }
// //       },
// //     );
// //   }
// //
// //   // Responsive spacing and padding helpers
// //   double _getResponsiveSpacing(double dimension, double factor) => dimension * factor;
// //
// //   double _getHorizontalPadding(double screenWidth) {
// //     if (screenWidth > 1200) return screenWidth * 0.08;
// //     if (screenWidth > 900) return screenWidth * 0.06;
// //     if (screenWidth > 600) return screenWidth * 0.05;
// //     return screenWidth * 0.04;
// //   }
// //
// //   double _getContentPadding(double screenWidth, bool isTablet) =>
// //       isTablet ? screenWidth * 0.07 : screenWidth * 0.03;
// //
// //   double _getButtonPadding(double screenWidth, bool isTablet, bool isDesktop) {
// //     if (isDesktop) return screenWidth * 0.25;
// //     if (isTablet) return screenWidth * 0.15;
// //     return screenWidth * 0.1;
// //   }
// //
// //   double _getTitleFontSize(double screenWidth, bool isTablet, bool isDesktop) {
// //     if (isDesktop) return (screenWidth * 0.035).sp;
// //     if (isTablet) return (screenWidth * 0.04).sp;
// //     return (screenWidth * 0.055).sp;
// //   }
// //
// //   double _getSubtitleFontSize(double screenWidth, bool isTablet, bool isDesktop) {
// //     if (isDesktop) return (screenWidth * 0.022).sp;
// //     if (isTablet) return (screenWidth * 0.026).sp;
// //     return (screenWidth * 0.038).sp;
// //   }
// // }