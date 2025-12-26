import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../generated/models/responses/dashboard_for_all/dashboard_all.dart';

class CustomTopPerformerWidget extends StatelessWidget {
  final List<PlayerModel> topThree;

  const CustomTopPerformerWidget({
    super.key,
    required this.topThree,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait = size.height > size.width;

    if (topThree.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('No top performers available'.tr),
        ),
      );
    }

    // Sort by rank
    final List<PlayerModel> sortedTop = List.from(topThree);
    sortedTop.sort((a, b) => (a.rank ?? 0).compareTo(b.rank ?? 0));

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final blockWidth = (maxWidth / 3) - 16.w;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// 🥈 2nd Place
              if (sortedTop.length > 1)
                Flexible(
                  child: _buildPodiumTile(
                    player: sortedTop[1],
                    rank: 2,
                    height: isPortrait
                        ? size.height * 0.20
                        : size.height * 0.25,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFB0BEC5), Color(0xFF90A4AE)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    width: blockWidth,
                  ),
                )
              else
                SizedBox(width: blockWidth),

              /// 🥇 1st Place
              if (sortedTop.isNotEmpty)
                Flexible(
                  child: _buildPodiumTile(
                    player: sortedTop[0],
                    rank: 1,
                    height: isPortrait
                        ? size.height * 0.26
                        : size.height * 0.32,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFF176), Color(0xFFFBC02D)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    width: blockWidth,
                  ),
                ),

              /// 🥉 3rd Place
              if (sortedTop.length > 2)
                Flexible(
                  child: _buildPodiumTile(
                    player: sortedTop[2],
                    rank: 3,
                    height: isPortrait
                        ? size.height * 0.18
                        : size.height * 0.22,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFA726), Color(0xFFEF6C00)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    width: blockWidth,
                  ),
                )
              else
                SizedBox(width: blockWidth),
            ],
          );
        },
      ),
    );
  }

  /// 🔥 Podium Tile Builder
  Widget _buildPodiumTile({
    required PlayerModel player,
    required int rank,
    required double height,
    required Gradient gradient,
    required double width,
  }) {
    final name = player.name ?? 'Unknown';
    final score = player.totalScore ?? 0;
    final level = player.level ?? '0';
    final avatarPicId = player.avatarPicId;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        /// Avatar + Rank
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: rank == 1 ? Colors.red : Colors.blue,
                  width: 2.w,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: SizedBox(
                  height: 55.w,
                  width: 55.w,
                  child: avatarPicId != null && avatarPicId.isNotEmpty
                      ? Image.network(
                    avatarPicId,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildDefaultAvatar(name, rank);
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: rank == 1 ? Colors.red : Colors.blue,
                        ),
                      );
                    },
                  )
                      : _buildDefaultAvatar(name, rank),
                ),
              ),
            ),
            Positioned(
              bottom: -5,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: rank == 1 ? Colors.red : Colors.black87,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Text(
                  "$rank",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),

        /// Podium Block
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                offset: const Offset(2, 4),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "⭐\n$score",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "level".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    "$level",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Default Avatar (when image is null or fails to load)
  Widget _buildDefaultAvatar(String name, int rank) {
    return Container(
      color: rank == 1
          ? Colors.red.withOpacity(0.1)
          : rank == 2
          ? Colors.blue.withOpacity(0.1)
          : Colors.orange.withOpacity(0.1),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'U',
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: rank == 1
                ? Colors.red
                : rank == 2
                ? Colors.blue
                : Colors.orange,
          ),
        ),
      ),
    );
  }
}