// lib/presentation/views/challange_mode/join_challange_screen.dart
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
  final ChallengeViewModel _viewModel = Get.put(ChallengeViewModel());

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  // Initialize screen data
  Future<void> _initializeScreen() async {
   // await _saveHardcodedUserId();

    await _convertUserIdToHostId();
    await _viewModel.fetchPlayersExceptCurrentUser();


    // Fetch invitations after user ID is set
    await _viewModel.fetchInvitations();
  }

  // Function to save hardcoded user ID
  Future<void> _saveHardcodedUserId() async {
    await SharedPrefs.saveUserId('ceb0147f-273b-425e-a1f8-07e8f0dee9f2');
  }

  // Function to convert user ID to host ID and save it
  Future<void> _convertUserIdToHostId() async {
    final userId = SharedPrefs.getUserId();
    if (userId != null) {
      await SharedPrefs.saveHostId(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    // Show loading, error, or data state - FIXED: Use invitationResponse
                    Obx(() => _buildChallengersSection()),
                    SizedBox(height: 40.h),
                    Obx(() {
                      final status = _viewModel.inviteCodeResponse.value.status;
                      final isLoading = status == Status.loading;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: CustomButton2(
                          text: isLoading ? "Creating..." : "Create Challenge",
                          onPressed: isLoading
                              ? null
                              : () {
                            final hostId = SharedPrefs.getHostId();
                            if (hostId != null) {
                              _viewModel.createChallenge(hostId);
                            } else {
                              Get.snackbar(
                                'Error',
                                'Host ID not found',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          },
                        ),
                      );
                    }),
                    SizedBox(height: 15.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: CustomButton2(
                        text: "Continue",
                        onPressed: () => Get.to(() => ChallengeDetailsScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Build challengers section based on API state - FIXED: Use invitationResponse
  Widget _buildChallengersSection() {
    final status = _viewModel.invitationResponse.value.status;

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

  /// Invite Code Card
  Widget _buildInviteCodeCard(ChallengeViewModel controller, String code) {
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


              child: Center(child: Icon(Icons.search, color: Colors.grey.shade600, size: 20.sp))),
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
/// Player Card
class _PlayerCard extends StatelessWidget {
  final Map<String, dynamic> player;
  const _PlayerCard({required this.player});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xffC43917)),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 20.r,
            backgroundImage: player['avatar'].toString().startsWith('http')
                ? NetworkImage(player['avatar'])
                : const AssetImage('assets/images/solo2.png') as ImageProvider,
          ),
          SizedBox(width: 10.w),

          // Player name and status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Player Name
                Text(
                  player['name'] ?? 'Unknown',
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
                    CircleAvatar(
                      radius: 4.r,
                      backgroundColor: Colors.green,
                    ),
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

          ElevatedButton(
            onPressed: () {
              final playerId = player['id']; // from your player map
              Get.find<ChallengeViewModel>().sendChallengeInvite(playerId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text("Challenge"),
          )

        ],
      ),
    );
  }
}


/// Challengers List
class _ChallengersList extends StatelessWidget {
  final List<Map<String, dynamic>> challengers;
  const _ChallengersList({required this.challengers});

  @override
  Widget build(BuildContext context) {
    if (challengers.isEmpty) {
      return Container(
        height: 150.h,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Text(
            'No challengers found',
            style: TextStyle(color: Colors.grey, fontSize: 14.sp),
          ),
        ),
      );
    }

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

/// Challenger Card - UPDATED: Now uses real API calls
/// Challenger Card - UPDATED: Use invitation ID instead of challenge ID
class _ChallengerCard extends StatelessWidget {
  final Map<String, dynamic> challenger;
  const _ChallengerCard({required this.challenger});

  @override
  Widget build(BuildContext context) {
    final ChallengeViewModel viewModel = Get.find<ChallengeViewModel>();

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
              CircleAvatar(
                radius: 20.r,
                backgroundImage: challenger['avatar'].toString().startsWith('http')
                    ? NetworkImage(challenger['avatar']) as ImageProvider
                    : AssetImage(challenger['avatar']),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenger['name'],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(
                          challenger['level'],
                          style: TextStyle(color: Colors.blue, fontSize: 10.sp),
                        ),
                        SizedBox(width: 6.w),
                        Container(height: 8.h, width: 1.w, color: const Color(0xffC43917)),
                        SizedBox(width: 6.w),
                        Text(
                          '${challenger['points']} Points',
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
                    challenger['points'].toString(),
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
                  // FIXED: Use 'id' (invitation ID) instead of 'challengeId'
                  onTap: () => viewModel.respondToChallenge(challenger['id'], true),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: const Color(0xff8DC046),
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
                  // FIXED: Use 'id' (invitation ID) instead of 'challengeId'
                  onTap: () => viewModel.respondToChallenge(challenger['id'], false),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: const Color(0xffC43917),
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
}