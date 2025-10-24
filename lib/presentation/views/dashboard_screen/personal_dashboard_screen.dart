import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/personal_dashboard_controller.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_dimensions.dart';
import '../../routes/app_routes.dart';
import '../../widgets/common_image.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_circular_avatar.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PersonalDashboardScreen extends StatelessWidget {
  const PersonalDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PersonalDashboardController());
    final media = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomBackground(
        child: SafeArea(
          child: OrientationBuilder(
            builder: (context, orientation) {
              final bool isPortrait = orientation == Orientation.portrait;
              final double width = media.size.width;
              final double height = media.size.height;

              final double sidePadding =
              isPortrait ? width * 0.05 : width * 0.08;
              final double avatarSize =
              isPortrait ? width * 0.35 : width * 0.25;
              final double smallCardHeight =
              isPortrait ? height * 0.14 : height * 0.18;

              return Stack(
                children: [
                  /// ✅ Scroll everything including header
                  Positioned.fill(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                        bottom: height * 0.019,
                        top: 12.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// ✅ Header (no horizontal padding)
                          CustomHeader(
                            title: 'Your',
                            highlightedText: 'ScoreBoard',
                            subtitle: '',
                            onBackTap: () =>
                                Get.back(),
                          ),

                          SizedBox(height: height * 0.002),

                          /// ✅ Content with side padding
                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: sidePadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                /// Avatar + Level Badge
                                Center(
                                  child: CustomCircularAvatar(
                                    imagePath: 'assets/images/solo_image.png',
                                    innerColors: [
                                      AppColors.softRed.withValues(alpha: 0.5),
                                      AppColors.softRed.withValues(alpha: 0.5),
                                      AppColors.softRed.withValues(alpha: 0.5)
                                    ],
                                    borderGradient: [AppColors.primaryRed, AppColors.primaryRed.withOpacity(0.5)],
                                    size: 120,
                                  ),
                                ),
                                SizedBox(height: 12.h),

                                /// Title & Success rate
                                Text(
                                  'strategic_architect'.tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8.h),

                                Obx(() {
                                  return Column(
                                    children: [
                                      Text(
                                        '${controller.successRate.value}% ${'success_rate'.tr}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                          color: AppColors.primaryRed,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 8.h),
                                      ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(10.r),
                                        child: LinearProgressIndicator(
                                          value: controller.progressValue(),
                                          minHeight: 8.h,
                                          color: AppColors.primaryRed,
                                          backgroundColor: AppColors
                                              .textSecondary
                                              .withOpacity(0.12),
                                        ),
                                      ),
                                    ],
                                  );
                                }),

                                SizedBox(height: 20.h),

                                /// Stats Row
                                Row(
                                  children: [
                                    Expanded(
                                      child: _smallStatCard(
                                        context,
                                        label: 'badges'.tr,
                                        count: controller.badgesCount.value,
                                        height: smallCardHeight,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: _smallStatCard(
                                        context,
                                        label: 'trophies'.tr,
                                        count: controller.trophiesCount.value,
                                        height: smallCardHeight,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: _smallStatCard(
                                        context,
                                        label: 'cards'.tr,
                                        count: controller.cardsCount.value,
                                        height: smallCardHeight,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 22.h),

                                /// Achievements
                                _sectionCard(
                                  context,
                                  titleKey: 'recent_achievements',
                                  icon: Icons.thumb_up,
                                  borderColor: AppColors.primaryRed,
                                  items: controller.achievements,
                                  showCheck: true,
                                ),

                                SizedBox(height: 18.h),

                                /// Recent Games
                                _gamesCard(
                                    context, controller.recentGames.toList()),

                                SizedBox(height: 24.h),

                                /// Bottom buttons
                                CustomButton(
                                  text: 'schedule_async_game'.tr,
                                  onPressed: controller.scheduleAsyncGame,
                                ),
                                SizedBox(height: 12.h),
                                CustomButton(
                                  text: 'invite_a_player'.tr,
                                  onPressed: controller.invitePlayer,
                                  backgroundColor: AppColors.primaryBlue,
                                ),
                                SizedBox(height: 12.h),
                                CustomButton(
                                  text: 'launch_challenge'.tr,
                                  onPressed: controller.launchChallenge,
                                  backgroundColor: AppColors.primaryRed,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// Floating Home Nav
                  Positioned(
                    right: -width * 0.05,
                    top: height * 0.45,
                    child: const CustomHomeNavBar(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// ✅ small stat card
  Widget _smallStatCard(
      BuildContext context, {
        required String label,
        required int count,
        required double height,
      }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey.withOpacity(0.28)),
      ),
      padding: EdgeInsets.all(8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events, color: AppColors.primaryBlue, size: 26.sp),
          SizedBox(height: 6.h),
          Text(
            '$count',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// ✅ section card
  Widget _sectionCard(
      BuildContext context, {
        required String titleKey,
        required IconData icon,
        required Color borderColor,
        required List<Map<String, dynamic>> items,
        bool showCheck = false,
      }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.all(AppDimensions.d12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.d18.r),
        border: Border.all(color: borderColor.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: AppDimensions.d18.r,
                backgroundColor: borderColor,
                child: Icon(icon, color: Colors.white),
              ),
              SizedBox(width: AppDimensions.d12.w),
              Expanded(
                child: Text(
                  titleKey.tr,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  size: 18, color: Colors.grey),
            ],
          ),
          SizedBox(height: AppDimensions.d12.h),

          ...items.map((m) {
            final titleKey = m['key'] as String? ?? '';
            final done = m['done'] as bool? ?? false;
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        titleKey.tr,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                          color: AppColors.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (showCheck)
                      Icon(Icons.check_circle,
                          color: done ? Colors.green : Colors.grey,
                          size: 20.sp),
                  ],
                ),
                Divider(
                  color: AppColors.grey.withOpacity(0.2),
                  height: 14.h,
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  /// ✅ recent games card
  Widget _gamesCard(BuildContext context, List<Map<String, String>> games) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.all(AppDimensions.d12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.d18.r),
        border: Border.all(color: AppColors.grey.withOpacity(0.28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: AppDimensions.d18.r,
                backgroundColor: AppColors.primaryBlue,
                child: const Icon(Icons.history, color: Colors.white),
              ),
              SizedBox(width: AppDimensions.d12.w),
              Expanded(
                child: Text(
                  'recent_games'.tr,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  size: 18, color: Colors.grey),
            ],
          ),
          SizedBox(height: AppDimensions.d12.h),

          ...games.map((g) {
            return Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.softRed,
                      child: Icon(Icons.person, color: AppColors.primaryRed),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            g['titleKey']!.tr,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryBlue,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            g['date'] ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${g['score']} ${'score'.tr}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Divider(
                  color: AppColors.grey.withOpacity(0.2),
                  height: 14.h,
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}
























// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../../../controllers/personal_dashboard_controller.dart';
// import '../../../core/app_colors.dart';
// import '../../../core/app_dimensions.dart';
// import '../../routes/app_routes.dart';
// import '../../widgets/common_image.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_circular_avatar.dart';
// import '../../widgets/custom_home_navbar.dart';
// import '../../widgets/screens_unique_parts/custom_background.dart';
// import '../../widgets/screens_unique_parts/custom_header.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// class PersonalDashboardScreen extends StatelessWidget {
//   const PersonalDashboardScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(PersonalDashboardController());
//     final media = MediaQuery.of(context);
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: CustomBackground(
//         child: SafeArea(
//           child: OrientationBuilder(
//             builder: (context, orientation) {
//               final bool isPortrait = orientation == Orientation.portrait;
//               final double width = media.size.width;
//               final double height = media.size.height;
//
//               final double sidePadding =
//               isPortrait ? width * 0.05 : width * 0.08;
//               final double avatarSize =
//               isPortrait ? width * 0.35 : width * 0.25;
//               final double smallCardHeight =
//               isPortrait ? height * 0.14 : height * 0.18;
//
//               return Stack(
//                 children: [
//                   /// ✅ Scroll everything including header
//                   Positioned.fill(
//                     child: SingleChildScrollView(
//                       physics: const BouncingScrollPhysics(),
//                       padding: EdgeInsets.only(
//                         bottom: height * 0.019,
//                         top: 12.h,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           /// ✅ Header (no horizontal padding)
//                           CustomHeader(
//                             title: 'Your',
//                             highlightedText: 'ScoreBoard',
//                             subtitle: '',
//                             onBackTap: () =>
//                                 Get.back(),
//                           ),
//
//                           SizedBox(height: height * 0.002),
//
//                           /// ✅ Content with side padding
//                           Padding(
//                             padding:
//                             EdgeInsets.symmetric(horizontal: sidePadding),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 /// Avatar + Level Badge
//                                 Center(
//                                   child: CustomCircularAvatar(
//                                     imagePath: 'assets/images/solo_image.png',
//                                     innerColors: [
//                                       AppColors.softRed.withValues(alpha: 0.5),
//                                       AppColors.softRed.withValues(alpha: 0.5),
//                                       AppColors.softRed.withValues(alpha: 0.5)
//                                     ],
//                                     borderGradient: [AppColors.primaryRed, AppColors.primaryRed.withOpacity(0.5)],
//                                     size: 120,
//                                   ),
//                                 ),
//                                 SizedBox(height: 12.h),
//
//                                 /// Title & Success rate
//                                 Text(
//                                   'strategic_architect'.tr,
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodyLarge
//                                       ?.copyWith(
//                                     color: AppColors.primaryBlue,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                                 SizedBox(height: 8.h),
//
//                                 Obx(() {
//                                   return Column(
//                                     children: [
//                                       Text(
//                                         '${controller.successRate.value}% ${'success_rate'.tr}',
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .headlineSmall
//                                             ?.copyWith(
//                                           color: AppColors.primaryRed,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                         textAlign: TextAlign.center,
//                                       ),
//                                       SizedBox(height: 8.h),
//                                       ClipRRect(
//                                         borderRadius:
//                                         BorderRadius.circular(10.r),
//                                         child: LinearProgressIndicator(
//                                           value: controller.progressValue(),
//                                           minHeight: 8.h,
//                                           color: AppColors.primaryRed,
//                                           backgroundColor: AppColors
//                                               .textSecondary
//                                               .withOpacity(0.12),
//                                         ),
//                                       ),
//                                     ],
//                                   );
//                                 }),
//
//                                 SizedBox(height: 20.h),
//
//                                 /// Stats Row
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: _smallStatCard(
//                                         context,
//                                         label: 'badges'.tr,
//                                         count: controller.badgesCount.value,
//                                         height: smallCardHeight,
//                                       ),
//                                     ),
//                                     SizedBox(width: 12.w),
//                                     Expanded(
//                                       child: _smallStatCard(
//                                         context,
//                                         label: 'trophies'.tr,
//                                         count: controller.trophiesCount.value,
//                                         height: smallCardHeight,
//                                       ),
//                                     ),
//                                     SizedBox(width: 12.w),
//                                     Expanded(
//                                       child: _smallStatCard(
//                                         context,
//                                         label: 'cards'.tr,
//                                         count: controller.cardsCount.value,
//                                         height: smallCardHeight,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//
//                                 SizedBox(height: 22.h),
//
//                                 /// Achievements
//                                 _sectionCard(
//                                   context,
//                                   titleKey: 'recent_achievements',
//                                   icon: Icons.thumb_up,
//                                   borderColor: AppColors.primaryRed,
//                                   items: controller.achievements,
//                                   showCheck: true,
//                                 ),
//
//                                 SizedBox(height: 18.h),
//
//                                 /// Recent Games
//                                 _gamesCard(
//                                     context, controller.recentGames.toList()),
//
//                                 SizedBox(height: 24.h),
//
//                                 /// Bottom buttons
//                                 CustomButton(
//                                   text: 'schedule_async_game'.tr,
//                                   onPressed: controller.scheduleAsyncGame,
//                                 ),
//                                 SizedBox(height: 12.h),
//                                 CustomButton(
//                                   text: 'invite_a_player'.tr,
//                                   onPressed: controller.invitePlayer,
//                                   backgroundColor: AppColors.primaryBlue,
//                                 ),
//                                 SizedBox(height: 12.h),
//                                 CustomButton(
//                                   text: 'launch_challenge'.tr,
//                                   onPressed: controller.launchChallenge,
//                                   backgroundColor: AppColors.primaryRed,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   /// Floating Home Nav
//                   Positioned(
//                     right: -width * 0.05,
//                     top: height * 0.45,
//                     child: const CustomHomeNavBar(),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   /// ✅ small stat card
//   Widget _smallStatCard(
//       BuildContext context, {
//         required String label,
//         required int count,
//         required double height,
//       }) {
//     return Container(
//       height: height,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(color: AppColors.grey.withOpacity(0.28)),
//       ),
//       padding: EdgeInsets.all(8.w),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.emoji_events, color: AppColors.primaryBlue, size: 26.sp),
//           SizedBox(height: 6.h),
//           Text(
//             '$count',
//             style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//               color: AppColors.primaryBlue,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Text(
//             label,
//             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//               color: AppColors.textSecondary,
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// ✅ section card
//   Widget _sectionCard(
//       BuildContext context, {
//         required String titleKey,
//         required IconData icon,
//         required Color borderColor,
//         required List<Map<String, dynamic>> items,
//         bool showCheck = false,
//       }) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 6.h),
//       padding: EdgeInsets.all(AppDimensions.d12.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(AppDimensions.d18.r),
//         border: Border.all(color: borderColor.withOpacity(0.25)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: AppDimensions.d18.r,
//                 backgroundColor: borderColor,
//                 child: Icon(icon, color: Colors.white),
//               ),
//               SizedBox(width: AppDimensions.d12.w),
//               Expanded(
//                 child: Text(
//                   titleKey.tr,
//                   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.primaryBlue,
//                   ),
//                 ),
//               ),
//               const Icon(Icons.arrow_forward_ios,
//                   size: 18, color: Colors.grey),
//             ],
//           ),
//           SizedBox(height: AppDimensions.d12.h),
//
//           ...items.map((m) {
//             final titleKey = m['key'] as String? ?? '';
//             final done = m['done'] as bool? ?? false;
//             return Column(
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Text(
//                         titleKey.tr,
//                         style: Theme.of(context)
//                             .textTheme
//                             .bodyMedium
//                             ?.copyWith(
//                           color: AppColors.primaryBlue,
//                           fontWeight: FontWeight.w600,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     if (showCheck)
//                       Icon(Icons.check_circle,
//                           color: done ? Colors.green : Colors.grey,
//                           size: 20.sp),
//                   ],
//                 ),
//                 Divider(
//                   color: AppColors.grey.withOpacity(0.2),
//                   height: 14.h,
//                 ),
//               ],
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }
//
//   /// ✅ recent games card
//   Widget _gamesCard(BuildContext context, List<Map<String, String>> games) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 6.h),
//       padding: EdgeInsets.all(AppDimensions.d12.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(AppDimensions.d18.r),
//         border: Border.all(color: AppColors.grey.withOpacity(0.28)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: AppDimensions.d18.r,
//                 backgroundColor: AppColors.primaryBlue,
//                 child: const Icon(Icons.history, color: Colors.white),
//               ),
//               SizedBox(width: AppDimensions.d12.w),
//               Expanded(
//                 child: Text(
//                   'recent_games'.tr,
//                   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.primaryBlue,
//                   ),
//                 ),
//               ),
//               const Icon(Icons.arrow_forward_ios,
//                   size: 18, color: Colors.grey),
//             ],
//           ),
//           SizedBox(height: AppDimensions.d12.h),
//
//           ...games.map((g) {
//             return Column(
//               children: [
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       backgroundColor: AppColors.softRed,
//                       child: Icon(Icons.person, color: AppColors.primaryRed),
//                     ),
//                     SizedBox(width: 12.w),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             g['titleKey']!.tr,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyMedium
//                                 ?.copyWith(
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.primaryBlue,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           SizedBox(height: 4.h),
//                           Text(
//                             g['date'] ?? '',
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodySmall
//                                 ?.copyWith(
//                               color: AppColors.textSecondary,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Text(
//                       '${g['score']} ${'score'.tr}',
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodyMedium
//                           ?.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: AppColors.primaryBlue,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//                 Divider(
//                   color: AppColors.grey.withOpacity(0.2),
//                   height: 14.h,
//                 ),
//               ],
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }
// }
