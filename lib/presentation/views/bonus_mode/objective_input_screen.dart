// // lib/presentation/views/bonus_mode/objective_input_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/Get.dart';
// import '../../../core/app_colors.dart';
// import '../../../view_model/bonus_controller/bonus_controller.dart';
// import '../../widgets/custom_button2.dart';
// import '../../widgets/custom_home_navbar.dart';
// import '../../widgets/screens_unique_parts/custom_background.dart';
// import '../../widgets/screens_unique_parts/custom_header.dart';
// import 'key_result_input_screen.dart';
//
//
// class ObjectiveInputScreen extends StatelessWidget {
//   final TextEditingController objectiveCtrl = TextEditingController();
//   final BonusModeController controller = Get.find();
//
//   ObjectiveInputScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomBackground(
//         child: Column(
//           children: [
//             CustomHeader(title: 'step_1_objective'.tr, onBackTap: () => Get.back()),
//             Expanded(
//               child: SafeArea(
//                 top: false,
//                 child: SingleChildScrollView(
//                   padding: EdgeInsets.all(24.w),
//                   child: Column(
//                     children: [
//                       SizedBox(height: 40.h),
//                       _buildInstructionCard(),
//                       SizedBox(height: 32.h),
//                       _buildInputField(objectiveCtrl, 'example_objective'.tr),
//                       SizedBox(height: 50.h),
//                       CustomButton2(
//                         text: 'next_key_results'.tr,
//                         onPressed: () {
//                           if (objectiveCtrl.text.isEmpty) {
//                             Get.snackbar('Error'.tr, 'Please enter an objective'.tr);
//                             return;
//                           }
//                           controller.setObjective(objectiveCtrl.text);
//                           Get.to(() => KeyResultsInputScreen(objective: objectiveCtrl.text,));
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInstructionCard() {
//     return Container(
//       padding: EdgeInsets.all(24.w),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [AppColors.primaryRed.withOpacity(0.1), AppColors.primaryRed.withOpacity(0.05)],
//         ),
//         borderRadius: BorderRadius.circular(20.r),
//       ),
//       child: Column(
//         children: [
//           Icon(Icons.flag, size: 48.sp, color: AppColors.primaryRed),
//           SizedBox(height: 16.h),
//           Text(
//             'write_one_ambitious_objective'.tr,
//             style: TextStyle(fontSize: 20.sp, color: Colors.black87, fontWeight: FontWeight.w600),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 8.h),
//           Text('objective_hint'.tr, style: TextStyle(fontSize: 14.sp, color: Colors.black54)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInputField(TextEditingController ctrl, String hint) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20.r),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: Offset(0, 4))],
//       ),
//       child: TextField(
//         controller: ctrl,
//         maxLines: 5,
//         style: TextStyle(color: Colors.black87, fontSize: 16.sp, height: 1.5),
//         decoration: InputDecoration(
//           hintText: hint,
//           hintStyle: TextStyle(color: Colors.black38, fontSize: 15.sp),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.r), borderSide: BorderSide.none),
//           contentPadding: EdgeInsets.all(20.w),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/views/bonus_mode/persistent_timer_widget.dart';
import 'package:get/Get.dart';
import '../../../core/app_colors.dart';
import '../../../view_model/bonus_controller/bonus_controller.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import 'key_result_input_screen.dart';

class ObjectiveInputScreen extends StatelessWidget {
  final TextEditingController objectiveCtrl = TextEditingController();
  final BonusModeController controller = Get.find();

  ObjectiveInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Timer continues - don't stop it
        return true;
      },
      child: Scaffold(
        body: CustomBackground(
          child: Column(
            children: [
              CustomHeader(
                title: 'step_1_objective'.tr,
                onBackTap: () => Get.back(),
              ),
              // ✅ USE REUSABLE TIMER WIDGET
              PersistentTimerWidget(showTimeUpAlert: true),
              Expanded(
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      children: [
                        SizedBox(height: 40.h),
                        _buildInstructionCard(),
                        SizedBox(height: 32.h),
                        _buildInputField(objectiveCtrl, 'example_objective'.tr),
                        SizedBox(height: 50.h),
                        CustomButton2(
                          text: 'next_key_results'.tr,
                          onPressed: () {
                            if (objectiveCtrl.text.isEmpty) {
                              Get.snackbar('Error'.tr, 'Please enter an objective'.tr);
                              return;
                            }
                            controller.setObjective(objectiveCtrl.text);
                            Get.to(() => KeyResultsInputScreen(objective: objectiveCtrl.text));
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
          Icon(Icons.flag, size: 48.sp, color: AppColors.primaryRed),
          SizedBox(height: 16.h),
          Text(
            'write_one_ambitious_objective'.tr,
            style: TextStyle(fontSize: 20.sp, color: Colors.black87, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text('objective_hint'.tr, style: TextStyle(fontSize: 14.sp, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildInputField(TextEditingController ctrl, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: TextField(
        controller: ctrl,
        maxLines: 5,
        style: TextStyle(color: Colors.black87, fontSize: 16.sp, height: 1.5),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black38, fontSize: 15.sp),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.r), borderSide: BorderSide.none),
          contentPadding: EdgeInsets.all(20.w),
        ),
      ),
    );
  }
}