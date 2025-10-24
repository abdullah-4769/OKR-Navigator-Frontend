import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/journey_controller.dart';
import '../../../controllers/key_results_controller.dart';
import '../../../controllers/okr_constellation_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
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
import '../feedback_screen.dart';
import '../suggestion_Initiatives/suggestion_initiatives_creen.dart';

class KeyResultsScreen extends StatelessWidget {
  KeyResultsScreen({super.key});

  final KeyResultsController keyResultsController = Get.put(
    KeyResultsController(),
  );
  final OKRConstellationController constellationController = Get.put(
    OKRConstellationController(),
  );
  final JourneyController journeyController = Get.find<JourneyController>();

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
                          onBackTap: () =>
                              Get.offAllNamed(AppRoutes.keyObjectiveScreen),
                          showDashboardIcon: true,
                        ),

                        SizedBox(height: screenHeight * 0.015),

                        /// Selected Objective Container
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _getHorizontalPadding(screenWidth),
                          ),
                          child: CustomObjectiveContainer(
                            icon: Icons.rocket,
                            title: _safeTranslate('selected_objective'),
                            subtitle: _safeTranslate('launch_2_products'),
                            description: _safeTranslate(
                              'objective_description',
                            ),
                          ),
                        ),

                        SizedBox(
                          height: _getResponsiveSpacing(screenHeight, 0.02),
                        ),

                        /// Selected Key Results Container
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _getHorizontalPadding(screenWidth),
                          ),
                          child: const CustomSelectedKeyResultsContainer(),
                        ),

                        SizedBox(
                          height: _getResponsiveSpacing(screenHeight, 0.02),
                        ),

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
                                  fontSize: _getTitleFontSize(
                                    screenWidth,
                                    isTablet,
                                    isDesktop,
                                  ),
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryRed,
                                  fontFamily: 'GothamBold',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                _safeTranslate('choose_3_outcomes'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: _getSubtitleFontSize(
                                    screenWidth,
                                    isTablet,
                                    isDesktop,
                                  ),
                                  color: AppColors.textSecondary,
                                  fontFamily: 'Gotham',
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: _getResponsiveSpacing(screenHeight, 0.025),
                        ),

                        /// Key Results List
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _getContentPadding(
                              screenWidth,
                              isTablet,
                            ),
                          ),
                          child: Obx(() {
                            if (keyResultsController.loading.value) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (keyResultsController.keyResults.isEmpty) {
                              return Text(
                                _safeTranslate('No Key Results found!'),
                                textAlign: TextAlign.center,
                              );
                            }
                            return _buildKeyResultsList(screenWidth, isTablet);
                          }),
                        ),

                        SizedBox(
                          height: _getResponsiveSpacing(screenHeight, 0.03),
                        ),

                        /// OKR Constellation
                        const CustomOKRConstellation(),

                        SizedBox(
                          height: _getResponsiveSpacing(screenHeight, 0.03),
                        ),

                        /// Journey Map
                        Obx(
                              () => CustomJourneyMap(
                            progress: journeyController.progress.value,
                            steps: journeyController.steps,
                            completedSteps: journeyController.completedSteps,
                            onToggle: journeyController.toggleJourneyDetails,
                            showDetails: journeyController.showDetails.value,
                          ),
                        ),

                        SizedBox(
                          height: _getResponsiveSpacing(screenHeight, 0.03),
                        ),

                        /// Complete Selection Button
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _getButtonPadding(
                              screenWidth,
                              isTablet,
                              isDesktop,
                            ),
                          ),
                          child: Obx(
                                () => CustomButton2(
                              text: _safeTranslate('complete_selection'),


                                  // In KeyResultsScreen - update the navigation
                                  // In KeyResultsScreen - update the navigation with debugging
                                  onPressed: keyResultsController.selectedCount.value ==
                                      keyResultsController.requiredCount.value
                                      ? () {
                                    journeyController.completeStep(2);

                                    // ✅ Debug the selection first
                                    keyResultsController.debugSelection();

                                    // ✅ Convert Map to KeyResult model
                                    final selectedKeyResults = keyResultsController.getSelectedKeyResults();

                                    print('🎯 Final selected key results for API: ${selectedKeyResults.length}');
                                    selectedKeyResults.forEach((kr) {
                                      print('   - ${kr.title}: ${kr.description}');
                                    });

                                    // ✅ Navigate to FeedbackScreen with selected key results
                                    Get.to(
                                          () => FeedbackScreen(
                                        selectedKeyResults: selectedKeyResults,
                                      ),
                                    );
                                  }

                                      : null,
                                  // onPressed: keyResultsController
                              //     .selectedCount.value ==
                              //     keyResultsController.requiredCount.value
                              //     ? () {
                              //   journeyController.completeStep(2);
                              //
                              //   // ✅ Convert Map to KeyResult model
                              //   final selectedKeyResults =
                              //   keyResultsController
                              //       .getSelectedKeyResults();
                              //
                              //   // ✅ Navigate with proper type
                              //   Get.to(
                              //         () => FeedbackScreen(
                              //       // selectedKeyResults:
                              //       // selectedKeyResults,
                              //     ),
                              //   );
                              // }
                              //     : null,
                            ),
                          ),
                        ),

                        SizedBox(
                          height: _getResponsiveSpacing(screenHeight, 0.025),
                        ),
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

  /// Build key results list with responsive layout
  Widget _buildKeyResultsList(double screenWidth, bool isTablet) {
    if (isTablet && screenWidth > 800) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          crossAxisSpacing: AppDimensions.d16.w,
          mainAxisSpacing: AppDimensions.d16.h,
        ),
        itemCount: keyResultsController.keyResults.length,
        itemBuilder: (context, index) => _buildKeyResultItem(index),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: keyResultsController.keyResults.length,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: AppDimensions.d16.h),
        child: _buildKeyResultItem(index),
      ),
    );
  }

  /// Build individual key result item
  Widget _buildKeyResultItem(int index) {
    final item = keyResultsController.keyResults[index];

    return Obx(
          () => CustomIndustryContainer(
        title: _safeTranslate(item['title'], fallback: 'Unknown Title'),
        description: _safeTranslate(
          item['description'],
          fallback: 'No description',
        ),
        icon: item['icon'] ?? Icons.rocket,
        isSelected: keyResultsController.isSelected(index),
        onTap: () {
          keyResultsController.toggleSelection(index);
          final icon = item['icon'] ?? Icons.key;
          if (keyResultsController.isSelected(index)) {
            constellationController.addIcon(icon);
          } else {
            constellationController.removeIcon(icon);
          }
        },
        showTag1: true,
        tag1Icon: Icons.trending_up,
        tag1Text: _safeTranslate(item['tag1'] ?? '', fallback: ''),
        showTag2: true,
        tag2Icon: Icons.access_time,
        tag2Text: _safeTranslate(item['tag2'] ?? '', fallback: ''),
      ),
    );
  }

  // 🔹 RESPONSIVE HELPER METHODS

  double _getResponsiveSpacing(double dimension, double factor) {
    return dimension * factor;
  }

  double _getHorizontalPadding(double screenWidth) {
    if (screenWidth > 1200) return screenWidth * 0.06;
    if (screenWidth > 900) return screenWidth * 0.04;
    if (screenWidth > 600) return screenWidth * 0.03;
    return screenWidth * 0.02;
  }

  double _getContentPadding(double screenWidth, bool isTablet) {
    if (isTablet) return screenWidth * 0.06;
    return screenWidth * 0.04;
  }

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

  double _getSubtitleFontSize(
      double screenWidth,
      bool isTablet,
      bool isDesktop,
      ) {
    if (isDesktop) return (screenWidth * 0.026).sp;
    if (isTablet) return (screenWidth * 0.030).sp;
    return (screenWidth * 0.039).sp;
  }
}