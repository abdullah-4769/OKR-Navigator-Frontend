import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../../widgets/custom_circular_avatar.dart';

class OrganizationPathCard extends StatelessWidget {
  final String orgName;
  final String orgSubtitle;
  final int stars;
  final List<OrgNode> nodes;
  final int currentNodeIndex;

  const OrganizationPathCard({
    super.key,
    required this.orgName,
    required this.orgSubtitle,
    required this.stars,
    required this.nodes,
    this.currentNodeIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;

    return Container(
      margin: EdgeInsets.all(isWideScreen ? 20.w : 12.w),
      padding: EdgeInsets.all(isWideScreen ? 20.w : 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isWideScreen ? 20.r : 16.r),
        border: Border.all(
          width: 2,
          color: Colors.transparent, // gradient override
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isWideScreen ? 20.r : 16.r),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Top Section (Nodes randomly placed)
            SizedBox(
              height: isWideScreen ? 260.h : 220.h,
              width: double.infinity,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  /// ✅ Background Image (progress_track)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/progress_track.png', // <-- your image
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),

                  // Node 1 → bottom left
                  Positioned(
                    left: 10.w,
                    bottom: 1.h,
                    child: _buildNode(
                      nodes[0],
                      isCurrent: currentNodeIndex == 0,
                      isDisabled: 0 > currentNodeIndex,
                      isWideScreen: isWideScreen,
                    ),
                  ),

                  // Node 2 → middle right
                  if (nodes.length > 1)
                    Positioned(
                      right: 120.w,
                      bottom: 130.h,
                      child: _buildNode(
                        nodes[1],
                        isCurrent: currentNodeIndex == 1,
                        isDisabled: 1 > currentNodeIndex,
                        isWideScreen: isWideScreen,
                      ),
                    ),

                  // Node 3 → top center
                  if (nodes.length > 2)
                    Positioned(
                      top: 60.h,
                      left: (screenWidth / 2) - 20.w,
                      child: _buildNode(
                        nodes[2],
                        isCurrent: currentNodeIndex == 2,
                        isDisabled: 2 > currentNodeIndex,
                        isWideScreen: isWideScreen,
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(height: isWideScreen ? 18.h : 14.h),

            /// 🔹 Bottom Section (Stars)
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (index) {
                  return Icon(
                    index < stars ? Icons.star : Icons.star_border,
                    color:
                    index < stars ? AppColors.primaryRed : AppColors.grey,
                    size: isWideScreen ? 20.sp : 18.sp,
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNode(
      OrgNode node, {
        required bool isCurrent,
        required bool isDisabled,
        required bool isWideScreen,
      }) {
    return Column(
      children: [
        if (isCurrent)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppColors.primaryRed,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              "You".tr,
              style: TextStyle(
                color: Colors.white,
                fontSize: isWideScreen ? 10.sp : 9.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Opacity(
          opacity: isDisabled ? 0.4 : 1.0,
          child: CustomCircularAvatar(
            imagePath: node.imagePath,
            innerColors: node.innerColors,
            borderGradient: isCurrent ? node.borderGradient : null,
            size: isWideScreen ? 80 : 70,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          node.title.tr,
          style: TextStyle(
            fontSize: isWideScreen ? 14.sp : 13.sp,
            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
            color: isCurrent ? AppColors.black : AppColors.grey,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          node.subtitle.tr,
          style: TextStyle(
            fontSize: isWideScreen ? 12.sp : 11.sp,
            color:
            isCurrent ? AppColors.black : AppColors.grey.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class OrgNode {
  final String title;
  final String subtitle;
  final String imagePath;
  final List<Color> innerColors;
  final List<Color>? borderGradient;
  final bool isYou;

  OrgNode({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.innerColors,
    this.borderGradient,
    this.isYou = false,
  });
}










// this is old we have new
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import '../../../core/app_colors.dart';
// import '../../widgets/custom_circular_avatar.dart';
//
// class OrganizationPathCard extends StatelessWidget {
//   final String orgName;
//   final String orgSubtitle;
//   final int stars;
//   final List<OrgNode> nodes;
//   final int currentNodeIndex;
//
//   const OrganizationPathCard({
//     super.key,
//     required this.orgName,
//     required this.orgSubtitle,
//     required this.stars,
//     required this.nodes,
//     this.currentNodeIndex = 0,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isWideScreen = screenWidth > 600;
//
//     return
//
//       Container(
//       margin: EdgeInsets.all(isWideScreen ? 20.w : 12.w),
//       padding: EdgeInsets.all(isWideScreen ? 20.w : 14.w),
//       decoration: BoxDecoration(
//
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(isWideScreen ? 20.r : 16.r),
//         border: Border.all(
//           width: 2,
//           color: Colors.transparent, // we’ll override with gradient below
//         ),
//       ),
//
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(isWideScreen ? 20.r : 16.r),
//             border: Border.all(color: Colors.white, width: 2,),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// 🔹 Top Section (Nodes randomly placed)
//               SizedBox(
//                 height: isWideScreen ? 260.h : 220.h,
//                 width: double.infinity,
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     // Node 1 → bottom left
//                     Positioned(
//                       left: 10.w,
//                       bottom: 1.h,
//                       child: _buildNode(
//                         nodes[0],
//                         isCurrent: currentNodeIndex == 0,
//                         isDisabled: 0 > currentNodeIndex,
//                         isWideScreen: isWideScreen,
//                       ),
//                     ),
//
//                     // Node 2 → middle right
//                     if (nodes.length > 1)
//                       Positioned(
//                         right: 120.w,
//                         bottom: 130.h,
//                         child: _buildNode(
//                           nodes[1],
//                           isCurrent: currentNodeIndex == 1,
//                           isDisabled: 1 > currentNodeIndex,
//                           isWideScreen: isWideScreen,
//                         ),
//                       ),
//
//                     // Node 3 → top center
//                     if (nodes.length > 2)
//                       Positioned(
//                         top: 60.h,
//                         left: (screenWidth / 2) - 20.w,
//                         child: _buildNode(
//                           nodes[2],
//                           isCurrent: currentNodeIndex == 2,
//                           isDisabled: 2 > currentNodeIndex,
//                           isWideScreen: isWideScreen,
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//
//               SizedBox(height: isWideScreen ? 18.h : 14.h),
//
//               /// 🔹 Bottom Section (Stars only, since orgName/subtitle are optional)
//               Align(
//                 alignment: Alignment.bottomRight,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: List.generate(3, (index) {
//                     return Icon(
//                       index < stars ? Icons.star : Icons.star_border,
//                       color:
//                       index < stars ? AppColors.primaryRed : AppColors.grey,
//                       size: isWideScreen ? 20.sp : 18.sp,
//                     );
//                   }),
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//     );
//   }
//
//   Widget _buildNode(
//       OrgNode node, {
//         required bool isCurrent,
//         required bool isDisabled,
//         required bool isWideScreen,
//       }) {
//     return Column(
//       children: [
//         if (isCurrent)
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
//             decoration: BoxDecoration(
//               color: AppColors.primaryRed,
//               borderRadius: BorderRadius.circular(10.r),
//             ),
//             child: Text(
//               "You".tr,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: isWideScreen ? 10.sp : 9.sp,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         Opacity(
//           opacity: isDisabled ? 0.4 : 1.0,
//           child: CustomCircularAvatar(
//             imagePath: node.imagePath,
//             innerColors: node.innerColors,
//             borderGradient: isCurrent ? node.borderGradient : null,
//             size: isWideScreen ? 80 : 70,
//           ),
//         ),
//         SizedBox(height: 8.h),
//         Text(
//           node.title.tr,
//           style: TextStyle(
//             fontSize: isWideScreen ? 14.sp : 13.sp,
//             fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
//             color: isCurrent ? AppColors.black : AppColors.grey,
//           ),
//           textAlign: TextAlign.center,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//         ),
//         Text(
//           node.subtitle.tr,
//           style: TextStyle(
//             fontSize: isWideScreen ? 12.sp : 11.sp,
//             color: isCurrent
//                 ? AppColors.black
//                 : AppColors.grey.withOpacity(0.7),
//           ),
//           textAlign: TextAlign.center,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//         ),
//       ],
//     );
//   }
// }
//
// class OrgNode {
//   final String title;
//   final String subtitle;
//   final String imagePath;
//   final List<Color> innerColors;
//   final List<Color>? borderGradient;
//   final bool isYou;
//
//   OrgNode({
//     required this.title,
//     required this.subtitle,
//     required this.imagePath,
//     required this.innerColors,
//     this.borderGradient,
//     this.isYou = false,
//   });
// }
