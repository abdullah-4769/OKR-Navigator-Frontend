
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/views/campaign_mode_views/widgets/custom_timer_widget.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../services/campaign/certification_evaluation_viewmodel.dart';
import '../../../services/shared_preference.dart';
import '../../routes/app_routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/custom_initiative_input.dart';
import '../../widgets/global_widgets/custom_progress_path.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import '../../widgets/team_mode_widgets/section_card.dart';
import '../../widgets/custom_objective_container.dart';
import '../../widgets/custom_selected_key_result_container.dart';
import '../../widgets/responsive_arrow.dart';
// ================== CONTROLLER ==================
class NavigatorSuggestionInitiativesController extends GetxController {
  final firstInitiativeTitle = TextEditingController();
  final firstInitiativeDesc = TextEditingController();
  final secondInitiativeTitle = TextEditingController();
  final secondInitiativeDesc = TextEditingController();

  final selectedCount = 0.obs;
  final requiredCount = 2.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // ✅ Add listeners to update count when any text changes
    firstInitiativeTitle.addListener(updateSelectedCount);
    firstInitiativeDesc.addListener(updateSelectedCount);
    secondInitiativeTitle.addListener(updateSelectedCount);
    secondInitiativeDesc.addListener(updateSelectedCount);
  }

  void updateSelectedCount() {
    int count = 0;
    if (firstInitiativeTitle.text.trim().isNotEmpty &&
        firstInitiativeDesc.text.trim().isNotEmpty) {
      count++;
    }
    if (secondInitiativeTitle.text.trim().isNotEmpty &&
        secondInitiativeDesc.text.trim().isNotEmpty) {
      count++;
    }
    selectedCount.value = count;
  }

  Future<void> submitInitiatives() async {
    if (selectedCount.value < requiredCount.value) {
      Get.snackbar(
        'Error',
        'Please fill in all ${requiredCount.value} initiative titles and descriptions before continuing.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Prepare initiatives data
      final initiatives = [
        {
          'title': firstInitiativeTitle.text.trim(),
          'description': firstInitiativeDesc.text.trim(),
        },
        {
          'title': secondInitiativeTitle.text.trim(),
          'description': secondInitiativeDesc.text.trim(),
        },
      ];

      // Save initiatives to SharedPreferences
      await SharedPrefs.saveCertificateInitiatives(initiatives);

      // Debug: Print all saved data
      SharedPrefs.printCertificateData();

      // ✅ INTEGRATE API CALL HERE
      await _submitEvaluationToAPI();

      Get.snackbar(
        'Success',
        'Evaluation completed successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to results screen
      Get.toNamed(AppRoutes.campaignFinalCertificationScreen);

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit evaluation: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _submitEvaluationToAPI() async {
    try {
      print('🚀 Starting API evaluation submission...');

      // Get the viewmodel and submit evaluation
      final viewModel = Get.find<CertificationEvaluationViewModel>();
      await viewModel.submitFinalEvaluation();

      print('✅ API evaluation completed successfully!');

    } catch (e) {
      print('❌ API evaluation failed: $e');
      rethrow;
    }
  }

  @override
  void onClose() {
    firstInitiativeTitle.dispose();
    firstInitiativeDesc.dispose();
    secondInitiativeTitle.dispose();
    secondInitiativeDesc.dispose();
    super.onClose();
  }
}
// ================== MAIN SCREEN ==================
class NavigatorSuggestionInitiativesScreen extends StatefulWidget {
  const NavigatorSuggestionInitiativesScreen({super.key});

  @override
  State<NavigatorSuggestionInitiativesScreen> createState() =>
      _NavigatorSuggestionInitiativesScreenState();
}

class _NavigatorSuggestionInitiativesScreenState extends State<NavigatorSuggestionInitiativesScreen> {
  final controller = Get.put(NavigatorSuggestionInitiativesController());

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    final size = MediaQuery
        .of(context)
        .size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      body: CustomBackground(
        child: OrientationBuilder(
          builder: (context, orientation) =>
              Stack(
                children: [
                  Positioned.fill(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: height * 0.015),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomHeader(
                            title: 'Final',
                            highlightedText: 'Test Certification',
                            subtitle: '',
                            onBackTap: () => Get.back(),
                          ),
                          SizedBox(height: height * 0.01),
                          const Center(child: ResponsiveArrow()),
                          Center(child:
                          CountdownTimerWidget(

                            size: 130,
                            onTimerComplete: () {
                              // Custom navigation or action
                              Get.offAllNamed('/campaignModeScreen');
                              // Or any other action
                            },
                          )),
                          SizedBox(height: 10.h),
                          Center(child: const ResponsiveArrow()),
                          SizedBox(height: 10.h),
                          /// Scenario
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CustomObjectiveContainer(
                              title: 'Business Scenario',
                              description: SharedPrefs.getCertificateScenario(),
                              icon: Icons.business_center,
                            ),
                          ),

                          /// Impact section
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryRed.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.yellow.withOpacity(0.7),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Impact: ',
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                    color: AppColors.primaryRed,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Increase market share by 15% while improving cross-departmental efficiency by 25% within 12 months.',
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: AppColors.primaryRed),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),

                          /// Progress Path
                          Text("Your OKR Progress Path"),
                          SizedBox(height: 5.h),
                          CustomProgressPath(
                            stepLabels: ["1", "2", "3", "4"],
                            currentStep: 4,
                            showCircles: true,
                          ),
                          SizedBox(height: 15.h),
                        //  CustomSelectedKeyResultsContainer(),

                          /// Initiative Input Fields
                          CustomInitiativeInput(
                            numberText: 'First Initiative',
                            titleController: controller.firstInitiativeTitle,
                            descController: controller.firstInitiativeDesc,
                          ),
                          SizedBox(height: 15.h),
                          CustomInitiativeInput(
                            numberText: 'Second Initiative',
                            titleController: controller.secondInitiativeTitle,
                            descController: controller.secondInitiativeDesc,
                          ),
                          SizedBox(height: 20.h),

                          /// Continue Button
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.d24,
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: AppDimensions.d12),
                                CustomButton(
                                  icon: Icons.launch,
                                  text: "Continue",
                                  onPressed: () {
                                    print('📍 Submitting initiatives');
                                    controller.submitInitiatives();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// Floating NavBar
                  Positioned(
                    right: width * -0.07,
                    top: height * 0.5,
                    child: const CustomHomeNavBar(),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}