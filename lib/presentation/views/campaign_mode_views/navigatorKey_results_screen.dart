
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:game_app/presentation/views/campaign_mode_views/widgets/custom_timer_widget.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../../services/shared_preference.dart';
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
class NavigatorKeyResultController extends GetxController {
  final firstKeyResultTitle = TextEditingController();
  final firstKeyResultDesc = TextEditingController();
  final secondKeyResultTitle = TextEditingController();
  final secondKeyResultDesc = TextEditingController();
  final thirdKeyResultTitle = TextEditingController();
  final thirdKeyResultDesc = TextEditingController();

  // Proper GetX reactive variables
  var selectedCount = 0.obs;
  final requiredCount = 3.obs;

  @override
  void onInit() {
    super.onInit();
    // ✅ Add listeners to update count when any text changes
    firstKeyResultTitle.addListener(_updateSelectedCount);
    firstKeyResultDesc.addListener(_updateSelectedCount);
    secondKeyResultTitle.addListener(_updateSelectedCount);
    secondKeyResultDesc.addListener(_updateSelectedCount);
    thirdKeyResultTitle.addListener(_updateSelectedCount);
    thirdKeyResultDesc.addListener(_updateSelectedCount);
  }

  void _updateSelectedCount() {
    int count = 0;
    if (firstKeyResultTitle.text.trim().isNotEmpty &&
        firstKeyResultDesc.text.trim().isNotEmpty) {
      count++;
    }
    if (secondKeyResultTitle.text.trim().isNotEmpty &&
        secondKeyResultDesc.text.trim().isNotEmpty) {
      count++;
    }
    if (thirdKeyResultTitle.text.trim().isNotEmpty &&
        thirdKeyResultDesc.text.trim().isNotEmpty) {
      count++;
    }
    selectedCount.value = count;
  }

  Future<void> submitInitiatives() async {
    if (selectedCount.value < requiredCount.value) {
      Get.snackbar(
        'Error',
        'Please fill in all ${requiredCount.value} key result titles and descriptions before continuing.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      // Prepare key results data
      final keyResults = [
        {
          'title': firstKeyResultTitle.text.trim(),
          'description': firstKeyResultDesc.text.trim(),
        },
        {
          'title': secondKeyResultTitle.text.trim(),
          'description': secondKeyResultDesc.text.trim(),
        },
        {
          'title': thirdKeyResultTitle.text.trim(),
          'description': thirdKeyResultDesc.text.trim(),
        },
      ];

      // Save key results to SharedPreferences
      await SharedPrefs.saveCertificateKeyResults(keyResults);

      // Debug: Print saved data
      SharedPrefs.printCertificateData();

      Get.snackbar(
        'Success',
        'Key results saved successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.toNamed(AppRoutes.navigatorSuggestionInitiativeScreen);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save key results: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    firstKeyResultTitle.dispose();
    firstKeyResultDesc.dispose();
    secondKeyResultTitle.dispose();
    secondKeyResultDesc.dispose();
    thirdKeyResultTitle.dispose();
    thirdKeyResultDesc.dispose();
    super.onClose();
  }
}

// ================== MAIN SCREEN ==================
class NavigatorkeyResultsScreen extends StatefulWidget {
  const NavigatorkeyResultsScreen({super.key});

  @override
  State<NavigatorkeyResultsScreen> createState() =>
      _NavigatorkeyResultsScreenState();
}

class _NavigatorkeyResultsScreenState extends State<NavigatorkeyResultsScreen> {
  final controller = Get.put(NavigatorKeyResultController());

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      body: CustomBackground(
        child: OrientationBuilder(
          builder: (context, orientation) => Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: height * 0.015),
                  child: GetBuilder<NavigatorKeyResultController>(
                    builder: (controller) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomHeader(
                            title: 'Final',
                            highlightedText: 'Test Certification',
                            subtitle: '',
                            onBackTap: () => Get.back(),
                          ),
                          SizedBox(height: height * 0.01),


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
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppColors.primaryRed,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Increase market share by 15% while improving cross-departmental efficiency by 25% within 12 months.',
                                    style: Theme.of(context).textTheme.bodySmall
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
                            currentStep: 2,
                            showCircles: true,
                          ),
                          SizedBox(height: 15.h),
                      //  CustomSelectedKeyResultsContainer(),

                          /// Key Result Input Fields
                          CustomInitiativeInput(
                            numberText: 'First Key Result',
                            titleController: controller.firstKeyResultTitle,
                            descController: controller.firstKeyResultDesc,
                          ),
                          SizedBox(height: 15.h),
                          CustomInitiativeInput(
                            numberText: 'Second Key Result',
                            titleController: controller.secondKeyResultTitle,
                            descController: controller.secondKeyResultDesc,
                          ),
                          SizedBox(height: 15.h),
                          CustomInitiativeInput(
                            numberText: 'Third Key Result',
                            titleController: controller.thirdKeyResultTitle,
                            descController: controller.thirdKeyResultDesc,
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
                                    print('📍 Submitting key results');
                                    controller.submitInitiatives();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
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
// Create a controller for key results
class KeyResultsController extends GetxController {
  var keyResults = <Map<String, String>>[].obs;

  void loadKeyResults() {
    keyResults.value = SharedPrefs.getCertificateKeyResults();
  }

  void updateKeyResults() {
    loadKeyResults();
  }
}

// Then update your widget to use Obx properly:
class CustomSelectedKeyResultsContainer extends StatelessWidget {
  const CustomSelectedKeyResultsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KeyResultsController>();

    return Obx(() {
      final keyResults = controller.keyResults;

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.primaryRed, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.primaryRed, size: 20.w),
                SizedBox(width: 8.w),
                Text(
                  'Selected Key Results',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryRed,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '${keyResults.length}/3',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryRed,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            if (keyResults.isEmpty)
              Text(
                'No key results selected yet. Fill in the fields below.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              )
            else
              ...keyResults.asMap().entries.map((entry) {
                final index = entry.key;
                final result = entry.value;
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              result['title'] ?? 'Untitled',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              result['description'] ?? 'No description',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
          ],
        ),
      );
    });
  }
}