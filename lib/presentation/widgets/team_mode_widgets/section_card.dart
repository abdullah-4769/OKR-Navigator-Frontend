import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_colors.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color borderColor;
  final List<Map<String, dynamic>> items;
  final bool showCheck;
  final bool showScore;

  /// 🔹 Flags
  final bool showLeftIcons;   // if true → show same icons on left side
  final bool showRightIcons;  // if false → hide icons on right side
  final bool showTopButton;   // if false → hide ">" arrow

  /// 🔹 Customizations
  final Color? outerCircleColor; // CircleAvatar bg
  final Color? checkIconColor;   // ✔ tick color (single, always applied)

  /// 🔹 New properties for text flexibility
  final int? maxLines; // Allow text to wrap to multiple lines
  final TextAlign textAlign; // Text alignment
  final bool wrapContent; // Allow the card to expand vertically

  const SectionCard({
    super.key,
    required this.title,
    this.icon,
    required this.borderColor,
    required this.items,
    this.showCheck = false,
    this.showScore = false,
    this.showLeftIcons = false,
    this.showRightIcons = true,
    this.showTopButton = true,
    this.outerCircleColor,
    this.checkIconColor,
    this.maxLines, // Allow unlimited lines by default
    this.textAlign = TextAlign.start,
    this.wrapContent = true, // Enable content wrapping by default
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.symmetric(vertical: 6.h),
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18.r),
      border: Border.all(color: borderColor),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min, // Allow column to shrink-wrap content
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              CircleAvatar(
                radius: 18.r,
                backgroundColor: outerCircleColor ?? borderColor,
                child: Icon(icon, color: Colors.white, size: 18.sp),
              ),
              SizedBox(width: 12.w),
            ],
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryRed,
                ),
                maxLines: 2, // Allow title to wrap to 2 lines
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (showTopButton)
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
        SizedBox(height: 12.h),

        /// 🔹 Items - Now with flexible height
        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final m = entry.value;
          final isLast = index == items.length - 1;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start, // Align items to top
                children: [
                  /// Left side
                  if (showLeftIcons && (showCheck || showScore)) ...[
                    if (showCheck)
                      Icon(
                        Icons.check_circle,
                        color: checkIconColor ?? Colors.green,
                        size: 20.sp,
                      ),
                    if (showScore)
                      Padding(
                        padding: EdgeInsets.only(left: 6.w),
                        child: Text(
                          '${m['score']}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    SizedBox(width: 10.w),
                  ],

                  /// Title - Now with flexible height
                  Expanded(
                    child: Text(
                      m['key'] ?? m['title'] ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: maxLines, // null = unlimited lines
                      overflow: maxLines == null ? null : TextOverflow.ellipsis,
                      textAlign: textAlign,
                    ),
                  ),

                  /// Right side
                  if (showRightIcons) ...[
                    if (showCheck)
                      Icon(
                        Icons.check_circle,
                        color: checkIconColor ?? Colors.green,
                        size: 20.sp,
                      ),
                    if (showScore)
                      Text(
                        '${m['score']}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                        ),
                      ),
                  ]
                ],
              ),
              if (!isLast) // Only show divider if not the last item
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








// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../../core/app_colors.dart';
//
// class SectionCard extends StatelessWidget {
//   final String title;
//   final IconData? icon;
//   final Color borderColor;
//   final List<Map<String, dynamic>> items;
//   final bool showCheck;
//   final bool showScore;
//
//   /// 🔹 Flags
//   final bool showLeftIcons;   // if true → show same icons on left side
//   final bool showRightIcons;  // if false → hide icons on right side
//   final bool showTopButton;   // if false → hide ">" arrow
//
//   /// 🔹 Customizations
//   final Color? outerCircleColor; // CircleAvatar bg
//   final Color? checkIconColor;   // ✔ tick color (single, always applied)
//
//   const SectionCard({
//     super.key,
//     required this.title,
//     this.icon,
//     required this.borderColor,
//     required this.items,
//     this.showCheck = false,
//     this.showScore = false,
//     this.showLeftIcons = false,
//     this.showRightIcons = true,
//     this.showTopButton = true,
//     this.outerCircleColor,
//     this.checkIconColor,
//   });
//
//   @override
//   Widget build(BuildContext context) => Container(
//     margin: EdgeInsets.symmetric(vertical: 6.h),
//     padding: EdgeInsets.all(12.w),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(18.r),
//       border: Border.all(color: borderColor),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.03),
//           blurRadius: 6,
//           offset: const Offset(0, 3),
//         ),
//       ],
//     ),
//     child: Column(
//       children: [
//         Row(
//           children: [
//             if (icon != null) ...[
//               CircleAvatar(
//                 radius: 18.r,
//                 backgroundColor: outerCircleColor ?? borderColor,
//                 child: Icon(icon, color: Colors.white, size: 18.sp),
//               ),
//               SizedBox(width: 12.w),
//             ],
//             Expanded(
//               child: Text(title,
//                   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.primaryRed)),
//             ),
//             if (showTopButton)
//               const Icon(Icons.arrow_forward_ios,
//                   size: 18, color: Colors.grey),
//           ],
//         ),
//         SizedBox(height: 12.h),
//
//         /// 🔹 Items
//         ...items.map((m) => Column(
//           children: [
//             Row(
//               children: [
//                 /// Left side
//                 if (showLeftIcons && (showCheck || showScore)) ...[
//                   if (showCheck)
//                     Icon(Icons.check_circle,
//                         color: checkIconColor ?? Colors.green,
//                         size: 20.sp),
//                   if (showScore)
//                     Padding(
//                       padding: EdgeInsets.only(left: 6.w),
//                       child: Text('${m['score']}%',
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 13.sp)),
//                     ),
//                   SizedBox(width: 10.w),
//                 ],
//
//                 /// Title
//                 Expanded(
//                   child: Text(
//                     m['key'] ?? m['title'] ?? '',
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodyMedium
//                         ?.copyWith(
//                         color: AppColors.black,
//                         fontWeight: FontWeight.w600),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//
//                 /// Right side
//                 if (showRightIcons) ...[
//                   if (showCheck)
//                     Icon(Icons.check_circle,
//                         color: checkIconColor ?? Colors.green,
//                         size: 20.sp),
//                   if (showScore)
//                     Text('${m['score']}%',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 13.sp)),
//                 ]
//               ],
//             ),
//             Divider(
//                 color: AppColors.grey.withOpacity(0.2), height: 14.h),
//           ],
//         )).toList(),
//       ],
//     ),
//   );
// }
