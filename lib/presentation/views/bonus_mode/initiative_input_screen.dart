import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../../../view_model/bonus_controller/bonus_controller.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import 'evaluation_loading_screen.dart';

class InitiativeInputScreen extends StatefulWidget {
  final String objective;
  final String kr1;
  final String kr2;

  const InitiativeInputScreen({
    required this.objective,
    required this.kr1,
    required this.kr2,
    super.key,
  });

  @override
  State<InitiativeInputScreen> createState() => _InitiativeInputScreenState();
}

class _InitiativeInputScreenState extends State<InitiativeInputScreen> {
  final TextEditingController initiativeCtrl = TextEditingController();
  final BonusModeController controller = Get.find();

  @override
  void initState() {
    super.initState();
    controller.startCountdownTimer();
  }

  @override
  void dispose() {
    controller.stopCountdownTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.stopCountdownTimer();
        return true;
      },
      child: Scaffold(
        body: CustomBackground(
          child: Column(
            children: [
              CustomHeader(title: 'step_3_initiative'.tr, onBackTap: () {
                controller.stopCountdownTimer();
                Get.back();
              }),
              Expanded(
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      children: [
                        SizedBox(height: 32.h),
                        _buildTimerCard(),
                        SizedBox(height: 24.h),
                        _buildInstructionCard(),
                        SizedBox(height: 32.h),
                        _buildInputField(initiativeCtrl),
                        SizedBox(height: 50.h),
                        CustomButton2(
                          text: 'submit_for_ai_evaluation'.tr,
                          onPressed: () async {
                            if (initiativeCtrl.text.isEmpty) {
                              Get.snackbar('Error'.tr, 'Please enter an initiative'.tr);
                              return;
                            }

                            controller.setInitiative(initiativeCtrl.text);
                            controller.stopCountdownTimer();

                            Get.to(() => EvaluationLoadingScreen(
                              objective: widget.objective,
                              kr1: widget.kr1,
                              kr2: widget.kr2,
                              initiative: initiativeCtrl.text,
                            ));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimerCard() {
    return Obx(() => Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.withOpacity(0.2), Colors.red.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: controller.remainingSeconds.value < 60
              ? Colors.red.withOpacity(0.5)
              : Colors.orange.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timer,
            color: controller.remainingSeconds.value < 60 ? Colors.red : Colors.orange,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Text(
            controller.getFormattedTime(),
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: controller.remainingSeconds.value < 60 ? Colors.red : Colors.orange,
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            'time_remaining'.tr,
            style: TextStyle(fontSize: 14.sp, color: Colors.black54),
          ),
        ],
      ),
    ));
  }

  Widget _buildInstructionCard() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryRed.withOpacity(0.1), AppColors.primaryRed.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Icon(Icons.lightbulb, size: 48.sp, color: AppColors.primaryRed),
          SizedBox(height: 16.h),
          Text(
            'propose_one_actionable_initiative'.tr,
            style: TextStyle(fontSize: 20.sp, color: Colors.black87, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text('initiative_hint'.tr, style: TextStyle(fontSize: 14.sp, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildInputField(TextEditingController ctrl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: TextField(
        controller: ctrl,
        maxLines: 6,
        style: TextStyle(color: Colors.black87, fontSize: 16.sp, height: 1.5),
        decoration: InputDecoration(
          hintText: 'example_initiative'.tr,
          hintStyle: TextStyle(color: Colors.black38, fontSize: 15.sp),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.r), borderSide: BorderSide.none),
          contentPadding: EdgeInsets.all(20.w),
        ),
      ),
    );
  }
}