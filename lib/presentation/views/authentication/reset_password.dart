import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../../../utils/validator.dart';
import '../../../view_model/forget_password_and_otp.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class ResetPasswordScreen extends StatelessWidget {
  final ForgotPasswordController controller;

  const ResetPasswordScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'create_new_password'.tr,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'password_requirements'.tr,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 32.h),

        /// NEW PASSWORD FIELD
        Obx(
              () => CustomTextField(
            controller: controller.newPasswordController,
            hint: 'enter_new_password_hint'.tr,
            obscureText: !controller.isPasswordVisible.value,
            prefixIcon: Icon(
              Icons.lock_outlined,
              color: AppColors.textSecondary,
              size: 20.sp,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                controller.isPasswordVisible.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.textSecondary,
                size: 20.sp,
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
            validator: Validators.password,
          ),
        ),
        SizedBox(height: 20.h),

        /// CONFIRM PASSWORD FIELD
        Obx(
              () => CustomTextField(
            controller: controller.confirmPasswordController,
            hint: 'confirm_password_hint'.tr,
            obscureText: !controller.isConfirmPasswordVisible.value,
            prefixIcon: Icon(
              Icons.lock_outlined,
              color: AppColors.textSecondary,
              size: 20.sp,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                controller.isConfirmPasswordVisible.value
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.textSecondary,
                size: 20.sp,
              ),
              onPressed: controller.toggleConfirmPasswordVisibility,
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'please_confirm_password'.tr;
              }
              if (value != controller.newPasswordController.text) {
                return 'passwords_do_not_match'.tr;
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 48.h),

        /// RESET BUTTON
        Obx(
              () => CustomButton(
            text: 'reset_password_button'.tr,
            onPressed: controller.resetPassword,
            isLoading: controller.isLoading.value,
            backgroundColor: AppColors.primaryRed,
            height: 56.h,
          ),
        ),
      ],
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../../../core/app_colors.dart';
// import '../../../utils/validator.dart';
// import '../../../view_model/forget_password_and_otp.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_textfield.dart';
//
// class ResetPasswordScreen extends StatelessWidget {
//   final ForgotPasswordController controller;
//
//   const ResetPasswordScreen({
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
//           'Create new password',
//           style: TextStyle(
//             fontSize: 16.sp,
//             fontWeight: FontWeight.w600,
//             color: AppColors.textPrimary,
//           ),
//         ),
//         SizedBox(height: 12.h),
//         Text(
//           'Make sure it\'s at least 6 characters long',
//           style: TextStyle(
//             fontSize: 14.sp,
//             color: AppColors.textSecondary,
//           ),
//         ),
//         SizedBox(height: 32.h),
//
//         /// NEW PASSWORD FIELD
//         Obx(
//               () => CustomTextField(
//             controller: controller.newPasswordController,
//             hint: 'Enter new password',
//             obscureText: !controller.isPasswordVisible.value,
//             prefixIcon: Icon(
//               Icons.lock_outlined,
//               color: AppColors.textSecondary,
//               size: 20.sp,
//             ),
//             suffixIcon: IconButton(
//               icon: Icon(
//                 controller.isPasswordVisible.value
//                     ? Icons.visibility_outlined
//                     : Icons.visibility_off_outlined,
//                 color: AppColors.textSecondary,
//                 size: 20.sp,
//               ),
//               onPressed: controller.togglePasswordVisibility,
//             ),
//             validator: Validators.password,
//           ),
//         ),
//         SizedBox(height: 20.h),
//
//         /// CONFIRM PASSWORD FIELD
//         Obx(
//               () => CustomTextField(
//             controller: controller.confirmPasswordController,
//             hint: 'Confirm password',
//             obscureText: !controller.isConfirmPasswordVisible.value,
//             prefixIcon: Icon(
//               Icons.lock_outlined,
//               color: AppColors.textSecondary,
//               size: 20.sp,
//             ),
//             suffixIcon: IconButton(
//               icon: Icon(
//                 controller.isConfirmPasswordVisible.value
//                     ? Icons.visibility_outlined
//                     : Icons.visibility_off_outlined,
//                 color: AppColors.textSecondary,
//                 size: 20.sp,
//               ),
//               onPressed: controller.toggleConfirmPasswordVisibility,
//             ),
//             validator: (value) {
//               if (value?.isEmpty ?? true) {
//                 return 'Please confirm password';
//               }
//               if (value != controller.newPasswordController.text) {
//                 return 'Passwords do not match';
//               }
//               return null;
//             },
//           ),
//         ),
//         SizedBox(height: 48.h),
//
//         /// RESET BUTTON
//         Obx(
//               () => CustomButton(
//             text: 'Reset Password',
//             onPressed: controller.resetPassword,
//             isLoading: controller.isLoading.value,
//             backgroundColor: AppColors.primaryRed,
//             height: 56.h,
//           ),
//         ),
//       ],
//     );
//   }
// }