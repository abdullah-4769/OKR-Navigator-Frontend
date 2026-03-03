import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../../../view_model/forget_password_and_otp.dart';
import '../../widgets/custom_button.dart';

class OtpVerificationScreen extends StatelessWidget {
  final ForgotPasswordController controller;

  const OtpVerificationScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'verify_otp_title'.tr,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          '${'otp_sent_to'.tr} ${controller.emailController.text}',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 32.h),

        /// OTP INPUT BOXES
        _buildOtpInputField(),
        SizedBox(height: 24.h),

        /// TIMER AND RESEND
        _buildTimerSection(),
        SizedBox(height: 48.h),

        /// VERIFY BUTTON
        Obx(
              () => CustomButton(
            text: 'verify_otp'.tr,
            onPressed: (controller.isOtpExpired.value || controller.isLoading.value)
                ? () {}  // ✅ Empty function instead of null
                : () => controller.verifyOtp(),
            isLoading: controller.isLoading.value,
            backgroundColor: (controller.isOtpExpired.value || controller.isLoading.value)
                ? AppColors.border
                : AppColors.primaryRed,
            height: 56.h,
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInputField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        6,
            (index) => _buildOtpBox(index),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return Obx(
          () => Container(
        width: 50.w,
        height: 60.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: controller.otpControllers[index].text.isEmpty
                ? AppColors.border
                : (controller.isOtpExpired.value
                ? AppColors.border
                : AppColors.primaryBlue),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12.r),
          color: controller.isOtpExpired.value
              ? AppColors.border.withOpacity(0.2)
              : Colors.white,
        ),
        child: TextField(
          controller: controller.otpControllers[index],
          focusNode: controller.otpFocusNodes[index],
          enabled: !controller.isOtpExpired.value && !controller.isLoading.value,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
            contentPadding: EdgeInsets.zero,
          ),
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          onChanged: (value) {
            controller.onOtpFieldChanged(value, index);
          },
        ),
      ),
    );
  }

  Widget _buildTimerSection() {
    return Obx(
          () => Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: controller.isOtpExpired.value
                  ? AppColors.border.withOpacity(0.2)
                  : AppColors.primaryRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.schedule,
                  color: controller.isOtpExpired.value
                      ? AppColors.border
                      : AppColors.primaryRed,
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  controller.isOtpExpired.value
                      ? 'otp_expired'.tr
                      : '${'time_remaining'.tr} ${controller.getFormattedTime()}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: controller.isOtpExpired.value
                        ? AppColors.border
                        : AppColors.primaryRed,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Center(
            child: TextButton(
              onPressed: controller.isOtpExpired.value
                  ? controller.resendOtp
                  : null,
              child: Text(
                controller.isOtpExpired.value
                    ? 'resend_otp'.tr
                    : 'did_not_receive_code'.tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: controller.isOtpExpired.value
                      ? AppColors.primaryRed
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../../../core/app_colors.dart';
// import '../../../view_model/forget_password_and_otp.dart';
// import '../../widgets/custom_button.dart';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../../../core/app_colors.dart';
// import '../../widgets/custom_button.dart';
//
// class OtpVerificationScreen extends StatelessWidget {
//   final ForgotPasswordController controller;
//
//   const OtpVerificationScreen({
//     super.key,
//     required this.controller,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Enter the OTP',
//           style: TextStyle(
//             fontSize: 16.sp,
//             fontWeight: FontWeight.w600,
//             color: AppColors.textPrimary,
//           ),
//         ),
//         SizedBox(height: 12.h),
//         Text(
//           'A 6-digit code has been sent to ${controller.emailController.text}',
//           style: TextStyle(
//             fontSize: 14.sp,
//             color: AppColors.textSecondary,
//           ),
//         ),
//         SizedBox(height: 32.h),
//
//         /// OTP INPUT BOXES
//         _buildOtpInputField(),
//         SizedBox(height: 24.h),
//
//         /// TIMER AND RESEND
//         _buildTimerSection(),
//         SizedBox(height: 48.h),
//
//         /// VERIFY BUTTON
//         Obx(
//               () => CustomButton(
//             text: 'Verify OTP',
//             onPressed: controller.isOtpExpired.value ? () {} : _handleVerifyOtp,
//             isLoading: controller.isLoading.value,
//             backgroundColor: controller.isOtpExpired.value
//                 ? AppColors.border
//                 : AppColors.primaryRed,
//             height: 56.h,
//           ),
//         ),
//       ],
//     );
//   }
//
//   void _handleVerifyOtp() {
//     controller.currentStep.value = 2;
//   }
//
//   Widget _buildOtpInputField() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: List.generate(
//         6,
//             (index) => _buildOtpBox(index),
//       ),
//     );
//   }
//
//   Widget _buildOtpBox(int index) {
//     return Obx(
//           () => Container(
//         width: 50.w,
//         height: 60.h,
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: controller.otpControllers[index].text.isEmpty
//                 ? AppColors.border
//                 : AppColors.primaryBlue,
//             width: 2,
//           ),
//           borderRadius: BorderRadius.circular(12.r),
//           color: controller.isOtpExpired.value
//               ? AppColors.border.withOpacity(0.2)
//               : Colors.white,
//         ),
//         child: TextField(
//           controller: controller.otpControllers[index],
//           focusNode: controller.otpFocusNodes[index],
//           enabled: !controller.isOtpExpired.value,
//           textAlign: TextAlign.center,
//           keyboardType: TextInputType.number,
//           inputFormatters: [
//             LengthLimitingTextInputFormatter(1),
//             FilteringTextInputFormatter.digitsOnly,
//           ],
//           decoration: InputDecoration(
//             border: InputBorder.none,
//             counterText: '',
//             contentPadding: EdgeInsets.zero,
//           ),
//           style: TextStyle(
//             fontSize: 24.sp,
//             fontWeight: FontWeight.bold,
//             color: AppColors.textPrimary,
//           ),
//           onChanged: (value) {
//             if (value.isNotEmpty) {
//               controller.onOtpFieldChanged(value, index);
//             }
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTimerSection() {
//     return Obx(
//           () => Column(
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
//             decoration: BoxDecoration(
//               color: controller.isOtpExpired.value
//                   ? AppColors.border.withOpacity(0.2)
//                   : AppColors.primaryRed.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8.r),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.schedule,
//                   color: controller.isOtpExpired.value
//                       ? AppColors.border
//                       : AppColors.primaryRed,
//                   size: 18.sp,
//                 ),
//                 SizedBox(width: 8.w),
//                 Text(
//                   controller.isOtpExpired.value
//                       ? 'OTP Expired'
//                       : 'Time remaining: ${controller.getFormattedTime()}',
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w600,
//                     color: controller.isOtpExpired.value
//                         ? AppColors.border
//                         : AppColors.primaryRed,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 16.h),
//           Center(
//             child: TextButton(
//               onPressed: controller.isOtpExpired.value
//                   ? controller.resendOtp
//                   : null,
//               child: Text(
//                 controller.isOtpExpired.value
//                     ? 'Resend OTP'
//                     : 'Didn\'t receive code?',
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w600,
//                   color: controller.isOtpExpired.value
//                       ? AppColors.primaryRed
//                       : AppColors.textSecondary,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }