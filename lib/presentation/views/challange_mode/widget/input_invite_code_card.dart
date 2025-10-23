import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:game_app/data/response/api_response.dart';
import 'package:game_app/view_model/challange_view_models/join_challenge_view_model.dart';

import '../../../../data/response/status.dart';
import '../../../routes/app_routes.dart';
import '../challange_detail_screen.dart';

class InputInviteCodeCard extends StatelessWidget {
  InputInviteCodeCard({super.key});

  final JoinChallengeViewModel _challengeVM = Get.put(JoinChallengeViewModel());
  final TextEditingController _inviteCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Enter Invite Code",
            style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: _inviteCodeController,
            decoration: InputDecoration(
              hintText: "Enter code here",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Obx(() {
            if (_challengeVM.isJoining.value) {
              print('InputInviteCodeCard: Showing CircularProgressIndicator (isJoining: true)');
              return const Center(child: CircularProgressIndicator());
            }
            return ElevatedButton(
              onPressed: () async {
                final code = _inviteCodeController.text.trim();
                print('InputInviteCodeCard: Join button pressed with code: $code');
                if (code.isNotEmpty) {
                  print('InputInviteCodeCard: Calling joinChallenge with code: $code');
                  await _challengeVM.joinChallenge(code);
                  final response = _challengeVM.joinChallengeResponse;
                  print('InputInviteCodeCard: Response status: ${response.status}, message: ${response.message}, data: ${response.data}');
                  if (response.status == Status.completed) {
                    print('InputInviteCodeCard: Join successful, navigating to /challenge-detail with data: ${response.data}');
                    Get.snackbar("Success", "Joined challenge successfully!",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.green,
                        colorText: Colors.white);
                    // Navigate to challenge detail screen
                    Get.toNamed('/challenge-detail', arguments: response.data);
                  } else {
                    print('InputInviteCodeCard: Join failed, showing error: ${response.message}');
                    Get.snackbar("Error", response.message ?? "Failed to join challenge",
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red,
                        colorText: Colors.white);
                  }
                } else {
                  print('InputInviteCodeCard: Invalid code entered (empty)');
                  Get.snackbar("Error", "Please enter a valid code",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                "Join Challenge",
                style: TextStyle(fontSize: 16.sp),
              ),
            );
          }),
          SizedBox(height: 8.h),
          Obx(() {
            final response = _challengeVM.joinChallengeResponse;
            if (response.status == Status.error) {
              print('InputInviteCodeCard: Displaying error: ${response.message}');
              return Text(
                "Error: ${response.message}",
                style: TextStyle(color: Colors.red, fontSize: 14.sp),
              );
            } else if (response.status == Status.completed) {

              Get.to(ChallengeDetailsScreen());
              print('InputInviteCodeCard: Displaying success message');
              // return Text(
              //   "Joined successfully ✅",
              //   style: TextStyle(color: Colors.green, fontSize: 14.sp),
              // );
            }
            print('InputInviteCodeCard: No status to display, returning SizedBox');
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}