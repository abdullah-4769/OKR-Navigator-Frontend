// widgets/custom_industry_container.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/app_colors.dart';
import '../../core/app_dimensions.dart';

class CustomIndustryContainer extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon; // Changed from required to optional
  final bool isSelected;
  final VoidCallback onTap;

  // Dynamic Bottom Tags
  final bool showTag1;
  final IconData? tag1Icon;
  final String? tag1Text;

  final bool showTag2;
  final IconData? tag2Icon;
  final String? tag2Text;

  final bool showTag3;
  final IconData? tag3Icon;
  final String? tag3Text;

  const CustomIndustryContainer({
    Key? key,
    required this.title,
    required this.description,
    this.icon = Icons.auto_graph_sharp, // Default icon if none provided
    required this.isSelected,
    required this.onTap,
    this.showTag1 = false,
    this.tag1Icon,
    this.tag1Text,
    this.showTag2 = false,
    this.tag2Icon,
    this.tag2Text,
    this.showTag3 = false,
    this.tag3Icon,
    this.tag3Text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color activeColor = isSelected ? AppColors.primaryRed : AppColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: EdgeInsets.only(bottom: AppDimensions.d16.h),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.d16.w,
          vertical: AppDimensions.d20.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(AppDimensions.d16.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryRed : AppColors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primaryRed.withOpacity(0.12)
                  : Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Icon + Title + Selection Circle Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Icon Circle
                Container(
                  padding: EdgeInsets.all(AppDimensions.d10.w),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryRed : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon, // Now uses the icon from controller
                    size: AppDimensions.d24.w,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
                SizedBox(width: AppDimensions.d14.w),

                // Title Text
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: AppDimensions.d18.sp,
                      fontWeight: FontWeight.w700,
                      color: activeColor,
                      fontFamily: 'Gotham',
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Selection Circle Right Side
                Container(
                  height: AppDimensions.d18.w,
                  width: AppDimensions.d18.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.primaryRed : Colors.transparent,
                    border: Border.all(
                      color: AppColors.primaryRed,
                      width: 2,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDimensions.d10.h),

            // 🔹 Description
            Text(
              description,
              style: TextStyle(
                fontSize: AppDimensions.d14.sp,
                color: AppColors.textSecondary,
                fontFamily: 'Gotham',
                height: 1.4,
              ),
            ),

            SizedBox(height: AppDimensions.d12.h),

            // 🔹 Bottom Tags (Dynamic)
            if (showTag1 || showTag2 || showTag3)
              Row(
                children: [
                  if (showTag1 && tag1Icon != null && tag1Text != null)
                    _buildTag(tag1Icon!, tag1Text!, activeColor),
                  if (showTag2 && tag2Icon != null && tag2Text != null)
                    _buildTag(tag2Icon!, tag2Text!, activeColor),
                  if (showTag3 && tag3Icon != null && tag3Text != null)
                    _buildTag(tag3Icon!, tag3Text!, activeColor),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // 🔹 Helper Method for Small Tags
  Widget _buildTag(IconData icon, String text, Color color) {
    return Padding(
      padding: EdgeInsets.only(right: AppDimensions.d16.w),
      child: Row(
        children: [
          Icon(icon, color: color, size: AppDimensions.d16.w),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: AppDimensions.d12.sp,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../core/app_colors.dart';
// import '../../core/app_dimensions.dart';
//
// class CustomIndustryContainer extends StatelessWidget {
//   final String title;
//   final String description;
//   final IconData icon;
//   final bool isSelected;
//   final VoidCallback onTap;
//
//   // Dynamic Bottom Tags
//   final bool showTag1;
//   final IconData? tag1Icon;
//   final String? tag1Text;
//
//   final bool showTag2;
//   final IconData? tag2Icon;
//   final String? tag2Text;
//
//   final bool showTag3;
//   final IconData? tag3Icon;
//   final String? tag3Text;
//
//   const CustomIndustryContainer({
//     Key? key,
//     required this.title,
//     required this.description,
//     required this.icon,
//     required this.isSelected,
//     required this.onTap,
//     this.showTag1 = false,
//     this.tag1Icon,
//     this.tag1Text,
//     this.showTag2 = false,
//     this.tag2Icon,
//     this.tag2Text,
//     this.showTag3 = false,
//     this.tag3Icon,
//     this.tag3Text,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final Color activeColor = isSelected ? AppColors.primaryRed : AppColors.textSecondary;
//
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 250),
//         margin: EdgeInsets.only(bottom: AppDimensions.d16.h),
//         padding: EdgeInsets.symmetric(
//           horizontal: AppDimensions.d16.w,
//           vertical: AppDimensions.d20.h,
//         ),
//         decoration: BoxDecoration(
//           color: AppColors.lightGrey,
//           borderRadius: BorderRadius.circular(AppDimensions.d16.r),
//           border: Border.all(
//             color: isSelected ? AppColors.primaryRed : AppColors.grey.withOpacity(0.3),
//             width: isSelected ? 2 : 1,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: isSelected
//                   ? AppColors.primaryRed.withOpacity(0.12)
//                   : Colors.black.withOpacity(0.03),
//               blurRadius: 6,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 🔹 Icon + Title + Selection Circle Row
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Left Icon Circle
//                 Container(
//                   padding: EdgeInsets.all(AppDimensions.d10.w),
//                   decoration: BoxDecoration(
//                     color: isSelected ? AppColors.primaryRed : Colors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.08),
//                         blurRadius: 4,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Icon(
//                     icon,
//                     size: AppDimensions.d24.w,
//                     color: isSelected ? Colors.white : AppColors.textSecondary,
//                   ),
//                 ),
//                 SizedBox(width: AppDimensions.d14.w),
//
//                 // Title Text
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: AppDimensions.d18.sp,
//                       fontWeight: FontWeight.w700,
//                       color: activeColor,
//                       fontFamily: 'Gotham',
//                     ),
//                     maxLines: 3,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//
//                 // Selection Circle Right Side
//                 Container(
//                   height: AppDimensions.d18.w,
//                   width: AppDimensions.d18.w,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: isSelected ? AppColors.primaryRed : Colors.transparent,
//                     border: Border.all(
//                       color: AppColors.primaryRed,
//                       width: 2,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: AppDimensions.d10.h),
//
//             // 🔹 Description
//             Text(
//               description,
//               style: TextStyle(
//                 fontSize: AppDimensions.d14.sp,
//                 color: AppColors.textSecondary,
//                 fontFamily: 'Gotham',
//                 height: 1.4,
//               ),
//             ),
//
//             SizedBox(height: AppDimensions.d12.h),
//
//             // 🔹 Bottom Tags (Dynamic)
//             if (showTag1 || showTag2 || showTag3)
//               Row(
//                 children: [
//                   if (showTag1 && tag1Icon != null && tag1Text != null)
//                     _buildTag(tag1Icon!, tag1Text!, activeColor),
//                   if (showTag2 && tag2Icon != null && tag2Text != null)
//                     _buildTag(tag2Icon!, tag2Text!, activeColor),
//                   if (showTag3 && tag3Icon != null && tag3Text != null)
//                     _buildTag(tag3Icon!, tag3Text!, activeColor),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // 🔹 Helper Method for Small Tags
//   Widget _buildTag(IconData icon, String text, Color color) {
//     return Padding(
//       padding: EdgeInsets.only(right: AppDimensions.d16.w),
//       child: Row(
//         children: [
//           Icon(icon, color: color, size: AppDimensions.d16.w),
//           SizedBox(width: 4.w),
//           Text(
//             text,
//             style: TextStyle(
//               fontSize: AppDimensions.d12.sp,
//               fontWeight: FontWeight.w500,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
// //container we provide
//
// //
// // CustomIndustryContainer(
// // title: "Launch 2 New Product Lines",
// // description: "Develop and introduce innovative products...",
// // icon: Icons.rocket_launch,
// // isSelected: controller.selectedIndex.value == 0,
// // onTap: () => controller.selectIndustry(0),
// // showTag1: true,
// // tag1Icon: Icons.lightbulb_outline,
// // tag1Text: "Product Innovation",
// // showTag2: true,
// // tag2Icon: Icons.star,
// // tag2Text: "High Impact",
// // showTag3: true,
// // tag3Icon: Icons.access_time,
// // tag3Text: "12 months",
// // );
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import '../../core/app_colors.dart';
// // import '../../core/app_dimensions.dart';
// //
// // class CustomIndustryContainer extends StatelessWidget {
// //   final String title;
// //   final String description;
// //   final IconData icon;
// //   final bool isSelected;
// //   final VoidCallback onTap;
// //
// //   // Bottom tags
// //   final bool showProductInnovation;
// //   final bool showHighImpact;
// //   final bool showDuration;
// //   final String durationText;
// //
// //   const CustomIndustryContainer({
// //     Key? key,
// //     required this.title,
// //     required this.description,
// //     required this.icon,
// //     required this.isSelected,
// //     required this.onTap,
// //     this.showProductInnovation = false,
// //     this.showHighImpact = false,
// //     this.showDuration = false,
// //     this.durationText = "12 months",
// //   }) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final Color activeColor = isSelected ? AppColors.primaryRed : AppColors.grey;
// //
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: AnimatedContainer(
// //         duration: const Duration(milliseconds: 260),
// //         margin: EdgeInsets.only(bottom: AppDimensions.d16.h),
// //         padding: EdgeInsets.symmetric(
// //           horizontal: AppDimensions.d16.w,
// //           vertical: AppDimensions.d20.h,
// //         ),
// //         constraints: BoxConstraints(minHeight: 110.h),
// //         decoration: BoxDecoration(
// //           color: AppColors.lightGrey,
// //           borderRadius: BorderRadius.circular(AppDimensions.d16.r),
// //           border: Border.all(
// //             color: isSelected ? AppColors.primaryRed : AppColors.grey.withOpacity(0.3),
// //             width: isSelected ? 2 : 1,
// //           ),
// //           boxShadow: isSelected
// //               ? [
// //             BoxShadow(
// //               color: AppColors.primaryRed.withOpacity(0.12),
// //               blurRadius: 10,
// //               offset: const Offset(0, 4),
// //             )
// //           ]
// //               : [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.03),
// //               blurRadius: 4,
// //               offset: const Offset(0, 2),
// //             )
// //           ],
// //         ),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // 🔹 Top Row → Icon + Title + Selection Circle
// //             Row(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 // Icon circle
// //                 Container(
// //                   padding: EdgeInsets.all(AppDimensions.d10.w),
// //                   decoration: BoxDecoration(
// //                     color: isSelected ? AppColors.primaryRed : Colors.white,
// //                     shape: BoxShape.circle,
// //                     boxShadow: [
// //                       BoxShadow(
// //                         color: Colors.black.withOpacity(0.08),
// //                         blurRadius: 4,
// //                         offset: const Offset(0, 2),
// //                       )
// //                     ],
// //                   ),
// //                   child: Icon(
// //                     icon,
// //                     size: AppDimensions.d24.w,
// //                     color: isSelected ? Colors.white : Colors.grey,
// //                   ),
// //                 ),
// //                 SizedBox(width: AppDimensions.d14.w),
// //
// //                 // Title & Selection Dot
// //                 Expanded(
// //                   child: Text(
// //                     title,
// //                     style: TextStyle(
// //                       fontSize: AppDimensions.d18.sp,
// //                       fontWeight: FontWeight.w700,
// //                       color: activeColor,
// //                       fontFamily: 'Gotham',
// //                     ),
// //                     maxLines: 3,
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                 ),
// //
// //                 // Selection Circle
// //                 Container(
// //                   height: AppDimensions.d18.w,
// //                   width: AppDimensions.d18.w,
// //                   decoration: BoxDecoration(
// //                     shape: BoxShape.circle,
// //                     color: isSelected ? AppColors.primaryRed : Colors.transparent,
// //                     border: Border.all(
// //                       color: AppColors.primaryRed,
// //                       width: 2,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //             SizedBox(height: AppDimensions.d10.h),
// //
// //             // 🔹 Description Below Title
// //             Text(
// //               description,
// //               style: TextStyle(
// //                 fontSize: AppDimensions.d14.sp,
// //                 color: AppColors.textSecondary,
// //                 fontFamily: 'Gotham',
// //                 height: 1.4,
// //               ),
// //             ),
// //
// //             SizedBox(height: AppDimensions.d14.h),
// //
// //             // 🔹 Bottom Row with Conditional Tags
// //             if (showProductInnovation || showHighImpact || showDuration)
// //               Row(
// //                 children: [
// //                   // Product Innovation Tag
// //                   if (showProductInnovation)
// //                     Row(
// //                       children: [
// //                         Icon(
// //                           Icons.lightbulb_outline,
// //                           color: activeColor,
// //                           size: AppDimensions.d16.w,
// //                         ),
// //                         SizedBox(width: 4.w),
// //                         Text(
// //                           "Product Innovation",
// //                           style: TextStyle(
// //                             fontSize: AppDimensions.d12.sp,
// //                             fontWeight: FontWeight.w500,
// //                             color: activeColor,
// //                           ),
// //                         ),
// //                         SizedBox(width: 12.w),
// //                       ],
// //                     ),
// //
// //                   // High Impact Tag
// //                   if (showHighImpact)
// //                     Row(
// //                       children: [
// //                         Icon(
// //                           Icons.star,
// //                           color: activeColor,
// //                           size: AppDimensions.d16.w,
// //                         ),
// //                         SizedBox(width: 4.w),
// //                         Text(
// //                           "High Impact",
// //                           style: TextStyle(
// //                             fontSize: AppDimensions.d12.sp,
// //                             fontWeight: FontWeight.w500,
// //                             color: activeColor,
// //                           ),
// //                         ),
// //                         SizedBox(width: 12.w),
// //                       ],
// //                     ),
// //
// //                   // Duration Tag
// //                   if (showDuration)
// //                     Row(
// //                       children: [
// //                         Icon(
// //                           Icons.access_time,
// //                           color: activeColor,
// //                           size: AppDimensions.d16.w,
// //                         ),
// //                         SizedBox(width: 4.w),
// //                         Text(
// //                           durationText,
// //                           style: TextStyle(
// //                             fontSize: AppDimensions.d12.sp,
// //                             fontWeight: FontWeight.w500,
// //                             color: activeColor,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                 ],
// //               ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// //
// // // for all other we
// //
// // //
// // // CustomIndustryContainer(
// // // title: "Launch 2 New Product Lines for Emerging Markets",
// // // description: "Develop and introduce innovative products tailored for new market demands",
// // // icon: Icons.rocket_launch,
// // // isSelected: controller.selectedIndex.value == 0,
// // // onTap: () => controller.selectIndustry(0),
// // // showProductInnovation: false,
// // // showHighImpact: false,
// // // showDuration: false,
// // // durationText: "12 months",
// // // );