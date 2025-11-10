import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/scoreboard_controllers/score_board_controller.dart';
import '../widgets/global_widgets/custom_top_performer_widget.dart';
import '../widgets/score_board/mode_selector.dart';
import '../widgets/score_board/rank_item_widget.dart';
import '../widgets/score_board/top_performance.dart';
import '../widgets/screens_unique_parts/custom_header.dart';

class ScoreboardScreen extends StatelessWidget {
  const ScoreboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ScoreboardController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: "your".tr,
              highlightedText: "scoreboard".tr,
              subtitle: "".tr,
              onBackTap: () => Get.back(),
            ),
            Container(
              child: const Column(
                children: [
                  SizedBox(height: 10),
                  ModeSelectorWidget(),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  );
                }

                if (controller.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 60,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading scoreboard',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.errorMessage.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () => controller.fetchScoreboard(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          'Show Personal Achievements',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomTopPerformerWidget(
                        topThree: controller.topThree,
                      ),
                      const SizedBox(height: 20),
                      if (controller.userDetails.value != null)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.emoji_events,
                                color: Colors.red,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'I\'m ranked #${controller.userDetails.value?.rank ?? 'N/A'} in ${controller.getModeName()} this week!',
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Leaderboard',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (controller.allPlayers.isEmpty)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    'No leaderboard data available',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ),
                              )
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.allPlayers.length,
                                itemBuilder: (context, index) {
                                  final player = controller.allPlayers[index];
                                  final isCurrentUser =
                                      controller.userDetails.value?.userId ==
                                          player.userId;

                                  // Use computed rank (from sorting) or fallback
                                  final displayRank = player.rank ?? (index + 1);

                                  return RankItemWidget(
                                    player: player,
                                    // rank: displayRank,
                                    isCurrentUser: isCurrentUser,
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
