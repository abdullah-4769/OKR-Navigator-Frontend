
// lib/presentation/views/game_result_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/app_colors.dart';
import '../../../generated/models/requests/challange_mode/challenge_mode_request_model.dart';
import '../../../view_model/challange_view_models/challenge_mode_view_score_model.dart';
import '../../widgets/custom_circular_avatar.dart';
import '../../widgets/custom_curved_arrow.dart';
import '../../widgets/custom_home_navbar.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';

// Add ViewStatus enum here since it's missing
enum ViewStatus { idle, loading, completed, error }

class GameResultScreen extends StatelessWidget {
  const GameResultScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            return _ResponsiveGameResult(
              constraints: constraints,
              orientation: orientation,
            );
          },
        );
      },
    ),
  );
}

class _ResponsiveGameResult extends StatelessWidget {
  final BoxConstraints constraints;
  final Orientation orientation;

  const _ResponsiveGameResult({
    required this.constraints,
    required this.orientation,
  });

  double get screenWidth => constraints.maxWidth;
  double get screenHeight => constraints.maxHeight;

  DeviceType get deviceType {
    if (screenWidth < 600) return DeviceType.mobile;
    if (screenWidth >= 600 && screenWidth < 900) return DeviceType.tablet;
    if (screenWidth >= 900 && screenWidth < 1200) return DeviceType.desktop;
    if (screenWidth >= 1200 && screenWidth < 1920) return DeviceType.largeDesktop;
    return DeviceType.ultraWide;
  }

  bool get isDesktop =>
      deviceType == DeviceType.desktop ||
          deviceType == DeviceType.largeDesktop ||
          deviceType == DeviceType.ultraWide;

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

