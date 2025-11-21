import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:game_app/view_model/key_result_latest_view_model.dart';
import '../../../controllers/journey_controller.dart';
import '../../../controllers/key_objective_controller.dart';
import '../../../controllers/okr_constellation_controller.dart';
import '../../../controllers/strategy_selection_controller.dart';
import '../../../controllers/language_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../generated/models/requests/key_results_latest_model.dart';
import '../../../generated/models/responses/key_results/key_results_response.dart' hide Text;
import '../../../services/shared_preference.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_industry_container.dart';
import '../../widgets/custom_journey_map.dart';
import '../../widgets/custom_objective_container.dart';
import '../../widgets/custom_okr_constellation.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import '../feedback_screen.dart';
import '../suggestion_Initiatives/suggestion_initiatives_creen.dart';

class KeyResultsScreen extends StatefulWidget {
  const KeyResultsScreen({super.key});

  @override
  State<KeyResultsScreen> createState() => _KeyResultsScreenState();
}

class _KeyResultsScreenState extends State<KeyResultsScreen> {
  final KeyResultsLatestViewModel keyResultsViewModel = Get.find<KeyResultsLatestViewModel>();
  final OKRConstellationController constellationController = Get.find<OKRConstellationController>();
  final JourneyController journeyController = Get.find<JourneyController>();
  final KeyObjectiveController objectiveController = Get.find<KeyObjectiveController>();
  final StrategySelectionController strategyController = Get.find<StrategySelectionController>();
  final LanguageController languageController = Get.find<LanguageController>();
  final ScrollController _keyResultsScrollController = ScrollController();

  // ✅ Track source and initialization
  bool _isInitialized = false;
  bool _hasShownMessage = false;

  // ✅ Different sources with different behaviors
  final bool _isRetryFromAnalysis = Get.parameters['isRetry'] == 'true';
  final bool _isModifyFromContextual = Get.parameters['source'] == 'contextual_challenge';
  final bool _isNormalFlow = !Get.parameters.containsKey('isRetry') && !Get.parameters.containsKey('source');

