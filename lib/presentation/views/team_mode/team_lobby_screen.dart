// lib/presentation/views/team_mode/team_lobby_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for Clipboard
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/team_mode_controller/create_team_controller.dart'; 
import '../../../controllers/team_mode_controller/team_lobby_controller.dart';
import '../../../core/app_colors.dart';
import '../../../data/repositories/storage_repository.dart';
import '../../../utils/snackbar_helper.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/custom_circular_avatar.dart';
import '../../widgets/global_widgets/custom_progress_path.dart';
import '../../widgets/scoreboard_widgets/custom_rank_container.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

class TeamLobbyScreen extends StatelessWidget {
const TeamLobbyScreen({super.key});

 // Helper widget for the "Waiting for player..." slot
 Widget _buildInviteSlot(double width) => Container(
     padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
     decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(48.r),
      border: Border.all(color: AppColors.primaryRed, width: 1),
     ),
     child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
       // Simple Icon (person icon)
       Icon(
         Icons.person,
         size: 24.sp, 
         color: AppColors.primaryRed,
       ),
       SizedBox(width: 12.w), 
       Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(
          "Waiting for player...",
          style: TextStyle(
           fontSize: 14.sp,
           fontWeight: FontWeight.w600,
           color: AppColors.textSecondary,
          ),
         ),
         Text(
          "Invite someone to join",
          style: TextStyle(
           fontSize: 12.sp,
           color: AppColors.textSecondary.withOpacity(0.7),
          ),
         ),
        ],
       ),
      ],
     ),
    );

