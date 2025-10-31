import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/view_model/key_result_latest_view_model.dart';
import 'package:get/get.dart';
import '../../../controllers/journey_controller.dart';
import '../../../controllers/okr_constellation_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';

import '../../../generated/models/requests/key_results_latest_model.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_industry_container.dart';
import '../../widgets/custom_journey_map.dart';
import '../../widgets/custom_objective_container.dart';
import '../../widgets/custom_okr_constellation.dart';
import '../../widgets/custom_selected_key_result_container.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import '../suggestion_Initiatives/suggestion_initiatives_creen.dart';

import '../../../controllers/key_objective_controller.dart';
import '../../../controllers/strategy_selection_controller.dart';
import '../../../controllers/language_controller.dart';
import '../../../services/shared_preference.dart';

class KeyResultsScreen extends StatefulWidget {
  const KeyResultsScreen({super.key});

  @override
  State<KeyResultsScreen> createState() => _KeyResultsScreenState();
}

class _KeyResultsScreenState extends State<KeyResultsScreen> {
  // Use the new latest viewmodel
  final KeyResultsLatestViewModel keyResultsViewModel = Get.put(KeyResultsLatestViewModel());
  final OKRConstellationController constellationController = Get.put(OKRConstellationController());
  final JourneyController journeyController = Get.find<JourneyController>();
  final KeyObjectiveController objectiveController = Get.find<KeyObjectiveController>();
  final StrategySelectionController strategyController = Get.find<StrategySelectionController>();
  final LanguageController languageController = Get.find<LanguageController>();

