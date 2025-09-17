import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/journey_controller.dart';
import '../../../controllers/key_objective_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_journey_map.dart';
import '../../widgets/custom_objective_container.dart';
import '../../widgets/custom_industry_container.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

class KeyObjectiveSelectedScreen extends StatelessWidget {
  KeyObjectiveSelectedScreen({super.key});

  final KeyObjectiveController controller = Get.put(KeyObjectiveController());
  final JourneyController journeyController = Get.find<JourneyController>();

  // Helper method to safely get translated text
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
    // Initialize journey step when screen builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      journeyController.setStep(0, true);
    });

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Responsive calculations
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
                      bottom: _getResponsiveSpacing(screenHeight, 0.025),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.03),

                        /// Custom Header
                        CustomHeader(
                          title: _safeTranslate('choose'),
                          highlightedText: _safeTranslate('objective'),
                          onBackTap: () => Get.offAllNamed(AppRoutes.selectStrategy),
                          showDashboardIcon: true,
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        /// Selected Strategy Container
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _getHorizontalPadding(screenWidth),
                          ),
                          child: CustomObjectiveContainer(
                            title: _safeTranslate('selected_strategy'),
                            subtitle: _safeTranslate('development_new_markets'),
                            description: _safeTranslate('objective_description'),
                            icon: Icons.emoji_objects,
                          ),
                        ),

                        SizedBox(height: _getResponsiveSpacing(screenHeight, 0.025)),

                        /// Choose Your Objective Title
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

                        /// Objectives List
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: _getContentPadding(screenWidth, isTablet),
                          ),
                          child: Obx(
                                () => _buildObjectivesList(screenWidth, isTablet),
                          ),
                        ),

                        SizedBox(height: _getResponsiveSpacing(screenHeight, 0.03)),

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

                        SizedBox(height: _getResponsiveSpacing(screenHeight, 0.03)),

                        /// Complete Selection Button
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

  /// Build objectives list with responsive layout
  Widget _buildObjectivesList(double screenWidth, bool isTablet) {
    // For tablets and larger screens, consider grid layout
    if (isTablet && screenWidth > 800) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: AppDimensions.d16.w,
          mainAxisSpacing: AppDimensions.d16.h,
        ),
        itemCount: controller.objectives.length,
        itemBuilder: (context, index) => _buildObjectiveItem(index),
      );
    }

    // Default column layout for mobile and smaller tablets
    return Column(
      children: List.generate(
        controller.objectives.length,
            (index) => Padding(
          padding: EdgeInsets.only(bottom: AppDimensions.d16.h),
          child: _buildObjectiveItem(index),
        ),
      ),
    );
  }

  /// Build individual objective item
  Widget _buildObjectiveItem(int index) {
    final obj = controller.objectives[index];
    final titleKey = obj['titleKey'] as String?;
    final descriptionKey = obj['descriptionKey'] as String?;

    return CustomIndustryContainer(
      title: _safeTranslate(titleKey, fallback: 'Unknown'),
      description: _safeTranslate(descriptionKey, fallback: 'No description available'),
      icon: obj['icon'] as IconData,
      isSelected: controller.isSelected(index),
      onTap: () {
        controller.selectObjective(index);
        // Update journey progress after selection
        if (controller.isSelected(index)) {
          journeyController.progress.value = 40;
          journeyController.completeStep(0);
        } else {
          journeyController.progress.value = 20;
          journeyController.completedSteps[0] = false;
        }
      },
    );
  }

  // 🔹 RESPONSIVE HELPER METHODS

  /// Get responsive spacing
  double _getResponsiveSpacing(double dimension, double factor) {
    return dimension * factor;
  }

  /// Get horizontal padding for general content
  double _getHorizontalPadding(double screenWidth) {
    if (screenWidth > 1200) return screenWidth * 0.08;
    if (screenWidth > 900) return screenWidth * 0.06;
    if (screenWidth > 600) return screenWidth * 0.05;
    return screenWidth * 0.04;
  }

  /// Get content padding for objectives list
  double _getContentPadding(double screenWidth, bool isTablet) {
    if (isTablet) return screenWidth * 0.07;
    return screenWidth * 0.03;
  }

  /// Get button padding
  double _getButtonPadding(double screenWidth, bool isTablet, bool isDesktop) {
    if (isDesktop) return screenWidth * 0.25;
    if (isTablet) return screenWidth * 0.15;
    return screenWidth * 0.1;
  }

  /// Get title font size
  double _getTitleFontSize(double screenWidth, bool isTablet, bool isDesktop) {
    if (isDesktop) return (screenWidth * 0.035).sp;
    if (isTablet) return (screenWidth * 0.04).sp;
    return (screenWidth * 0.055).sp;
  }

  /// Get subtitle font size
  double _getSubtitleFontSize(double screenWidth, bool isTablet, bool isDesktop) {
    if (isDesktop) return (screenWidth * 0.022).sp;
    if (isTablet) return (screenWidth * 0.026).sp;
    return (screenWidth * 0.038).sp;
  }
}