  @override
  Widget build(BuildContext context) {
    final vm = Get.put(GameResultViewModel());

    return SafeArea(
      child: Obx(() {
        // Handle loading state
        if (vm.status.value == ViewStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handle error state
        if (vm.status.value == ViewStatus.error || !vm.isValidChallenge.value) {
          return _buildErrorState(vm);
        }

        // Handle completed state with validation
        final model = vm.model.value;
        if (model == null || model.results.isEmpty) {
          return _buildNoResultsState(vm);
        }

        // Validate user participation
        if (!vm.isUserInChallenge) {
          return _buildNotInChallengeState(vm);
        }

        // Validate player count
        if (!vm.hasValidPlayerCount) {
          return _buildInvalidPlayerCountState(vm, model.results.length);
        }

        // Show results
        return _buildResultsUI(vm, model);
      }),
    );
  }

  Widget _buildErrorState(GameResultViewModel vm) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text(
                'Unable to Load Results',
                style: TextStyle(fontSize: 18.sp, color: Colors.red, fontWeight: FontWeight.bold)
            ),
            SizedBox(height: 8.h),
            Text(
              vm.message.value,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: vm.fetchResult,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
            SizedBox(height: 8.h),
            TextButton(
              onPressed: () => Get.offAllNamed('/home'),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotInChallengeState(GameResultViewModel vm) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_off, size: 48.sp, color: Colors.orange),
            SizedBox(height: 16.h),
            Text(
                'Not Participating',
                style: TextStyle(fontSize: 18.sp, color: Colors.orange, fontWeight: FontWeight.bold)
            ),
            SizedBox(height: 8.h),
            const Text(
              'You are not participating in this challenge or the challenge has ended.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () => Get.offAllNamed('/challenges'),
              child: const Text('Browse Challenges'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvalidPlayerCountState(GameResultViewModel vm, int playerCount) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.group_off, size: 48.sp, color: Colors.orange),
            SizedBox(height: 16.h),
            Text(
                'Invalid Challenge',
                style: TextStyle(fontSize: 18.sp, color: Colors.orange, fontWeight: FontWeight.bold)
            ),
            SizedBox(height: 8.h),
            Text(
              'This challenge has $playerCount players. Only challenges with 1-2 players are supported.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () => Get.offAllNamed('/challenges'),
              child: const Text('Find Another Challenge'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState(GameResultViewModel vm) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox, size: 48.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
                'No Results Available',
                style: TextStyle(fontSize: 18.sp, color: Colors.grey, fontWeight: FontWeight.bold)
            ),
            SizedBox(height: 8.h),
            const Text('No challenge results found for this user.'),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: vm.fetchResult,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsUI(GameResultViewModel vm, ChallengeModeScoreModel model) {
    final primary = vm.primaryPlayer!;
    final opponent = vm.opponents.isNotEmpty ? vm.opponents.first : null;

    return Stack(
      children: [
        SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: isDesktop ? 600 : double.infinity),
              padding: EdgeInsets.symmetric(
                vertical: getResponsiveSpacing(mobile: 20, tablet: 24, desktop: 28, largeDesktop: 32, ultraWide: 36),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomHeader(
                    title: 'Challenge',
                    highlightedText: 'Game Results',
                    onBackTap: () { Get.back(); },
                  ),
                  SizedBox(height: getResponsiveSpacing(mobile: 12, tablet: 14, desktop: 18, largeDesktop: 20, ultraWide: 24)),
                  _buildCelebrationSection(),
                  SizedBox(height: getResponsiveSpacing(mobile: 12, tablet: 14, desktop: 16, largeDesktop: 18, ultraWide: 20)),
                  _buildTitleSection(),
                  SizedBox(height: getResponsiveSpacing(mobile: 12, tablet: 14, desktop: 16, largeDesktop: 18, ultraWide: 20)),
                  _buildScoreSection(primary, opponent),
                  SizedBox(height: getResponsiveSpacing(mobile: 12, tablet: 14, desktop: 16, largeDesktop: 18, ultraWide: 20)),
                  _buildDetailsSection(primary, opponent),
                  SizedBox(height: getResponsiveSpacing(mobile: 40, tablet: 50, desktop: 60, largeDesktop: 70, ultraWide: 80)), // Extra space for navbar
                ],
              ),
            ),
          ),
        ),

        // Responsive Home NavBar positioned using MediaQuery
        Positioned(
          right: screenWidth * -0.07, // Use screenWidth from MediaQuery
          top: screenHeight * 0.4, // Use screenHeight from MediaQuery
          child: const CustomHomeNavBar(),
        ),
      ],
    );
  }

  Widget _buildCelebrationSection() {
    return Container(
      padding: EdgeInsets.all(getResponsiveSpacing(mobile: 16, tablet: 18, desktop: 20, largeDesktop: 24, ultraWide: 28)),
      decoration: const BoxDecoration(color: Color(0xffFFEEEA), shape: BoxShape.circle),
      child: Text(
          '🎉',
          style: TextStyle(fontSize: getResponsiveFont(
              mobile: 36, tablet: 40, desktop: 48, largeDesktop: 56, ultraWide: 64
          ))
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      children: [
        Text(
          'Victory!',
          style: TextStyle(
              fontSize: getResponsiveFont(mobile: 20, tablet: 22, desktop: 26, largeDesktop: 30, ultraWide: 34),
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: getResponsiveSpacing(mobile: 6, tablet: 8, desktop: 10, largeDesktop: 12, ultraWide: 14)),
        Text(
          'Challenge results',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildScoreSection(ChallengeModeScoreResult primary, ChallengeModeScoreResult? opponent) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(getResponsiveSpacing(mobile: 12, tablet: 14, desktop: 16, largeDesktop: 18, ultraWide: 20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _playerScoreCard(primary, isWinner: primary.score >= (opponent?.score ?? 0)),
          _playerScoreCard(opponent, isWinner: opponent != null && (opponent.score > primary.score)),
        ],
      ),
    );
  }

  Widget _playerScoreCard(ChallengeModeScoreResult? player, {required bool isWinner}) {
    if (player == null) {
      return Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'No player',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: getResponsiveFont(
                    mobile: 12, tablet: 14, desktop: 16, largeDesktop: 18, ultraWide: 20
                ),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.h),
            Text(
              '-',
              style: TextStyle(
                fontSize: getResponsiveFont(
                    mobile: 14, tablet: 16, desktop: 18, largeDesktop: 20, ultraWide: 22
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isWinner ? const Color(0xffFFC107) : Colors.grey.shade400,
                width: 3,
              ),
            ),
            child: CircleAvatar(
              radius: getResponsiveSpacing(
                  mobile: 30, tablet: 35, desktop: 40, largeDesktop: 45, ultraWide: 50
              ),
              backgroundImage: const AssetImage('assets/images/solo_image.png'),
              backgroundColor: Colors.grey.shade200,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: getResponsiveSpacing(mobile: 8, tablet: 10, desktop: 12, largeDesktop: 14, ultraWide: 16),
              vertical: getResponsiveSpacing(mobile: 6, tablet: 7, desktop: 8, largeDesktop: 9, ultraWide: 10),
            ),
            constraints: BoxConstraints(
              minWidth: getResponsiveSpacing(mobile: 40, tablet: 50, desktop: 60, largeDesktop: 70, ultraWide: 80),
            ),
            decoration: BoxDecoration(
              color: isWinner ? const Color(0xffFFC107) : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              player.score.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: getResponsiveFont(
                    mobile: 14, tablet: 16, desktop: 18, largeDesktop: 20, ultraWide: 22
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            player.name,
            style: TextStyle(
              fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
              fontSize: getResponsiveFont(
                  mobile: 12, tablet: 14, desktop: 16, largeDesktop: 18, ultraWide: 20
              ),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            player.position,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: getResponsiveFont(
                  mobile: 10, tablet: 12, desktop: 14, largeDesktop: 16, ultraWide: 18
              ),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(ChallengeModeScoreResult? primary, ChallengeModeScoreResult? opponent) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(color: const Color(0xffDFDFDF))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Breakdown',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: getResponsiveFont(
                  mobile: 16, tablet: 18, desktop: 20, largeDesktop: 22, ultraWide: 24
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (primary != null) ...[
            _buildPerformanceRow('Alignment Strategy', primary.alignmentStrategy),
            _buildPerformanceRow('Objective Clarity', primary.objectiveClarity),
            _buildPerformanceRow('Key Result Quality', primary.keyResultQuality),
            _buildPerformanceRow('Initiative Relevance', primary.initiativeRelevance),
            _buildPerformanceRow('Challenge Adoption', primary.challengeAdoption),
            if ((primary.keyResultQualityLog ?? '').isNotEmpty)
              _buildPerformanceNotes(primary.keyResultQualityLog!),
          ],
          const SizedBox(height: 12),
          if (opponent != null) ...[
            Divider(color: Colors.grey.shade300),
            Text(
              'Opponent Performance',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: getResponsiveFont(
                    mobile: 14, tablet: 16, desktop: 18, largeDesktop: 20, ultraWide: 22
                ),
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8.h),
            Text('Score: ${opponent.score}'),
            Text('Position: ${opponent.position}'),
          ],
        ],
      ),
    );
  }

  Widget _buildPerformanceRow(String label, double? value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: getResponsiveFont(
                    mobile: 12, tablet: 14, desktop: 16, largeDesktop: 18, ultraWide: 20
                ),
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value?.toStringAsFixed(1) ?? '-',
              style: TextStyle(
                fontSize: getResponsiveFont(
                    mobile: 12, tablet: 14, desktop: 16, largeDesktop: 18, ultraWide: 20
                ),
                fontWeight: FontWeight.w600,
                color: _getScoreColor(value),
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceNotes(String notes) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Key Result Notes:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: getResponsiveFont(
                  mobile: 12, tablet: 14, desktop: 16, largeDesktop: 18, ultraWide: 20
              ),
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            notes,
            style: TextStyle(
              fontSize: getResponsiveFont(
                  mobile: 11, tablet: 13, desktop: 15, largeDesktop: 17, ultraWide: 19
              ),
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double? score) {
    if (score == null) return Colors.grey;
    if (score >= 8.0) return Colors.green;
    if (score >= 6.0) return Colors.orange;
    return Colors.red;
  }
}

enum DeviceType { mobile, tablet, desktop, largeDesktop, ultraWide }



// // lib/presentation/views/game_result_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../../../core/app_colors.dart';
// import '../../../generated/models/requests/challange_mode/challenge_mode_request_model.dart';
// import '../../../view_model/challange_view_models/challenge_mode_view_score_model.dart';
// import '../../widgets/custom_circular_avatar.dart';
// import '../../widgets/custom_curved_arrow.dart';
// import '../../widgets/custom_home_navbar.dart';
// import '../../widgets/screens_unique_parts/custom_header.dart';
//
// // Add ViewStatus enum here since it's missing
// enum ViewStatus { idle, loading, completed, error }
//
// class GameResultScreen extends StatelessWidget {
//   const GameResultScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     backgroundColor: Colors.white,
//     body: LayoutBuilder(
//       builder: (context, constraints) {
//         return OrientationBuilder(
//           builder: (context, orientation) {
//             return _ResponsiveGameResult(
//               constraints: constraints,
//               orientation: orientation,
//             );
//           },
//         );
//       },
//     ),
//   );
// }
//
// class _ResponsiveGameResult extends StatelessWidget {
//   final BoxConstraints constraints;
//   final Orientation orientation;
//
//   const _ResponsiveGameResult({
//     required this.constraints,
//     required this.orientation,
//   });
//
//   double get screenWidth => constraints.maxWidth;
//   double get screenHeight => constraints.maxHeight;
//
//   DeviceType get deviceType {
//     if (screenWidth < 600) return DeviceType.mobile;
//     if (screenWidth >= 600 && screenWidth < 900) return DeviceType.tablet;
//     if (screenWidth >= 900 && screenWidth < 1200) return DeviceType.desktop;
//     if (screenWidth >= 1200 && screenWidth < 1920) return DeviceType.largeDesktop;
//     return DeviceType.ultraWide;
//   }
//
//   bool get isDesktop =>
//       deviceType == DeviceType.desktop ||
//           deviceType == DeviceType.largeDesktop ||
//           deviceType == DeviceType.ultraWide;
//
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
//   @override
//   Widget build(BuildContext context) {
//     final vm = Get.put(GameResultViewModel());
//
//     return SafeArea(
//       child: Obx(() {
//         // Handle loading state - FIXED: Use vm.status.value instead of undefined 'stat'
//         if (vm.status.value == ViewStatus.loading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         // Handle error state
//         if (vm.status.value == ViewStatus.error || !vm.isValidChallenge.value) {
//           return _buildErrorState(vm);
//         }
//
//         // Handle completed state with validation
//         final model = vm.model.value;
//         if (model == null || model.results.isEmpty) {
//           return _buildNoResultsState(vm);
//         }
//
//         // Validate user participation
//         if (!vm.isUserInChallenge) {
//           return _buildNotInChallengeState(vm);
//         }
//
//         // Validate player count
//         if (!vm.hasValidPlayerCount) {
//           return _buildInvalidPlayerCountState(vm, model.results.length);
//         }
//
//         // Show results
//         return _buildResultsUI(vm, model);
//       }),
//     );
//   }
//
//   Widget _buildErrorState(GameResultViewModel vm) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.error_outline, size: 48.sp, color: Colors.red),
//             SizedBox(height: 16.h),
//             Text(
//                 'Unable to Load Results',
//                 style: TextStyle(fontSize: 18.sp, color: Colors.red, fontWeight: FontWeight.bold)
//             ),
//             SizedBox(height: 8.h),
//             Text(
//               vm.message.value,
//               style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 16.h),
//             ElevatedButton(
//               onPressed: vm.fetchResult,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primaryRed,
//                 foregroundColor: Colors.white,
//               ),
//               child: const Text('Retry'),
//             ),
//             SizedBox(height: 8.h),
//             TextButton(
//               onPressed: () => Get.offAllNamed('/home'),
//               child: const Text('Go to Home'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNotInChallengeState(GameResultViewModel vm) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.person_off, size: 48.sp, color: Colors.orange),
//             SizedBox(height: 16.h),
//             Text(
//                 'Not Participating',
//                 style: TextStyle(fontSize: 18.sp, color: Colors.orange, fontWeight: FontWeight.bold)
//             ),
//             SizedBox(height: 8.h),
//             const Text(
//               'You are not participating in this challenge or the challenge has ended.',
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 16.h),
//             TextButton(
//               onPressed: () => Get.offAllNamed('/challenges'),
//               child: const Text('Browse Challenges'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInvalidPlayerCountState(GameResultViewModel vm, int playerCount) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.group_off, size: 48.sp, color: Colors.orange),
//             SizedBox(height: 16.h),
//             Text(
//                 'Invalid Challenge',
//                 style: TextStyle(fontSize: 18.sp, color: Colors.orange, fontWeight: FontWeight.bold)
//             ),
//             SizedBox(height: 8.h),
//             Text(
//               'This challenge has $playerCount players. Only challenges with 1-2 players are supported.',
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 16.h),
//             TextButton(
//               onPressed: () => Get.offAllNamed('/challenges'),
//               child: const Text('Find Another Challenge'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNoResultsState(GameResultViewModel vm) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(Icons.inbox, size: 48.sp, color: Colors.grey),
//             SizedBox(height: 16.h),
//             Text(
//                 'No Results Available',
//                 style: TextStyle(fontSize: 18.sp, color: Colors.grey, fontWeight: FontWeight.bold)
//             ),
//             SizedBox(height: 8.h),
//             const Text('No challenge results found for this user.'),
//             SizedBox(height: 16.h),
//             ElevatedButton(
//               onPressed: vm.fetchResult,
//               child: const Text('Retry'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildResultsUI(GameResultViewModel vm, ChallengeModeScoreModel model) {
//     final primary = vm.primaryPlayer!;
//     final opponent = vm.opponents.isNotEmpty ? vm.opponents.first : null;
//
//     return SingleChildScrollView(
//       child: Center(
//         child: Container(
//           constraints: BoxConstraints(maxWidth: isDesktop ? 600 : double.infinity),
//           padding: EdgeInsets.symmetric(
//             vertical: getResponsiveSpacing(mobile: 20, tablet: 24, desktop: 28, largeDesktop: 32, ultraWide: 36),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               CustomHeader(title: 'Challenge',
//               highlightedText: 'Game Results',
//               onBackTap: () { Get.back(); },),
//              // _buildHeaderRow(),
//               SizedBox(height: getResponsiveSpacing(mobile: 12, tablet: 14, desktop: 18, largeDesktop: 20, ultraWide: 24)),
//               _buildCelebrationSection(),
//               SizedBox(height: getResponsiveSpacing(mobile: 12, tablet: 14, desktop: 16, largeDesktop: 18, ultraWide: 20)),
//               _buildTitleSection(),
//               SizedBox(height: getResponsiveSpacing(mobile: 12, tablet: 14, desktop: 16, largeDesktop: 18, ultraWide: 20)),
//               _buildScoreSection(primary, opponent),
//               SizedBox(height: getResponsiveSpacing(mobile: 12, tablet: 14, desktop: 16, largeDesktop: 18, ultraWide: 20)),
//               _buildDetailsSection(primary, opponent),
//               SizedBox(height: getResponsiveSpacing(mobile: 12, tablet: 14, desktop: 16, largeDesktop: 18, ultraWide: 20)),
//               Positioned(
//                 right: width * -0.07,
//                 top: height * 0.4,
//                 child: const CustomHomeNavBar(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   //
//   // Widget _buildHeaderRow() {
//   //   return Row(
//   //     children: [
//   //       CustomCurvedArrow(
//   //           isLeft: true,
//   //           onTap: () => Get.back(),
//   //           width: 50,
//   //           height: 120
//   //       ),
//   //       Expanded(
//   //         child: Image.asset(
//   //           'assets/images/game_result.png',
//   //           height: 80,
//   //           fit: BoxFit.contain,
//   //         ),
//   //       ),
//   //       // Padding(
//   //       //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//   //       //   child: CustomCircularAvatar(
//   //       //     imagePath: 'assets/images/solo_image.png',
//   //       //     size: 50,
//   //       //     innerColors: [
//   //       //       AppColors.softRed.withOpacity(0.5),
//   //       //       AppColors.softRed.withOpacity(0.5),
//   //       //     ],
//   //       //     borderGradient: [AppColors.primaryRed, AppColors.primaryRed.withOpacity(0.5)],
//   //       //   ),
//   //       // )
//   //     ],
//   //   );
//   // }
//
//   Widget _buildCelebrationSection() {
//     return Container(
//       padding: EdgeInsets.all(getResponsiveSpacing(mobile: 16, tablet: 18, desktop: 20, largeDesktop: 24, ultraWide: 28)),
//       decoration: const BoxDecoration(color: Color(0xffFFEEEA), shape: BoxShape.circle),
//       child: Text(
//           '🎉',
//           style: TextStyle(fontSize: getResponsiveFont(
//               mobile: 36, tablet: 40, desktop: 48, largeDesktop: 56, ultraWide: 64
//           ))
//       ),
//     );
//   }
//
//   Widget _buildTitleSection() {
//     return Column(
//       children: [
//         Text(
//           'Victory!',
//           style: TextStyle(
//               fontSize: getResponsiveFont(mobile: 20, tablet: 22, desktop: 26, largeDesktop: 30, ultraWide: 34),
//               fontWeight: FontWeight.bold
//           ),
//         ),
//         SizedBox(height: getResponsiveSpacing(mobile: 6, tablet: 8, desktop: 10, largeDesktop: 12, ultraWide: 14)),
//         Text(
//           'Challenge results',
//           style: TextStyle(color: Colors.grey.shade600),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildScoreSection(ChallengeModeScoreResult primary, ChallengeModeScoreResult? opponent) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: EdgeInsets.all(getResponsiveSpacing(mobile: 12, tablet: 14, desktop: 16, largeDesktop: 18, ultraWide: 20)),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           _playerScoreCard(primary, isWinner: primary.score >= (opponent?.score ?? 0)),
//           _playerScoreCard(opponent, isWinner: opponent != null && (opponent.score > primary.score)),
//         ],
//       ),
//     );
//   }
//
//   Widget _playerScoreCard(ChallengeModeScoreResult? player, {required bool isWinner}) {
//     if (player == null) {
//       return Expanded(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'No player',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: getResponsiveFont(
//                     mobile: 12, tablet: 14, desktop: 16, largeDesktop: 18, ultraWide: 20
//                 ),
//               ),
//               textAlign: TextAlign.center,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//             SizedBox(height: 8.h),
//             Text(
//               '-',
//               style: TextStyle(
//                 fontSize: getResponsiveFont(
//                     mobile: 14, tablet: 16, desktop: 18, largeDesktop: 20, ultraWide: 22
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     return Expanded(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(4),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(
//                 color: isWinner ? const Color(0xffFFC107) : Colors.grey.shade400,
//                 width: 3,
//               ),
//             ),
//             child: CircleAvatar(
//               radius: getResponsiveSpacing(
//                   mobile: 30, tablet: 35, desktop: 40, largeDesktop: 45, ultraWide: 50
//               ),
//               backgroundImage: const AssetImage('assets/images/solo_image.png'),
//               backgroundColor: Colors.grey.shade200,
//             ),
//           ),
//           SizedBox(height: 8.h),
//           Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: getResponsiveSpacing(mobile: 8, tablet: 10, desktop: 12, largeDesktop: 14, ultraWide: 16),
//               vertical: getResponsiveSpacing(mobile: 6, tablet: 7, desktop: 8, largeDesktop: 9, ultraWide: 10),
//             ),
//             constraints: BoxConstraints(
//               minWidth: getResponsiveSpacing(mobile: 40, tablet: 50, desktop: 60, largeDesktop: 70, ultraWide: 80),
//             ),
//             decoration: BoxDecoration(
//               color: isWinner ? const Color(0xffFFC107) : Colors.grey.shade300,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Text(
//               player.score.toString(),
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: getResponsiveFont(
//                     mobile: 14, tablet: 16, desktop: 18, largeDesktop: 20, ultraWide: 22
//                 ),
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           SizedBox(height: 8.h),
//           Text(
//             player.name,
//             style: TextStyle(
//               fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
//               fontSize: getResponsiveFont(
//                   mobile: 12, tablet: 14, desktop: 16, largeDesktop: 18, ultraWide: 20
//               ),
//             ),
//             textAlign: TextAlign.center,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           SizedBox(height: 4.h),
//           Text(
//             player.position,
//             style: TextStyle(
//               color: Colors.grey.shade600,
//               fontSize: getResponsiveFont(
//                   mobile: 10, tablet: 12, desktop: 14, largeDesktop: 16, ultraWide: 18
//               ),
//             ),
//             textAlign: TextAlign.center,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDetailsSection(ChallengeModeScoreResult? primary, ChallengeModeScoreResult? opponent) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           color: Colors.white,
//           border: Border.all(color: const Color(0xffDFDFDF))
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Performance Breakdown',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: getResponsiveFont(
//                   mobile: 16, tablet: 18, desktop: 20, largeDesktop: 22, ultraWide: 24
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),
//           if (primary != null) ...[
//             _buildPerformanceRow('Alignment Strategy', primary.alignmentStrategy),
//             _buildPerformanceRow('Objective Clarity', primary.objectiveClarity),
//             _buildPerformanceRow('Key Result Quality', primary.keyResultQuality),
//             _buildPerformanceRow('Initiative Relevance', primary.initiativeRelevance),
//             _buildPerformanceRow('Challenge Adoption', primary.challengeAdoption),
//             if ((primary.keyResultQualityLog ?? '').isNotEmpty)
//               _buildPerformanceNotes(primary.keyResultQualityLog!),
//           ],
//           const SizedBox(height: 12),
//           if (opponent != null) ...[
//             Divider(color: Colors.grey.shade300),
//             Text(
//               'Opponent Performance',
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: getResponsiveFont(
//                     mobile: 14, tablet: 16, desktop: 18, largeDesktop: 20, ultraWide: 22
//                 ),
//                 color: Colors.grey.shade700,
//               ),
//             ),
//             SizedBox(height: 8.h),
//             Text('Score: ${opponent.score}'),
//             Text('Position: ${opponent.position}'),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPerformanceRow(String label, double? value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 4.h),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               '$label:',
//               style: TextStyle(
//                 fontSize: getResponsiveFont(
//                     mobile: 12, tablet: 14, desktop: 16, largeDesktop: 18, ultraWide: 20
//                 ),
//                 color: Colors.grey.shade700,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Text(
//               value?.toStringAsFixed(1) ?? '-',
//               style: TextStyle(
//                 fontSize: getResponsiveFont(
//                     mobile: 12, tablet: 14, desktop: 16, largeDesktop: 18, ultraWide: 20
//                 ),
//                 fontWeight: FontWeight.w600,
//                 color: _getScoreColor(value),
//               ),
//               textAlign: TextAlign.right,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPerformanceNotes(String notes) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Key Result Notes:',
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: getResponsiveFont(
//                   mobile: 12, tablet: 14, desktop: 16, largeDesktop: 18, ultraWide: 20
//               ),
//               color: Colors.grey.shade700,
//             ),
//           ),
//           SizedBox(height: 4.h),
//           Text(
//             notes,
//             style: TextStyle(
//               fontSize: getResponsiveFont(
//                   mobile: 11, tablet: 13, desktop: 15, largeDesktop: 17, ultraWide: 19
//               ),
//               color: Colors.grey.shade600,
//               fontStyle: FontStyle.italic,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Color _getScoreColor(double? score) {
//     if (score == null) return Colors.grey;
//     if (score >= 8.0) return Colors.green;
//     if (score >= 6.0) return Colors.orange;
//     return Colors.red;
//   }
// }
//
// enum DeviceType { mobile, tablet, desktop, largeDesktop, ultraWide }
//


// // lib/presentation/views/game_result_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:game_app/core/app_colors.dart';
// import 'package:game_app/generated/models/responses/challenge_mode/challenge_mode_response_model.dart';
// import 'package:game_app/services/shared_preference.dart';
// import '../../../repository/challange_repositories/challenge_mode_repository.dart';
// import '../../widgets/custom_circular_avatar.dart';
// import '../../widgets/custom_curved_arrow.dart';
// import '../../widgets/custom_home_navbar.dart';
// import '../../widgets/screens_unique_parts/custom_background.dart';
// import '../../widgets/screens_unique_parts/custom_header.dart';
// import 'certificate_screen.dart';
//
// class GameResultScreen extends StatelessWidget {
//   const GameResultScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     backgroundColor: Colors.white,
//     body: LayoutBuilder(
//       builder: (context, constraints) {
//         return OrientationBuilder(
//           builder: (context, orientation) {
//             return _ResponsiveGameResult(
//               constraints: constraints,
//               orientation: orientation,
//             );
//           },
//         );
//       },
//     ),
//   );
// }
//
// class _ResponsiveGameResult extends StatelessWidget {
//   final BoxConstraints constraints;
//   final Orientation orientation;
//
//   const _ResponsiveGameResult({
//     required this.constraints,
//     required this.orientation,
//   });
//
//   double get screenWidth => constraints.maxWidth;
//   double get screenHeight => constraints.maxHeight;
//
//   DeviceType get deviceType {
//     if (screenWidth < 600) return DeviceType.mobile;
//     if (screenWidth >= 600 && screenWidth < 900) return DeviceType.tablet;
//     if (screenWidth >= 900 && screenWidth < 1200) return DeviceType.desktop;
//     if (screenWidth >= 1200 && screenWidth < 1920) return DeviceType.largeDesktop;
//     return DeviceType.ultraWide;
//   }
//
//   bool get isPortrait => orientation == Orientation.portrait;
//   bool get isMobile => deviceType == DeviceType.mobile;
//   bool get isWeb => deviceType == DeviceType.largeDesktop || deviceType == DeviceType.ultraWide;
//
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
//   Widget build(BuildContext context) {
//     final ChallengeModeScoreRepository scoreRepo = Get.put(ChallengeModeScoreRepository());
//     // Get challengeId from SharedPrefs or arguments
//     return FutureBuilder<String?>(
//       future: SharedPrefs.getChallengeId(),
//       builder: (context, challengeIdSnapshot) {
//         if (challengeIdSnapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         final challengeId = int.tryParse(challengeIdSnapshot.data ?? '0') ?? 0;
//
//         return SafeArea(
//           child: CustomBackground(
//             child: SingleChildScrollView(
//               child: Center(
//                 child: Container(
//                   constraints: BoxConstraints(
//                     maxWidth: isWeb ? 500 : double.infinity,
//                   ),
//                   padding: EdgeInsets.symmetric(
//                     vertical: getResponsiveSpacing(
//                       mobile: 20,
//                       tablet: 24,
//                       desktop: 28,
//                       largeDesktop: 32,
//                       ultraWide: 36,
//                     ),
//                   ),
//                   child: FutureBuilder<List<ChallengeModeScoreResponse>>(
//                     future: scoreRepo.getChallengeScoresByChallenge(challengeId),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(child: CircularProgressIndicator());
//                       }
//                       if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
//                         return const Center(child: Text('No scores available'));
//                       }
//
//                       final scores = snapshot.data!;
//                       final userId = SharedPrefs.getUserId() ?? '';
//                       // Sort scores to determine winner (highest score first)
//                       scores.sort((a, b) => b.score.compareTo(a.score));
//                       final player1 = scores[0]; // Highest score (winner)
//                       final player2 = scores.length > 1 ? scores[1] : null; // Second player
//                       final isUserWinner = player1.userId == userId;
//
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           CustomHeader(
//                             title: "Game",
//                             highlightedText: "Result",
//                             onBackTap: () => Get.back(),
//                           ),
//                           SizedBox(
//                             height: getResponsiveSpacing(
//                               mobile: 20,
//                               tablet: 25,
//                               desktop: 30,
//                               largeDesktop: 35,
//                               ultraWide: 40,
//                             ),
//                           ),
//                           _buildVictoryCelebration(isUserWinner),
//                           SizedBox(
//                             height: getResponsiveSpacing(
//                               mobile: 20,
//                               tablet: 25,
//                               desktop: 30,
//                               largeDesktop: 35,
//                               ultraWide: 40,
//                             ),
//                           ),
//                           Stack(
//                             clipBehavior: Clip.none,
//                             children: [
//                               _buildScoreSection(
//                                 player1: player1,
//                                 player2: player2,
//                                 userId: userId,
//                               ),
//                               Positioned(
//                                 top: 60,
//                                 right: -40,
//                                 child: ConstrainedBox(
//                                   constraints: BoxConstraints(
//                                     maxWidth: screenWidth * 0.5,
//                                   ),
//                                   child: const CustomHomeNavBar(),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: getResponsiveSpacing(
//                               mobile: 25,
//                               tablet: 30,
//                               desktop: 35,
//                               largeDesktop: 40,
//                               ultraWide: 45,
//                             ),
//                           ),
//                           _buildPointsBreakdown(player1, userId),
//                           SizedBox(
//                             height: getResponsiveSpacing(
//                               mobile: 25,
//                               tablet: 30,
//                               desktop: 35,
//                               largeDesktop: 40,
//                               ultraWide: 45,
//                             ),
//                           ),
//                           _buildMatchDetails(),
//                           SizedBox(
//                             height: getResponsiveSpacing(
//                               mobile: 25,
//                               tablet: 30,
//                               desktop: 35,
//                               largeDesktop: 40,
//                               ultraWide: 45,
//                             ),
//                           ),
//                           _buildPerformanceFeedback(player1, userId),
//                           SizedBox(
//                             height: getResponsiveSpacing(
//                               mobile: 30,
//                               tablet: 35,
//                               desktop: 40,
//                               largeDesktop: 45,
//                               ultraWide: 50,
//                             ),
//                           ),
//                           _buildActionButtons(context),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildVictoryCelebration(bool isUserWinner) => Column(
//     children: [
//       Container(
//         padding: EdgeInsets.all(getResponsiveSpacing(
//           mobile: 30,
//           tablet: 35,
//           desktop: 40,
//           largeDesktop: 45,
//           ultraWide: 50,
//         )),
//         decoration: const BoxDecoration(
//           color: Color(0xffFFEEEA),
//           shape: BoxShape.circle,
//         ),
//         child: Text(
//           '🎉',
//           style: TextStyle(
//             fontSize: getResponsiveFont(
//               mobile: 50,
//               tablet: 60,
//               desktop: 70,
//               largeDesktop: 80,
//               ultraWide: 90,
//             ),
//           ),
//         ),
//       ),
//       SizedBox(
//         height: getResponsiveSpacing(
//           mobile: 16,
//           tablet: 20,
//           desktop: 24,
//           largeDesktop: 28,
//           ultraWide: 32,
//         ),
//       ),
//       Text(
//         isUserWinner ? 'Victory!' : 'Better Luck Next Time!',
//         style: TextStyle(
//           fontSize: getResponsiveFont(
//             mobile: 28,
//             tablet: 32,
//             desktop: 36,
//             largeDesktop: 40,
//             ultraWide: 44,
//           ),
//           fontWeight: FontWeight.bold,
//           color: Colors.black87,
//           fontFamily: 'Gotham-Bold',
//         ),
//       ),
//       SizedBox(
//         height: getResponsiveSpacing(
//           mobile: 8,
//           tablet: 10,
//           desktop: 12,
//           largeDesktop: 14,
//           ultraWide: 16,
//         ),
//       ),
//       Text(
//         isUserWinner ? 'You won the OKR challenge' : 'You didn\'t win this time',
//         style: TextStyle(
//           fontSize: getResponsiveFont(
//             mobile: 14,
//             tablet: 16,
//             desktop: 18,
//             largeDesktop: 20,
//             ultraWide: 22,
//           ),
//           color: Colors.grey.shade600,
//         ),
//       ),
//     ],
//   );
//
//   Widget _buildScoreSection({
//     required ChallengeModeScoreResponse player1,
//     ChallengeModeScoreResponse? player2,
//     required String userId,
//   }) => Container(
//     margin: const EdgeInsets.symmetric(horizontal: 16),
//     padding: EdgeInsets.all(getResponsiveSpacing(
//       mobile: 20,
//       tablet: 24,
//       desktop: 28,
//       largeDesktop: 32,
//       ultraWide: 36,
//     )),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(20),
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         _buildPlayerScore(
//           imagePath: player2?.userId == userId ? 'assets/images/solo_image.png' : 'assets/images/opponent_image.png',
//           score: player2?.score.toString() ?? '0',
//           name: player2?.userId == userId ? 'You' : player2?.title ?? 'Opponent',
//           backgroundColor: Colors.grey.shade300,
//           isWinner: false,
//         ),
//         _buildPlayerScore(
//           imagePath: player1.userId == userId ? 'assets/images/solo_image.png' : 'assets/images/opponent_image.png',
//           score: player1.score.toString(),
//           name: player1.userId == userId ? 'You' : player1.title,
//           backgroundColor: const Color(0xffFFC107),
//           isWinner: true,
//         ),
//       ],
//     ),
//   );
//
//   Widget _buildPlayerScore({
//     required String imagePath,
//     required String score,
//     required String name,
//     required Color backgroundColor,
//     required bool isWinner,
//   }) => Column(
//     children: [
//       Container(
//         padding: const EdgeInsets.all(4),
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           border: Border.all(
//             color: isWinner ? const Color(0xffFFC107) : Colors.grey.shade400,
//             width: 3,
//           ),
//         ),
//         child: CircleAvatar(
//           radius: getResponsiveWidth(
//             mobile: isWinner ? 50 : 35,
//             tablet: isWinner ? 60 : 40,
//             desktop: isWinner ? 70 : 45,
//             largeDesktop: isWinner ? 80 : 50,
//             ultraWide: isWinner ? 90 : 55,
//           ),
//           backgroundImage: AssetImage(imagePath),
//           backgroundColor: Colors.grey.shade200,
//         ),
//       ),
//       SizedBox(
//         height: getResponsiveSpacing(
//           mobile: isWinner ? 16 : 12,
//           tablet: isWinner ? 18 : 14,
//           desktop: isWinner ? 20 : 16,
//           largeDesktop: isWinner ? 22 : 18,
//           ultraWide: isWinner ? 24 : 20,
//         ),
//       ),
//       Container(
//         height: isWinner ? 60 : 40,
//         padding: EdgeInsets.symmetric(
//           horizontal: getResponsiveWidth(
//             mobile: isWinner ? 24 : 20,
//             tablet: isWinner ? 28 : 24,
//             desktop: isWinner ? 32 : 28,
//             largeDesktop: isWinner ? 36 : 32,
//             ultraWide: isWinner ? 40 : 36,
//           ),
//           vertical: getResponsiveSpacing(
//             mobile: isWinner ? 10 : 8,
//             tablet: isWinner ? 12 : 10,
//             desktop: isWinner ? 14 : 12,
//             largeDesktop: isWinner ? 16 : 14,
//             ultraWide: isWinner ? 18 : 16,
//           ),
//         ),
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(
//           score,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: getResponsiveFont(
//               mobile: isWinner ? 22 : 18,
//               tablet: isWinner ? 24 : 20,
//               desktop: isWinner ? 26 : 22,
//               largeDesktop: isWinner ? 28 : 24,
//               ultraWide: isWinner ? 30 : 26,
//             ),
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       SizedBox(height: isWinner ? 12 : 8),
//       Text(
//         name,
//         style: TextStyle(
//           fontSize: getResponsiveFont(
//             mobile: isWinner ? 16 : 14,
//             tablet: isWinner ? 18 : 16,
//             desktop: isWinner ? 20 : 18,
//             largeDesktop: isWinner ? 22 : 20,
//             ultraWide: isWinner ? 24 : 22,
//           ),
//           fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
//           color: Colors.black87,
//         ),
//       ),
//     ],
//   );
//
//   Widget _buildPointsBreakdown(ChallengeModeScoreResponse player, String userId) => Container(
//     margin: const EdgeInsets.symmetric(horizontal: 16),
//     padding: EdgeInsets.all(getResponsiveSpacing(
//       mobile: 20,
//       tablet: 24,
//       desktop: 28,
//       largeDesktop: 32,
//       ultraWide: 36,
//     )),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(20),
//       border: Border.all(color: const Color(0xffC43917), width: 2),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Container(
//               height: 40,
//               width: 40,
//               decoration: const BoxDecoration(
//                 color: Color(0xffC43917),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.wine_bar_outlined,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Text(
//               player.userId == userId ? 'Your Points' : '${player.title}\'s Points',
//               style: TextStyle(
//                 fontSize: getResponsiveFont(
//                   mobile: 16,
//                   tablet: 18,
//                   desktop: 20,
//                   largeDesktop: 22,
//                   ultraWide: 24,
//                 ),
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xff00233B),
//                 fontFamily: 'Gotham-Bold',
//               ),
//             ),
//           ],
//         ),
//         SizedBox(
//           height: getResponsiveSpacing(
//             mobile: 20,
//             tablet: 24,
//             desktop: 28,
//             largeDesktop: 32,
//             ultraWide: 36,
//           ),
//         ),
//         _buildPointsItem('Strategy Alignment', player.alignmentStrategy.toString()),
//         Divider(color: Colors.grey.shade300),
//         _buildPointsItem('Objective Clarity', player.objectiveClarity.toString()),
//         Divider(color: Colors.grey.shade300),
//         _buildPointsItem('Key Result Quality', player.keyResultQuality.toString()),
//         Divider(color: Colors.grey.shade300),
//         _buildPointsItem('Initiative Relevance', player.initiativeRelevance.toString()),
//         Divider(color: Colors.grey.shade300),
//         _buildPointsItem('Challenge Adoption', player.challengeAdoption.toString()),
//       ],
//     ),
//   );
//
//   Widget _buildPointsItem(String label, String points) => Padding(
//     padding: EdgeInsets.symmetric(
//       vertical: getResponsiveSpacing(
//         mobile: 8,
//         tablet: 10,
//         desktop: 12,
//         largeDesktop: 14,
//         ultraWide: 16,
//       ),
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: getResponsiveFont(
//               mobile: 14,
//               tablet: 16,
//               desktop: 18,
//               largeDesktop: 20,
//               ultraWide: 22,
//             ),
//             color: Colors.grey.shade700,
//           ),
//         ),
//         Row(
//           children: [
//             Text(
//               points,
//               style: TextStyle(
//                 fontSize: getResponsiveFont(
//                   mobile: 14,
//                   tablet: 16,
//                   desktop: 18,
//                   largeDesktop: 20,
//                   ultraWide: 22,
//                 ),
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xff00233B),
//               ),
//             ),
//             const SizedBox(width: 4),
//             const Image(image: AssetImage("assets/images/win.png")),
//           ],
//         ),
//       ],
//     ),
//   );
//
//   Widget _buildMatchDetails() => Container(
//     margin: const EdgeInsets.symmetric(horizontal: 16),
//     padding: EdgeInsets.all(getResponsiveSpacing(
//       mobile: 20,
//       tablet: 24,
//       desktop: 28,
//       largeDesktop: 32,
//       ultraWide: 36,
//     )),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(20),
//       border: Border.all(color: const Color(0xffFFC72C), width: 2),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Column(
//           children: [
//             Container(
//               height: 40,
//               width: 40,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//                 image: DecorationImage(
//                   image: AssetImage("assets/images/okrgroup.png"),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Text(
//               'Match Details',
//               style: TextStyle(
//                 fontSize: getResponsiveFont(
//                   mobile: 16,
//                   tablet: 18,
//                   desktop: 20,
//                   largeDesktop: 22,
//                   ultraWide: 24,
//                 ),
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xff00233B),
//                 fontFamily: 'Gotham-Bold',
//               ),
//             ),
//           ],
//         ),
//         SizedBox(
//           height: getResponsiveSpacing(
//             mobile: 20,
//             tablet: 24,
//             desktop: 28,
//             largeDesktop: 32,
//             ultraWide: 36,
//           ),
//         ),
//         _buildMatchDetailItem('Match Type', 'Challenge Mode'),
//         Divider(color: const Color(0xffDFDFDF).withOpacity(0.3)),
//         _buildMatchDetailItem('Duration', '8m 32s'),
//         Divider(color: const Color(0xffDFDFDF).withOpacity(0.3)),
//         _buildMatchDetailItem('Difficulty', 'Intermediate'),
//       ],
//     ),
//   );
//
//   Widget _buildMatchDetailItem(String label, String value) => Padding(
//     padding: EdgeInsets.symmetric(
//       vertical: getResponsiveSpacing(
//         mobile: 8,
//         tablet: 10,
//         desktop: 12,
//         largeDesktop: 14,
//         ultraWide: 16,
//       ),
//     ),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: getResponsiveFont(
//               mobile: 14,
//               tablet: 16,
//               desktop: 18,
//               largeDesktop: 20,
//               ultraWide: 22,
//             ),
//             color: Colors.grey.shade700,
//           ),
//         ),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: getResponsiveFont(
//               mobile: 14,
//               tablet: 16,
//               desktop: 18,
//               largeDesktop: 20,
//               ultraWide: 22,
//             ),
//             fontWeight: FontWeight.bold,
//             color: const Color(0xff00233B),
//           ),
//         ),
//       ],
//     ),
//   );
//
//   Widget _buildPerformanceFeedback(ChallengeModeScoreResponse player, String userId) => Container(
//     margin: const EdgeInsets.symmetric(horizontal: 16),
//     padding: EdgeInsets.all(getResponsiveSpacing(
//       mobile: 20,
//       tablet: 24,
//       desktop: 28,
//       largeDesktop: 32,
//       ultraWide: 36,
//     )),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(20),
//       border: Border.all(color: const Color(0xffC43917), width: 2),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Container(
//               height: 40,
//               width: 40,
//               decoration: const BoxDecoration(
//                 color: Color(0xffC43917),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.thumb_up_alt,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Text(
//               player.userId == userId ? 'Your Performance Feedback' : '${player.title}\'s Performance Feedback',
//               style: TextStyle(
//                 fontSize: getResponsiveFont(
//                   mobile: 16,
//                   tablet: 18,
//                   desktop: 20,
//                   largeDesktop: 22,
//                   ultraWide: 24,
//                 ),
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xff00233B),
//                 fontFamily: 'Gotham-Bold',
//               ),
//             ),
//           ],
//         ),
//         SizedBox(
//           height: getResponsiveSpacing(
//             mobile: 20,
//             tablet: 24,
//             desktop: 28,
//             largeDesktop: 32,
//             ultraWide: 36,
//           ),
//         ),
//         _buildFeedbackItem(
//           'Strategic Alignment',
//           _getStatus(player.alignmentStrategy),
//           player.strategyAlignment['feedback']?.toString() ?? 'No feedback available',
//           _getStatusColor(player.alignmentStrategy),
//         ),
//         const SizedBox(height: 12),
//         _buildFeedbackItem(
//           'Objective Clarity',
//           _getStatus(player.objectiveClarity),
//           player.objectiveAlignment['feedback']?.toString() ?? 'No feedback available',
//           _getStatusColor(player.objectiveClarity),
//         ),
//         const SizedBox(height: 12),
//         _buildFeedbackItem(
//           'Key Results Quality',
//           _getStatus(player.keyResultQuality),
//           player.keyResultQualityLog['feedback']?.toString() ?? 'No feedback available',
//           _getStatusColor(player.keyResultQuality),
//         ),
//       ],
//     ),
//   );
//
//   String _getStatus(int score) {
//     if (score >= 80) return 'Perfect';
//     if (score >= 50) return 'Good';
//     return 'Need Work';
//   }
//
//   Color _getStatusColor(int score) {
//     if (score >= 80) return const Color(0xffC43917);
//     if (score >= 50) return const Color(0xff8DC046);
//     return Colors.orange.shade300;
//   }
//
//   Widget _buildFeedbackItem(String title, String status, String description, Color statusColor) => Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Text(
//               title,
//               style: TextStyle(
//                 fontSize: getResponsiveFont(
//                   mobile: 14,
//                   tablet: 16,
//                   desktop: 18,
//                   largeDesktop: 20,
//                   ultraWide: 22,
//                 ),
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Text(
//               status,
//               style: TextStyle(
//                 color: statusColor,
//                 fontSize: getResponsiveFont(
//                   mobile: 10,
//                   tablet: 12,
//                   desktop: 14,
//                   largeDesktop: 16,
//                   ultraWide: 18,
//                 ),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//       const SizedBox(height: 8),
//       Text(
//         description,
//         style: TextStyle(
//           fontSize: getResponsiveFont(
//             mobile: 12,
//             tablet: 14,
//             desktop: 16,
//             largeDesktop: 18,
//             ultraWide: 20,
//           ),
//           color: Colors.grey.shade600,
//           height: 1.4,
//         ),
//       ),
//     ],
//   );
//
//   Widget _buildActionButtons(BuildContext context) => Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 16),
//     child: Column(
//       children: [
//         Container(
//           width: double.infinity,
//           padding: EdgeInsets.symmetric(
//             vertical: getResponsiveSpacing(
//               mobile: 14,
//               tablet: 16,
//               desktop: 18,
//               largeDesktop: 20,
//               ultraWide: 22,
//             ),
//           ),
//           decoration: BoxDecoration(
//             color: const Color(0xffC43917),
//             borderRadius: BorderRadius.circular(25),
//             gradient: const LinearGradient(colors: [
//               Color(0xffC43917),
//               Color(0xff24387F),
//             ]),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.red.withOpacity(0.3),
//                 blurRadius: 8,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.access_time_filled,
//                 color: Colors.white,
//                 size: 20,
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 'Play Again',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: getResponsiveFont(
//                     mobile: 16,
//                     tablet: 18,
//                     desktop: 20,
//                     largeDesktop: 22,
//                     ultraWide: 24,
//                   ),
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Gotham-Bold',
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 12),
//         InkWell(
//           onTap: () {
//             Navigator.push(context, MaterialPageRoute(builder: (context) => const CertificationScreen()));
//           },
//           child: Container(
//             width: double.infinity,
//             padding: EdgeInsets.symmetric(
//               vertical: getResponsiveSpacing(
//                 mobile: 14,
//                 tablet: 16,
//                 desktop: 18,
//                 largeDesktop: 20,
//                 ultraWide: 22,
//               ),
//             ),
//             decoration: BoxDecoration(
//               color: const Color(0xff24387F),
//               borderRadius: BorderRadius.circular(25),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.blue.withOpacity(0.3),
//                   blurRadius: 8,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(
//                   Icons.redo,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Share',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: getResponsiveFont(
//                       mobile: 16,
//                       tablet: 18,
//                       desktop: 20,
//                       largeDesktop: 22,
//                       ultraWide: 24,
//                     ),
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Gotham-Bold',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
// enum DeviceType {
//   mobile,
//   tablet,
//   desktop,
//   largeDesktop,
//   ultraWide,
// }
//
//
//
//
