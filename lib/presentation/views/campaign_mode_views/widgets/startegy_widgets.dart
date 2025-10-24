import 'package:flutter/material.dart';
import 'package:game_app/presentation/views/campaign_mode_views/widgets/startegy_card.dart';
import 'package:get/get.dart';
import '../../../../data/response/status.dart';
import '../../../../services/shared_preference.dart';
import '../../../../view_model/campaign_mode/campaign_senerio_view_model.dart';

class GrowthStrategySection extends StatefulWidget {
  const GrowthStrategySection({Key? key}) : super(key: key);

  @override
  State<GrowthStrategySection> createState() => _GrowthStrategySectionState();
}

class _GrowthStrategySectionState extends State<GrowthStrategySection> {
  int? selectedIndex;
  Map<String, dynamic>? selectedStrategy;

  @override
  Widget build(BuildContext context) {
    final viewModel = Get.find<NavigatorCertificationViewModel>();

    return Obx(() {
      final response = viewModel.strategies.value;

      if (response.status == Status.loading) {
        return const Center(child: CircularProgressIndicator());
      } else if (response.status == Status.error) {
        return Center(child: Text('Error: ${response.message}'));
      } else if (response.status == Status.completed) {
        final List<dynamic> strategies = response.data ?? [];

        if (strategies.isEmpty) {
          return const Center(child: Text('No strategies found'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Your Strategy (${strategies.length} options)',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

              ],
            ),
            const SizedBox(height: 12),
            if (selectedStrategy != null)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Text(
                    'Selected',
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: strategies.length,
              itemBuilder: (context, index) {
                final strategy = strategies[index];
                final strategyId = strategy['id'] ?? (index + 1);
                final title = strategy['title'] ?? 'Untitled Strategy';
                final description = strategy['text'] ?? 'No description available';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: StrategyCard(
                    title: title,
                    description: description,
                    difficulty: _calculateDifficulty(strategy),
                    isSelected: selectedIndex == index,
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        selectedStrategy = {
                          'id': strategyId,
                          'title': title,
                          'description': description,
                          'text': description,
                          'difficulty': _calculateDifficulty(strategy),
                        };
                      });

                      // Save the selected strategy to SharedPreferences
                      SharedPrefs.saveCertificateSelectedAIStrategy(selectedStrategy!);

                      // Show selection feedback
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('✅ Strategy Selected: $title'),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.green,
                        ),
                      );

                      // Print debug info
                      print('🎯 Strategy Selected: $title');
                      print('📝 Description: $description');
                      SharedPrefs.printCertificateData();
                    },
                  ),
                );
              },
            ),

            // Selection requirement message
            if (selectedIndex == null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.orange.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Please select one strategy to continue',
                        style: TextStyle(
                          color: Colors.orange.shade800,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Selected strategy details
            if (selectedStrategy != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green.shade700, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Strategy Selected',
                          style: TextStyle(
                            color: Colors.green.shade800,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      selectedStrategy!['title'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      selectedStrategy!['description'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      }

      return const SizedBox.shrink();
    });
  }

  String _calculateDifficulty(Map<String, dynamic> strategy) {
    final title = (strategy['title'] ?? '').toString().toLowerCase();

    if (title.contains('aggressive') || title.contains('outsource')) {
      return 'Hard';
    } else if (title.contains('expansion') || title.contains('automation')) {
      return 'Medium';
    } else {
      return 'Easy';
    }
  }
}





// import 'package:flutter/material.dart';
// import 'package:game_app/presentation/views/campaign_mode_views/widgets/startegy_card.dart';
// import 'package:get/get.dart';
// import '../../../../data/response/status.dart';
// import '../../../../view_model/campaign_mode/campaign_senerio_view_model.dart';
//
// class GrowthStrategySection extends StatefulWidget {
//   const GrowthStrategySection({Key? key}) : super(key: key);
//
//   @override
//   State<GrowthStrategySection> createState() => _GrowthStrategySectionState();
// }
//
// class _GrowthStrategySectionState extends State<GrowthStrategySection> {
//   int? selectedIndex;
//
//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Get.find<NavigatorCertificationViewModel>();
//
//     return Obx(() {
//       final response = viewModel.strategies.value;
//
//       if (response.status == Status.loading) {
//         return const Center(child: CircularProgressIndicator());
//       } else if (response.status == Status.error) {
//         return Center(child: Text('Error: ${response.message}'));
//       } else if (response.status == Status.completed) {
//         final List<dynamic> strategies = response.data ?? [];
//
//         if (strategies.isEmpty) {
//           return const Center(child: Text('No strategies found'));
//         }
//
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Select Your Strategy (${strategies.length} options)',
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 12),
//             ListView.builder(
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               itemCount: strategies.length,
//               itemBuilder: (context, index) {
//                 final strategy = strategies[index];
//                 final strategyId = strategy['id'] ?? (index + 1);
//                 final title = strategy['title'] ?? 'Untitled Strategy';
//                 final description = strategy['text'] ?? 'No description available';
//
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 16),
//                   child: StrategyCard(
//                     title: title,
//                     description: description,
//                     difficulty: _calculateDifficulty(strategy), // You can customize this
//                     isSelected: selectedIndex == index,
//                     onTap: () {
//                       setState(() {
//                         selectedIndex = selectedIndex == index ? null : index;
//                       });
//
//                       // Show selection feedback
//                       final isCorrect = viewModel.isCorrectStrategy(strategyId);
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             'Selected: $title\n'
//                                 '${isCorrect ? '✅ Correct choice!' : '❌ Not the optimal strategy'}',
//                           ),
//                           duration: const Duration(seconds: 3),
//                           backgroundColor: isCorrect ? Colors.green : Colors.orange,
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//
//             // Show correct strategy hint (optional - for testing)
//             if (selectedIndex != null) ...[
//               const SizedBox(height: 16),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade50,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.blue.shade200),
//                 ),
//                 child: Text(
//                   '💡 Hint: The correct strategy focuses on sustainable partnerships',
//                   style: TextStyle(
//                     color: Colors.blue.shade800,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         );
//       }
//
//       return const SizedBox.shrink();
//     });
//   }
//
//   String _calculateDifficulty(Map<String, dynamic> strategy) {
//     // You can calculate difficulty based on strategy data
//     // For now, let's use a simple logic
//     final title = (strategy['title'] ?? '').toString().toLowerCase();
//
//     if (title.contains('aggressive') || title.contains('outsource')) {
//       return 'Hard';
//     } else if (title.contains('expansion') || title.contains('automation')) {
//       return 'Medium';
//     } else {
//       return 'Easy';
//     }
//   }
// }
