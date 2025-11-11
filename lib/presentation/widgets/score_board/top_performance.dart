import 'package:flutter/material.dart';

import '../../../generated/models/responses/dashboard_for_all/dashboard_all.dart';

class TopPerformerWidget extends StatelessWidget {
  final List<PlayerModel> topThree;

  const TopPerformerWidget({
    super.key,
    required this.topThree,
  });

  @override
  Widget build(BuildContext context) {
    if (topThree.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('No top performers available'),
        ),
      );
    }

    final List<PlayerModel> sortedTop = List.from(topThree);
    sortedTop.sort((a, b) => (a.rank ?? 0).compareTo(b.rank ?? 0));

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (sortedTop.length > 1)
            _buildTopPerformer(sortedTop[1], 2)
          else
            const SizedBox(width: 80),
          if (sortedTop.isNotEmpty) _buildTopPerformer(sortedTop[0], 1),
          if (sortedTop.length > 2)
            _buildTopPerformer(sortedTop[2], 3)
          else
            const SizedBox(width: 80),
        ],
      ),
    );
  }

  Widget _buildTopPerformer(PlayerModel player, int position) {
    final bool isFirst = position == 1;
    final double size = isFirst ? 90 : 70;
    final Color borderColor = isFirst ? Colors.red : Colors.blue;

    return Column(
      children: [
        if (isFirst)
          const Icon(
            Icons.star,
            color: Colors.red,
            size: 28,
          ),
        const SizedBox(height: 4),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 3),
                color: Colors.white,
              ),
              child: Center(
                child: player.avatarPicId != null
                    ? Image.network(
                  player.avatarPicId!,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildInitialAvatar(player.name ?? 'U', borderColor),
                )
                    : _buildInitialAvatar(player.name ?? 'U', borderColor),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: borderColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '#${player.rank ?? position}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${player.totalScore ?? 0}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: borderColor,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 80,
          child: Text(
            player.name ?? 'Unknown',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildInitialAvatar(String name, Color color) {
    return Text(
      name.isNotEmpty ? name[0].toUpperCase() : 'U',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}
