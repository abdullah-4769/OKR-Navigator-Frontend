import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/api_constants.dart';
import '../../../core/app_colors.dart';
import '../../routes/app_routes.dart';
import '../../views/authentication/profile_screen.dart';
import '../common_image.dart';
import '../custom_curved_arrow.dart';

class CustomHeader extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String? highlightedText;
  final VoidCallback onBackTap;
  final bool showDashboardIcon;

  const CustomHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.highlightedText,
    required this.onBackTap,
    this.showDashboardIcon = true,
  });

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  String? userAvatarUrl;

  @override
  void initState() {
    super.initState();
    _loadUserAvatar();
  }

  void _loadUserAvatar() {
    try {
      final prefs = GetStorage();
      final json = prefs.read('user-data');

      if (json != null) {
        final userData = jsonDecode(json);
        final avatarId = userData['avatarPicId']?.toString();

        if (avatarId != null && avatarId.isNotEmpty) {
          setState(() {
            if (avatarId.startsWith("http")) {
              userAvatarUrl = avatarId; // Google image full URL
            } else {
              userAvatarUrl = '${ApiConstants.baseUrl}/uploads/$avatarId';
            }
          });
        }
      }
    } catch (e) {
      print("❌ CustomHeader avatar error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentRoute = Get.currentRoute;

    return SizedBox(
      height: 130.h,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// BACK BUTTON
              CustomCurvedArrow(
                isLeft: true,
                onTap: widget.onBackTap,
                width: 60.w,
                height: 60.h,
              ),

              /// TITLE SECTION
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: theme.textTheme.displayLarge?.copyWith(
                        color: AppColors.primaryRed,
                        fontSize: 20.sp,
                      ),
                    ),
                    if (widget.highlightedText != null)
                      Text(
                        widget.highlightedText!,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: AppColors.primaryBlue,
                          fontSize: 18.sp,
                        ),
                      ),
                  ],
                ),
              ),

              /// RIGHT SIDE: LANGUAGE + PROFILE PICTURE
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.language, color: AppColors.primaryBlue, size: 32),
                    onPressed: () => Get.toNamed(AppRoutes.language, parameters: {
                      'from': currentRoute,
                    }),
                  ),

                  if (widget.showDashboardIcon)
                    InkWell(
                      onTap: () => Get.to(ProfileScreen()),
                      child: CircleAvatar(
                        radius: 24.r,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: userAvatarUrl != null
                              ? Image.network(
                            userAvatarUrl!,
                            fit: BoxFit.cover,
                            width: 46.sp,
                            height: 46.sp,
                            errorBuilder: (_, __, ___) => Image.asset("assets/images/solo_image.png"),
                          )
                              : Image.asset("assets/images/solo_image.png"),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),

          /// SUBTITLE
          if (widget.subtitle != null)
            Positioned(
              top: 100.h,
              right: 10.w,
              child: Text(
                widget.subtitle!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 12.sp,
                  color: AppColors.textBlack,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