  @override
  void initState() {
    super.initState();

    print('🎯 Key Results Screen Source:');
    print('   - Retry from Analysis: $_isRetryFromAnalysis');
    print('   - Modify from Contextual: $_isModifyFromContextual');
    print('   - Normal Flow: $_isNormalFlow');

    // Use delayed initialization to avoid build phase conflicts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeScreen();
    });
  }

  void _initializeScreen() {
    if (_isInitialized) return;

    _isInitialized = true;

    // Handle different scenarios with appropriate messages
    if (!_hasShownMessage) {
      _hasShownMessage = true;

      Future.delayed(const Duration(milliseconds: 500), () {
        if (_isRetryFromAnalysis) {
          Get.snackbar(
            'Try Again',
            'Please select different key results to improve your initiatives',
            backgroundColor: AppColors.primaryRed,
            colorText: Colors.white,
          );
        } else if (_isModifyFromContextual) {
          Get.snackbar(
            'Modify Key Results',
            'Select new key results to adapt to the market challenge',
            backgroundColor: AppColors.primaryBlue,
            colorText: Colors.white,
          );
        }
      });
    }

    // Clear previous selection for retry/modify scenarios
    if (_isRetryFromAnalysis || _isModifyFromContextual) {
      keyResultsViewModel.clearSelection();
    }

    // ✅ FIXED: For normal flow, ALWAYS initialize key results
    if (_isNormalFlow) {
      print('🚀 Normal Flow - Generating new key results...');
      _initializeKeyResults();
    } else {
      // For modify/retry flows, use existing key results without re-fetching
      print('🔄 Using existing ${keyResultsViewModel.allKeyResults.length} key results');
    }
  }

  // ✅ FIXED: Proper initialization for key results generation
  void _initializeKeyResults() async {
    print('🚀 Initializing Key Results for Normal Flow...');

    try {
      // Get all required data dynamically
      final selectedRole = await _getSelectedRole();
      final selectedStrategy = await _getSelectedStrategy();
      final selectedObjectives = await _getSelectedObjectives(); // ✅ Get dynamic objectives
      final selectedLanguage = await _getSelectedLanguage();

      print('📋 Data Summary for API:');
      print('   - Strategy: $selectedStrategy');
      print('   - Objectives: $selectedObjectives');
      print('   - Role: $selectedRole');
      print('   - Language: $selectedLanguage');

      if (selectedObjectives.isEmpty || selectedStrategy == null || selectedRole == null) {
        print('❌ Missing required data for API call');
        Get.snackbar(
          'Error',
          'Missing required data. Please go back and try again.',
          backgroundColor: AppColors.primaryRed,
          colorText: Colors.white,
        );
        return;
      }

      // Generate key results using the new viewmodel
      await keyResultsViewModel.generateKeyResults(
        strategy: selectedStrategy,
        objectives: selectedObjectives, // ✅ Send dynamic objectives
        role: selectedRole,
        language: selectedLanguage,
      );

      print('✅ Key results generation completed');
      print('📊 Total key results generated: ${keyResultsViewModel.allKeyResults.length}');

    } catch (e) {
      print('❌ Error generating key results: $e');
      Get.snackbar(
        'Error',
        'Failed to generate key results. Please try again.',
        backgroundColor: AppColors.primaryRed,
        colorText: Colors.white,
      );
    }
  }

  // ✅ FIXED: Get dynamic objectives from the previous screen
  Future<List<String>> _getSelectedObjectives() async {
    try {
      final List<String> objectives = [];

      // 1. Get the main selected objective from controller
      final selectedObjective = objectiveController.selectedObjective.value;
      if (selectedObjective?.title != null && selectedObjective!.title!.isNotEmpty) {
        print('🎯 Main Selected Objective: ${selectedObjective.title}');
        objectives.add(selectedObjective.title!);
      }

      // 2. Get AI-generated objectives from various sources
      final aiObjectives = await _getAIGeneratedObjectives();

      // 3. Add AI objectives to the list
      for (final objective in aiObjectives) {
        if (objectives.length < 8 && !objectives.contains(objective)) {
          objectives.add(objective);
        }
        if (objectives.length >= 8) break;
      }

      // 4. If we still don't have enough objectives, use fallback
      if (objectives.length < 8) {
        final additionalObjectives = await _getFallbackObjectives();
        for (final objective in additionalObjectives) {
          if (objectives.length < 8 && !objectives.contains(objective)) {
            objectives.add(objective);
          }
          if (objectives.length >= 8) break;
        }
      }

      print('🎯 Final Objectives for API (${objectives.length}): $objectives');
      return objectives;

    } catch (e) {
      print('❌ Error getting objectives: $e');
      // Fallback to ensure we always have objectives
      return await _getFallbackObjectives();
    }
  }

  // ✅ FIXED: Get AI-generated objectives from various sources
  Future<List<String>> _getAIGeneratedObjectives() async {
    try {
      final List<String> objectives = [];

      // Try to get from SharedPreferences first - using available methods
      final savedStrategy = await SharedPrefs.getSelectedStrategy();
      if (savedStrategy != null && savedStrategy['title'] != null) {
        final strategyTitle = savedStrategy['title'].toString();
        // Use strategy title as one objective
        objectives.add('Implement $strategyTitle Strategy');
      }

      // Try to get from controller if available - using available properties
      // Check if there are any additional objectives stored in the controller
      if (objectiveController.selectedObjective.value?.title != null) {
        final mainObjective = objectiveController.selectedObjective.value!.title!;
        // Create related objectives based on the main one
        objectives.addAll([
          'Optimize $mainObjective Implementation',
          'Enhance $mainObjective Efficiency',
          'Scale $mainObjective Across Organization',
        ]);
      }

      // Get industry to create relevant objectives
      final industryData = await SharedPrefs.getSelectedIndustry();
      if (industryData != null && industryData['titleKey'] != null) {
        final industry = industryData['titleKey'].toString();
        objectives.add('Align $industry Best Practices');
      }

      print('📚 AI Objectives from available data: $objectives');
      return objectives;

    } catch (e) {
      print('❌ Error getting AI objectives: $e');
      return [];
    }
  }

  // ✅ FIXED: Return type corrected to Future<List<String>>
  Future<List<String>> _getFallbackObjectives() async {
    // Get the main objective to make fallbacks relevant
    final mainObjective = objectiveController.selectedObjective.value?.title ?? 'HR Technology';

    final List<String> diverseHRObjectives = [
      'Improve Employee Retention in $mainObjective',
      'Enhance Training and Development Programs for $mainObjective',
      'Boost Employee Morale and Engagement through $mainObjective',
      'Develop Leadership Pipeline for $mainObjective',
      'Improve Work-Life Balance Initiatives with $mainObjective',
      'Enhance Diversity and Inclusion in $mainObjective',
      'Strengthen Employer Brand through $mainObjective',
      'Optimize Performance Management System with $mainObjective',
      'Increase Employee Productivity using $mainObjective',
      'Reduce Recruitment Costs with $mainObjective',
      'Improve Onboarding Process through $mainObjective',
      'Enhance Employee Benefits Package with $mainObjective',
    ];

    // Shuffle and take unique objectives until we have 8
    final shuffledObjectives = List<String>.from(diverseHRObjectives)..shuffle();
    return shuffledObjectives.take(8).toList();
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

  // ✅ DYNAMIC HEADER & MESSAGES BASED ON SOURCE
  String _getHeaderTitle() {
    if (_isRetryFromAnalysis) {
      return 'try_again_with'.tr;
    } else if (_isModifyFromContextual) {
      return 'modify'.tr;
    }
    return 'select'.tr;
  }

  String _getHeaderHighlight() {
    if (_isRetryFromAnalysis) {
      return 'key_results'.tr;
    } else if (_isModifyFromContextual) {
      return 'key_results'.tr;
    }
    return 'key_results'.tr;
  }

  String _getSubtitleText() {
    if (_isRetryFromAnalysis) {
      return 'choose_3_outcomes_retry'.tr;
    } else if (_isModifyFromContextual) {
      return 'choose_3_outcomes_modify'.tr;
    }
    return 'choose_3_outcomes'.tr;
  }

  // ✅ Get appropriate button text
  String _getButtonText() {
    if (_isModifyFromContextual) {
      return 'save_changes'.tr;
    }
    return 'complete_selection'.tr;
  }

  // ✅ Get navigation destination
  void _navigateToNextScreen() {
    if (_isModifyFromContextual) {
      // Return to contextual challenge screen
      Get.back();
      Get.snackbar(
        'Success',
        'Key results updated successfully',
        backgroundColor: AppColors.primaryGreen,
        colorText: Colors.white,
      );
    } else {
      // Normal flow - go to initiatives screen
      final selectedKeyResults = keyResultsViewModel.getSelectedKeyResultsAsKeyResult();
      Get.to(
            () => SuggestionInitiativesScreen(
          selectedKeyResults: selectedKeyResults,
        ),
      );
    }
  }
  void _showBackConfirmationDialog() {
    // Agar modify from contextual flow hai to direct back karein
    if (_isModifyFromContextual) {
      Get.back();
      return;
    }

    // Normal flow ke liye confirmation dialog show karein
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'exit_selection'.tr,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryRed,
            fontFamily: 'GothamBold',
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'exit_selection_confirmation'.tr,
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textSecondary,
            fontFamily: 'Gotham',
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          // No Button - Current screen pe hi rahein
          TextButton(
            onPressed: () {
              Get.back(); // Dialog band karein
            },
            child: Text(
              'no'.tr,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Yes Button - Home screen pe navigate karein
          ElevatedButton(
            onPressed: () {
              Get.back(); // Dialog band karein
              Get.offAllNamed(AppRoutes.home); // Home screen pe navigate karein
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
            child: Text(
              'yes'.tr,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        actionsAlignment: MainAxisAlignment.spaceAround,
      ),
      barrierDismissible: false, // User ko dialog ke bahar click karke band karne se roke
    );
  }
  @override
  Widget build(BuildContext context) {
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
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: _getResponsiveSpacing(screenHeight, 0.03),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.02),
                        CustomHeader(
                          title: _getHeaderTitle(),
                          highlightedText: _getHeaderHighlight(),
                          onBackTap: () {
                            _showBackConfirmationDialog();
                          },
                          showDashboardIcon: true,
                        ),
                        /// Custom Header
                        // CustomHeader(
                        //   title: _getHeaderTitle(),
                        //   highlightedText: _getHeaderHighlight(),
                        //   onBackTap: () {
                        //     if (_isModifyFromContextual) {
                        //       // Just go back to contextual challenge
                        //       Get.back();
                        //     } else {
                        //       // Normal navigation back
                        //       Get.toNamed(AppRoutes.keyObjectiveScreen);
                        //     }
                        //   },
                        //   showDashboardIcon: true,
                        // ),

                        SizedBox(height: screenHeight * 0.015),

                        /// Selected Objective Container
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _getHorizontalPadding(screenWidth),
                          ),
                          child: Obx(() {
                            final selectedObjective = Get.find<KeyObjectiveController>().selectedObjective.value;
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
                              Obx(() {
                                final isLoading = keyResultsViewModel.loading.value && _isNormalFlow;

                                return AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (child, animation) =>
                                      ScaleTransition(scale: animation, child: child),
                                  child: isLoading
                                      ? Column(
                                    children: [
                                      SizedBox(height: 8.h),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 16.w,
                                            height: 16.h,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
                                            ),
                                          ),
                                          SizedBox(width: 12.w),
                                          Text(
                                            'please_wait'.tr,
                                            style: TextStyle(
                                              fontSize: _getSubtitleFontSize(screenWidth, isTablet, isDesktop),
                                              color: AppColors.primaryRed,
                                              fontFamily: 'Gotham',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                      : Text(
                                    '${_getSubtitleText()} '
                                        '(${keyResultsViewModel.selectedCount}/${keyResultsViewModel.requiredCount})',
                                    key: ValueKey<int>(keyResultsViewModel.selectedCount),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: _getSubtitleFontSize(screenWidth, isTablet, isDesktop),
                                      color: keyResultsViewModel.selectedCount >= keyResultsViewModel.requiredCount
                                          ? AppColors.primaryRed
                                          : _getSubtitleColor(),
                                      fontFamily: 'Gotham',
                                      height: 1.4,
                                      fontWeight: _getSubtitleFontWeight(),
                                    ),
                                  ),
                                );
                              }),

                              // ✅ SHOW DIFFERENT BADGES BASED ON SOURCE
                              if (_isRetryFromAnalysis) ...[
                                SizedBox(height: screenHeight * 0.01),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryRed.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(color: AppColors.primaryRed.withOpacity(0.3)),
                                  ),
                                  child: Text(
                                    'retry_attempt'.tr,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.primaryRed,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ] else if (_isModifyFromContextual) ...[
                                SizedBox(height: screenHeight * 0.01),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryBlue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
                                  ),
                                  child: Text(
                                    'adapting_to_challenge'.tr,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.primaryBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        SizedBox(height: _getResponsiveSpacing(screenHeight, 0.025)),

                        /// Key Results List
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _getContentPadding(screenWidth, isTablet),
                          ),
                          child: Obx(() {
                            final isLoading = keyResultsViewModel.loading.value && _isNormalFlow;

                            if (isLoading) {
                              return Container(
                                height: 200.h,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
                                      ),
                                      SizedBox(height: 16.h),
                                      Center(
                                        child: Text(
                                          'generating_key_results'.tr,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            if (keyResultsViewModel.allKeyResults.isEmpty) {
                              return Column(
                                children: [
                                  SizedBox(height: screenHeight * 0.05),
                                  Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                                  SizedBox(height: 16.h),
                                  Text(
                                    'No Key Results Available',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Please check your configuration',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  if (_isNormalFlow) ...[
                                    SizedBox(height: 16.h),
                                    ElevatedButton(
                                      onPressed: _initializeKeyResults,
                                      child: Text('Retry Generation'),
                                    ),
                                  ],
                                ],
                              );
                            }
                            return _buildKeyResultsList(screenWidth, isTablet);
                          }),
                        ),

                        SizedBox(height: _getResponsiveSpacing(screenHeight, 0.03)),

                        /// OKR Constellation
                        // const CustomOKRConstellation(),

                        SizedBox(height: _getResponsiveSpacing(screenHeight, 0.03)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _getButtonPadding(screenWidth, isTablet, isDesktop),
                          ),
                          child: Obx(() => CustomButton2(
                            text: _getButtonText(),
                            onPressed: keyResultsViewModel.isSelectionComplete
                                ? () async {
                              journeyController.completeStep(2);

                              // ✅ GET SELECTED KEY RESULTS
                              final selectedKeyResults = keyResultsViewModel.getSelectedKeyResultsAsKeyResult();

                              print('🎯 Navigating to FeedbackScreen with ${selectedKeyResults.length} key results');

                              // ✅ SAVE KEY RESULTS BEFORE NAVIGATION
                              await _saveKeyResultsForNextScreen(selectedKeyResults);

                              // ✅ Navigate to FeedbackScreen with selected key results
                              Get.to(
                                    () => FeedbackScreen(
                                  selectedKeyResults: selectedKeyResults,
                                ),
                              );
                            }
                                : null,
                          )),
                        ),
                        SizedBox(height: _getResponsiveSpacing(screenHeight, 0.03)),

                        /// Journey Map (hide for modification flow)
                        if (!_isModifyFromContextual) ...[
                          Obx(() => CustomJourneyMap(
                            progress: journeyController.progress.value,
                            steps: journeyController.steps,
                            completedSteps: journeyController.completedSteps,
                            onToggle: journeyController.toggleJourneyDetails,
                            showDetails: journeyController.showDetails.value,
                          )),
                          SizedBox(height: _getResponsiveSpacing(screenHeight, 0.03)),
                        ],

                        /// Complete Selection Button

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

  // ✅ ADD THIS HELPER METHOD
  Future<void> _saveKeyResultsForNextScreen(List<KeyResult> selectedKeyResults) async {
    try {
      final keyResultsJson = jsonEncode(selectedKeyResults.map((kr) => {
        'id': kr.id,
        'title': kr.title,
        'description': kr.description,
        // 'tag1': kr.tag1,
        // 'tag2': kr.tag2,
      }).toList());

      await SharedPrefs.saveString('selected_key_results', keyResultsJson);
      print('💾 Saved ${selectedKeyResults.length} key results for next screen');
    } catch (e) {
      print('❌ Error saving key results for next screen: $e');
    }
  }

  @override
  void dispose() {
    _keyResultsScrollController.dispose();
    super.dispose();
  }

  // ✅ Helper methods for dynamic styling
  Color _getSubtitleColor() {
    if (_isRetryFromAnalysis) return AppColors.primaryRed;
    if (_isModifyFromContextual) return AppColors.primaryBlue;
    return AppColors.textSecondary;
  }

  FontWeight _getSubtitleFontWeight() {
    if (_isRetryFromAnalysis || _isModifyFromContextual) return FontWeight.w600;
    return FontWeight.normal;
  }

  // Make sure your key results list is properly built
  Widget _buildKeyResultsList(double screenWidth, bool isTablet) => Container(
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
                  'available_key_results'.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryRed,
                    fontFamily: 'GothamBold',
                  ),
                ),
                Obx(() => Text(
                  '${keyResultsViewModel.allKeyResults.length} available'.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                )),
              ],
            ),
          ),

          // The actual key results list WITH SCROLL CONTROLLER
          _buildKeyResultsGrid(screenWidth, isTablet),
        ],
      ),
    );

  // Update the _buildKeyResultsGrid method
  Widget _buildKeyResultsGrid(double screenWidth, bool isTablet) {
    final shuffledKeyResults = List.from(keyResultsViewModel.allKeyResults)..shuffle();
    final visibleHeight = 320.h;

    return SizedBox(
      height: visibleHeight,
      child: Scrollbar(
        controller: _keyResultsScrollController, // ✅ ADD THIS
        thumbVisibility: true,
        child: ListView.builder(
          controller: _keyResultsScrollController, // ✅ ADD THIS
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

  Widget _buildKeyResultItem(KeyResultLatest item, int displayIndex) {
    final originalIndex = keyResultsViewModel.allKeyResults.indexOf(item);

    // Dynamic heading: K1, K2, K3...
    final heading = 'K${displayIndex + 1}';

    // Only use flag icon for all key results
    final flagIcon = Icons.flag;

    return Obx(() => CustomIndustryContainer(
      title: heading, // ✅ Set dynamic heading
      description: _safeTranslate(item.description, fallback: 'Available for the selected one'),
      icon: flagIcon, // Only flag icon
      isSelected: keyResultsViewModel.isSelected(originalIndex),
      onTap: () {
        keyResultsViewModel.toggleSelection(originalIndex);
        if (keyResultsViewModel.isSelected(originalIndex)) {
          constellationController.addIcon(flagIcon); // Add flag icon to constellation
        } else {
          constellationController.removeIcon(flagIcon); // Remove flag icon from constellation
        }

        // Update journey progress based on key results selection
        if (keyResultsViewModel.isSelectionComplete) {
          journeyController.completeStep(2); // Mark key results step as complete
        } else {
          journeyController.uncompleteStep(2); // Mark key results step as incomplete
        }
      },
      showTag1: false,
      showTag2: false,
    ));
  }
  String _safeTranslate(String? key, {String fallback = ''}) {
    if (key == null) return fallback;
    try {
      return key.tr;
    } catch (e) {
      return fallback;
    }
  }

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

