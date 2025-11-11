// lib/presentation/views/team_mode/role_screens/assign_role_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for Clipboard
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/data/repositories/storage_repository.dart' show StorageRepository;
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:game_app/presentation/widgets/custom_button.dart';
import 'package:game_app/presentation/widgets/custom_circular_avatar.dart';
import 'package:game_app/presentation/widgets/custom_objective_container.dart';
import 'package:game_app/presentation/widgets/screens_unique_parts/custom_background.dart';
import 'package:game_app/presentation/widgets/screens_unique_parts/custom_header.dart';
import 'package:game_app/presentation/widgets/team_mode_widgets/custom_available_roles.dart';
import 'package:game_app/services/shared_preference.dart';
import 'package:get/get.dart';

import '../../../../controllers/team_mode_controller/create_team_controller.dart';
import '../../../../controllers/team_mode_controller/team_lobby_controller.dart';
import '../../../../controllers/team_mode_controller/assign_roles_controller.dart';
import '../../../../controllers/team_mode_controller/team_game_controller.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_dimensions.dart';


class AssignRolesScreen extends StatelessWidget {
 const AssignRolesScreen({super.key});

 @override
 Widget build(BuildContext context) {
  final controller = Get.put(AssignRolesController());
  final textTheme = Theme.of(context).textTheme;
  final size = MediaQuery.of(context).size;
  final width = size.width;
  final height = size.height;
  final StorageRepository storageRepo = Get.find<StorageRepository>();
  final String? currentUserId = storageRepo.getUser()?.id;
  final Map<String, dynamic> selectedIndustry = SharedPrefs.getSelectedIndustry() ?? {
   'titleKey': 'Technology',
   'title': 'Technology',
  };

  // --- Get Avatar Path Logic ---
  final TeamLobbyController lobbyController = Get.find<TeamLobbyController>();
  final CreateTeamController createController = Get.find<CreateTeamController>();

  final teamData = lobbyController.teamData.value;
  final avatarId = int.tryParse(teamData?.teamavatorid ?? '0') ?? 0;
  final avatarPath = createController.avatars.isNotEmpty
      ? createController.avatars[avatarId.clamp(0, createController.avatars.length - 1)]
      : 'assets/images/role_icon.png';
  // --- End Avatar Path Logic ---

  return Scaffold(
   backgroundColor: Colors.transparent,
   body: CustomBackground(
    child: SafeArea(
     child: _buildContent(
      context: context,
      controller: controller,
      textTheme: textTheme,
      width: width,
      height: height,
      currentUserId: currentUserId,
      selectedIndustry: selectedIndustry,
      avatarPath: avatarPath, // Passed dynamic path
     ),
    ),
   ),
  );
 }