  // Add ScrollController for the list
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeKeyResults();
  }

  void _initializeKeyResults() async {
    print('🚀 Initializing Key Results...');

    // Get all required data
    final selectedRole = await _getSelectedRole();
    final selectedStrategy = await _getSelectedStrategy();
    final selectedObjectives = await _getSelectedObjectives(); // ✅ Get multiple objectives
    final selectedLanguage = await _getSelectedLanguage();

    print('📋 Data Summary:');
    print('   - Strategy: $selectedStrategy');
    print('   - Objectives: $selectedObjectives');
    print('   - Role: $selectedRole');
    print('   - Language: $selectedLanguage');

    if (selectedObjectives.isEmpty || selectedStrategy == null || selectedRole == null) {
      print('❌ Missing required data for API call');
      return;
    }

    // Generate key results using the new viewmodel
    keyResultsViewModel.generateKeyResults(
      strategy: selectedStrategy,
      objectives: selectedObjectives, // ✅ Send multiple objectives
      role: selectedRole,
      language: selectedLanguage,
    );
  }

  // ✅ UPDATED: Get multiple objectives for API
  Future<List<String>> _getSelectedObjectives() async {
    try {
      final List<String> objectives = [];

      // Add the selected objective first
      final selectedObjective = objectiveController.selectedObjective.value;
      if (selectedObjective?.title != null && selectedObjective!.title!.isNotEmpty) {
        print('🎯 Selected Objective: ${selectedObjective.title}');
        objectives.add(selectedObjective.title!);
      }

      // Add diverse HR objectives to reach 8
      final diverseHRObjectives = [
        'Improve Employee Retention',
        'Enhance Training and Development Programs',
        'Boost Employee Morale and Engagement',
        'Develop Leadership Pipeline',
        'Improve Work-Life Balance Initiatives',
        'Enhance Diversity and Inclusion',
        'Strengthen Employer Brand',
        'Optimize Performance Management System',
        'Increase Employee Productivity',
        'Reduce Recruitment Costs',
        'Improve Onboarding Process',
        'Enhance Employee Benefits Package',
        'Strengthen Internal Communications',
        'Develop Succession Planning',
        'Improve Health and Wellness Programs',
        'Increase Cross-Department Collaboration'
      ];

      // Shuffle and take unique objectives until we have 8
      final shuffledObjectives = List.from(diverseHRObjectives)..shuffle();

      for (final objective in shuffledObjectives) {
        if (objectives.length < 8 && !objectives.contains(objective)) {
          objectives.add(objective);
        }
        if (objectives.length >= 8) break;
      }

      print('🎯 Final Objectives for API: $objectives');
      return objectives;

    } catch (e) {
      print('❌ Error getting objectives: $e');
      // Fallback to diverse objectives
      return [
        'Boost Employee Engagement',
        'Improve Employee Retention',
        'Enhance Training Programs',
        'Develop Leadership Skills',
        'Improve Work-Life Balance',
        'Enhance Diversity and Inclusion',
        'Strengthen Employer Brand',
        'Optimize Performance Management'
      ];
    }
  }

  // Get selected role from SharedPreferences or arguments
  Future<String?> _getSelectedRole() async {
    try {
      // Try to get from SharedPreferences first
      final roleData = await SharedPrefs.getSelectedRole();
      if (roleData != null && roleData['titleKey'] != null) {
        final role = roleData['titleKey'].toString();
        print('👤 Role from SharedPrefs: $role');
        return role;
      }

      // Fallback to controller data or arguments
      final args = Get.arguments as Map<String, dynamic>?;
      final roleFromArgs = args?['selectedRole'] as Map<String, dynamic>?;
      if (roleFromArgs != null && roleFromArgs['titleKey'] != null) {
        final role = roleFromArgs['titleKey'].toString();
        print('👤 Role from arguments: $role');
        return role;
      }

      // Check if we have role data stored in other SharedPreferences keys
      final userRole = SharedPrefs.getUserRole();
      if (userRole != null) {
        print('👤 Role from userRole: $userRole');
        return userRole;
      }

      print('⚠️ No role found, using default');
      return 'Manager'; // Default fallback
    } catch (e) {
      print('❌ Error getting role: $e');
      return 'Manager';
    }
  }

  // Get selected strategy from controller or SharedPreferences
  Future<String?> _getSelectedStrategy() async {
    try {
      // First try to get from StrategySelectionController
      final strategy = strategyController.selectedStrategy.value;
      if (strategy?.title != null && strategy!.title!.isNotEmpty) {
        print('🎯 Strategy from controller: ${strategy.title}');
        return strategy.title!;
      }

      // Fallback to SharedPreferences
      final strategyData = await SharedPrefs.getSelectedStrategy();
      if (strategyData != null && strategyData['title'] != null) {
        final strategyTitle = strategyData['title'].toString();
        print('🎯 Strategy from SharedPrefs: $strategyTitle');
        return strategyTitle;
      }

      // Check if we have strategy in certificate data
      final certificateStrategy = SharedPrefs.getCertificateSelectedAIStrategy();
      if (certificateStrategy.isNotEmpty && certificateStrategy['title'] != null) {
        final strategyTitle = certificateStrategy['title'].toString();
        print('🎯 Strategy from certificate: $strategyTitle');
        return strategyTitle;
      }

      print('⚠️ No strategy found, using default');
      return 'Default Strategy';
    } catch (e) {
      print('❌ Error getting strategy: $e');
      return 'Default Strategy';
    }
  }

  // Get selected language from controller
  Future<String> _getSelectedLanguage() async {
    try {
      final language = languageController.selectedLanguage.value;
      print('🌐 Language from controller: ${language.name}');
      return language.name;
    } catch (e) {
      print('❌ Error getting language: $e');
      return 'English';
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _safeTranslate(String? key, {String fallback = ''}) {
    if (key == null) return fallback;
    try {
      return key.tr;
    } catch (e) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      journeyController.completeStep(0);
      journeyController.setStep(1, true);
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
              /// Scrollable Content
              Positioned.fill(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: _getResponsiveSpacing(screenHeight, 0.03),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.02),

                        /// Custom Header
                        CustomHeader(
                          title: _safeTranslate('select'),
                          highlightedText: _safeTranslate('key_results'),
                          onBackTap: () => Get.offAllNamed(AppRoutes.keyObjectiveScreen),
                          showDashboardIcon: true,
                        ),

                        SizedBox(height: screenHeight * 0.015),

                        /// Selected Objective Container
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _getHorizontalPadding(screenWidth),
                          ),
                          child: Obx(() {
                            final selectedObjective = objectiveController.selectedObjective.value;
                            return CustomObjectiveContainer(
                              icon: Icons.flag,
                              title: _safeTranslate('selected_objective'),
                              subtitle: selectedObjective?.title?.tr ?? 'No objective selected',
                              description: selectedObjective?.description?.tr ?? '',
                            );
                          }),
                        ),

                        SizedBox(height: _getResponsiveSpacing(screenHeight, 0.02)),

                        /// Select Key Results Title & Subtitle
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _getHorizontalPadding(screenWidth),
                          ),
                          child: Column(
                            children: [
                              Text(
                                _safeTranslate('select_key_results'),
                                style: TextStyle(
                                  fontSize: _getTitleFontSize(screenWidth, isTablet, isDesktop),
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryRed,
                                  fontFamily: 'GothamExtraBold',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Obx(() => AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) =>
                                    ScaleTransition(scale: animation, child: child),
                                child: Text(
                                  '${_safeTranslate('choose_3_outcomes')} '
                                      '(${keyResultsViewModel.selectedCount}/${keyResultsViewModel.requiredCount})',
                                  key: ValueKey<int>(keyResultsViewModel.selectedCount),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: _getSubtitleFontSize(screenWidth, isTablet, isDesktop),
                                    color: keyResultsViewModel.selectedCount >= keyResultsViewModel.requiredCount
                                        ? AppColors.primaryRed
                                        : AppColors.textSecondary,
                                    fontFamily: 'Gotham',
                                    height: 1.4,
                                  ),
                                ),
                              )),

                              SizedBox(height: screenHeight * 0.01),
                              // // ✅ Show total available key results
                              // Obx(() => Text(
                              //   '${keyResultsViewModel.allKeyResults.length} key results available',
                              //   textAlign: TextAlign.center,
                              //   style: TextStyle(
                              //     fontSize: _getSubtitleFontSize(screenWidth, isTablet, isDesktop) * 0.9,
                              //     color: AppColors.textSecondary.withOpacity(0.7),
                              //     fontFamily: 'Gotham',
                              //     height: 1.4,
                              //   ),
                              // )),
                            ],
                          ),
                        ),

                        SizedBox(height: _getResponsiveSpacing(screenHeight, 0.025)),

                        /// Key Results List - ALL KEY RESULTS IN SCROLLABLE CONTAINER
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _getContentPadding(screenWidth, isTablet),
                          ),
                          child: Obx(() {
                            if (keyResultsViewModel.loading.value) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (keyResultsViewModel.allKeyResults.isEmpty) {
                              return Column(
                                children: [
                                  SizedBox(height: screenHeight * 0.05),
                                  Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                                  SizedBox(height: 16),
                                  Text(
                                    'No Key Results Generated',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Please check your API configuration or try again',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _initializeKeyResults,
                                    child: Text('Retry'),
                                  ),
                                ],
                              );
                            }
                            return _buildKeyResultsList(screenWidth, isTablet);
                          }),
                        ),

                        SizedBox(height: _getResponsiveSpacing(screenHeight, 0.03)),

                        /// OKR Constellation
                        const CustomOKRConstellation(),

                        SizedBox(height: _getResponsiveSpacing(screenHeight, 0.03)),

                        /// Journey Map
                        Obx(() => CustomJourneyMap(
                          progress: journeyController.progress.value,
                          steps: journeyController.steps,
                          completedSteps: journeyController.completedSteps,
                          onToggle: journeyController.toggleJourneyDetails,
                          showDetails: journeyController.showDetails.value,
                        )),

                        SizedBox(height: _getResponsiveSpacing(screenHeight, 0.03)),

                        /// Complete Selection Button
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _getButtonPadding(screenWidth, isTablet, isDesktop),
                          ),
                          child: Obx(() => CustomButton2(
                            text: _safeTranslate('complete_selection'),
                            onPressed: keyResultsViewModel.isSelectionComplete
                                ? () {
                              journeyController.completeStep(2);

                              // ✅ Get selected key results as KeyResult objects
                              final selectedKeyResults = keyResultsViewModel.getSelectedKeyResultsAsKeyResult();

                              print('🎯 Navigating with ${selectedKeyResults.length} key results');

                              // ✅ Navigate with proper type
                              Get.to(
                                    () => SuggestionInitiativesScreen(
                                  selectedKeyResults: selectedKeyResults,
                                ),
                              );
                            }
                                : null,
                          )),
                        ),

                        SizedBox(height: _getResponsiveSpacing(screenHeight, 0.025)),
                      ],
                    ),
                  ),
                ),
              ),

              /// Floating Navigation Bar
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

  /// Build key results list with responsive layout - ALL KEY RESULTS
  Widget _buildKeyResultsList(double screenWidth, bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.accentRed.withOpacity(0.3), width: 1),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header showing total count
          Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Key Results',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryRed,
                    fontFamily: 'GothamBold',
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  // child: Text(
                  //   '${keyResultsViewModel.allKeyResults.length} total',
                  //   style: TextStyle(
                  //     fontSize: 14.sp,
                  //     fontWeight: FontWeight.w600,
                  //     color: AppColors.primaryRed,
                  //   ),
                  // ),
                ),
              ],
            ),
          ),

          // The actual key results list
          _buildKeyResultsGrid(screenWidth, isTablet),
        ],
      ),
    );
  }

  Widget _buildKeyResultsGrid(double screenWidth, bool isTablet) {
    final shuffledKeyResults = List.from(keyResultsViewModel.allKeyResults)..shuffle();

    // Show max 4 visible at once with internal scrolling
    final visibleHeight = 320.h; // Adjust as needed

    return SizedBox(
      height: visibleHeight,
      child: Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: shuffledKeyResults.length,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.only(bottom: AppDimensions.d16.h),
            child: _buildKeyResultItem(shuffledKeyResults[index], index),
          ),
        ),
      ),
    );
  }

  //
  // /// Build the grid/list of key results
  // Widget _buildKeyResultsGrid(double screenWidth, bool isTablet) {
  //   // ✅ SHUFFLE the key results for random display each time
  //   final shuffledKeyResults = List.from(keyResultsViewModel.allKeyResults)..shuffle();
  //
  //   if (isTablet && screenWidth > 800) {
  //     return GridView.builder(
  //       shrinkWrap: true,
  //       physics: const NeverScrollableScrollPhysics(),
  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 2,
  //         childAspectRatio: 0.9,
  //         crossAxisSpacing: AppDimensions.d16.w,
  //         mainAxisSpacing: AppDimensions.d16.h,
  //       ),
  //       itemCount: shuffledKeyResults.length,
  //       itemBuilder: (context, index) => _buildKeyResultItem(shuffledKeyResults[index], index),
  //     );
  //   }
  //
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     itemCount: shuffledKeyResults.length,
  //     itemBuilder: (context, index) => Padding(
  //       padding: EdgeInsets.only(bottom: AppDimensions.d16.h),
  //       child: _buildKeyResultItem(shuffledKeyResults[index], index),
  //     ),
  //   );
  // }
  Widget _buildKeyResultItem(KeyResultLatest item, int displayIndex) {
    final originalIndex = keyResultsViewModel.allKeyResults.indexOf(item);

    // 🌀 Random icons list
    final icons = [
      Icons.star,
      Icons.rocket,
      Icons.lightbulb,
      Icons.flag,
      Icons.trending_up,
      Icons.bar_chart,
      Icons.thumb_up,
      Icons.work,
      Icons.public,
      Icons.check_circle,
    ];

    final randomIcon = icons[displayIndex % icons.length]; // or Random().nextInt(icons.length)

    return Obx(() => CustomIndustryContainer(
      title: _safeTranslate(item.title, fallback: 'Unknown Title'),
      description: _safeTranslate(item.description, fallback: 'No description'),
      icon: randomIcon, // 🔹 Use random icon here
      isSelected: keyResultsViewModel.isSelected(originalIndex),
      onTap: () {
        keyResultsViewModel.toggleSelection(originalIndex);
        if (keyResultsViewModel.isSelected(originalIndex)) {
          constellationController.addIcon(randomIcon);
        } else {
          constellationController.removeIcon(randomIcon);
        }
      },
      showTag1: true,
      tag1Icon: Icons.trending_up,
      tag1Text: _safeTranslate(item.tag1 ?? '', fallback: ''),
      showTag2: true,
      tag2Icon: Icons.access_time,
      tag2Text: _safeTranslate(item.tag2 ?? '', fallback: ''),
    ));
  }


  // 🔹 RESPONSIVE HELPER METHODS
  double _getResponsiveSpacing(double dimension, double factor) => dimension * factor;

  double _getHorizontalPadding(double screenWidth) {
    if (screenWidth > 1200) return screenWidth * 0.06;
    if (screenWidth > 900) return screenWidth * 0.04;
    if (screenWidth > 600) return screenWidth * 0.03;
    return screenWidth * 0.02;
  }

  double _getContentPadding(double screenWidth, bool isTablet) =>
      isTablet ? screenWidth * 0.06 : screenWidth * 0.04;

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
    if (isDesktop) return (screenWidth * 0.026).sp;
    if (isTablet) return (screenWidth * 0.030).sp;
    return (screenWidth * 0.039).sp;
  }
}










// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:game_app/view_model/key_result_latest_view_model.dart';
// import 'package:get/get.dart';
// import '../../../controllers/journey_controller.dart';
// import '../../../controllers/okr_constellation_controller.dart';
// import '../../../core/app_colors.dart';
// import '../../../core/app_dimensions.dart';
//
// import '../../routes/app_routes.dart';
// import '../../widgets/custom_button2.dart';
// import '../../widgets/custom_home_navbar.dart';
// import '../../widgets/custom_industry_container.dart';
// import '../../widgets/custom_journey_map.dart';
// import '../../widgets/custom_objective_container.dart';
// import '../../widgets/custom_okr_constellation.dart';
// import '../../widgets/custom_selected_key_result_container.dart';
// import '../../widgets/screens_unique_parts/custom_background.dart';
// import '../../widgets/screens_unique_parts/custom_header.dart';
// import '../suggestion_Initiatives/suggestion_initiatives_creen.dart';
//
// import '../../../controllers/key_objective_controller.dart';
// import '../../../controllers/strategy_selection_controller.dart';
// import '../../../controllers/language_controller.dart';
// import '../../../services/shared_preference.dart';
//
// class KeyResultsScreen extends StatefulWidget {
//   const KeyResultsScreen({super.key});
//
//   @override
//   State<KeyResultsScreen> createState() => _KeyResultsScreenState();
// }
//
// class _KeyResultsScreenState extends State<KeyResultsScreen> {
//   // Use the new latest viewmodel
//   final KeyResultsLatestViewModel keyResultsViewModel = Get.put(KeyResultsLatestViewModel());
//   final OKRConstellationController constellationController = Get.put(OKRConstellationController());
//   final JourneyController journeyController = Get.find<JourneyController>();
//   final KeyObjectiveController objectiveController = Get.find<KeyObjectiveController>();
//   final StrategySelectionController strategyController = Get.find<StrategySelectionController>();
//   final LanguageController languageController = Get.find<LanguageController>();
//
//   // Add ScrollController for the list
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeKeyResults();
//   }
//
//   void _initializeKeyResults() async {
//     print('🚀 Initializing Key Results...');
//
//     // Get all required data
//     final selectedRole = await _getSelectedRole();
//     final selectedStrategy = await _getSelectedStrategy();
//     final selectedObjective = await _getSelectedObjective();
//     final selectedLanguage = await _getSelectedLanguage();
//
//     print('📋 Data Summary:');
//     print('   - Strategy: $selectedStrategy');
//     print('   - Objective: $selectedObjective');
//     print('   - Role: $selectedRole');
//     print('   - Language: $selectedLanguage');
//
//     if (selectedObjective == null || selectedStrategy == null || selectedRole == null) {
//       print('❌ Missing required data for API call');
//       return;
//     }
//
//     // Generate key results using the new viewmodel
//     keyResultsViewModel.generateKeyResults(
//       strategy: selectedStrategy,
//       objectives: [selectedObjective],
//       role: selectedRole,
//       language: selectedLanguage,
//     );
//   }
//
//   // Get selected role from SharedPreferences or arguments
//   Future<String?> _getSelectedRole() async {
//     try {
//       // Try to get from SharedPreferences first
//       final roleData = await SharedPrefs.getSelectedRole();
//       if (roleData != null && roleData['titleKey'] != null) {
//         final role = roleData['titleKey'].toString();
//         print('👤 Role from SharedPrefs: $role');
//         return role;
//       }
//
//       // Fallback to controller data or arguments
//       final args = Get.arguments as Map<String, dynamic>?;
//       final roleFromArgs = args?['selectedRole'] as Map<String, dynamic>?;
//       if (roleFromArgs != null && roleFromArgs['titleKey'] != null) {
//         final role = roleFromArgs['titleKey'].toString();
//         print('👤 Role from arguments: $role');
//         return role;
//       }
//
//       // Check if we have role data stored in other SharedPreferences keys
//       final userRole = SharedPrefs.getUserRole();
//       if (userRole != null) {
//         print('👤 Role from userRole: $userRole');
//         return userRole;
//       }
//
//       print('⚠️ No role found, using default');
//       return 'Manager'; // Default fallback
//     } catch (e) {
//       print('❌ Error getting role: $e');
//       return 'Manager';
//     }
//   }
//
//   // Get selected strategy from controller or SharedPreferences
//   Future<String?> _getSelectedStrategy() async {
//     try {
//       // First try to get from StrategySelectionController
//       final strategy = strategyController.selectedStrategy.value;
//       if (strategy?.title != null && strategy!.title!.isNotEmpty) {
//         print('🎯 Strategy from controller: ${strategy.title}');
//         return strategy.title!;
//       }
//
//       // Fallback to SharedPreferences
//       final strategyData = await SharedPrefs.getSelectedStrategy();
//       if (strategyData != null && strategyData['title'] != null) {
//         final strategyTitle = strategyData['title'].toString();
//         print('🎯 Strategy from SharedPrefs: $strategyTitle');
//         return strategyTitle;
//       }
//
//       // Check if we have strategy in certificate data
//       final certificateStrategy = SharedPrefs.getCertificateSelectedAIStrategy();
//       if (certificateStrategy.isNotEmpty && certificateStrategy['title'] != null) {
//         final strategyTitle = certificateStrategy['title'].toString();
//         print('🎯 Strategy from certificate: $strategyTitle');
//         return strategyTitle;
//       }
//
//       print('⚠️ No strategy found, using default');
//       return 'Default Strategy';
//     } catch (e) {
//       print('❌ Error getting strategy: $e');
//       return 'Default Strategy';
//     }
//   }
//
//   // Get selected objective from controller
//   Future<String?> _getSelectedObjective() async {
//     try {
//       // Get from KeyObjectiveController
//       final objective = objectiveController.selectedObjective.value;
//       if (objective?.title != null && objective!.title!.isNotEmpty) {
//         print('🎯 Objective from controller: ${objective.title}');
//         return objective.title!;
//       }
//
//       // Fallback to arguments if needed
//       final args = Get.arguments as Map<String, dynamic>?;
//       final objectiveFromArgs = args?['selectedObjective'] as Map<String, dynamic>?;
//       if (objectiveFromArgs != null && objectiveFromArgs['title'] != null) {
//         final objectiveTitle = objectiveFromArgs['title'].toString();
//         print('🎯 Objective from arguments: $objectiveTitle');
//         return objectiveTitle;
//       }
//
//       // Check certificate data
//       final certificateObjective = SharedPrefs.getCertificateObjective();
//       if (certificateObjective['title']?.isNotEmpty == true) {
//         final objectiveTitle = certificateObjective['title']!;
//         print('🎯 Objective from certificate: $objectiveTitle');
//         return objectiveTitle;
//       }
//
//       print('⚠️ No objective found, using default');
//       return 'Default Objective';
//     } catch (e) {
//       print('❌ Error getting objective: $e');
//       return 'Default Objective';
//     }
//   }
//
//   // Get selected language from controller
//   Future<String> _getSelectedLanguage() async {
//     try {
//       final language = languageController.selectedLanguage.value;
//       print('🌐 Language from controller: ${language.name}');
//       return language.name;
//     } catch (e) {
//       print('❌ Error getting language: $e');
//       return 'English';
//     }
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   String _safeTranslate(String? key, {String fallback = ''}) {
//     if (key == null) return fallback;
//     try {
//       return key.tr;
//     } catch (e) {
//       return fallback;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       journeyController.completeStep(0);
//       journeyController.setStep(1, true);
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
//               /// Scrollable Content
//               Positioned.fill(
//                 child: SingleChildScrollView(
//                   controller: _scrollController,
//                   physics: const BouncingScrollPhysics(),
//                   child: Padding(
//                     padding: EdgeInsets.only(
//                       bottom: _getResponsiveSpacing(screenHeight, 0.03),
//                     ),
//                     child: Column(
//                       children: [
//                         SizedBox(height: screenHeight * 0.02),
//
//                         /// Custom Header
//                         CustomHeader(
//                           title: _safeTranslate('select'),
//                           highlightedText: _safeTranslate('key_results'),
//                           onBackTap: () => Get.offAllNamed(AppRoutes.keyObjectiveScreen),
//                           showDashboardIcon: true,
//                         ),
//
//                         SizedBox(height: screenHeight * 0.015),
//
//                         // /// Selected Strategy Container
//                         // Padding(
//                         //   padding: EdgeInsets.symmetric(
//                         //     horizontal: _getHorizontalPadding(screenWidth),
//                         //   ),
//                         //   child: Obx(() {
//                         //     final selectedStrategy = strategyController.selectedStrategy.value;
//                         //     return CustomObjectiveContainer(
//                         //       icon: Icons.emoji_objects,
//                         //       title: _safeTranslate('selected_strategy'),
//                         //       subtitle: selectedStrategy?.title?.tr ?? 'No strategy selected',
//                         //       //description: selectedStrategy?.description?.tr ?? '',
//                         //       titleColor: AppColors.primaryRed,
//                         //     );
//                         //   }),
//                         // ),
//
//                         SizedBox(height: _getResponsiveSpacing(screenHeight, 0.02)),
//
//                         /// Selected Objective Container
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: _getHorizontalPadding(screenWidth),
//                           ),
//                           child: Obx(() {
//                             final selectedObjective = objectiveController.selectedObjective.value;
//                             return CustomObjectiveContainer(
//                               icon: Icons.flag,
//                               title: _safeTranslate('selected_objective'),
//                               subtitle: selectedObjective?.title?.tr ?? 'No objective selected',
//                               description: selectedObjective?.description?.tr ?? '',
//                             );
//                           }),
//                         ),
//
//                         SizedBox(height: _getResponsiveSpacing(screenHeight, 0.02)),
//
//                         /// Selected Key Results Container
//                         // Padding(
//                         //   padding: EdgeInsets.symmetric(
//                         //     horizontal: _getHorizontalPadding(screenWidth),
//                         //   ),
//                         //   child: Obx(() => CustomSelectedKeyResultsContainer(
//                         //     selectedCount: keyResultsViewModel.selectedCount,
//                         //     requiredCount: keyResultsViewModel.requiredCount,
//                         //   )),
//                         // ),
//
//                         SizedBox(height: _getResponsiveSpacing(screenHeight, 0.02)),
//
//                         /// Select Key Results Title & Subtitle
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: _getHorizontalPadding(screenWidth),
//                           ),
//                           child: Column(
//                             children: [
//                               Text(
//                                 _safeTranslate('select_key_results'),
//                                 style: TextStyle(
//                                   fontSize: _getTitleFontSize(screenWidth, isTablet, isDesktop),
//                                   fontWeight: FontWeight.bold,
//                                   color: AppColors.primaryRed,
//                                   fontFamily: 'GothamExtraBold',
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                               SizedBox(height: screenHeight * 0.01),
//                               Text(
//                                 '${_safeTranslate('choose_3_outcomes')} (${keyResultsViewModel.selectedCount}/${keyResultsViewModel.requiredCount})',
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
//                         SizedBox(height: _getResponsiveSpacing(screenHeight, 0.025)),
//
//                         /// Key Results List
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: _getContentPadding(screenWidth, isTablet),
//                           ),
//                           child: Obx(() {
//                             if (keyResultsViewModel.loading.value) {
//                               return const Center(child: CircularProgressIndicator());
//                             }
//                             if (keyResultsViewModel.allKeyResults.isEmpty) {
//                               return Column(
//                                 children: [
//                                   SizedBox(height: screenHeight * 0.05),
//                                   Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
//                                   SizedBox(height: 16),
//                                   Text(
//                                     'No Key Results Generated',
//                                     style: TextStyle(
//                                       fontSize: 18,
//                                       color: Colors.grey[600],
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text(
//                                     'Please check your API configuration or try again',
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Colors.grey[500],
//                                     ),
//                                   ),
//                                   SizedBox(height: 16),
//                                   ElevatedButton(
//                                     onPressed: _initializeKeyResults,
//                                     child: Text('Retry'),
//                                   ),
//                                 ],
//                               );
//                             }
//                             return _buildKeyResultsList(screenWidth, isTablet);
//                           }),
//                         ),
//
//                         SizedBox(height: _getResponsiveSpacing(screenHeight, 0.03)),
//
//                         /// OKR Constellation
//                         const CustomOKRConstellation(),
//
//                         SizedBox(height: _getResponsiveSpacing(screenHeight, 0.03)),
//
//                         /// Journey Map
//                         Obx(() => CustomJourneyMap(
//                           progress: journeyController.progress.value,
//                           steps: journeyController.steps,
//                           completedSteps: journeyController.completedSteps,
//                           onToggle: journeyController.toggleJourneyDetails,
//                           showDetails: journeyController.showDetails.value,
//                         )),
//
//                         SizedBox(height: _getResponsiveSpacing(screenHeight, 0.03)),
//
//                         /// Complete Selection Button
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: _getButtonPadding(screenWidth, isTablet, isDesktop),
//                           ),
//                           child: Obx(() => CustomButton2(
//                             text: _safeTranslate('complete_selection'),
//                             onPressed: keyResultsViewModel.isSelectionComplete
//                                 ? () {
//                               journeyController.completeStep(2);
//
//                               // ✅ Get selected key results as KeyResult objects
//                               final selectedKeyResults = keyResultsViewModel.getSelectedKeyResultsAsKeyResult();
//
//                               print('🎯 Navigating with ${selectedKeyResults.length} key results');
//
//                               // ✅ Navigate with proper type
//                               Get.to(
//                                     () => SuggestionInitiativesScreen(
//                                   selectedKeyResults: selectedKeyResults,
//                                 ),
//                               );
//                             }
//                                 : null,
//                           )),
//                         ),
//
//                         SizedBox(height: _getResponsiveSpacing(screenHeight, 0.025)),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               /// Floating Navigation Bar
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
//   /// Build key results list with responsive layout
//   Widget _buildKeyResultsList(double screenWidth, bool isTablet) {
//     if (isTablet && screenWidth > 800) {
//       return GridView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           childAspectRatio: 0.9,
//           crossAxisSpacing: AppDimensions.d16.w,
//           mainAxisSpacing: AppDimensions.d16.h,
//         ),
//         itemCount: keyResultsViewModel.allKeyResults.length,
//         itemBuilder: (context, index) => _buildKeyResultItem(index),
//       );
//     }
//
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: keyResultsViewModel.allKeyResults.length,
//       itemBuilder: (context, index) => Padding(
//         padding: EdgeInsets.only(bottom: AppDimensions.d16.h),
//         child: _buildKeyResultItem(index),
//       ),
//     );
//   }
//
//   /// Build individual key result item
//   Widget _buildKeyResultItem(int index) {
//     final item = keyResultsViewModel.allKeyResults[index];
//
//     return Obx(() => CustomIndustryContainer(
//       title: _safeTranslate(item.title, fallback: 'Unknown Title'),
//       description: _safeTranslate(item.description, fallback: 'No description'),
//       icon: item.icon ?? Icons.rocket,
//       isSelected: keyResultsViewModel.isSelected(index),
//       onTap: () {
//         keyResultsViewModel.toggleSelection(index);
//         final icon = item.icon ?? Icons.key;
//         if (keyResultsViewModel.isSelected(index)) {
//           constellationController.addIcon(icon);
//         } else {
//           constellationController.removeIcon(icon);
//         }
//       },
//       showTag1: true,
//       tag1Icon: Icons.trending_up,
//       tag1Text: _safeTranslate(item.tag1 ?? '', fallback: ''),
//       showTag2: true,
//       tag2Icon: Icons.access_time,
//       tag2Text: _safeTranslate(item.tag2 ?? '', fallback: ''),
//     ));
//   }
//
//   // 🔹 RESPONSIVE HELPER METHODS
//   double _getResponsiveSpacing(double dimension, double factor) => dimension * factor;
//
//   double _getHorizontalPadding(double screenWidth) {
//     if (screenWidth > 1200) return screenWidth * 0.06;
//     if (screenWidth > 900) return screenWidth * 0.04;
//     if (screenWidth > 600) return screenWidth * 0.03;
//     return screenWidth * 0.02;
//   }
//
//   double _getContentPadding(double screenWidth, bool isTablet) =>
//       isTablet ? screenWidth * 0.06 : screenWidth * 0.04;
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
//     if (isDesktop) return (screenWidth * 0.026).sp;
//     if (isTablet) return (screenWidth * 0.030).sp;
//     return (screenWidth * 0.039).sp;
//   }
// }
