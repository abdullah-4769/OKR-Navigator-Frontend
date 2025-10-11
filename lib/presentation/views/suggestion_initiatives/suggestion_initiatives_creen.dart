import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/widgets/screens_unique_parts/custom_background.dart';
import 'package:get/get.dart';

import '../../../controllers/journey_controller.dart';
import '../../../controllers/suggestion_initiatives_ontroller.dart';
import '../../../core/app_dimensions.dart';
import '../../../generated/models/responses/key_results/key_results_response.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_ai_strategy_container.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_initiative_input.dart';
import '../../widgets/custom_journey_map.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

class SuggestionInitiativesScreen extends StatelessWidget {
  final List<KeyResult> selectedKeyResults;

  SuggestionInitiativesScreen({super.key, required this.selectedKeyResults});

  final JourneyController journeyController = Get.find<JourneyController>();
  final controller = Get.put(SuggestionInitiativesController());

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      body: CustomBackground(
        child: SafeArea(
          child: Stack(
            children: [
              /// 🔹 Main Content
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: AppDimensions.d18.h),
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * 0.03),

                      /// 🔹 Header
                      CustomHeader(
                        title: 'suggestion'.tr,
                        highlightedText: 'of_initiatives'.tr,
                        subtitle: 'add_initiatives_subtitle'.tr,
                        onBackTap: () =>
                            Get.offAllNamed(AppRoutes.keyResultsScreen),
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      /// 🔹 Initiative Inputs
                      CustomInitiativeInput(
                        numberText: 'first_initiative'.tr,
                        titleController: controller.firstInitiativeTitle,
                        descController: controller.firstInitiativeDesc,
                      ),
                      CustomInitiativeInput(
                        numberText: 'second_initiative'.tr,
                        titleController: controller.secondInitiativeTitle,
                        descController: controller.secondInitiativeDesc,
                      ),

                      SizedBox(height: AppDimensions.d12.h),

                      /// 🔹 AI Strategy Suggestion
                      const CustomAIStrategyContainer(),

                      SizedBox(height: AppDimensions.d28.h),

                      /// 🔹 Journey Map
                      Obx(
                        () => CustomJourneyMap(
                          progress: journeyController.progress.value,
                          steps: journeyController.steps,
                          completedSteps: journeyController.completedSteps,
                          onToggle: journeyController.toggleJourneyDetails,
                          showDetails: journeyController.showDetails.value,
                        ),
                      ),

                      SizedBox(height: AppDimensions.d28.h),

                      /// 🔹 Complete Button
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.d40.w,
                        ),
                        child: Obx(
                          () => CustomButton2(
                            text: controller.isSubmitting.value
                                ? 'submitting'.tr
                                : 'submit_analysis'.tr,
                            onPressed: controller.isSubmitting.value
                                ? null
                                : () => controller.submitInitiatives(
                                    selectedKeyResults,
                                  ),
                          ),
                        ),
                      ),

                      SizedBox(height: AppDimensions.d28.h),
                    ],
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
}
