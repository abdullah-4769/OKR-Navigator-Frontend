import 'package:flutter/material.dart';
import 'package:game_app/core/app_colors.dart';

class StrategyCard extends StatelessWidget {
  final String title;
  final String description;
  final String difficulty;
  final bool isSelected;
  final VoidCallback onTap;

  const StrategyCard({
    Key? key,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  int get difficultyLevel {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return 1;
      case 'medium':
        return 2;
      case 'hard':
        return 3;
      default:
        return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryRed : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primaryRed.withOpacity(0.2)
                  : Colors.black.withOpacity(0.05),
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.psychology,
                    color: AppColors.primaryRed,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryRed,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryRed : Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSelected ? Icons.check : Icons.circle_outlined,
                    color: isSelected ? Colors.white : Colors.grey[400],
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: TextStyle(
                fontSize: 14, // Slightly larger for better readability
                color: Colors.grey[800],
                height: 1.5,
              ),
              maxLines: 4, // Limit lines to prevent overflow
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ...List.generate(
                  3,
                      (index) => Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(
                      index < difficultyLevel ? Icons.star : Icons.star_border,
                      color: Colors.orange,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  difficulty,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:game_app/core/app_colors.dart';
//
// class StrategyCard extends StatelessWidget {
//   final String title;
//   final String description;
//   final String difficulty;
//   final bool isSelected;
//   final VoidCallback onTap;
//
//   const StrategyCard({
//     Key? key,
//     required this.title,
//     required this.description,
//     required this.difficulty,
//     required this.isSelected,
//     required this.onTap,
//   }) : super(key: key);
//
//   int get difficultyLevel {
//     switch (difficulty.toLowerCase()) {
//       case 'easy':
//         return 1;
//       case 'medium':
//         return 2;
//       case 'hard':
//         return 3;
//       default:
//         return 2;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: isSelected ? AppColors.primaryRed : Colors.transparent,
//             width: 2,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: isSelected
//                   ? AppColors.primaryRed.withOpacity(0.2)
//                   : Colors.black.withOpacity(0.05),
//               blurRadius: isSelected ? 12 : 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.psychology,
//                     color: AppColors.primaryRed,
//                     size: 28,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.primaryRed,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: isSelected ? AppColors.primaryRed : Colors.grey[200],
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     isSelected ? Icons.check : Icons.circle_outlined,
//                     color: isSelected ? Colors.white : Colors.grey[400],
//                     size: 24,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               description,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey[800],
//                 height: 1.5,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: List.generate(
//                 3,
//                     (index) => Padding(
//                   padding: const EdgeInsets.only(right: 4),
//                   child: Icon(
//                     index < difficultyLevel ? Icons.star : Icons.star_border,
//                     color: Colors.orange,
//                     size: 24,
//                   ),
//                 ),
//               )
//                 ..add(const SizedBox(width: 8))
//                 ..add(
//                   Text(
//                     difficulty,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey[600],
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
