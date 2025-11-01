import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/utils/snackbar_helper.dart';
import 'package:get/get.dart';
import 'dart:developer';

import '../../../controllers/journey_controller.dart';
import '../../../controllers/key_objective_controller.dart';
import '../../../controllers/strategy_selection_controller.dart'; // ✅ ADD THIS IMPORT
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
  State<KeyObjectiveSelectedScreen> createState() => _KeyObjectiveSelectedScreenState(

  );
}

class _KeyObjectiveSelectedScreenState extends State<KeyObjectiveSelectedScreen> {
  final TextEditingController searchController = TextEditingController();
  final RxList<Objective> filteredObjectives = RxList<Objective>();
  final KeyObjectiveController controller = Get.find<KeyObjectiveController>();
  final JourneyController journeyController = Get.find<JourneyController>();
  final StrategySelectionController strategyController = Get.find<StrategySelectionController>(); // ✅ ADD THIS

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
    if (!Get.isRegistered<StrategySelectionController>()) {
      Get.put(StrategySelectionController(), permanent: true);
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

  // ✅ NEW: Get strategy display text
  String _getStrategyDisplayText() {
    final strategy = strategyController.selectedStrategy.value;
    if (strategy == null) {
      return 'No strategy selected';
    }
    return strategy.title ?? 'Unknown Strategy';
  }

  // ✅ NEW: Get strategy description
  String _getStrategyDescription() {
    final strategy = strategyController.selectedStrategy.value;
    if (strategy == null) {
      return 'Please go back and select a strategy';
    }
    // You can customize this based on your strategy response structure
    return 'Your selected approach for this mission';
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
    log('Selected Strategy: ${strategyController.selectedStrategy.value?.title}'); // ✅ LOG STRATEGY
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

                        // ✅ UPDATED: Show selected strategy with actual strategy data
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _getHorizontalPadding(screenWidth),
                          ),
                          child: Obx(() => CustomObjectiveContainer(
                            title: _safeTranslate('selected_strategy'), // ✅ Use actual strategy title
                            subtitle:  _getStrategyDisplayText(),// ✅ This becomes the subtitle
                            //description: _getStrategyDescription(), // ✅ Strategy description
                            icon: Icons.emoji_objects,
                            titleColor: AppColors.primaryRed,
                          )),
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

  // ... rest of your methods remain the same ...
  Widget _buildObjectivesList(double screenWidth, bool isTablet) {
    final maxWidth = screenWidth > 1200 ? 1200.0 : screenWidth;

    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.accentRed, width: 2),
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
          // Scrollable Objectives List with Scrollbar
          Container(
            constraints: BoxConstraints(maxHeight: 400.h),
            child: Scrollbar(
              thumbVisibility: true, // Always show scrollbar
              trackVisibility: true, // Show track too
              thickness: 8.w, // Custom thickness
              radius: Radius.circular(10.r), // Rounded scrollbar
              child: Obx(() => isTablet && screenWidth > 800
                  ? GridView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(), // ✅ FIXED: Enable scrolling
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: AppDimensions.d16.w,
                  mainAxisSpacing: AppDimensions.d16.h,
                ),
                itemCount: filteredObjectives.length,
                itemBuilder: (context, index) => _buildObjectiveItem(index),
              )
                  : ListView.builder( // ✅ FIXED: Use ListView.builder for better performance
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(), // ✅ FIXED: Enable scrolling
                itemCount: filteredObjectives.length,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: AppDimensions.d16.h),
                  child: _buildObjectiveItem(index),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }


  // Add this method to your _KeyObjectiveSelectedScreenState class
  IconData _getRandomObjectiveIcon() {
    final randomIcons = [
      Icons.flag,
      Icons.star,
      Icons.rocket_launch,
      Icons.trending_up,
      Icons.lightbulb,
      Icons.auto_awesome,
      Icons.bolt,
      Icons.workspace_premium,
      Icons.emoji_events,
      Icons.assignment_turned_in,
      Icons.track_changes,
      Icons.insights,
      Icons.bar_chart,
      Icons.show_chart,
      Icons.pie_chart,
      Icons.account_tree,
      Icons.dashboard,
      Icons.timeline,
      Icons.multiline_chart,
      Icons.stacked_line_chart,
    ];

    // Get random icon based on index for consistency
    final random = Random();
    return randomIcons[random.nextInt(randomIcons.length)];
  }

// Or for consistent icons per objective (better UX):
  IconData _getObjectiveIcon(int index) {
    final icons = [
      Icons.flag,
      Icons.star,
      Icons.rocket_launch,
      Icons.trending_up,
      Icons.lightbulb,
      Icons.auto_awesome,
      Icons.bolt,
      Icons.workspace_premium,
      Icons.emoji_events,
      Icons.assignment_turned_in,
    ];

    return icons[index % icons.length];
  }
  Widget _buildObjectiveItem(int index) {
    final obj = filteredObjectives[index];
    final titleKey = obj.title;
    final descriptionKey = obj.description;

    return Obx(() {
      final isSelected = controller.isSelected(obj);

      return Container(
        margin: EdgeInsets.only(bottom: AppDimensions.d16.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primaryRed : Colors.transparent,
            width: 3.0,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: CustomIndustryContainer(
          title: _safeTranslate(titleKey, fallback: 'Unknown'),
          description: _safeTranslate(descriptionKey, fallback: 'No description available'),
          icon: _getObjectiveIcon(index),
          isSelected: isSelected,
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
        ),
      );
    });
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
// import '../../../generated/models/responses/objectives/objectives_response.dart';
// import '../../routes/app_routes.dart';
// import '../../widgets/custom_button2.dart';
// import '../../widgets/custom_home_navbar.dart';
// import '../../widgets/custom_industry_container.dart';
// import '../../widgets/custom_journey_map.dart';
// import '../../widgets/custom_objective_container.dart';
// import '../../widgets/screens_unique_parts/custom_background.dart';
// import '../../widgets/screens_unique_parts/custom_header.dart';
//
// class KeyObjectiveSelectedScreen extends StatefulWidget {
//   const KeyObjectiveSelectedScreen({super.key});
//
//   @override
//   State<KeyObjectiveSelectedScreen> createState() => _KeyObjectiveSelectedScreenState();
// }
//
// class _KeyObjectiveSelectedScreenState extends State<KeyObjectiveSelectedScreen> {
//   final TextEditingController searchController = TextEditingController();
//   final RxList<Objective> filteredObjectives = RxList<Objective>();
//   final KeyObjectiveController controller = Get.find<KeyObjectiveController>();
//   final JourneyController journeyController = Get.find<JourneyController>();
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeControllers();
//     // Initialize filteredObjectives with controller.objectives
//     filteredObjectives.assignAll(controller.objectives);
//     // Update filteredObjectives when controller.objectives changes
//     ever(controller.objectives, (_) {
//       filteredObjectives.assignAll(controller.objectives);
//       // Apply current search filter if search text exists
//       if (searchController.text.isNotEmpty) {
//         filterObjectives(searchController.text);
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
//
//   void _initializeControllers() {
//     if (!Get.isRegistered<JourneyController>()) {
//       Get.put(JourneyController(), permanent: true);
//     }
//     if (!Get.isRegistered<KeyObjectiveController>()) {
//       Get.put(KeyObjectiveController(), permanent: true);
//     }
//   }
//
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
//   void filterObjectives(String query) {
//     if (query.isEmpty) {
//       filteredObjectives.assignAll(controller.objectives);
//     } else {
//       filteredObjectives.assignAll(
//         controller.objectives.where((obj) {
//           final translatedTitle = obj.title?.tr ?? '';
//           final translatedDescription = obj.description?.tr ?? '';
//           return translatedTitle.toLowerCase().contains(query.toLowerCase()) ||
//               translatedDescription.toLowerCase().contains(query.toLowerCase());
//         }).toList(),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final args = Get.arguments as Map<String, dynamic>?;
//     final selectedRole = args?['selectedRole'] as Map<String, dynamic>?;
//     final selectedIndustry = args?['selectedIndustry'] as Map<String, dynamic>?;
//     final isCampaignMode = args?['isCampaignMode'] as bool? ?? false;
//
//     log('════════════════════════════════════════');
//     log('📦 KeyObjectiveScreen BUILD CALLED');
//     log('Arguments: $args');
//     log('Role: $selectedRole');
//     log('Industry: $selectedIndustry');
//     log('Campaign Mode: $isCampaignMode');
//     log('Current Route: ${Get.currentRoute}');
//     log('════════════════════════════════════════');
//
//     // ✅ Handle campaign mode - use organization as industry
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       journeyController.setStep(0, true);
//
//       if (isCampaignMode) {
//         log('🎯 Campaign mode detected - using organization as industry');
//         // In campaign mode, we should have both role and organization
//         if (selectedRole != null && selectedIndustry != null) {
//           log('✅ Campaign mode: Fetching objectives with role and organization');
//           await controller.getObjectives(selectedRole, selectedIndustry);
//         } else {
//           log('❌ Campaign mode: Missing role or organization data');
//           SnackbarHelper.error('Missing campaign data. Please restart the campaign.');
//         }
//       } else {
//         // Original solo mode logic
//         if (selectedRole != null && selectedIndustry != null) {
//           log('✅ Solo mode: Fetching objectives with valid role and industry');
//           await controller.getObjectives(selectedRole, selectedIndustry);
//         } else {
//           log('❌ Solo mode: Missing role or industry - navigating back');
//           SnackbarHelper.error('Please select both a role and an industry.');
//           await Future.delayed(const Duration(seconds: 1));
//           Get.offAllNamed(AppRoutes.selectStrategy, arguments: {
//             'selectedRole': selectedRole,
//             'selectedIndustry': selectedIndustry,
//           });
//         }
//       }
//     });
//
//     final mediaQuery = MediaQuery.of(context);
//     final screenWidth = mediaQuery.size.width;
//     final screenHeight = mediaQuery.size.height;
//
//     final isTablet = screenWidth > 600;
//     final isDesktop = screenWidth > 900;
//
//     return Scaffold(
//       body: CustomBackground(
//         child: SafeArea(
//           child: Stack(
//             children: [
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
//                         CustomHeader(
//                           title: _safeTranslate('choose'),
//                           highlightedText: _safeTranslate('objective'),
//                           onBackTap: () => Get.offAllNamed(
//                             AppRoutes.selectStrategy,
//                             arguments: {
//                               'selectedRole': selectedRole,
//                               'selectedIndustry': selectedIndustry,
//                               'isCampaignMode': isCampaignMode, // ✅ Pass campaign mode flag back
//                             },
//                           ),
//                         ),
//                         SizedBox(height: screenHeight * 0.02),
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: _getHorizontalPadding(screenWidth),
//                           ),
//                           child: CustomObjectiveContainer(
//                             title: _safeTranslate('selected_strategy'),
//                             icon: Icons.emoji_objects,
//
//                           ),
//                         ),
//                         SizedBox(height: _getResponsiveSpacing(screenHeight, 0.025)),
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
//                         SizedBox(height: _getResponsiveSpacing(screenHeight, 0.02)),
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
//                         SizedBox(height: _getResponsiveSpacing(screenHeight, 0.03)),
//                         Obx(
//                               () => CustomJourneyMap(
//                             progress: journeyController.progress.value,
//                             steps: journeyController.steps,
//                             completedSteps: journeyController.completedSteps,
//                             onToggle: journeyController.toggleJourneyDetails,
//                             showDetails: journeyController.showDetails.value,
//                           ),
//                         ),
//                         SizedBox(height: _getResponsiveSpacing(screenHeight, 0.03)),
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
//                         SizedBox(height: _getResponsiveSpacing(screenHeight, 0.025)),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
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
//   Widget _buildObjectivesList(double screenWidth, bool isTablet) {
//     final maxWidth = screenWidth > 1200 ? 1200.0 : screenWidth;
//
//     return Container(
//       constraints: BoxConstraints(maxWidth: maxWidth),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         border: Border.all(color: AppColors.accentRed, width: 2),
//         borderRadius: BorderRadius.circular(12.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 8.r,
//             offset: Offset(0, 2.h),
//           ),
//         ],
//       ),
//       padding: EdgeInsets.all(16.w),
//       child: Column(
//         children: [
//           SizedBox(height: 16.h),
//           // Scrollable Objectives List with Scrollbar
//           Container(
//             constraints: BoxConstraints(maxHeight: 400.h),
//             child: Scrollbar(
//               thumbVisibility: true, // Always show scrollbar
//               trackVisibility: true, // Show track too
//               thickness: 8.w, // Custom thickness
//               radius: Radius.circular(10.r), // Rounded scrollbar
//               child: Obx(() => isTablet && screenWidth > 800
//                   ? GridView.builder(
//                 shrinkWrap: true,
//                 physics: const AlwaysScrollableScrollPhysics(), // ✅ FIXED: Enable scrolling
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 1.2,
//                   crossAxisSpacing: AppDimensions.d16.w,
//                   mainAxisSpacing: AppDimensions.d16.h,
//                 ),
//                 itemCount: filteredObjectives.length,
//                 itemBuilder: (context, index) => _buildObjectiveItem(index),
//               )
//                   : ListView.builder( // ✅ FIXED: Use ListView.builder for better performance
//                 shrinkWrap: true,
//                 physics: const AlwaysScrollableScrollPhysics(), // ✅ FIXED: Enable scrolling
//                 itemCount: filteredObjectives.length,
//                 itemBuilder: (context, index) => Padding(
//                   padding: EdgeInsets.only(bottom: AppDimensions.d16.h),
//                   child: _buildObjectiveItem(index),
//                 ),
//               )),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   Widget _buildObjectiveItem(int index) {
//     final obj = filteredObjectives[index];
//     final titleKey = obj.title;
//     final descriptionKey = obj.description;
//
//     // ✅ Make sure to return a Widget
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