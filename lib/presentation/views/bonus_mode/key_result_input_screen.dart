// // lib/presentation/views/bonus_mode/key_results_input_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/Get.dart';
// import '../../../core/app_colors.dart';
// import '../../../view_model/bonus_controller/bonus_controller.dart';
// import '../../widgets/custom_button2.dart';
// import '../../widgets/custom_home_navbar.dart';
// import '../../widgets/screens_unique_parts/custom_background.dart';
// import '../../widgets/screens_unique_parts/custom_header.dart';
// import 'initiative_input_screen.dart';
//
// class KeyResultsInputScreen extends StatelessWidget {
//   final String objective;
//   final TextEditingController kr1Ctrl = TextEditingController();
//   final TextEditingController kr2Ctrl = TextEditingController();
//   final BonusModeController controller = Get.find();
//
//   KeyResultsInputScreen({required this.objective, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomBackground(
//         child: Column(
//           children: [
//             CustomHeader(title: 'step_2_key_results'.tr, onBackTap: () => Get.back()),
//             Expanded(
//               child: SafeArea(
//                 top: false,
//                 child: SingleChildScrollView(
//                   padding: EdgeInsets.all(24.w),
//                   child: Column(
//                     children: [
//                       SizedBox(height: 32.h),
//                       _buildInstructionCard(),
//                       SizedBox(height: 32.h),
//                       _buildKRField(kr1Ctrl, 1),
//                       SizedBox(height: 24.h),
//                       _buildKRField(kr2Ctrl, 2),
//                       SizedBox(height: 50.h),
//                       CustomButton2(
//                         text: 'next_initiative'.tr,
//                         onPressed: () {
//                           if (kr1Ctrl.text.isEmpty || kr2Ctrl.text.isEmpty) {
//                             Get.snackbar('Error'.tr, 'Please fill all key results'.tr);
//                             return;
//                           }
//                           controller.setKeyResults(kr1Ctrl.text, kr2Ctrl.text);
//                           Get.to(() => InitiativeInputScreen(
//                             objective: objective,
//                             kr1: kr1Ctrl.text,
//                             kr2: kr2Ctrl.text,
//                           ));
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
//           Icon(Icons.track_changes, size: 48.sp, color: AppColors.primaryRed),
//           SizedBox(height: 16.h),
//           Text(
//             'define_two_measurable_krs'.tr,
//             style: TextStyle(fontSize: 20.sp, color: Colors.black87, fontWeight: FontWeight.w600),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 8.h),
//           Text('kr_hint'.tr, style: TextStyle(fontSize: 14.sp, color: Colors.black54)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildKRField(TextEditingController ctrl, int number) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Container(
//               width: 32.w,
//               height: 32.w,
//               decoration: BoxDecoration(color: AppColors.primaryRed, shape: BoxShape.circle),
//               child: Center(child: Text('$number', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp))),
//             ),
//             SizedBox(width: 12.w),
//             Text('key_result_$number'.tr, style: TextStyle(fontSize: 18.sp, color: Colors.black87, fontWeight: FontWeight.bold)),
//           ],
//         ),
//         SizedBox(height: 12.h),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20.r),
//             boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: Offset(0, 4))],
//           ),
//           child: TextField(
//             controller: ctrl,
//             maxLines: 3,
//             style: TextStyle(color: Colors.black87, fontSize: 16.sp, height: 1.5),
//             decoration: InputDecoration(
//               hintText: 'example_kr_$number'.tr,
//               hintStyle: TextStyle(color: Colors.black38, fontSize: 15.sp),
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.r), borderSide: BorderSide.none),
//               contentPadding: EdgeInsets.all(20.w),
//             ),
//           ),
//         ),
//       ],
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
import 'initiative_input_screen.dart';



class KeyResultsInputScreen extends StatelessWidget {
  final String objective;
  final TextEditingController kr1Ctrl = TextEditingController();
  final TextEditingController kr2Ctrl = TextEditingController();
  final BonusModeController controller = Get.find();

  KeyResultsInputScreen({required this.objective, super.key});

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
                title: 'step_2_key_results'.tr,
                onBackTap: () => Get.back(),
              ),
              // ✅ PERSISTENT TIMER
              PersistentTimerWidget(showTimeUpAlert: true),
              Expanded(
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      children: [
                        SizedBox(height: 32.h),
                        _buildInstructionCard(),
                        SizedBox(height: 32.h),
                        _buildKRField(kr1Ctrl, 1),
                        SizedBox(height: 24.h),
                        _buildKRField(kr2Ctrl, 2),
                        SizedBox(height: 50.h),
                        CustomButton2(
                          text: 'next_initiative'.tr,
                          onPressed: () {
                            if (kr1Ctrl.text.isEmpty || kr2Ctrl.text.isEmpty) {
                              Get.snackbar('Error'.tr, 'Please fill all key results'.tr);
                              return;
                            }
                            controller.setKeyResults(kr1Ctrl.text, kr2Ctrl.text);
                            Get.to(() => InitiativeInputScreen(
                              objective: objective,
                              kr1: kr1Ctrl.text,
                              kr2: kr2Ctrl.text,
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
          Icon(Icons.track_changes, size: 48.sp, color: AppColors.primaryRed),
          SizedBox(height: 16.h),
          Text(
            'define_two_measurable_krs'.tr,
            style: TextStyle(fontSize: 20.sp, color: Colors.black87, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text('kr_hint'.tr, style: TextStyle(fontSize: 14.sp, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildKRField(TextEditingController ctrl, int number) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(color: AppColors.primaryRed, shape: BoxShape.circle),
              child: Center(child: Text('$number', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp))),
            ),
            SizedBox(width: 12.w),
            Text('key_result_$number'.tr, style: TextStyle(fontSize: 18.sp, color: Colors.black87, fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: Offset(0, 4))],
          ),
          child: TextField(
            controller: ctrl,
            maxLines: 3,
            style: TextStyle(color: Colors.black87, fontSize: 16.sp, height: 1.5),
            decoration: InputDecoration(
              hintText: 'example_kr_$number'.tr,
              hintStyle: TextStyle(color: Colors.black38, fontSize: 15.sp),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.r), borderSide: BorderSide.none),
              contentPadding: EdgeInsets.all(20.w),
            ),
          ),
        ),
      ],
    );
  }
}