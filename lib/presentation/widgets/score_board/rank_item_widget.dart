import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../generated/models/responses/dashboard_for_all/dashboard_all.dart';

class RankItemWidget extends StatelessWidget {
  final PlayerModel player;
  final int rank;
  final bool isCurrentUser;

  const RankItemWidget({
    super.key,
    required this.player,
    required this.rank,
    this.isCurrentUser = false,
  });

  String translateLevel(String? level) {
    switch (level) {
      case 'Explorer':
        return 'level_explorer'.tr;
      case 'Newcomer':
        return 'level_newcomer'.tr;
      case 'Elite':
        return 'level_elite'.tr;
      default:
        return level ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.red : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.red,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            '${player.rank ?? 0}.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isCurrentUser ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.red, width: 2),
            ),
            child: player.avatarPicId != null
                ? ClipOval(
              child: Image.network(
                player.avatarPicId!,
                width: 36,
                height: 36,
                errorBuilder: (context, error, stackTrace) =>
                    _buildInitialAvatar(),
              ),
            )
                : _buildInitialAvatar(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isCurrentUser ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'level_points_earned'.trParams({
                    'level': translateLevel(player.level),
                    'points': '${player.totalScore ?? 0}',
                  }),
                )

              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.red, size: 18),
              const SizedBox(width: 4),
              Text(
                '${player.totalScore ?? 0}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isCurrentUser ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInitialAvatar() {
    final String initial =
    player.name != null && player.name!.isNotEmpty ? player.name![0] : 'U';
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial.toUpperCase(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
