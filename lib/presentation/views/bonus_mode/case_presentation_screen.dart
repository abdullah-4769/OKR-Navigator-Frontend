import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../../../view_model/bonus_controller/bonus_controller.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import 'objective_input_screen.dart';
import 'package:get/Get.dart';


class CasePresentationScreen extends StatefulWidget {
  final Map? selectedIndustry; // Industry data pass کریں

  const CasePresentationScreen({
    super.key,
    this.selectedIndustry,
  });

  @override
  State<CasePresentationScreen> createState() => _CasePresentationScreenState();
}

class _CasePresentationScreenState extends State<CasePresentationScreen> {
  final BonusModeController controller = Get.find();
  bool isLoadingScenario = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadScenario();
    });
  }

  Future<void> _loadScenario() async {
    try {
      setState(() => isLoadingScenario = true);

      // Industry اور role لیں
      final industryName = widget.selectedIndustry?['titleKey'] ?? 'Banking';
      final role = 'CEO'; // یا SharedPrefs سے لیں

      print('🔄 Generating scenario...');
      print('   Industry: $industryName');
      print('   Role: $role');

      // API call کریں
      await controller.generateScenario(role, industryName);

      print('✅ Scenario loaded:');
      print('   Title: ${controller.scenarioTitle.value}');
      print('   Description: ${controller.scenarioDescription.value}');

      setState(() => isLoadingScenario = false);
    } catch (e) {
      print('❌ Error loading scenario: $e');
      setState(() => isLoadingScenario = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: Column(
          children: [
            CustomHeader(
              title: 'todays_case'.tr,
              onBackTap: () => Get.back(),
            ),
            Expanded(
              child: SafeArea(
                top: false,
                child: isLoadingScenario
                    ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryRed,
                  ),
                )
                    : SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30.h),
                      // Industry
                      _buildInfoCard(
                        'industry'.tr,
                        controller.scenarioTitle.value.isEmpty
                            ? 'Banking'
                            : controller.scenarioTitle.value,
                        Icons.business,
                      ),
                      SizedBox(height: 16.h),
                      // Vision/Description
                      _buildInfoCard(
                        'vision'.tr,
                        controller.scenarioDescription.value.isEmpty
                            ? 'vision_description'.tr
                            : controller.scenarioDescription.value,
                        Icons.visibility,
                      ),
                      SizedBox(height: 16.h),
                      // Strategy (static for now)
                      _buildInfoCard(
                        'strategy'.tr,
                        'strategy_description'.tr,
                        Icons.lightbulb_outline,
                      ),
                      SizedBox(height: 32.h),
                      // Problems Section
                      _buildProblemsSection(),
                      SizedBox(height: 50.h),
                      CustomButton2(
                        text: 'define_objective'.tr,
                        onPressed: () =>
                            Get.to(() => ObjectiveInputScreen()),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: AppColors.primaryRed, size: 28.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProblemsSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryRed.withOpacity(0.1),
            AppColors.primaryRed.withOpacity(0.05)
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.primaryRed.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: AppColors.primaryRed, size: 28.sp),
              SizedBox(width: 12.w),
              Text(
                'problems_faced'.tr,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryRed,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...[
            'digital_outages'.tr,
            'high_operational_costs'.tr,
            'slow_staff_adoption'.tr
          ].map((p) => Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 6.h),
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    p,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}