 // The main content builder method
 Widget _buildContent({
  required BuildContext context,
  required AssignRolesController controller,
  required TextTheme textTheme,
  required double width,
  required double height,
  required String? currentUserId,
  required Map<String, dynamic> selectedIndustry,
  required String avatarPath,
 }) {
  return SingleChildScrollView(
   physics: const BouncingScrollPhysics(),
   child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     SizedBox(height: height * 0.015),

     /// ---------- HEADER ----------
     CustomHeader(
      title: 'Assign'.tr,
      highlightedText: "Roles".tr,
      onBackTap: () => Navigator.pop(context),
     ),

     SizedBox(height: height * 0.015),

     /// ---------- MAIN CONTENT ----------
     Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.d16.w),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        /// Team Avatar + Time Limit
        _buildHeaderSection(context, textTheme, width, height, avatarPath),

        SizedBox(height: height * 0.025),

        /// Available Roles
        const CustomAvailableRoles(),

        SizedBox(height: height * 0.03),

        /// Team Members Section with loading and error states
        _buildTeamMembersSection(
         context: context,
         controller: controller,
         textTheme: textTheme,
         width: width,
         height: height,
         currentUserId: currentUserId,
         selectedIndustry: selectedIndustry,
        ),

        SizedBox(height: height * 0.03),

        /// Pro Tip
        CustomObjectiveContainer(
         icon: Icons.lightbulb,
         title: 'Pro Tip'.tr,
         description:
         'Different roles have unique abilities and perspectives. Balance your team with complementary skills for better OKR outcomes.'
             .tr,
        ),

        SizedBox(height: height * 0.03),

        /// Action Buttons
        _buildActionButtons(
         controller: controller,
         currentUserId: currentUserId,
         selectedIndustry: selectedIndustry,
        ),

        SizedBox(height: height * 0.04),
       ],
      ),
     ),
    ],
   ),
  );
 }

 // Helper to build the top header section
 Widget _buildHeaderSection(BuildContext context, TextTheme textTheme, double width, double height, String avatarPath) {
  return Center(
   child: Column(
    children: [
     /// Larger solo icon -> REPLACED with Dynamic Avatar
     Center(
      child: CustomCircularAvatar(
       imagePath: avatarPath, // DYNAMIC AVATAR PATH
       innerColors: [
        Colors.yellow.shade100,
        Colors.orange.shade100,
        Colors.lightGreenAccent,
       ],
       borderGradient: [
        AppColors.primaryRed.withOpacity(0.9),
        AppColors.primaryRed.withOpacity(0.3),
       ],
       size: 150,
      ),
     ),
     SizedBox(height: height * 0.015),

     /// Time limit inside styled container
     CustomObjectiveContainer(
      title: '',
      child: Padding(
       padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.d16.w,
        vertical: AppDimensions.d8.h,
       ),
       child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         Text(
          'Time Limit'.tr,
          style: textTheme.bodyMedium?.copyWith(
           color: AppColors.grey,
          ),
         ),
         Obx(() {
          final timerController = Get.find<TeamGameTimerController>();
          final totalSeconds = timerController.remainingSeconds.value;
          final minutes = totalSeconds ~/ 60;
          final seconds = totalSeconds % 60;

          return Text(
           '$minutes:${seconds.toString().padLeft(2, '0')}',
           style: textTheme.titleLarge?.copyWith(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
           ),
          );
         }),

        ],
       ),
      ),
     ),

     SizedBox(height: height * 0.015),

     /// Description
     SizedBox(
      width: width * 0.8,
      child: Text(
       'Assign roles to optimize team performance'.tr,
       textAlign: TextAlign.center,
       style: textTheme.bodyLarge?.copyWith(
        color: AppColors.black,
        fontWeight: FontWeight.w400,
       ),
      ),
     ),
    ],
   ),
  );
 }

 // Helper to build the team members list section
 Widget _buildTeamMembersSection({
  required BuildContext context,
  required AssignRolesController controller,
  required TextTheme textTheme,
  required double width,
  required double height,
  required String? currentUserId,
  required Map<String, dynamic> selectedIndustry,
 }) {
  return Column(
   children: [
    /// Team Members heading
    Center(
     child: Text(
      'Team Members'.tr,
      style: textTheme.headlineLarge?.copyWith(
       color: AppColors.primaryRed,
      ),
     ),
    ),
    SizedBox(height: height * 0.015),

    /// Team member cards with loading and error states
    Obx(() {
     if (controller.isLoading.value) {
      return _buildLoadingState(height);
     }

     if (controller.errorMessage.value.isNotEmpty) {
      return _buildErrorState(controller, height);
     }

     return Column(
      children: controller.members.map((member) => Column(
       children: [
        _buildMemberCard(context, member.user?.name ?? 'Unknown', 'Level 5', member, controller),
        SizedBox(height: height * 0.015),
       ],
      )).toList(),
     );
    }),
   ],
  );
 }

 Widget _buildLoadingState(double height) {
  return Center(
   child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
     CircularProgressIndicator(
      color: AppColors.primaryRed,
     ),
     SizedBox(height: 16.h),
     Text(
      'Loading team members...',
      style: TextStyle(
       color: AppColors.textSecondary,
       fontSize: 16.sp,
      ),
     ),
    ],
   ),
  );
 }

 Widget _buildErrorState(AssignRolesController controller, double height) {
  return Center(
   child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
     Icon(
      Icons.error_outline,
      color: AppColors.primaryRed,
      size: 48.sp,
     ),
     SizedBox(height: 16.h),
     Text(
      controller.errorMessage.value,
      style: TextStyle(
       color: AppColors.primaryRed,
       fontSize: 16.sp,
      ),
      textAlign: TextAlign.center,
     ),
     SizedBox(height: 16.h),
     CustomButton(
      backgroundColor: AppColors.primaryRed,
      textColor: Colors.white,
      text: 'Retry',
      onPressed: () => controller.fetchTeamMembers(),
     ),
    ],
   ),
  );
 }

 // Helper to build action buttons
 Widget _buildActionButtons({
  required AssignRolesController controller,
  required String? currentUserId,
  required Map<String, dynamic> selectedIndustry,
 }) {
  return Column(
   children: [
    Center(
     child: CustomButton(
      text: 'Begin Mission'.tr,
      onPressed: () {
       // 1. Get current user's assigned role
       final currentUserMember = controller.members.firstWhereOrNull(
            (member) => member.userId == currentUserId,
       );
       final String currentRole = currentUserMember?.role ?? 'HOST';
       final Map<String, dynamic> roleArgument = {
        'title': currentRole,
        'titleKey': currentRole,
       };

       // 2. Navigate to Team Strategy Selection with arguments
       Get.toNamed(
        AppRoutes.teamStrategySelection,
        arguments: {
         'selectedRole': roleArgument,
         'selectedIndustry': selectedIndustry,
        },
       );
      },
     ),
    ),
    SizedBox(height: 10 * 0.02),

    Center(
     child: Obx(() => CustomButton(
      isLoading: controller.isAutoUpdatingRole.value,
      text: 'Auto Assign Roles'.tr,
      onPressed: () {
       controller.setRoleForGame();
      },
      backgroundColor: AppColors.primaryBlue,
     )),
    ),
   ],
  );
 }

 /// 🔹 Helper method to get valid role for dropdown (only assigned roles in the list of valid roles can be selected initially)
 String? _getValidRole(String? apiRole) {
  const validRoles = ['CEO', 'Strategist', 'HR Manager', 'Analyst', 'Team Lead', 'Manager'];

  if (apiRole == null) return null;

  // Check if the API role matches any of our valid roles
  if (validRoles.contains(apiRole)) {
   return apiRole;
  }

  // If API role doesn't match, return null to show hint text
  return null;
 }

 /// 🔹 Reusable team member card
 Widget _buildMemberCard(BuildContext context, String name, String level, dynamic member, AssignRolesController controller) {
  final textTheme = Theme.of(context).textTheme;
  final width = MediaQuery.of(context).size.width;

  // 💡 Determine host status and disabled state (Host cannot change their own role)
  final bool isHostMember = member.userId == controller.hostUserId.value;
  final bool isDisabled = isHostMember; // Host cannot be manually assigned a role

  // 💡 Get available roles dynamically (excluding those assigned to others)
  final List<String> dropdownRoles = controller.getAvailableRoles(member.userId);
  final String? dropdownValue = _getValidRole(member.role);


  return Container(
   width: width,
   padding: EdgeInsets.all(AppDimensions.d16.w),
   decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(AppDimensions.d16.r),
    border: Border.all(color: AppColors.grey.withOpacity(.3)),
   ),
   child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
     /// Avatar + name
     Row(
      children: [
       CustomCircularAvatar(
        imagePath: 'assets/images/role_icon.png',
        innerColors: [
         Colors.yellow.shade100,
         Colors.orange.shade100,
         Colors.lightGreenAccent,
        ],
        borderGradient: [
         AppColors.primaryRed.withOpacity(0.9),
         AppColors.primaryRed.withOpacity(0.3),
        ],
        size: 30,
       ),

       SizedBox(width: 12.w),
       Expanded(
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
          Text(
           name,
           style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.black,
           ),
           overflow: TextOverflow.ellipsis,
          ),
          Text(
           level,
           style: textTheme.titleMedium?.copyWith(
            color: AppColors.grey,
           ),
          ),
         ],
        ),
       ),
      ],
     ),

     SizedBox(height: 14.h),

     /// Heading above dropdown
     Text(
      'Assign Role'.tr,
      style: textTheme.titleSmall?.copyWith(
       color: AppColors.black,
       fontWeight: FontWeight.w600,
      ),
     ),
     SizedBox(height: 6.h),

     /// Dropdown with Obx for updating state
     Obx(() => DropdownButtonFormField<String>(
      // 💡 MODIFIED: Use null if current value is the implicit 'HOST' role for non-Host members, otherwise use the resolved value.
      value: dropdownRoles.contains(dropdownValue) ? dropdownValue : null,
      decoration: InputDecoration(
       // ✅ FIXED: Removed .tr from the dynamic role string (member.role ?? 'HOST') to prevent the original error.
       hintText: isDisabled ? (member.role ?? 'HOST') : 'Select a role...'.tr,
       border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
       ),
       // 💡 NEW: Disabled UI styling
       filled: isDisabled,
       fillColor: isDisabled ? AppColors.grey.withOpacity(0.1) : Colors.white,
       contentPadding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 10.h,
       ),
       suffixIcon: controller.isUpdatingRole.value
           ? Padding(
        padding: EdgeInsets.all(8.w),
        child: SizedBox(
         width: 16.w,
         height: 16.w,
         child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.primaryRed,
         ),
        ),
       )
           : null,
      ),
      // 💡 MODIFIED: Use dynamic/available list
      items: dropdownRoles
          .map((e) => DropdownMenuItem(
       value: e,
       child: Text(
        e.tr, // Roles might have translations defined as keys
        style: textTheme.titleSmall?.copyWith(
         color: AppColors.black,
        ),
       ),
      ))
          .toList(),
      // 💡 MODIFIED: Disable if isHost
      onChanged: isDisabled ? null : (val) {
       if (val != null && member.userId != null) {
        controller.assignRole(member.userId!, val);
       }
      },
     )),

     // 💡 NEW: Display message for host (Requirement 1)
     if (isDisabled)
      Padding(
       padding: EdgeInsets.only(top: 8.h),
       child: Text(
        "Host cannot assign role to self.".tr,
        style: textTheme.bodySmall?.copyWith(color: AppColors.primaryRed),
       ),
      ),
    ],
   ),
  );
 }
}