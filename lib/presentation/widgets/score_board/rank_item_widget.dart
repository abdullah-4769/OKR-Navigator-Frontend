// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../generated/models/responses/dashboard_for_all/dashboard_all.dart';
//
// class RankItemWidget extends StatelessWidget {
//   final PlayerModel player;
//   final int rank;
//   final bool isCurrentUser;
//
//   const RankItemWidget({
//     super.key,
//     required this.player,
//     required this.rank,
//     this.isCurrentUser = false,
//   });
//
//   String translateLevel(String? level) {
//     switch (level) {
//       case 'Explorer':
//         return 'level_explorer'.tr;
//       case 'Newcomer':
//         return 'level_newcomer'.tr;
//       case 'Elite':
//         return 'level_elite'.tr;
//       default:
//         return level ?? '';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
//       margin: const EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//         color: isCurrentUser ? Colors.red : Colors.white,
//         borderRadius: BorderRadius.circular(30),
//         border: Border.all(
//           color: Colors.red,
//           width: 1,
//         ),
//       ),
//       child: Row(
//         children: [
//           Text(
//             '${player.rank ?? 0}.',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: isCurrentUser ? Colors.white : Colors.black87,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Container(
//             padding: const EdgeInsets.all(4),
//             decoration: BoxDecoration(
//               color: Colors.red.withOpacity(0.15),
//               shape: BoxShape.circle,
//               border: Border.all(color: Colors.red, width: 2),
//             ),
//             child: player.avatarPicId != null
//                 ? ClipOval(
//               child: Image.network(
//                 player.avatarPicId!,
//                 width: 36,
//                 height: 36,
//                 errorBuilder: (context, error, stackTrace) =>
//                     _buildInitialAvatar(),
//               ),
//             )
//                 : _buildInitialAvatar(),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   player.name ?? 'Unknown',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: isCurrentUser ? Colors.white : Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'level_points_earned'.trParams({
//                     'level': translateLevel(player.level),
//                     'points': '${player.totalScore ?? 0}',
//                   }),
//                 )
//
//               ],
//             ),
//           ),
//           Row(
//             children: [
//               const Icon(Icons.star, color: Colors.red, size: 18),
//               const SizedBox(width: 4),
//               Text(
//                 '${player.totalScore ?? 0}',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: isCurrentUser ? Colors.white : Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildInitialAvatar() {
//     final String initial =
//     player.name != null && player.name!.isNotEmpty ? player.name![0] : 'U';
//     return Container(
//       width: 36,
//       height: 36,
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         shape: BoxShape.circle,
//       ),
//       child: Center(
//         child: Text(
//           initial.toUpperCase(),
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.red,
//           ),
//         ),
//       ),
//     );
//   }
// }
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

  /// ✅ Helper method to get correct image provider
  ImageProvider _getImageProvider(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return const AssetImage('assets/images/solo_image.png');
    }

    // Check if it's a local asset
    if (imagePath.startsWith('assets/') || imagePath.startsWith('lib/')) {
      return AssetImage(imagePath);
    }
    // Check if it's a full network URL
    else if (imagePath.startsWith('http://') ||
        imagePath.startsWith('https://')) {
      return NetworkImage(imagePath);
    }
    // Fallback: treat as network image (server upload)
    else {
      return NetworkImage(imagePath);
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
          // Rank number
          Text(
            '${player.rank ?? 0}.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isCurrentUser ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(width: 12),

          // Avatar section
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.red, width: 2),
            ),
            child: ClipOval(
              child: player.avatarPicId != null && player.avatarPicId!.isNotEmpty
                  ? Image(
                image: _getImageProvider(player.avatarPicId),
                width: 36,
                height: 36,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildInitialAvatar(),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 36,
                    height: 36,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                        ),
                      ),
                    ),
                  );
                },
              )
                  : _buildInitialAvatar(),
            ),
          ),
          const SizedBox(width: 12),

          // Name and level
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'level_points_earned'.trParams({
                    'level': translateLevel(player.level),
                    'points': '${player.totalScore ?? 0}',
                  }),
                  style: TextStyle(
                    fontSize: 12,
                    color: isCurrentUser
                        ? Colors.white.withOpacity(0.9)
                        : Colors.black54,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Score section
          Row(
            children: [
              Icon(
                Icons.star,
                color: isCurrentUser ? Colors.white : Colors.red,
                size: 18,
              ),
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

  /// ✅ Build initial avatar with user's first letter
  Widget _buildInitialAvatar() {
    final String initial = player.name != null && player.name!.isNotEmpty
        ? player.name![0].toUpperCase()
        : 'U';

    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initial,
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