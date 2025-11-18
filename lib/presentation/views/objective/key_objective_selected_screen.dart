import 'dart:math' hide log;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/utils/snackbar_helper.dart';
import 'package:get/get.dart';
import 'dart:developer';

import '../../../controllers/journey_controller.dart';
import '../../../controllers/key_objective_controller.dart';
import '../../../controllers/strategy_selection_controller.dart';
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
  final StrategySelectionController strategyController = Get.find<StrategySelectionController>();

  // ✅ ADD: Scroll controller for the objectives list
  final ScrollController _scrollController = ScrollController();

  // ✅ Track initialization state and source
  bool _isInitialized = false;
  bool _hasShownMessage = false;

  // ✅ Different sources with different behaviors
  final bool _isRetryFromAnalysis = Get.parameters['isRetry'] == 'true';
  final bool _isModifyFromContextual = Get.parameters['source'] == 'contextual_challenge';
  final bool _isNormalFlow = !Get.parameters.containsKey('isRetry') && !Get.parameters.containsKey('source');

  @override
  void initState() {
    super.initState();

    print('🎯 Objective Screen Source:');
    print('   - Retry from Analysis: $_isRetryFromAnalysis');
    print('   - Modify from Contextual: $_isModifyFromContextual');
    print('   - Normal Flow: $_isNormalFlow');

    // Initialize filtered objectives
    filteredObjectives.assignAll(controller.objectives);

    // Use delayed initialization to avoid build phase conflicts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeScreen();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose(); // ✅ DISPOSE: Scroll controller
    super.dispose();
  }

  void _initializeScreen() {
    if (_isInitialized) return;

    _isInitialized = true;

    // Handle different scenarios with appropriate messages
    if (!_hasShownMessage) {
      _hasShownMessage = true;

      Future.delayed(const Duration(milliseconds: 500), () {
        if (_isRetryFromAnalysis) {
          SnackbarHelper.info(
              'Please select a different objective to improve your initiatives'
          );
        } else if (_isModifyFromContextual) {
          SnackbarHelper.info(
              'Select a new objective to adapt to the market challenge'
          );
        }
        // No message for normal flow
      });
    }

    // Clear previous selection for retry/modify scenarios
    if (_isRetryFromAnalysis || _isModifyFromContextual) {
      controller.clearSelection();
      //journeyController.progress.value = 20; // Reset progress
    }

    // Set up objectives listener - safely after build
    ever(controller.objectives, (_) {
      if (mounted) {
        filteredObjectives.assignAll(controller.objectives);
        if (searchController.text.isNotEmpty) {
          filterObjectives(searchController.text);
        }
      }
    });

    // Load objectives if needed
    _loadObjectivesIfNeeded();
  }

  void _loadObjectivesIfNeeded() {
    final args = Get.arguments as Map<String, dynamic>?;
    final selectedRole = args?['selectedRole'] as Map<String, dynamic>?;
    final selectedIndustry = args?['selectedIndustry'] as Map<String, dynamic>?;
    final isCampaignMode = args?['isCampaignMode'] as bool? ?? false;

    // ✅ ONLY FETCH FOR NORMAL FLOW (from strategy screen)
    if (_isNormalFlow) {
      print('🔄 Normal flow detected - Fetching fresh objectives from API');
      _fetchObjectives(selectedRole, selectedIndustry, isCampaignMode);
      return;
    }

    // ✅ FOR RETRY/MODIFY - Use existing objectives
    if (_isRetryFromAnalysis || _isModifyFromContextual) {
      if (controller.objectives.isNotEmpty) {
        print('♻️ Reusing existing ${controller.objectives.length} objectives for ${_isRetryFromAnalysis ? "retry" : "modify"} scenario');
        filteredObjectives.assignAll(controller.objectives);
        return;
      } else {
        // Fallback: If somehow objectives are empty, fetch them
        print('⚠️ No existing objectives found, fetching as fallback...');
        _fetchObjectives(selectedRole, selectedIndustry, isCampaignMode);
      }
    }
  }

  Future<void> _fetchObjectives(
      Map<String, dynamic>? selectedRole,
      Map<String, dynamic>? selectedIndustry,
      bool isCampaignMode,
      ) async {
    try {
      // Show loading message only for normal flow
      if (_isNormalFlow) {
        print('📥 Fetching objectives from API...');
      }

      if (isCampaignMode) {
        if (selectedRole != null && selectedIndustry != null) {
          await controller.getObjectives(selectedRole, selectedIndustry);
          print('✅ Campaign objectives loaded: ${controller.objectives.length}');
        } else {
          SnackbarHelper.error('Missing campaign data. Please restart the campaign.');
        }
      } else {
        if (selectedRole != null && selectedIndustry != null) {
          await controller.getObjectives(selectedRole, selectedIndustry);
          print('✅ Solo objectives loaded: ${controller.objectives.length}');
        } else {
          SnackbarHelper.error('Please select both a role and an industry.');
          await Future.delayed(const Duration(seconds: 1));
          Get.offAllNamed(AppRoutes.selectStrategy, arguments: {
            'selectedRole': selectedRole,
            'selectedIndustry': selectedIndustry,
            'isCampaignMode': isCampaignMode,
          });
        }
      }
    } catch (e) {
      print('❌ Error fetching objectives: $e');
      SnackbarHelper.error('Failed to load objectives');
    }
  }

  String _safeTranslate(String? key, {String fallback = ''}) {
    if (key == null) return fallback;
    try {
      return key.tr;
    } catch (e) {
      return fallback;
    }
  }

  void filterObjectives(String query) {
    if (!mounted) return;

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

  String _getStrategyDisplayText() {
    final strategy = strategyController.selectedStrategy.value;
    if (strategy == null) {
      return 'No strategy selected'.tr;
    }
    return strategy.title ?? 'Unknown Strategy';
  }

  // ✅ DYNAMIC HEADER & MESSAGES BASED ON SOURCE
  String _getHeaderTitle() {
    if (_isRetryFromAnalysis) {
      return 'try_again_with_different'.tr;
    } else if (_isModifyFromContextual) {
      return 'modify'.tr;
    }
    return 'choose'.tr;
  }

  String _getHeaderHighlight() {
    if (_isRetryFromAnalysis) {
      return 'objective'.tr;
    } else if (_isModifyFromContextual) {
      return 'objective'.tr;
    }
    return 'objective'.tr;
  }

  String _getSubtitleText() {
    if (_isRetryFromAnalysis) {
      return 'select_different_objective_retry'.tr;
    } else if (_isModifyFromContextual) {
      return 'select_new_objective_for_challenge'.tr;
    }
    return 'select_one_objective'.tr;
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
      // Return to contextual challenge screen with updated objective
      Get.back(result: controller.selectedObjective.value);
      SnackbarHelper.success('Objective updated successfully');
    } else {
      // Normal flow - go to key results
      Get.offAllNamed(AppRoutes.keyResultsScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 900;

    print('🏗️ Building KeyObjectiveScreen - Source Analysis:');
    print('   - Retry: $_isRetryFromAnalysis');
    print('   - Modify: $_isModifyFromContextual');
    print('   - Normal: $_isNormalFlow');

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
                          title: _getHeaderTitle(),
                          highlightedText: _getHeaderHighlight(),
                          onBackTap: () {
                            final args = Get.arguments as Map<String, dynamic>?;

                            if (_isModifyFromContextual) {
                              // Just go back to contextual challenge
                              Get.back();
                            } else {
                              // Normal navigation back
                              Get.offAllNamed(
                                AppRoutes.selectStrategy,
                                arguments: {
                                  'selectedRole': args?['selectedRole'],
                                  'selectedIndustry': args?['selectedIndustry'],
                                  'isCampaignMode': args?['isCampaignMode'] ?? false,
                                },
                              );
                            }
                          },
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // ✅ Selected strategy container
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _getHorizontalPadding(screenWidth),
                          ),
                          child: Obx(() {
                            return CustomObjectiveContainer(
                              title: _safeTranslate('selected_strategy'),
                              subtitle: _getStrategyDisplayText(),
                              icon: Icons.emoji_objects,
                              titleColor: AppColors.primaryRed,
                            );
                          }),
                        ),

                        SizedBox(height: _getResponsiveSpacing(screenHeight, 0.025)),

                        // ✅ Title and subtitle section - DIFFERENT STYLES BASED ON SOURCE
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
                                _getSubtitleText(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: _getSubtitleFontSize(screenWidth, isTablet, isDesktop),
                                  color: _getSubtitleColor(),
                                  fontFamily: 'Gotham',
                                  height: 1.4,
                                  fontWeight: _getSubtitleFontWeight(),
                                ),
                              ),

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

                        SizedBox(height: _getResponsiveSpacing(screenHeight, 0.02)),

                        // ✅ Objectives list
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _getContentPadding(screenWidth, isTablet),
                          ),
                          child: _buildObjectivesContent(),
                        ),

                        SizedBox(height: _getResponsiveSpacing(screenHeight, 0.03)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _getButtonPadding(screenWidth, isTablet, isDesktop),
                          ),
                          child: Obx(() {
                            return CustomButton2(
                              text: _getButtonText(),
                              onPressed: controller.isButtonEnabled
                                  ? _navigateToNextScreen
                                  : null,
                            );
                          }),
                        ),
                        SizedBox(height: _getResponsiveSpacing(screenHeight, 0.03)),

                        // ✅ Journey map (hide for modification flow)
                        if (!_isModifyFromContextual) ...[
                          Obx(() {
                            return CustomJourneyMap(
                              progress: journeyController.progress.value,
                              steps: journeyController.steps,
                              completedSteps: journeyController.completedSteps,
                              onToggle: journeyController.toggleJourneyDetails,
                              showDetails: journeyController.showDetails.value,
                            );
                          }),
                          SizedBox(height: _getResponsiveSpacing(screenHeight, 0.03)),
                        ],

                        // ✅ Complete selection button

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

  // ✅ SAFE: Build objectives content without nested reactive calls
  Widget _buildObjectivesContent() {
    return Obx(() {
      // Show loader when fetching objectives for normal flow
      if (controller.loading.value && _isNormalFlow) {
        return Container(
          height: 200.h,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: AppColors.primaryRed,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Choosing Objectives for You...',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      if (controller.loading.value && controller.objectives.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.objectives.isEmpty) {
        return Center(
          child: Text(
            'No objectives available',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16.sp,
            ),
          ),
        );
      }

      return _buildObjectivesList(
        MediaQuery.of(Get.context!).size.width,
        MediaQuery.of(Get.context!).size.width > 600,
      );
    });
  }

  Widget _buildObjectivesList(double screenWidth, bool isTablet) {
    final maxWidth = screenWidth > 1200 ? 1200.0 : screenWidth;

    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Column(
        children: [
          SizedBox(height: 2.h), //  Less top spacing
          Container(
            decoration: BoxDecoration(color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
             border: Border.all(color: AppColors.primaryRed, width: 2.w)

            ),
            constraints: BoxConstraints(maxHeight: 400.h),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                trackVisibility: true,
                thickness: 6.w, // ✅ REDUCED: Thinner scrollbar
                radius: Radius.circular(20.r),
                child: Obx(() => isTablet && screenWidth > 800
                    ? GridView.builder(
                  controller: _scrollController, // ✅ ADDED: Scroll controller
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 8.w, // ✅ REDUCED: Less spacing between grid items
                    mainAxisSpacing: 8.h,  // ✅ REDUCED: Less spacing between grid items
                  ),
                  itemCount: filteredObjectives.length,
                  itemBuilder: (context, index) => _buildObjectiveItem(index),
                )
                    : ListView.builder(
                  controller: _scrollController, // ✅ ADDED: Scroll controller
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 8.h), // ✅ ADDED: Bottom padding for scroll
                  itemCount: filteredObjectives.length,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h), // ✅ REDUCED: Less spacing between list items
                    child: _buildObjectiveItem(index),
                  ),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
        margin: EdgeInsets.only(bottom: 2.h), // ✅ REDUCED: Less bottom margin
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.transparent,
            //width: 2.0, // ✅ REDUCED: Thinner border
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: CustomIndustryContainer(
          title: _safeTranslate(titleKey, fallback: 'Title'),
          description: _safeTranslate(descriptionKey, fallback: 'Available'),
          icon: _getObjectiveIcon(index),
          isSelected: isSelected,
          // In _buildObjectiveItem method
          onTap: () {
            controller.selectObjective(obj);
            if (controller.isSelected(obj)) {
              journeyController.completeStep(1); // Mark objective step as complete
            } else {
              journeyController.uncompleteStep(1); // Mark objective step as incomplete
            }
          },
          // ✅ ADD: Remove internal padding if CustomIndustryContainer has too much
         // padding: EdgeInsets.all(12.w), // Adjust as needed
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