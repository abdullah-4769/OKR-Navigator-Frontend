import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../data/repositories/storage_repository.dart';
import '../../../../view_model/challange_view_models/join_challenge_view_model.dart';

class InputInviteCodeCard extends StatelessWidget {
  InputInviteCodeCard({Key? key}) : super(key: key);

  final JoinChallengeViewModel _viewModel = Get.find<JoinChallengeViewModel>();
  final StorageRepository _storageRepo = Get.find<StorageRepository>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Enter Invite Code',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xff24387F),
            ),
          ),
          SizedBox(height: 12.h),

          // Input field with real-time validation
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _viewModel.inviteCodeController,
                  decoration: InputDecoration(
                    hintText: 'Enter 6-digit code',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14.sp,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xff24387F), width: 2),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    suffixIcon: _buildClearButton(),
                  ),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 6,
                  onChanged: (value) {
                    // Update observable invite code
                    _viewModel.inviteCode.value = value.toUpperCase(); // Ensure it's uppercase
                  },
                  buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
                    return null; // Hide counter
                  },
                ),
              ),
              SizedBox(width: 12.w),

              // Join Button
              _buildJoinButton(context),
            ],
          ),

          // Validation and status messages
          SizedBox(height: 8.h),
          _buildValidationMessage(),
          SizedBox(height: 8.h),
          _buildStatusMessage(),
        ],
      ),
    );
  }

  // Build clear button
  Widget _buildClearButton() {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _viewModel.inviteCodeController,
      builder: (context, value, child) {
        if (value.text.isEmpty) {
          return const SizedBox.shrink();
        }
        return IconButton(
          icon: Icon(Icons.clear, size: 20.sp),
          onPressed: () {
            _viewModel.inviteCodeController.clear();
            _viewModel.inviteCode.value = ''; // Clear observable as well
            _viewModel.clearStatus(); // Clear status when the button is pressed
          },
        );
      },
    );
  }

  // Build join button
  Widget _buildJoinButton(BuildContext context) {
    return Obx(() {
      final isLoading = _viewModel.isJoining.value;
      final isValidCode = _viewModel.isValidInviteCode(_viewModel.inviteCode.value);
      final userId = _getCurrentUserId();
      final isUserLoggedIn = userId != null && userId.isNotEmpty;

      return ElevatedButton(
        onPressed: (isLoading || !isValidCode || !isUserLoggedIn)
            ? null
            : () => _joinChallenge(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff24387F),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: Colors.grey.shade300,
        ),
        child: isLoading
            ? SizedBox(
          width: 20.w,
          height: 20.h,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Text(
          'Join',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    });
  }

  // Build validation message
  Widget _buildValidationMessage() {
    return Obx(() {
      final code = _viewModel.inviteCode.value;

      if (code.isEmpty) {
        return const SizedBox.shrink();
      }

      if (!_viewModel.isValidInviteCode(code)) {
        return Text(
          'Code must be exactly 6 characters (letters and numbers only)',
          style: TextStyle(
            color: Colors.red,
            fontSize: 12.sp,
          ),
        );
      }

      return Text(
        'Valid code format',
        style: TextStyle(
          color: Colors.green,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      );
    });
  }

  // Build status message
  Widget _buildStatusMessage() {
    return Obx(() {
      final status = _viewModel.joinStatus.value;

      if (status.isEmpty) {
        return const SizedBox.shrink();
      }

      Color textColor;
      Color backgroundColor;
      IconData icon;

      if (status.contains('Success') || status.contains('joined')) {
        textColor = Colors.green.shade800;
        backgroundColor = Colors.green.shade50;
        icon = Icons.check_circle;
      } else if (status.contains('Error') || status.contains('Failed')) {
        textColor = Colors.red.shade800;
        backgroundColor = Colors.red.shade50;
        icon = Icons.error;
      } else if (status.contains('Joining')) {
        textColor = Colors.blue.shade800;
        backgroundColor = Colors.blue.shade50;
        icon = Icons.hourglass_empty;
      } else {
        textColor = Colors.orange.shade800;
        backgroundColor = Colors.orange.shade50;
        icon = Icons.info;
      }

      return Container(
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: textColor.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 16.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                status,
                style: TextStyle(
                  color: textColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // Get Current User ID
  String? _getCurrentUserId() {
    String? userId = _storageRepo.getUserId();
    return userId?.isNotEmpty == true ? userId : null;
  }

  // Join Challenge
  Future<void> _joinChallenge(BuildContext context) async {
    final inviteCode = _viewModel.inviteCodeController.text.trim().toUpperCase();

    if (inviteCode.isEmpty || !_viewModel.isValidInviteCode(inviteCode)) {
      Get.snackbar(
        'Invalid Code',
        'Please enter a valid invite code.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final userId = _getCurrentUserId();
    if (userId == null) {
      Get.snackbar(
        'Authentication Required',
        'Please log in to join challenges.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    await _viewModel.joinChallengeWithCode(inviteCode, userId);
  }
}