@override
Widget build(BuildContext context) {
 // Find the controller instance
 final controller = Get.put(TeamLobbyController()); 
 final createController = Get.find<CreateTeamController>(); 
 final width = MediaQuery.of(context).size.width;
 final height = MediaQuery.of(context).size.height;
  
  const String BASE_INVITE_URL = "okrnav://join?code=";

 return Scaffold(
 body: CustomBackground(
  child: SafeArea(
  child: Obx(() {
   final teamData = controller.teamData.value;
   // Get current user ID safely from storage
   final currentUserId = Get.find<StorageRepository>().getUser()?.id;
   // Determine if current user is the host
   final isHost = teamData?.members?.any((m) => m.role == 'HOST' && m.user?.id == currentUserId) ?? false;
   // --- Source of Truth for Member Count ---
   final membersCount = controller.players.length; 
   final teamToken = teamData?.token ?? "N/A";
   
   // Calculate dynamic avatar path
   final avatarId = int.tryParse(teamData?.teamavatorid ?? '0') ?? 0;
   final avatarPath = createController.avatars.isNotEmpty 
      ? createController.avatars[avatarId.clamp(0, createController.avatars.length - 1)] 
      : 'assets/images/role_icon.png'; // Fallback path
   
   if (controller.isLoading.value) {
   return Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
     CircularProgressIndicator(color: AppColors.primaryRed),
     SizedBox(height: 16.h),
     Text('Loading team details...', style: TextStyle(color: AppColors.textSecondary, fontSize: 16.sp)),
    ],
    ),
   );
   }

   if (controller.errorMessage.value.isNotEmpty) {
   return Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
     Icon(Icons.error_outline, color: AppColors.primaryRed, size: 48.sp),
     SizedBox(height: 16.h),
     Text(controller.errorMessage.value, style: TextStyle(color: AppColors.primaryRed, fontSize: 16.sp), textAlign: TextAlign.center),
     SizedBox(height: 16.h),
     CustomButton(
     backgroundColor: AppColors.primaryRed,
     textColor: Colors.white,
     text: 'Retry',
     onPressed: () => controller.fetchTeamDetails(),
     ),
    ],
    ),
   );
   }
   
   // Render Lobby UI
   return Column(
   children: [
    Expanded(
    child: SingleChildScrollView(
     child: Column(
     children: [
      SizedBox(height: height * 0.015),
      /// Header
      CustomHeader(
      title: teamData?.title ?? 'Team'.tr, // Dynamic Team Name
      highlightedText: "Lobby".tr,
      showDashboardIcon: true,
      onBackTap: () => Get.back(),
      ),

      SizedBox(height: height * 0.01),
      /// Team Avatar with bubble
      Stack(
      alignment: Alignment.bottomRight,
      children: [
       CustomCircularAvatar(
       imagePath: avatarPath, 
       size: 150,
       innerColors: const [
        Colors.yellow,
        Colors.orange,
        Colors.red,
       ],
       borderGradient: [
        AppColors.primaryRed.withOpacity(0.9),
        AppColors.primaryRed.withOpacity(0.3),
       ],
       ),
      ],
      ),

      SizedBox(height: height * 0.015),

      Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: width * 0.06),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
       color: AppColors.softRed.withValues(alpha: 0.5),
       border: Border.all(color: AppColors.primaryRed, width: 0.5),
       borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
       children: [
       Text(
        "Team Code: ",
        style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
       ),
       SizedBox(width: 8.w),
       Expanded(
        child: Text(
        teamToken, // Dynamic Team Token
        style: TextStyle(
         fontSize: 16.sp,
         fontWeight: FontWeight.bold,
         color: AppColors.primaryRed,
        ),
        overflow: TextOverflow.ellipsis,
        ),
       ),
       SizedBox(width: 8.w),
       GestureDetector(
        onTap: () {
          // Copy to clipboard the Team Token
          Clipboard.setData(ClipboardData(text: teamToken));
          SnackbarHelper.info('Team code copied!'); 
        },
        child: CircleAvatar(
        radius: 16.r,
        backgroundColor: AppColors.primaryRed,
        child: Icon(Icons.copy, size: 18.sp, color: AppColors.white),
        ),
       ),
       ],
      ),
      ),

      SizedBox(height: height * 0.015),

      /// Waiting Text
      Text(
      "Waiting for others to join...",
      style: TextStyle(
       color: AppColors.textSecondary,
       fontSize: 14.sp,
      ),
      ),

      SizedBox(height: height * 0.02),

      /// Members Joined Progress
      Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.06),
      child: Center(
       child: Column(
       children: [
        Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         Icon(Icons.groups, color: AppColors.primaryRed),
         SizedBox(width: 6.w),
         Text(
         // Uses the calculated membersCount
         "$membersCount Members Joined", 
         style: TextStyle(
          color: AppColors.primaryRed,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
         ),
         ),
        ],
        ),
        SizedBox(height: 10.h),
        CustomProgressPath(
        stepLabels: const ["1", "2", "3", "4", "5"],
        // FIXED: Current step calculation: N members = N-1 segments completed.
        // Clamp prevents showing step 0 for 0 members (although the code prevents 0 members by relying on API)
        currentStep: (membersCount > 0 ? membersCount - 1 : 0).clamp(0, 4), 
        showCircles: false,
        ),
       ],
       ),
      ),
      ),

      SizedBox(height: height * 0.02),

      /// Start Game text
      Text(
      "Start Game (Minimum 2 players required)",
      style: TextStyle(
       color: AppColors.primaryRed,
       fontSize: 13.sp,
       fontWeight: FontWeight.w500,
      ),
      ),

      SizedBox(height: height * 0.02),

      /// Players List (Dynamic, using real API data)
      Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.06),
      child: Column(
       children: [
       ...controller.memberScores.asMap().entries.map((entry) {
        final index = entry.key;
        final memberData = entry.value;
        return CustomRankContainer(
        rank: index + 1,
        name: memberData['name'] ?? "Unknown",
        level: memberData['level'] ?? 1,
        points: memberData['points'] ?? 0,
        score: memberData['score'] ?? 0,
        isHighlighted: memberData['userId'] == currentUserId, // Highlight current user
        );
       }).toList(),

       // Placeholder/Invite Slot
       if (membersCount < 5)
        _buildInviteSlot(width)
       ],
      ),
      ),

      SizedBox(height: height * 0.03),

      /// Buttons
      Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: Column(
       children: [
       // Begin Mission Button
       CustomButton2(
        backgroundColor: membersCount >= 2 ? AppColors.primaryBlue : AppColors.textSecondary.withOpacity(0.3),
        textColor: Colors.white,
        text: "Begin Mission".tr,
        onPressed: controller.beginMission,
        // onPressed: membersCount >= 2 ? controller.beginMission : null,
       ),

       SizedBox(height: 10.h),
       // Invite Members Button (Only Host can invite)
       if (isHost)
       Obx(() {
        return CustomButton(
        backgroundColor: AppColors.primaryRed,
        textColor: Colors.white,
        text: controller.isInvitingMember.value ? "Inviting..." : "Invite Members".tr,
        isLoading: controller.isInvitingMember.value, // Bind loading state
        onPressed: () { 
         controller.inviteMembers().then((token) {
          if (token != null) {
                        final shareableLink = BASE_INVITE_URL + token; // Build the actual deep link
          Get.defaultDialog(
           title: "Shareable Team Link",
           content: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
            Text(
            "Share this link with your team members to join the app directly:",
            style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
            ),
            SizedBox(height: 15.h),
            // Shareable link ONLY (Deep Link)
            Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
             color: AppColors.primaryBlue.withOpacity(0.1),
             borderRadius: BorderRadius.circular(8.r),
             border: Border.all(color: AppColors.primaryBlue, width: 1),
            ),
            child: Row(
             children: [
             Expanded(
              child: SelectableText( // Use SelectableText for easy copying
              shareableLink, // Display the full link
              style: TextStyle(fontSize: 14.sp, color: AppColors.primaryBlue),
              ),
             ),
             SizedBox(width: 8.w),
             GestureDetector(
              onTap: () {
              // Copy the Shareable Link
              Clipboard.setData(ClipboardData(text: shareableLink));
              SnackbarHelper.success("Shareable link copied to clipboard!");
              Get.back();
              },
              child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
               color: AppColors.primaryBlue,
               borderRadius: BorderRadius.circular(6.r),
              ),
              child: Icon(Icons.copy, size: 16.sp, color: Colors.white),
              ),
             ),
             ],
            ),
            ),
            SizedBox(height: 15.h),
            CustomButton(
            text: "Done",
            onPressed: () => Get.back(),
            backgroundColor: AppColors.primaryRed,
            ),
           ],
           ),
           textConfirm: null, 
           onConfirm: null, 
           confirmTextColor: Colors.white,
          );
          }
         });
        },
        );
       }),
       
       SizedBox(height: 10.h),
       CustomButton(
       backgroundColor: AppColors.primaryBlue,
       textColor: Colors.white,
       text: "Edit Team Info".tr,
       onPressed: () => Get.back(), // Navigates back to edit screen
       ),
       ],
      ),
      ),
      

      SizedBox(height: height * 0.04),
     ],
     ),
    ),
    ),
   ]
   );
  }),
  ),
 ),
 );
}}