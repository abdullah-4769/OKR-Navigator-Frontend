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
import 'dart:developer' as developer;

class CustomHeader extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String? highlightedText;
  final VoidCallback onBackTap;
  final bool showDashboardIcon;
  final EdgeInsetsGeometry? padding;
  final double? spacing;

  const CustomHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.highlightedText,
    required this.onBackTap,
    this.showDashboardIcon = true,
    this.padding,
    this.spacing = 6.0,
  });

  @override
  State<CustomHeader> createState() => _CustomHeaderState();
}

class _CustomHeaderState extends State<CustomHeader> {
  String? userAvatarUrl;
  ImageProvider? avatarImageProvider;

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
            // Check if it's a local asset or network URL
            if (avatarId.startsWith('assets/') || avatarId.startsWith('lib/')) {
              // Local asset image
              avatarImageProvider = AssetImage(avatarId);
              userAvatarUrl = avatarId;
              developer.log(
                '🖼️ Loaded local asset image: $avatarId',
                name: 'CustomHeader',
              );
            } else if (avatarId.startsWith('http')) {
              // Direct network URL
              avatarImageProvider = NetworkImage(avatarId);
              userAvatarUrl = avatarId;
              developer.log(
                '🌐 Loaded network image: $avatarId',
                name: 'CustomHeader',
              );
            } else {
              // Construct full URL for server uploads
              final fullUrl = '${ApiConstants.baseUrl}/uploads/$avatarId';
              avatarImageProvider = NetworkImage(fullUrl);
              userAvatarUrl = fullUrl;
              developer.log(
                '🌐 Loaded server image: $fullUrl',
                name: 'CustomHeader',
              );
            }
          });
        }
      }
    } catch (e) {
      developer.log("❌ CustomHeader avatar error: $e", name: 'CustomHeader');
    }
  }

  void _navigateToLanguage() {
    final currentRoute = Get.currentRoute;
    developer.log(
      '🌐 Navigating to language screen from: $currentRoute',
      name: 'CustomHeader',
    );

    Get.toNamed(
      AppRoutes.language,
      parameters: {
        'from': currentRoute,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentRoute = Get.currentRoute;

    developer.log(
      '🎨 CustomHeader built for route: $currentRoute',
      name: 'CustomHeader',
    );

    return MediaQuery.removePadding(
      context: context,
      removeLeft: true,
      child: Container(
        height: 130.h,
        padding: widget.padding ?? EdgeInsets.zero,
        child: Stack(
          children: [
            /// MAIN ROW
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// BACK BUTTON
                CustomCurvedArrow(
                  isLeft: true,
                  onTap: widget.onBackTap,
                  width: 55.w,
                  height: 55.h,
                ),

                if (widget.spacing != null && widget.spacing! > 0)
                  SizedBox(width: widget.spacing!.w),

                /// TITLE
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          widget.title,
                          style: theme.textTheme.displayLarge?.copyWith(
                            color: AppColors.primaryRed,
                            fontSize: 20.sp,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (widget.highlightedText != null)
                        Center(
                          child: Text(
                            widget.highlightedText!,
                            style: theme.textTheme.headlineLarge?.copyWith(
                              color: AppColors.primaryBlue,
                              fontSize: 18.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),

                /// LANGUAGE + PROFILE
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.language,
                          color: AppColors.primaryBlue,
                          size: 32,
                        ),
                        onPressed: _navigateToLanguage,
                      ),
                    ),

                    if (widget.showDashboardIcon)
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: InkWell(
                          onTap: () => Get.to(ProfileScreen()),
                          child: CircleAvatar(
                            radius: 24.r,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: avatarImageProvider != null
                                  ? Image(
                                image: avatarImageProvider!,
                                fit: BoxFit.cover,
                                width: 46.sp,
                                height: 46.sp,
                                errorBuilder: (_, __, ___) =>
                                    Image.asset(
                                      "assets/images/solo_image.png",
                                      fit: BoxFit.cover,
                                    ),
                              )
                                  : Image.asset(
                                "assets/images/solo_image.png",
                                fit: BoxFit.cover,
                              ),
                            ),
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
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.textBlack,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}