import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../../../generated/models/responses/campaign/certification_info_mode.dart';
import '../../../view_model/campaign_mode/certification_info_model.dart';

import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

class CertificationScreen extends StatelessWidget {
  const CertificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CertificationInfoViewModel viewModel = Get.find<CertificationInfoViewModel>();

    return Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) => OrientationBuilder(
            builder: (context, orientation) {
              return _ResponsiveCertificationScreen(
                constraints: constraints,
                orientation: orientation,
                viewModel: viewModel,
              );
            },
          ),
        ),
    );
  }
}

class _ResponsiveCertificationScreen extends StatefulWidget {
  final BoxConstraints constraints;
  final Orientation orientation;
  final CertificationInfoViewModel viewModel;

  const _ResponsiveCertificationScreen({
    required this.constraints,
    required this.orientation,
    required this.viewModel,
  });

  @override
  State<_ResponsiveCertificationScreen> createState() => _ResponsiveCertificationScreenState();
}

class _ResponsiveCertificationScreenState extends State<_ResponsiveCertificationScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch certification data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.fetchCertificationInfo();
    });
  }

  // Device detection
  double get screenWidth => widget.constraints.maxWidth;
  double get screenHeight => widget.constraints.maxHeight;

  DeviceType get deviceType {
    if (screenWidth < 600) return DeviceType.mobile;
    if (screenWidth >= 600 && screenWidth < 900) return DeviceType.tablet;
    if (screenWidth >= 900 && screenWidth < 1200) return DeviceType.desktop;
    if (screenWidth >= 1200 && screenWidth < 1920) return DeviceType.largeDesktop;
    return DeviceType.ultraWide;
  }

  bool get isPortrait => widget.orientation == Orientation.portrait;
  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isWeb => deviceType == DeviceType.largeDesktop || deviceType == DeviceType.ultraWide;

  // Responsive helpers
  double getResponsiveFont({
    required double mobile,
    required double tablet,
    required double desktop,
    required double largeDesktop,
    required double ultraWide,
  }) {
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile.sp;
      case DeviceType.tablet:
        return tablet.sp;
      case DeviceType.desktop:
        return desktop.sp;
      case DeviceType.largeDesktop:
        return largeDesktop.sp;
      case DeviceType.ultraWide:
        return ultraWide.sp;
    }
  }

  double getResponsiveSpacing({
    required double mobile,
    required double tablet,
    required double desktop,
    required double largeDesktop,
    required double ultraWide,
  }) {
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile.h;
      case DeviceType.tablet:
        return tablet.h;
      case DeviceType.desktop:
        return desktop;
      case DeviceType.largeDesktop:
        return largeDesktop;
      case DeviceType.ultraWide:
        return ultraWide;
    }
  }

  double getResponsiveWidth({
    required double mobile,
    required double tablet,
    required double desktop,
    required double largeDesktop,
    required double ultraWide,
  }) {
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile.w;
      case DeviceType.tablet:
        return tablet.w;
      case DeviceType.desktop:
        return desktop;
      case DeviceType.largeDesktop:
        return largeDesktop;
      case DeviceType.ultraWide:
        return ultraWide;
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: isWeb ? 500 : double.infinity),
          padding: EdgeInsets.symmetric(
            vertical: getResponsiveSpacing(
              mobile: 18,
              tablet: 20,
              desktop: 24,
              largeDesktop: 28,
              ultraWide: 32,
            ),
          ),
          child: Obx(() {
            if (widget.viewModel.isLoading.value) {
              return _buildLoadingState();
            } else if (widget.viewModel.errorMessage.value.isNotEmpty) {
              return _buildErrorState();
            } else if (widget.viewModel.certificationInfo != null) {
              return _buildContent();
            } else {
              return _buildEmptyState();
            }
          }),
        ),
      ),
    ),
  );

  Widget _buildLoadingState() {
    return Column(
      children: [
        CustomHeader(
          title: 'Your',
          highlightedText: 'Certification',
          onBackTap: () => Get.back(),
        ),
        SizedBox(height: 50.h),
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
        ),
        SizedBox(height: 16.h),
        Text(
          'Loading your certifications...',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.primaryRed,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Column(
      children: [
        CustomHeader(
          title: 'Your',
          highlightedText: 'Certification',
          onBackTap: () => Get.back(),
        ),
        SizedBox(height: 50.h),
        Icon(
          Icons.error_outline,
          size: 64,
          color: AppColors.primaryRed,
        ),
        SizedBox(height: 16.h),
        Text(
          'Failed to load certifications',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryRed,
          ),
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Text(
            widget.viewModel.errorMessage.value,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp),
          ),
        ),
        SizedBox(height: 18.h),
        ElevatedButton(
          onPressed: () => widget.viewModel.fetchCertificationInfo(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryRed,
            foregroundColor: Colors.white,
          ),
          child: Text('Try Again'),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        CustomHeader(
          title: 'Your',
          highlightedText: 'Certification',
          onBackTap: () => Get.back(),
        ),
        SizedBox(height: 50.h),
        Text(
          'No certification data available',
          style: TextStyle(fontSize: 16.sp),
        ),
      ],
    );
  }

  Widget _buildContent() {
    final progress = widget.viewModel.certificationInfo!.progress;
    final certifications = widget.viewModel.certificationInfo!.certifications;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomHeader(
          title: 'Your',
          highlightedText: 'Certification',
          onBackTap: () => Get.back(),
        ),

        SizedBox(height: getResponsiveSpacing(mobile: 20, tablet: 35, desktop: 40, largeDesktop: 45, ultraWide: 50)),

        // Stats Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: _buildStatsRow(progress),
        ),

        SizedBox(height: getResponsiveSpacing(mobile: 18, tablet: 35, desktop: 40, largeDesktop: 45, ultraWide: 50)),

        // Earned Certifications Section
        if (certifications.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: _buildEarnedCertificationsSection(certifications),
          ),

        if (certifications.isNotEmpty)
          SizedBox(height: getResponsiveSpacing(mobile: 18, tablet: 35, desktop: 40, largeDesktop: 45, ultraWide: 50)),

        // Available to Start Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: _buildAvailableToStartSection(),
        ),
      ],
    );
  }

  Widget _buildStatsRow(ProgressInfo progress) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _buildStatCard(progress.earned.toString(), 'Earned', Color(0xff00233B)),
      _buildStatCard(progress.inProgress.toString(), 'In Progress', Color(0xff00233B)),
      _buildStatCard(progress.total.toString(), 'Available', Color(0xff00233B)),
    ],
  );

  Widget _buildStatCard(String number, String label, Color textColor) => Container(
    padding: EdgeInsets.symmetric(
      vertical: getResponsiveSpacing(mobile: 16, tablet: 20, desktop: 24, largeDesktop: 28, ultraWide: 32),
      horizontal: getResponsiveWidth(mobile: 16, tablet: 20, desktop: 24, largeDesktop: 28, ultraWide: 32),
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 2))],
    ),
    child: Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: getResponsiveFont(mobile: 24, tablet: 28, desktop: 32, largeDesktop: 36, ultraWide: 40),
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: getResponsiveFont(mobile: 12, tablet: 14, desktop: 16, largeDesktop: 18, ultraWide: 20),
            color: Color(0xff00233B),
          ),
        ),
      ],
    ),
  );

  Widget _buildEarnedCertificationsSection(List<Certification> certifications) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFD32F2F)),
            child: const Icon(Icons.emoji_events, color: Colors.white, size: 20),
          ),
          SizedBox(width: 12),
          Text(
            'Earned Certifications',
            style: TextStyle(
              fontSize: getResponsiveFont(mobile: 18, tablet: 20, desktop: 22, largeDesktop: 24, ultraWide: 26),
              fontWeight: FontWeight.bold,
              color: Color(0xff00233B),
            ),
          ),
        ],
      ),
      SizedBox(height:30),
      // Certification Cards
      ...certifications.map((cert) => Column(
        children: [
          _buildCertificationCard(cert),
          SizedBox(height: 16),
        ],
      )).toList(),
    ],
  );

  Widget _buildCertificationCard(Certification cert) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Color(0xFFD32F2F).withOpacity(0.3), width: 1),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: Offset(0, 2))],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badge icon - Made smaller
        Container(
          height: 40,
          width: 40,
          child: Image.asset(
            "assets/images/badge.png",
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFFD32F2F)),
              child: Icon(Icons.emoji_events, color: Colors.white, size: 20),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      cert.title,
                      style: TextStyle(
                        fontSize: getResponsiveFont(mobile: 16, tablet: 18, desktop: 20, largeDesktop: 22, ultraWide: 24),
                        fontWeight: FontWeight.bold,
                        color: Color(0xff00233B),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Color(0xFFD32F2F), shape: BoxShape.circle),
                    child: Icon(Icons.check, color: Colors.white, size: 16),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                cert.strengths,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: getResponsiveFont(mobile: 12, tablet: 13, desktop: 14, largeDesktop: 15, ultraWide: 16),
                  color: Color(0xff00233B),
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(width: 6, height: 6, decoration: BoxDecoration(color: Color(0xFFD32F2F), shape: BoxShape.circle)),
                      SizedBox(width: 6),
                      Text(
                        cert.formattedDate,
                        style: TextStyle(
                          fontSize: getResponsiveFont(mobile: 10, tablet: 11, desktop: 12, largeDesktop: 13, ultraWide: 14),
                          color: Color(0xFFD32F2F),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                          "assets/images/badge.png",
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.star, color: Colors.amber, size: 16),
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        cert.formattedScore,
                        style: TextStyle(
                          fontSize: getResponsiveFont(mobile: 16, tablet: 18, desktop: 20, largeDesktop: 22, ultraWide: 24),
                          fontWeight: FontWeight.bold,
                          color: Color(0xff00233B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildAvailableToStartSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // Made badge image smaller
      Container(
        width: 40, // Reduced from 60
        height: 40, // Reduced from 60
        child: Image.asset(
          "assets/images/badge.png",
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.emoji_events, size: 40, color: Color(0xFFD32F2F)),
        ),
      ),
      SizedBox(height: 16),
      Text(
        'Available to Start',
        style: TextStyle(
          fontSize: getResponsiveFont(mobile: 18, tablet: 20, desktop: 22, largeDesktop: 24, ultraWide: 26),
          fontWeight: FontWeight.bold,
          color: Color(0xff00233B),
        ),
      ),
      SizedBox(height: 24),
      ...widget.viewModel.availableCertifications.map((cert) => Column(
        children: [
          _buildAvailableCertificationCard(cert),
          SizedBox(height: 16),
        ],
      )).toList(),
    ],
  );

  Widget _buildAvailableCertificationCard(Map<String, dynamic> cert) => Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      border: Border.all(color: Color(0xffD7D7D7)),
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: Offset(0, 2))],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Color(0xFFD32F2F), shape: BoxShape.circle),
          child: Icon(cert['icon'] as IconData, color: Colors.white, size: 20),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      cert['title'],
                      style: TextStyle(
                        fontSize: getResponsiveFont(mobile: 16, tablet: 18, desktop: 20, largeDesktop: 22, ultraWide: 24),
                        fontWeight: FontWeight.bold,
                        color: Color(0xff00233B),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: Color(0xff24387F), borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      'Start',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: getResponsiveFont(mobile: 12, tablet: 14, desktop: 16, largeDesktop: 18, ultraWide: 20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                cert['description'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: getResponsiveFont(mobile: 12, tablet: 13, desktop: 14, largeDesktop: 15, ultraWide: 16),
                  color: Color(0xff00233B),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

enum DeviceType { mobile, tablet, desktop, largeDesktop, ultraWide }





// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// import '../../../core/app_colors.dart';
// import '../../widgets/custom_circular_avatar.dart';
// import '../../widgets/custom_curved_arrow.dart';
// import '../../widgets/screens_unique_parts/custom_background.dart';
// import '../../widgets/screens_unique_parts/custom_header.dart';
//
// class CertificationScreen extends StatelessWidget {
//   const CertificationScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     backgroundColor: const Color(0xFFF8F9FA),
//     body: LayoutBuilder(
//       builder: (context, constraints) => OrientationBuilder(
//         builder: (context, orientation) {
//           return _ResponsiveCertificationScreen(
//             constraints: constraints,
//             orientation: orientation,
//           );
//         },
//       ),
//     ),
//   );
// }
//
// class _ResponsiveCertificationScreen extends StatelessWidget {
//   final BoxConstraints constraints;
//   final Orientation orientation;
//
//   const _ResponsiveCertificationScreen({
//     required this.constraints,
//     required this.orientation,
//   });
//
//   // Device detection
//   double get screenWidth => constraints.maxWidth;
//   double get screenHeight => constraints.maxHeight;
//
//   DeviceType get deviceType {
//     if (screenWidth < 600) return DeviceType.mobile;
//     if (screenWidth >= 600 && screenWidth < 900) return DeviceType.tablet;
//     if (screenWidth >= 900 && screenWidth < 1200) return DeviceType.desktop;
//     if (screenWidth >= 1200 && screenWidth < 1920)
//       return DeviceType.largeDesktop;
//     return DeviceType.ultraWide;
//   }
//
//   bool get isPortrait => orientation == Orientation.portrait;
//   bool get isMobile => deviceType == DeviceType.mobile;
//   bool get isWeb =>
//       deviceType == DeviceType.largeDesktop ||
//           deviceType == DeviceType.ultraWide;
//
//   // Responsive helpers
//   double getResponsiveFont({
//     required double mobile,
//     required double tablet,
//     required double desktop,
//     required double largeDesktop,
//     required double ultraWide,
//   }) {
//     switch (deviceType) {
//       case DeviceType.mobile:
//         return mobile.sp;
//       case DeviceType.tablet:
//         return tablet.sp;
//       case DeviceType.desktop:
//         return desktop.sp;
//       case DeviceType.largeDesktop:
//         return largeDesktop.sp;
//       case DeviceType.ultraWide:
//         return ultraWide.sp;
//     }
//   }
//
//   double getResponsiveSpacing({
//     required double mobile,
//     required double tablet,
//     required double desktop,
//     required double largeDesktop,
//     required double ultraWide,
//   }) {
//     switch (deviceType) {
//       case DeviceType.mobile:
//         return mobile.h;
//       case DeviceType.tablet:
//         return tablet.h;
//       case DeviceType.desktop:
//         return desktop;
//       case DeviceType.largeDesktop:
//         return largeDesktop;
//       case DeviceType.ultraWide:
//         return ultraWide;
//     }
//   }
//
//   double getResponsiveWidth({
//     required double mobile,
//     required double tablet,
//     required double desktop,
//     required double largeDesktop,
//     required double ultraWide,
//   }) {
//     switch (deviceType) {
//       case DeviceType.mobile:
//         return mobile.w;
//       case DeviceType.tablet:
//         return tablet.w;
//       case DeviceType.desktop:
//         return desktop;
//       case DeviceType.largeDesktop:
//         return largeDesktop;
//       case DeviceType.ultraWide:
//         return ultraWide;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) => SafeArea(
//     child: CustomBackground(
//       child: SingleChildScrollView(
//         child: Center(
//           child: Container(
//             constraints: BoxConstraints(maxWidth: isWeb ? 500 : double.infinity),
//             padding: EdgeInsets.symmetric(
//               vertical: getResponsiveSpacing(
//                 mobile: 16,
//                 tablet: 20,
//                 desktop: 24,
//                 largeDesktop: 28,
//                 ultraWide: 32,
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustomHeader(
//                   title: 'Your',
//                   highlightedText: 'Certification',
//                   onBackTap: () {
//                     Get.back();
//                   },
//                 ),
//
//                 SizedBox(
//                   height: getResponsiveSpacing(
//                     mobile: 18,
//                     tablet: 35,
//                     desktop: 40,
//                     largeDesktop: 45,
//                     ultraWide: 50,
//                   ),
//                 ),
//
//                 // Stats Row
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 18.0),
//                   child: _buildStatsRow(),
//                 ),
//
//                 SizedBox(
//                   height: getResponsiveSpacing(
//                     mobile: 18,
//                     tablet: 35,
//                     desktop: 40,
//                     largeDesktop: 45,
//                     ultraWide: 50,
//                   ),
//                 ),
//
//                 // Earned Certifications Section
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                   child: _buildEarnedCertificationsSection(),
//                 ),
//
//                 SizedBox(
//                   height: getResponsiveSpacing(
//                     mobile: 18,
//                     tablet: 35,
//                     desktop: 40,
//                     largeDesktop: 45,
//                     ultraWide: 50,
//                   ),
//                 ),
//
//                 // Available to Start Section
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 18.0),
//                   child: _buildAvailableToStartSection(),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
//
//   Widget _buildStatsRow() => Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       _buildStatCard('5', 'Earned', Color(0xff00233B),
//       ),
//       _buildStatCard('3', 'In Progress', Color(0xff00233B)),
//       _buildStatCard('12', 'Available', Color(0xff00233B)),
//     ],
//   );
//
//   Widget _buildStatCard(String number, String label, Color textColor) =>
//       Container(
//         padding: EdgeInsets.symmetric(
//           vertical: getResponsiveSpacing(
//             mobile: 16,
//             tablet: 20,
//             desktop: 24,
//             largeDesktop: 28,
//             ultraWide: 32,
//           ),
//           horizontal: getResponsiveWidth(
//             mobile: 16,
//             tablet: 20,
//             desktop: 24,
//             largeDesktop: 28,
//             ultraWide: 32,
//           ),
//         ),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Text(
//               number,
//               style: TextStyle(
//                 fontSize: getResponsiveFont(
//                   mobile: 24,
//                   tablet: 28,
//                   desktop: 32,
//                   largeDesktop: 36,
//                   ultraWide: 40,
//                 ),
//                 fontWeight: FontWeight.bold,
//                 color: textColor,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: getResponsiveFont(
//                   mobile: 12,
//                   tablet: 14,
//                   desktop: 16,
//                   largeDesktop: 18,
//                   ultraWide: 20,
//                 ),
//                 color: Color(0xff00233B),
//
//               ),
//             ),
//           ],
//         ),
//       );
//
//   Widget _buildEarnedCertificationsSection() => Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: const BoxDecoration(
//               shape: BoxShape.circle,
//               color: Color(0xFFD32F2F),
//             ),
//             child: const Icon(
//               Icons.emoji_events,
//               color: Colors.white,
//               size: 20,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Text(
//             'Earned Certifications',
//             style: TextStyle(
//                 fontSize: getResponsiveFont(
//                   mobile: 18,
//                   tablet: 20,
//                   desktop: 22,
//                   largeDesktop: 24,
//                   ultraWide: 26,
//                 ),
//                 fontWeight: FontWeight.bold,
//                 color:Color(0xff00233B)            ),
//           ),
//         ],
//       ),
//
//       const SizedBox(height: 20),
//
//       // Certification Cards
//       _buildCertificationCard(
//         'OKR Fundamentals',
//         'Master the basics of Objectives and Results',
//         'Earned Jan 15, 2025',
//         '95%',
//         true,
//       ),
//
//       const SizedBox(height: 16),
//
//       _buildCertificationCard(
//         'Team Alignment Expert',
//         'Advanced team coordination strategies',
//         'Earned Feb 20, 2025',
//         '89%',
//         true,
//       ),
//
//       const SizedBox(height: 16),
//
//       _buildCertificationCard(
//         'Performance Tracking',
//         'KPI monitoring and analysis mastery',
//         'Earned Feb 20, 2025',
//         '92%',
//         true,
//       ),
//     ],
//   );
//
//   Widget _buildCertificationCard(
//       String title,
//       String description,
//       String date,
//       String percentage,
//       bool isCompleted,
//       ) => Container(
//     padding: const EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(12),
//       border: Border.all(
//         color: const Color(0xFFD32F2F).withOpacity(0.3),
//         width: 1,
//       ),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.05),
//           blurRadius: 8,
//           offset: const Offset(0, 2),
//         ),
//       ],
//     ),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Left side - Icon and content
//         Expanded(
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: 40,
//                 width: 40,
//                 padding: const EdgeInsets.all(8),
//                 decoration: const BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage("assets/images/badge.png"),
//                   ),
//                   color: Color(0xFFD32F2F),
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           title,
//                           style: TextStyle(
//                             fontSize: getResponsiveFont(
//                               mobile: 16,
//                               tablet: 18,
//                               desktop: 20,
//                               largeDesktop: 22,
//                               ultraWide: 24,
//                             ),
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xff00233B),
//                           ),
//                         ),
//                         Container(
//                           padding: const EdgeInsets.all(4),
//                           decoration: const BoxDecoration(
//                             color: Color(0xFFD32F2F),
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                             Icons.check,
//                             color: Colors.white,
//                             size: 16,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       description,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         fontSize: getResponsiveFont(
//                           mobile: 12,
//                           tablet: 13,
//                           desktop: 14,
//                           largeDesktop: 15,
//                           ultraWide: 16,
//                         ),
//                         color: Color(0xff00233B)
//                         ,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               width: 6,
//                               height: 6,
//                               decoration: const BoxDecoration(
//                                 color: Color(0xFFD32F2F),
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                             const SizedBox(width: 6),
//                             Text(
//                               date,
//                               style: TextStyle(
//                                 fontSize: getResponsiveFont(
//                                   mobile: 10,
//                                   tablet: 11,
//                                   desktop: 12,
//                                   largeDesktop: 13,
//                                   ultraWide: 14,
//                                 ),
//                                 color: const Color(0xFFD32F2F),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             const Image(
//                               image: AssetImage("assets/images/badge.png"),
//                             ),
//                             Text(
//                               percentage,
//                               style: TextStyle(
//                                 fontSize: getResponsiveFont(
//                                   mobile: 16,
//                                   tablet: 18,
//                                   desktop: 20,
//                                   largeDesktop: 22,
//                                   ultraWide: 24,
//                                 ),
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xff00233B),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
//
//   Widget _buildAvailableToStartSection() => Column(
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: [
//       Container(
//         width: 60,
//         height: 60,
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           image: DecorationImage(image: AssetImage("assets/images/badge.png")),
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//
//       const SizedBox(height: 16),
//
//       Text(
//         'Available to Start',
//         style: TextStyle(
//           fontSize: getResponsiveFont(
//             mobile: 18,
//             tablet: 20,
//             desktop: 22,
//             largeDesktop: 24,
//             ultraWide: 26,
//           ),
//           fontWeight: FontWeight.bold,
//           color: Color(0xff00233B),
//         ),
//       ),
//
//       const SizedBox(height: 24),
//
//       // Available Certification Cards
//       _buildAvailableCertificationCard(
//         'Leadership\nExcellence',
//         'Long-term objective setting and planning',
//         Icons.military_tech,
//       ),
//
//       const SizedBox(height: 16),
//
//       _buildAvailableCertificationCard(
//         'Stakeholder\nManagement',
//         'Effective communication and relationship',
//         Icons.groups,
//       ),
//     ],
//   );
//
//   Widget _buildAvailableCertificationCard(
//       String title,
//       String description,
//       IconData icon,
//       ) => Container(
//     padding:  EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       border: Border.all(color: Color(0xffD7D7D7)),
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(12),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.05),
//           blurRadius: 8,
//           offset: const Offset(0, 2),
//         ),
//       ],
//     ),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: const BoxDecoration(
//             color: Color(0xFFD32F2F),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(icon, color: Colors.white, size: 20),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: getResponsiveFont(
//                         mobile: 16,
//                         tablet: 18,
//                         desktop: 20,
//                         largeDesktop: 22,
//                         ultraWide: 24,
//                       ),
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xff00233B),
//
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 8,
//                     ),
//                     decoration: BoxDecoration(
//                       color: const Color(0xff24387F),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       'Start',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: getResponsiveFont(
//                           mobile: 12,
//                           tablet: 14,
//                           desktop: 16,
//                           largeDesktop: 18,
//                           ultraWide: 20,
//                         ),
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 description,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   fontSize: getResponsiveFont(
//                     mobile: 12,
//                     tablet: 13,
//                     desktop: 14,
//                     largeDesktop: 15,
//                     ultraWide: 16,
//                   ),
//                   color: Color(0xff00233B),
//
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
// enum DeviceType { mobile, tablet, desktop, largeDesktop, ultraWide }