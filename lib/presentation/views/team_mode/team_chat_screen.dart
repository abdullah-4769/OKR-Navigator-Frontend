// lib/presentation/views/team_mode/team_chat_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../../widgets/bubble_button.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import '../../widgets/team_mode_widgets/chat_widget.dart';
import '../../../controllers/team_mode_controller/team_chat_controller.dart'; // Import controller

class TeamChatScreen extends StatelessWidget {
  TeamChatScreen({super.key});

  final List<String> quickResponses = [
    'Let\'s align our OKRs! 🚀',
    'Starting my objectives now',
    'Great team synergy! 🤝',
    'Need help with strategy?',
  ];
  
  // Find/Put the new controller
  final TeamChatController controller = Get.put(TeamChatController()); 

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    
    // Add ScrollController to handle scrolling to the newest message
    final ScrollController scrollController = ScrollController();

    // Use a listener to automatically scroll to the newest message when list changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
        ever(controller.chatMessages, (_) {
            if (scrollController.hasClients) {
                scrollController.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                );
            }
        });
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomBackground(
        child: Stack(
          children: [
            /// Scrollable content
            Positioned.fill(
              child: SingleChildScrollView(
                controller: scrollController, // Apply ScrollController
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: height * 0.20), // Increased bottom padding to show input
                child: Column(
                  children: [

                    /// Header
                    CustomHeader(
                      title: 'Team',
                      highlightedText: 'Chat',
                      subtitle: '',
                      onBackTap: () => Get.back(),
                    ),

                    /// Team Name
                    Text(
                      'Team Alpha', 
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryRed,
                      ),
                    ),

                    SizedBox(height: height * 0.03),

                    /// Chat Messages (Use Obx for dynamic list)
                    Obx(() => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: controller.chatMessages
                            .map((message) => ChatWidget(
                          name: message['name'],
                          role: message['role'],
                          level: message['level'],
                          message: message['message'],
                          isCurrentUser: message['isCurrentUser'],
                        ))
                            .toList(),
                      ),
                    )),

                    SizedBox(height: height * 0.03),

                    /// Quick Team Responses Title
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Quick Team Responses:',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryRed,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.02),

                    /// Quick Response Buttons
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: quickResponses
                            .map((response) => Padding(
                          padding: EdgeInsets.only(bottom: 8.h),
                          child: CustomBubbleButton(
                            text: response,
                            width: double.infinity,
                            height: 50.h,
                            onTap: () {
                              // Use the quick response text as the message and send
                              controller.messageController.text = response;
                              controller.sendChatMessage();
                            },
                          ),
                        ))
                            .toList(),
                      ),
                    ),

                    SizedBox(height: height * 0.02),
                  ],
                ),
              ),
            ),

            /// Bottom Message Input (Positioned to stay above NavBar)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white, // Ensure the input field has a clean background
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Obx(()=> TextField(
                        controller: controller.messageController,
                        decoration: InputDecoration(
                          hintText: 'Message to team... 💬',
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.r),
                            borderSide: BorderSide(color: AppColors.grey.withOpacity(0.3)),
                          ),
                          enabled: !controller.isSending.value, // Disable when sending
                          fillColor: AppColors.softRed.withOpacity(0.5),
                          filled: true,
                        ),
                        onSubmitted: (value) => controller.sendChatMessage(),
                      )),
                    ),
                    SizedBox(width: 12.w),
                    Obx(()=> GestureDetector(
                      onTap: controller.isSending.value ? null : controller.sendChatMessage, // Disable when sending
                      child: Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: controller.isSending.value ? AppColors.grey : AppColors.primaryRed,
                          shape: BoxShape.circle,
                        ),
                        child: controller.isSending.value 
                            ? SizedBox(width: 20.w, height: 20.w, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) // Spinner
                            : Icon(Icons.send, color: Colors.white, size: 20.sp),
                      ),
                    )),
                    SizedBox(width: 8.w),
                    // Mic button (placeholder for now)
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),


            /// Home Navbar
            Positioned(
              right: width * -0.07,
              top: height * 0.5,
              child: const CustomHomeNavBar(),
            ),
          ],
        ),
      ),
    );
  }
}