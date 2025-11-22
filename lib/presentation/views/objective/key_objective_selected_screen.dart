// COMPLETE UPDATED KEY_OBJECTIVE_SELECTED_SCREEN.DART
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
import '../../../generated/models/responses/strategy/strategy_response.dart';
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
  // ✅ Make args nullable
  late final Map<String, dynamic>? args;
  late final StrategyResponse? strategy;
  late final String? strategyDisplayTitle;
  late final int? strategyCardIndex;

  final TextEditingController searchController = TextEditingController();
  final RxList<Objective> filteredObjectives = RxList<Objective>();
  final KeyObjectiveController controller = Get.find<KeyObjectiveController>();
  final JourneyController journeyController = Get.find<JourneyController>();
  final StrategySelectionController strategyController = Get.find<StrategySelectionController>();

  final ScrollController _scrollController = ScrollController();

  bool _isInitialized = false;
  bool _hasShownMessage = false;

  late final bool _isRetryFromAnalysis;
  late final bool _isModifyFromContextual;
  late final bool _isNormalFlow;

  @override
  void initState() {
    super.initState();

    // ✅ Safely get arguments
    args = Get.arguments as Map<String, dynamic>?;

    strategy = args?['strategy'] as StrategyResponse?;
    strategyDisplayTitle = args?['strategyDisplayTitle'] as String?;
    strategyCardIndex = args?['strategyCardIndex'] as int?;

    _isRetryFromAnalysis = Get.parameters['isRetry'] == 'true';
    _isModifyFromContextual = Get.parameters['source'] == 'contextual_challenge';
    _isNormalFlow = !_isRetryFromAnalysis && !_isModifyFromContextual;

    filteredObjectives.assignAll(controller.objectives);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeScreen();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeScreen() {
    if (_isInitialized) return;
    _isInitialized = true;

    if (!_hasShownMessage) {
      _hasShownMessage = true;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_isRetryFromAnalysis) {
          SnackbarHelper.info('Please select a different objective to improve your initiatives');
        } else if (_isModifyFromContextual) {
          SnackbarHelper.info('Select a new objective to adapt to the market challenge');
        }
      });
    }

    if (_isRetryFromAnalysis || _isModifyFromContextual) {
      controller.clearSelection();
    }

    ever(controller.objectives, (_) {
      if (mounted) {
        filteredObjectives.assignAll(controller.objectives);
        if (searchController.text.isNotEmpty) {
          filterObjectives(searchController.text);
        }
      }
    });

    _loadObjectivesIfNeeded();
  }

  void _loadObjectivesIfNeeded() {
    final selectedRole = args?['selectedRole'] as Map<String, dynamic>?;
    final selectedIndustry = args?['selectedIndustry'] as Map<String, dynamic>?;
    final isCampaignMode = args?['isCampaignMode'] as bool? ?? false;

    if (_isNormalFlow) {
      _fetchObjectives(selectedRole, selectedIndustry, isCampaignMode);
      return;
    }

    if (_isRetryFromAnalysis || _isModifyFromContextual) {
      if (controller.objectives.isNotEmpty) {
        filteredObjectives.assignAll(controller.objectives);
        return;
      } else {
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
      if (selectedRole != null && selectedIndustry != null) {
        await controller.getObjectives(selectedRole, selectedIndustry);
      } else {
        SnackbarHelper.error('Missing role or industry info.');
        await Future.delayed(const Duration(seconds: 1));
        Get.offAllNamed(AppRoutes.selectStrategy, arguments: args);
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

  // String _getStrategyDisplayText() {
  //   if (strategyDisplayTitle != null && strategyDisplayTitle!.isNotEmpty) {
  //     return strategyDisplayTitle!;
  //   }
  //
  //   if (strategyCardIndex != null && strategyCardIndex! >= 0) {
  //     final titleFromController = strategyController.getCardTitle(strategyCardIndex!);
  //     if (titleFromController != null && titleFromController.isNotEmpty) {
  //       return titleFromController;
  //     }
  //   }
  //
  //   final controllerStrategy = strategyController.selectedStrategy.value;
  //   if (controllerStrategy != null) {
  //     final titleFromIndex = strategyController.getCardTitle(strategyController.selectedCardIndex.value);
  //     if (titleFromIndex != null && titleFromIndex.isNotEmpty) {
  //       return titleFromIndex;
  //     }
  //   }
  //
  //   final apiTitle = strategy?.title ?? 'No strategy selected'.tr;
  //   return apiTitle;
  // }
  String _getStrategyDisplayText() {
    // Priority checks for title retrieval
    if (strategyDisplayTitle != null && strategyDisplayTitle!.isNotEmpty) {
      print('✅ Using strategyDisplayTitle: $strategyDisplayTitle');
      return strategyDisplayTitle!;
    }

    final strategyFromController = strategyController.selectedStrategy.value;

    // Check if backend card ID is available and match titles
    if (strategyFromController?.cardId != null) {
      final titleFromBackendId = strategyController.getCardTitleFromBackendId(strategyFromController?.cardId);
      if (titleFromBackendId != null && titleFromBackendId.isNotEmpty) {
        print('✅ Using title from backend ID mapping: $titleFromBackendId');
        return titleFromBackendId;
      }
    }

    // Fallback options for titles
    if (strategyCardIndex != null && strategyCardIndex! >= 0) {
      final titleFromController = strategyController.getCardTitle(strategyCardIndex!);
      if (titleFromController != null && titleFromController.isNotEmpty) {
        print('⚠️ Using title from controller card index: $titleFromController');
        return titleFromController;
      }
    }

    final controllerStrategy = strategyController.selectedStrategy.value;
    if (controllerStrategy != null && controllerStrategy.title != null && controllerStrategy.title!.isNotEmpty) {
      print('⚠️ Using API title from controller: ${controllerStrategy.title}');
      return controllerStrategy.title!;
    }

    print('❌ No strategy title found, using fallback');
    return 'No strategy selected'.tr;
  }  String _getHeaderTitle() {
    if (_isRetryFromAnalysis) return 'try_again_with_different'.tr;
    if (_isModifyFromContextual) return 'modify'.tr;
    return 'choose'.tr;
  }

  String _getHeaderHighlight() => 'objective'.tr;

  String _getSubtitleText() {
    if (_isRetryFromAnalysis) return 'select_different_objective_retry'.tr;
    if (_isModifyFromContextual) return 'select_new_objective_for_challenge'.tr;
    return 'select_one_objective'.tr;
  }

  String _getButtonText() {
    if (_isModifyFromContextual) return 'save_changes'.tr;
    return 'complete_selection'.tr;
  }

  void _navigateToNextScreen() {
    if (_isModifyFromContextual) {
      Get.back(result: controller.selectedObjective.value);
      SnackbarHelper.success('Objective updated successfully');
    } else {
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
                              Get.back();
                            } else {
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

                        // ✅ FIXED: Strategy display without unnecessary Obx wrapper
                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //     horizontal: _getHorizontalPadding(screenWidth),
                        //   ),
                        //   child: CustomObjectiveContainer(
                        //     title: _safeTranslate('selected_strategy'),
                        //     subtitle: _getStrategyDisplayText(),
                        //     icon: Icons.emoji_objects,
                        //     titleColor: AppColors.primaryRed,
                        //   ),
                        // ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _getHorizontalPadding(screenWidth),
                          ),
                          child: CustomObjectiveContainer(
                            title: _safeTranslate('selected_strategy'),
                            subtitle: _getStrategyDisplayText(),
                            icon: Icons.emoji_objects,
                            titleColor: AppColors.primaryRed,
                          ),
                        ),                        SizedBox(height: _getResponsiveSpacing(screenHeight, 0.025)),

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

  Color _getSubtitleColor() {
    if (_isRetryFromAnalysis) return AppColors.primaryRed;
    if (_isModifyFromContextual) return AppColors.primaryBlue;
    return AppColors.textSecondary;
  }

  FontWeight _getSubtitleFontWeight() {
    if (_isRetryFromAnalysis || _isModifyFromContextual) return FontWeight.w600;
    return FontWeight.normal;
  }

  Widget _buildObjectivesContent() {
    return Obx(() {
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
          SizedBox(height: 2.h),
          Container(
            decoration: BoxDecoration(
                color: AppColors.white,
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
                thickness: 6.w,
                radius: Radius.circular(20.r),
                child: Obx(() => isTablet && screenWidth > 800
                    ? GridView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.h,
                  ),
                  itemCount: filteredObjectives.length,
                  itemBuilder: (context, index) => _buildObjectiveItem(index),
                )
                    : ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 8.h),
                  itemCount: filteredObjectives.length,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
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
        margin: EdgeInsets.only(bottom: 2.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: CustomIndustryContainer(
          title: _safeTranslate(titleKey, fallback: 'Title'.tr),
          description: _safeTranslate(descriptionKey, fallback: 'Available'.tr),
          icon: _getObjectiveIcon(index),
          isSelected: isSelected,
          onTap: () {
            controller.selectObjective(obj);
            if (controller.isSelected(obj)) {
              journeyController.completeStep(1);
            } else {
              journeyController.uncompleteStep(1);
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