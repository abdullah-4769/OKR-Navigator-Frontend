import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_app/presentation/views/challange_mode/widget/input_invite_code_card.dart';
import 'package:get/get.dart';
import '../../../core/app_colors.dart';
import '../../../data/response/status.dart';
import '../../../services/shared_preference.dart';
import '../../../view_model/challange_view_models/challange_create_view_model.dart';
import '../../widgets/custom_button2.dart';
import '../../widgets/screens_unique_parts/custom_background.dart';
import '../../widgets/screens_unique_parts/custom_header.dart';
import '../../widgets/game_complete_widgets/custom_score_card.dart';
import 'challange_detail_screen.dart';

class JoinChallengeScreen extends StatefulWidget {
  const JoinChallengeScreen({Key? key}) : super(key: key);

  @override
  State<JoinChallengeScreen> createState() => _JoinChallengeScreenState();
}

class _JoinChallengeScreenState extends State<JoinChallengeScreen> {
  final ChallengeCreateViewModel _viewModel = Get.put(ChallengeCreateViewModel());
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  // Initialize screen data
  Future<void> _initializeScreen() async {
    try {
      setState(() {
        _isInitializing = true;
      });

      // Check if user is logged in
      final userId = SharedPrefs.getUserId();
      if (userId == null) {
        Get.snackbar(
          'Authentication Required',
          'Please log in to join challenges',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      // Use the actual user ID from authentication
      await _convertUserIdToHostId();
      await _viewModel.fetchPlayersExceptCurrentUser();
      await _viewModel.fetchInvitations();

    } catch (e) {
      print('❌ Error initializing screen: $e');
      Get.snackbar(
        'Error',
        'Failed to initialize: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  // Function to convert user ID to host ID and save it
  Future<void> _convertUserIdToHostId() async {
    final userId = SharedPrefs.getUserId();
    if (userId != null) {
      await SharedPrefs.saveHostId(userId);
      print('🔑 User ID converted to Host ID: $userId');
    } else {
      print('⚠️ No user ID found - user might not be logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20.h),
              Text('Loading Challenge Data...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomBackground(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 500.w),
                padding: EdgeInsets.symmetric(vertical: 6.h),
                child: Column(
                  children: [
                    CustomHeader(
                      title: "Join",
                      highlightedText: "Challenge",
                      onBackTap: Get.back,
                    ),
                    //  SizedBox(height: 10.h),
                    //_buildUserInfoCard(),
                    SizedBox(height: 10.h),
                    CustomScoreCard(
                      title: '',
                      showBackground: false,
                      imagePath: "assets/images/solo_image.png",
                    ),
                    SizedBox(height: 10.h),
                    InputInviteCodeCard(),
                    SizedBox(height: 25.h),
                    Obx(() {
                      if (_viewModel.inviteCode.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return _buildInviteCodeCard(_viewModel, _viewModel.inviteCode.value);
                    }),
                    SizedBox(height: 25.h),
                    _SectionTitle(title: 'Search Players'),
                    SizedBox(height: 15.h),
                    _SearchBar(
                      controller: _viewModel.searchPlayersController,
                      hint: 'Search Players',
                      onClear: _viewModel.clearPlayerSearch,
                    ),
                    SizedBox(height: 15.h),
                    Obx(() => _PlayersList(players: _viewModel.filteredPlayers.value)),
                    SizedBox(height: 30.h),
                    _SectionTitle(title: 'Active Challengers'),
                    SizedBox(height: 15.h),
                    _SearchBar(
                      controller: _viewModel.searchChallengersController,
                      hint: 'Search Challengers',
                      onClear: _viewModel.clearChallengerSearch,
                    ),
                    SizedBox(height: 15.h),
                    Obx(() => _buildChallengersSection()),
                    SizedBox(height: 40.h),
                    _buildActionButtons(),
                    SizedBox(height: 15.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // User info card showing current user
  Widget _buildUserInfoCard() {
    final userName = SharedPrefs.getUserName() ?? 'User';
    final userId = SharedPrefs.getUserId();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: Colors.blue,
            child: Text(
              userName[0].toUpperCase(),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                ),
                Text(
                  'ID: ${userId?.substring(0, 8)}...',
                  style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Action buttons with proper validation
  Widget _buildActionButtons() {
    return Column(
      children: [
        Obx(() {
          final status = _viewModel.inviteCodeResponse.value.status;
          final isLoading = status == Status.loading;
          final userId = SharedPrefs.getUserId();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: CustomButton2(
              text: isLoading ? "Creating Challenge..." : "Create Challenge",
              onPressed: (isLoading || userId == null)
                  ? null
                  : () {
                _viewModel.createChallenge(userId);
              },
            ),
          );
        }),
        SizedBox(height: 10.h),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: CustomButton2(
            text: "Continue",
            onPressed: () {
              final userId = SharedPrefs.getUserId();
              if (userId == null) {
                Get.snackbar(
                  'Authentication Required',
                  'Please log in to continue',
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
                return;
              }
              Get.to(() => ChallengeDetailsScreen());
            },
          ),
        ),
      ],
    );
  }
// Build challengers section based on API state - FIXED: Use invitationResponse
  Widget _buildChallengersSection() {
    final status = _viewModel.invitationResponse.value.status;

    // ✅ ADD DEBUG INFO
    print('🎯 Challengers API Status: $status');
    print('🎯 Number of challengers: ${_viewModel.filteredChallengers.value.length}');

    if (_viewModel.filteredChallengers.value.isNotEmpty) {
      print('🎯 First challenger data: ${_viewModel.filteredChallengers.value.first}');
    }

    if (status == Status.loading) {
      return Container(
        height: 280.h,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (status == Status.error) {
      return Container(
        height: 280.h,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 40.sp),
              SizedBox(height: 10.h),
              Text(
                'Failed to load challengers',
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
              SizedBox(height: 10.h),
              ElevatedButton(
                onPressed: () => _viewModel.fetchInvitations(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return _ChallengersList(challengers: _viewModel.filteredChallengers.value);
  }
  // Build challengers section based on API state
  // Widget _buildChallengersSection() {
  //   final status = _viewModel.invitationResponse.value.status;
  //
  //   if (status == Status.loading) {
  //     return Container(
  //       height: 200.h,
  //       margin: const EdgeInsets.symmetric(horizontal: 16.0),
  //       child: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             CircularProgressIndicator(),
  //             SizedBox(height: 10.h),
  //             Text('Loading challengers...'),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  //
  //   if (status == Status.error) {
  //     return Container(
  //       height: 200.h,
  //       margin: const EdgeInsets.symmetric(horizontal: 16.0),
  //       child: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Icon(Icons.error_outline, color: Colors.red, size: 40.sp),
  //             SizedBox(height: 10.h),
  //             Text(
  //               'Failed to load challengers',
  //               style: TextStyle(color: Colors.grey, fontSize: 14.sp),
  //             ),
  //             SizedBox(height: 10.h),
  //             ElevatedButton(
  //               onPressed: () => _viewModel.fetchInvitations(),
  //               child: const Text('Retry'),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  //
  //   // Check if we have any challengers
  //   final challengers = _viewModel.filteredChallengers.value;
  //   if (challengers.isEmpty) {
  //     return Container(
  //       height: 200.h,
  //       margin: const EdgeInsets.symmetric(horizontal: 16.0),
  //       child: Center(
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Icon(Icons.group_off, color: Colors.grey, size: 40.sp),
  //             SizedBox(height: 10.h),
  //             Text(
  //               'No active challengers',
  //               style: TextStyle(color: Colors.grey, fontSize: 14.sp),
  //             ),
  //             SizedBox(height: 5.h),
  //             Text(
  //               'When someone challenges you, they will appear here',
  //               style: TextStyle(color: Colors.grey, fontSize: 12.sp),
  //               textAlign: TextAlign.center,
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  //
  //   return _ChallengersList(challengers: challengers);
  // }

  Widget _buildInviteCodeCard(ChallengeCreateViewModel controller, String code) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Invite Code',
            style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                code,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () => controller.copyInviteCode(),
                child: CircleAvatar(
                  radius: 14.r,
                  backgroundColor: Colors.red.shade400,
                  child: Icon(Icons.copy, color: Colors.white, size: 16.sp),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Section Title
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xff24387F),
          ),
        ),
      ),
    );
  }
}

/// Search Bar
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final VoidCallback? onClear;

  const _SearchBar({required this.controller, required this.hint, this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14.r,
            backgroundColor: Colors.grey.shade200,
            child: Icon(Icons.search, color: Colors.grey.shade600, size: 16.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14.sp),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return GestureDetector(
                onTap: onClear,
                child: Icon(Icons.close, size: 18.sp, color: Colors.grey.shade600),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Players List
class _PlayersList extends StatelessWidget {
  final List<Map<String, dynamic>> players;
  const _PlayersList({required this.players});

  @override
  Widget build(BuildContext context) {
    if (players.isEmpty) {
      return Container(
        height: 120.h,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            'No players found',
            style: TextStyle(color: Colors.grey, fontSize: 14.sp),
          ),
        ),
      );
    }

    return Container(
      height: 160.h,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        padding: EdgeInsets.all(12.h),
        itemCount: players.length,
        separatorBuilder: (_, __) => SizedBox(height: 8.h),
        itemBuilder: (context, index) => _PlayerCard(player: players[index]),
      ),
    );
  }
}

/// Player Card - FIXED: Complete null safety for all player data
class _PlayerCard extends StatelessWidget {
  final Map<String, dynamic> player;
  const _PlayerCard({required this.player});

  @override
  Widget build(BuildContext context) {
    final ChallengeCreateViewModel viewModel = Get.find<ChallengeCreateViewModel>();

    // FIXED: Complete null safety - this was the main issue
    final playerId = player['id']?.toString() ?? '';
    final playerName = player['name']?.toString() ?? 'Unknown Player';
    final canChallenge = playerId.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xffC43917)),
      ),
      child: Row(
        children: [
          // Avatar with error handling
          _buildPlayerAvatar(player),
          SizedBox(width: 10.w),

          // Player name and status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Player Name
                Text(
                  playerName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff24387F),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 4.h),

                // Online Status
                Row(
                  children: [
                    CircleAvatar(radius: 4.r, backgroundColor: Colors.green),
                    SizedBox(width: 5.w),
                    Text(
                      'Online',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Challenge Button with loading state - FIXED: Complete null safety
          Obx(() {
            final isChallenging = viewModel.isChallengingPlayer(playerId);
            return ElevatedButton(
              onPressed: canChallenge && !isChallenging
                  ? () {
                print('🎯 Challenging player: $playerId - $playerName');
                viewModel.sendChallengeInvite(playerId);
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canChallenge ? Colors.blue : Colors.grey,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: isChallenging
                  ? SizedBox(
                width: 16.w,
                height: 16.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : Text(
                "Challenge",
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPlayerAvatar(Map<String, dynamic> player) {
    final avatar = player['avatar']?.toString();

    // Use default avatar if none provided or URL is invalid
    if (avatar == null || avatar.isEmpty || !avatar.startsWith('http')) {
      return CircleAvatar(
        radius: 20.r,
        backgroundColor: Colors.blue.shade100,
        child: Icon(Icons.person, color: Colors.blue.shade600, size: 20.sp),
      );
    }

    return CircleAvatar(
      radius: 20.r,
      backgroundImage: NetworkImage(avatar),
      onBackgroundImageError: (exception, stackTrace) {
        print('❌ Failed to load avatar: $avatar');
      },
      child: Icon(Icons.person, color: Colors.white, size: 20.sp),
    );
  }
}

/// Challengers List
class _ChallengersList extends StatelessWidget {
  final List<Map<String, dynamic>> challengers;
  const _ChallengersList({required this.challengers});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280.h,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        padding: EdgeInsets.all(12.h),
        itemCount: challengers.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (context, index) => _ChallengerCard(challenger: challengers[index]),
      ),
    );
  }
}
/// Challenger Card - FIXED: Use correct API response structure
class _ChallengerCard extends StatelessWidget {
  final Map<String, dynamic> challenger;
  const _ChallengerCard({required this.challenger});

  @override
  Widget build(BuildContext context) {
    final ChallengeCreateViewModel viewModel = Get.find<ChallengeCreateViewModel>();

    // ✅ FIXED: Use correct nested structure from API
    final hostDetail = challenger['challenge']?['hostDetail'] ?? {};
    final invitationId = challenger['id']?.toString() ?? '';
    final canRespond = invitationId.isNotEmpty;

    final challengerName = hostDetail['name']?.toString() ?? 'Unknown Challenger';
    final level = hostDetail['rank']?.toString() ?? '1';
    final points = hostDetail['totalPoints']?.toString() ?? '0';
    final avatar = hostDetail['avatarPicId']?.toString();

    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffD7D7D7)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // ✅ FIXED: Avatar with proper URL construction
              _buildChallengerAvatar(avatar),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challengerName, // ✅ FIXED: Use correct name
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(
                          'Level $level', // ✅ FIXED: Use correct level
                          style: TextStyle(color: Colors.blue, fontSize: 10.sp),
                        ),
                        SizedBox(width: 6.w),
                        Container(height: 8.h, width: 1.w, color: const Color(0xffC43917)),
                        SizedBox(width: 6.w),
                        Text(
                          '$points Points', // ✅ FIXED: Use correct points
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 10.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Color(0xffC43917), size: 16.sp),
                  SizedBox(width: 4.w),
                  Text(
                    points, // ✅ FIXED: Use correct points
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: canRespond ? () => viewModel.respondToChallenge(invitationId, true) : null,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: canRespond ? const Color(0xff8DC046) : Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Accept',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.sp),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: GestureDetector(
                  onTap: canRespond ? () => viewModel.respondToChallenge(invitationId, false) : null,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: canRespond ? const Color(0xffC43917) : Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Decline',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.sp),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ FIXED: Proper avatar builder with URL construction
  Widget _buildChallengerAvatar(String? avatarId) {
    if (avatarId == null || avatarId.isEmpty) {
      return CircleAvatar(
        radius: 20.r,
        backgroundColor: Colors.orange.shade100,
        child: Icon(Icons.people, color: Colors.orange.shade600, size: 20.sp),
      );
    }

    // Build proper avatar URL
    final avatarUrl = 'https://okr-navigator-backend.onrender.com/uploads/$avatarId';

    return CircleAvatar(
      radius: 20.r,
      backgroundImage: NetworkImage(avatarUrl),
      onBackgroundImageError: (exception, stackTrace) {
        print('❌ Failed to load challenger avatar: $avatarUrl');
      },
      child: Icon(Icons.person, color: Colors.white, size: 20.sp),
    );
  }
}
/// Challenger Card - UPDATED: With loading states and better error handling
// class _ChallengerCard extends StatelessWidget {
//   final Map<String, dynamic> challenger;
//   const _ChallengerCard({required this.challenger});
//
//   @override
//   Widget build(BuildContext context) {
//     final ChallengeCreateViewModel viewModel = Get.find<ChallengeCreateViewModel>();
//
//     // FIXED: Proper null safety for invitation ID
//     final invitationId = challenger['id']?.toString() ?? '';
//     final canRespond = invitationId.isNotEmpty;
//
//     return Container(
//       padding: EdgeInsets.all(16.h),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xffD7D7D7)),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               // Challenger Avatar
//               _buildChallengerAvatar(challenger),
//               SizedBox(width: 12.w),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       challenger['challenge']?['hostDetail']?['name']?.toString() ?? 'Unknown Challenger',
//                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
//                     ),
//                     SizedBox(height: 4.h),
//                     Row(
//                       children: [
//                         Text(
//                           'Level ${challenger['challenge']?['hostDetail']?['rank'] ?? '1'}',
//                           style: TextStyle(color: Colors.blue, fontSize: 10.sp),
//                         ),
//                         SizedBox(width: 6.w),
//                         Container(height: 8.h, width: 1.w, color: const Color(0xffC43917)),
//                         SizedBox(width: 6.w),
//                         Text(
//                           '${challenger['challenge']?['hostDetail']?['totalPoints'] ?? 0} Points',
//                           style: TextStyle(color: Colors.grey.shade600, fontSize: 10.sp),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.star, color: Color(0xffC43917), size: 16.sp),
//                   SizedBox(width: 4.w),
//                   Text(
//                     (challenger['challenge']?['hostDetail']?['totalPoints'] ?? 0).toString(),
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: 12.h),
//           // Accept/Decline Buttons with loading states - FIXED: Proper null safety
//           Obx(() {
//             final isResponding = viewModel.isRespondingToInvitation(invitationId);
//             final isDisabled = !canRespond || isResponding;
//
//             return Row(
//               children: [
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: isDisabled ? null : () {
//                       print('✅ Accepting invitation: $invitationId');
//                       viewModel.respondToChallenge(invitationId, true);
//                     },
//                     child: Container(
//                       padding: EdgeInsets.symmetric(vertical: 10.h),
//                       decoration: BoxDecoration(
//                         color: isDisabled ? Colors.grey : const Color(0xff8DC046),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: isResponding
//                           ? Center(
//                         child: SizedBox(
//                           width: 16.w,
//                           height: 16.h,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                           ),
//                         ),
//                       )
//                           : Text(
//                         'Accept',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.sp),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8.w),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: isDisabled ? null : () {
//                       print('❌ Declining invitation: $invitationId');
//                       viewModel.respondToChallenge(invitationId, false);
//                     },
//                     child: Container(
//                       padding: EdgeInsets.symmetric(vertical: 10.h),
//                       decoration: BoxDecoration(
//                         color: isDisabled ? Colors.grey : const Color(0xffC43917),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: isResponding
//                           ? Center(
//                         child: SizedBox(
//                           width: 16.w,
//                           height: 16.h,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                           ),
//                         ),
//                       )
//                           : Text(
//                         'Decline',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.sp),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           }),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildChallengerAvatar(Map<String, dynamic> challenger) {
//     final hostDetail = challenger['challenge']?['hostDetail'];
//     final avatar = hostDetail?['avatarPicId']?.toString();
//
//     // Use default avatar if none provided
//     if (avatar == null || avatar.isEmpty) {
//       return CircleAvatar(
//         radius: 20.r,
//         backgroundColor: Colors.orange.shade100,
//         child: Icon(Icons.people, color: Colors.orange.shade600, size: 20.sp),
//       );
//     }
//
//     // Build avatar URL properly
//     final avatarUrl = 'https://okr-navigator-backend.onrender.com/uploads/$avatar';
//
//     return CircleAvatar(
//       radius: 20.r,
//       backgroundImage: NetworkImage(avatarUrl),
//       onBackgroundImageError: (exception, stackTrace) {
//         print('❌ Failed to load challenger avatar: $avatarUrl');
//       },
//       child: Icon(Icons.person, color: Colors.white, size: 20.sp),
//     );
//   }
// }





















// // lib/presentation/views/challange_mode/join_challange_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:game_app/presentation/views/challange_mode/widget/input_invite_code_card.dart';
// import 'package:get/get.dart';
// import '../../../core/app_colors.dart';
// import '../../../data/response/status.dart';
// import '../../../services/shared_preference.dart';
// import '../../../view_model/challange_view_models/challange_create_view_model.dart';
// import '../../widgets/custom_button2.dart';
// import '../../widgets/screens_unique_parts/custom_background.dart';
// import '../../widgets/screens_unique_parts/custom_header.dart';
// import '../../widgets/game_complete_widgets/custom_score_card.dart';
// import 'challange_detail_screen.dart';
//
// class JoinChallengeScreen extends StatefulWidget {
//   const JoinChallengeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<JoinChallengeScreen> createState() => _JoinChallengeScreenState();
// }
//
// class _JoinChallengeScreenState extends State<JoinChallengeScreen> {
//   final ChallengeCreateViewModel _viewModel = Get.put(ChallengeCreateViewModel());
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeScreen();
//   }
//
//   // Initialize screen data
//   Future<void> _initializeScreen() async {
//    // await _saveHardcodedUserId();
//
//     await _convertUserIdToHostId();
//     await _viewModel.fetchPlayersExceptCurrentUser();
//
//
//     // Fetch invitations after user ID is set
//     await _viewModel.fetchInvitations();
//   }
//
//   // Function to save hardcoded user ID
//   Future<void> _saveHardcodedUserId() async {
//     await SharedPrefs.saveUserId('ceb0147f-273b-425e-a1f8-07e8f0dee9f2');
//   }
//
//   // Function to convert user ID to host ID and save it
//   Future<void> _convertUserIdToHostId() async {
//     final userId = SharedPrefs.getUserId();
//     if (userId != null) {
//       await SharedPrefs.saveHostId(userId);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: CustomBackground(
//           child: SingleChildScrollView(
//             child: Center(
//               child: Container(
//                 constraints: BoxConstraints(maxWidth: 500.w),
//                 padding: EdgeInsets.symmetric(vertical: 6.h),
//                 child: Column(
//                   children: [
//                     CustomHeader(
//                       title: "Join",
//                       highlightedText: "Challenge",
//                       onBackTap: Get.back,
//                     ),
//                     SizedBox(height: 10.h),
//                     CustomScoreCard(
//                       title: '',
//                       showBackground: false,
//                       imagePath: "assets/images/solo_image.png",
//                     ),
//                     SizedBox(height: 10.h),
//                     InputInviteCodeCard(),
//                     SizedBox(height: 25.h),
//                     Obx(() {
//                       if (_viewModel.inviteCode.isEmpty) {
//                         return const SizedBox.shrink();
//                       }
//                       return _buildInviteCodeCard(_viewModel, _viewModel.inviteCode.value);
//                     }),
//                     SizedBox(height: 25.h),
//                     _SectionTitle(title: 'Search Players'),
//                     SizedBox(height: 15.h),
//                     _SearchBar(
//                       controller: _viewModel.searchPlayersController,
//                       hint: 'Search Players',
//                       onClear: _viewModel.clearPlayerSearch,
//                     ),
//                     SizedBox(height: 15.h),
//                     Obx(() => _PlayersList(players: _viewModel.filteredPlayers.value)),
//                     SizedBox(height: 30.h),
//                     _SectionTitle(title: 'Active Challengers'),
//                     SizedBox(height: 15.h),
//                     _SearchBar(
//                       controller: _viewModel.searchChallengersController,
//                       hint: 'Search Challengers',
//                       onClear: _viewModel.clearChallengerSearch,
//                     ),
//                     SizedBox(height: 15.h),
//                     // Show loading, error, or data state - FIXED: Use invitationResponse
//                     Obx(() => _buildChallengersSection()),
//                     SizedBox(height: 40.h),
//                     Obx(() {
//                       final status = _viewModel.inviteCodeResponse.value.status;
//                       final isLoading = status == Status.loading;
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 12),
//                         child: CustomButton2(
//                           text: isLoading ? "Creating..." : "Create Challenge",
//                           onPressed: isLoading
//                               ? null
//                               : () {
//                             final hostId = SharedPrefs.getHostId();
//                             if (hostId != null) {
//                               _viewModel.createChallenge(hostId);
//                             } else {
//                               Get.snackbar(
//                                 'Error',
//                                 'Host ID not found',
//                                 backgroundColor: Colors.red,
//                                 colorText: Colors.white,
//                               );
//                             }
//                           },
//                         ),
//                       );
//                     }),
//                     SizedBox(height: 15.h),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       child: CustomButton2(
//                         text: "Continue",
//                         onPressed: () => Get.to(() => ChallengeDetailsScreen()),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Build challengers section based on API state - FIXED: Use invitationResponse
//   Widget _buildChallengersSection() {
//     final status = _viewModel.invitationResponse.value.status;
//
//     if (status == Status.loading) {
//       return Container(
//         height: 280.h,
//         margin: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: const Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     if (status == Status.error) {
//       return Container(
//         height: 280.h,
//         margin: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.error_outline, color: Colors.red, size: 40.sp),
//               SizedBox(height: 10.h),
//               Text(
//                 'Failed to load challengers',
//                 style: TextStyle(color: Colors.grey, fontSize: 14.sp),
//               ),
//               SizedBox(height: 10.h),
//               ElevatedButton(
//                 onPressed: () => _viewModel.fetchInvitations(),
//                 child: const Text('Retry'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//
//     return _ChallengersList(challengers: _viewModel.filteredChallengers.value);
//   }
//
//   /// Invite Code Card
//   Widget _buildInviteCodeCard(ChallengeCreateViewModel controller, String code) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 18),
//       padding: EdgeInsets.all(16.h),
//       decoration: BoxDecoration(
//         color: Colors.red.shade50,
//         borderRadius: BorderRadius.circular(28),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             'Invite Code',
//             style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
//           ),
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 code,
//                 style: TextStyle(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.red,
//                 ),
//               ),
//               SizedBox(width: 8.w),
//               GestureDetector(
//                 onTap: () => controller.copyInviteCode(),
//                 child: CircleAvatar(
//                   radius: 14.r,
//                   backgroundColor: Colors.red.shade400,
//                   child: Icon(Icons.copy, color: Colors.white, size: 16.sp),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// Section Title
// class _SectionTitle extends StatelessWidget {
//   final String title;
//   const _SectionTitle({required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Align(
//         alignment: Alignment.centerLeft,
//         child: Text(
//           title,
//           style: TextStyle(
//             fontSize: 20.sp,
//             fontWeight: FontWeight.bold,
//             color: const Color(0xff24387F),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// /// Search Bar
// class _SearchBar extends StatelessWidget {
//   final TextEditingController controller;
//   final String hint;
//   final VoidCallback? onClear;
//
//   const _SearchBar({required this.controller, required this.hint, this.onClear});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 18),
//       padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(28),
//         border: Border.all(color: Colors.grey),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//
//
//               child: Center(child: Icon(Icons.search, color: Colors.grey.shade600, size: 20.sp))),
//           SizedBox(width: 12.w),
//           Expanded(
//             child: TextField(
//               controller: controller,
//               decoration: InputDecoration(
//                 hintText: hint,
//                 hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14.sp),
//                 border: InputBorder.none,
//                 isDense: true,
//                 contentPadding: EdgeInsets.zero,
//               ),
//             ),
//           ),
//           ValueListenableBuilder<TextEditingValue>(
//             valueListenable: controller,
//             builder: (context, value, child) {
//               if (value.text.isEmpty) return const SizedBox.shrink();
//               return GestureDetector(
//                 onTap: onClear,
//                 child: Icon(Icons.close, size: 18.sp, color: Colors.grey.shade600),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// /// Players List
// class _PlayersList extends StatelessWidget {
//   final List<Map<String, dynamic>> players;
//   const _PlayersList({required this.players});
//
//   @override
//   Widget build(BuildContext context) {
//     if (players.isEmpty) {
//       return Container(
//         height: 120.h,
//         margin: const EdgeInsets.symmetric(horizontal: 16.0),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey.shade300),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Center(
//           child: Text(
//             'No players found',
//             style: TextStyle(color: Colors.grey, fontSize: 14.sp),
//           ),
//         ),
//       );
//     }
//
//     return Container(
//       height: 160.h,
//       margin: const EdgeInsets.symmetric(horizontal: 16.0),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: ListView.separated(
//         padding: EdgeInsets.all(12.h),
//         itemCount: players.length,
//         separatorBuilder: (_, __) => SizedBox(height: 8.h),
//         itemBuilder: (context, index) => _PlayerCard(player: players[index]),
//       ),
//     );
//   }
// }
// /// Player Card
// class _PlayerCard extends StatelessWidget {
//   final Map<String, dynamic> player;
//   const _PlayerCard({required this.player});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(12.h),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(25),
//         border: Border.all(color: const Color(0xffC43917)),
//       ),
//       child: Row(
//         children: [
//           // Avatar
//           CircleAvatar(
//             radius: 20.r,
//             backgroundImage: player['avatar'].toString().startsWith('http')
//                 ? NetworkImage(player['avatar'])
//                 : const AssetImage('assets/images/solo2.png') as ImageProvider,
//           ),
//           SizedBox(width: 10.w),
//
//           // Player name and status
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Player Name
//                 Text(
//                   player['name'] ?? 'Unknown',
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.bold,
//                     color: const Color(0xff24387F),
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 1,
//                 ),
//                 SizedBox(height: 4.h),
//
//                 // Online Status
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 4.r,
//                       backgroundColor: Colors.green,
//                     ),
//                     SizedBox(width: 5.w),
//                     Text(
//                       'Online',
//                       style: TextStyle(
//                         fontSize: 11.sp,
//                         color: Colors.green.shade700,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           ElevatedButton(
//             onPressed: () {
//               final playerId = player['id']; // from your player map
//               Get.find<ChallengeCreateViewModel>().sendChallengeInvite(playerId);
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//             child: const Text("Challenge"),
//           )
//
//         ],
//       ),
//     );
//   }
// }
//
//
// /// Challengers List
// class _ChallengersList extends StatelessWidget {
//   final List<Map<String, dynamic>> challengers;
//   const _ChallengersList({required this.challengers});
//
//   @override
//   Widget build(BuildContext context) {
//     if (challengers.isEmpty) {
//       return Container(
//         height: 150.h,
//         margin: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: Center(
//           child: Text(
//             'No challengers found',
//             style: TextStyle(color: Colors.grey, fontSize: 14.sp),
//           ),
//         ),
//       );
//     }
//
//     return Container(
//       height: 280.h,
//       margin: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: ListView.separated(
//         padding: EdgeInsets.all(12.h),
//         itemCount: challengers.length,
//         separatorBuilder: (_, __) => SizedBox(height: 12.h),
//         itemBuilder: (context, index) => _ChallengerCard(challenger: challengers[index]),
//       ),
//     );
//   }
// }
//
// /// Challenger Card - UPDATED: Now uses real API calls
// /// Challenger Card - UPDATED: Use invitation ID instead of challenge ID
// class _ChallengerCard extends StatelessWidget {
//   final Map<String, dynamic> challenger;
//   const _ChallengerCard({required this.challenger});
//
//   @override
//   Widget build(BuildContext context) {
//     final ChallengeCreateViewModel viewModel = Get.find<ChallengeCreateViewModel>();
//
//     return Container(
//       padding: EdgeInsets.all(16.h),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xffD7D7D7)),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 20.r,
//                 backgroundImage: challenger['avatar'].toString().startsWith('http')
//                     ? NetworkImage(challenger['avatar']) as ImageProvider
//                     : AssetImage(challenger['avatar']),
//               ),
//               SizedBox(width: 12.w),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       challenger['name'],
//                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
//                     ),
//                     SizedBox(height: 4.h),
//                     Row(
//                       children: [
//                         Text(
//                           challenger['level'],
//                           style: TextStyle(color: Colors.blue, fontSize: 10.sp),
//                         ),
//                         SizedBox(width: 6.w),
//                         Container(height: 8.h, width: 1.w, color: const Color(0xffC43917)),
//                         SizedBox(width: 6.w),
//                         Text(
//                           '${challenger['points']} Points',
//                           style: TextStyle(color: Colors.grey.shade600, fontSize: 10.sp),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.star, color: Color(0xffC43917), size: 16.sp),
//                   SizedBox(width: 4.w),
//                   Text(
//                     challenger['points'].toString(),
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: 12.h),
//           Row(
//             children: [
//               Expanded(
//                 child: GestureDetector(
//                   // FIXED: Use 'id' (invitation ID) instead of 'challengeId'
//                   onTap: () => viewModel.respondToChallenge(challenger['id'], true),
//                   child: Container(
//                     padding: EdgeInsets.symmetric(vertical: 10.h),
//                     decoration: BoxDecoration(
//                       color: const Color(0xff8DC046),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       'Accept',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.sp),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 8.w),
//               Expanded(
//                 child: GestureDetector(
//                   // FIXED: Use 'id' (invitation ID) instead of 'challengeId'
//                   onTap: () => viewModel.respondToChallenge(challenger['id'], false),
//                   child: Container(
//                     padding: EdgeInsets.symmetric(vertical: 10.h),
//                     decoration: BoxDecoration(
//                       color: const Color(0xffC43917),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       'Decline',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.sp),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }