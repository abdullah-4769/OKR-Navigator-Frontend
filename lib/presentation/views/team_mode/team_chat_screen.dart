import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../../widgets/bubble_button.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import '../../widgets/team_mode_widgets/chat_widget.dart';

class TeamChatScreen extends StatelessWidget {
  TeamChatScreen({super.key});

  final List<Map<String, dynamic>> chatMessages = [
    {
      'name': 'You',
      'role': 'CEO',
      'level': 5,
      'message': 'Team, I got "Development of New Markets" strategy! Perfect for our goals 😊',
      'isCurrentUser': true,
    },
    {
      'name': 'Johnson',
      'role': 'Strategist',
      'level': 5,
      'message': 'Nice! I drew "Digital Transformation Initiative". These strategies complement each other well!',
      'isCurrentUser': false,
    },
    {
      'name': 'Tasha',
      'role': 'Strategist',
      'level': 5,
      'message': 'let\'s Start the Game,Nice! I drew "Digital Transformation Initiative". These strategies complement each other well!',
      'isCurrentUser': false,
    },
  ];

  final List<String> quickResponses = [
    'Let\'s align our OKRs! 😊',
    'Starting my objectives now',
    'Great team synergy! 🌔',
    'Need help with strategy?',
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomBackground(
        child: Stack(
          children: [
            /// Scrollable content
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: height * 0.01),
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

                    /// Chat Messages
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: chatMessages
                            .map((message) => ChatWidget(
                          name: message['name'],
                          role: message['role'],
                          level: message['level'],
                          message: message['message'],
                          isCurrentUser: message['isCurrentUser'],
                        ))
                            .toList(),
                      ),
                    ),

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
                              // Handle quick response tap
                            },
                          ),
                        ))
                            .toList(),
                      ),
                    ),


                    /// Bottom Message Input
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Positioned(
                        bottom: 8.h,
                        left: 16.w,
                        right: 16.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppColors.softRed.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(25.r), // Added circular border
                            border: Border.all(color: AppColors.grey.withOpacity(0.3)), // Changed to all sides border
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w), // Added horizontal padding
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.grey.withOpacity(0.1), // Added opacity
                                      borderRadius: BorderRadius.circular(25.r),
                                    ),
                                    child: Text(
                                      'Message to team... 😊',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Container(
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryRed,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                ),
                                SizedBox(width: 8.w),
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
                      ),
                    ),
                    SizedBox(height: height * 0.02),

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