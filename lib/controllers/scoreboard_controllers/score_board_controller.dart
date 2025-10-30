// controllers/scoreboard_controller.dart
import 'package:get/get.dart';

class ScoreboardController extends GetxController {
  final RxString selectedTimeFrame = 'Today'.obs;
  final List<String> timeFrames = ['Today', 'This Week', 'This Month'];

  final RxList<Map<String, dynamic>> leaderboard = <Map<String, dynamic>>[
    {
      'rank': 3,
      'name': 'You',
      'level': 1,
      'points': 2000,
      'highlighted': true,
    },
    {
      'rank': 4,
      'name': 'Adam',
      'level': 5,
      'points': 2000,
      'highlighted': false,
    },
    {
      'rank': 5,
      'name': 'Warner',
      'level': 8,
      'points': 2000,
      'highlighted': false,
    },
    {
      'rank': 6,
      'name': 'Tasha',
      'level': 3,
      'points': 2000,
      'highlighted': false,
    },
    {
      'rank': 7,
      'name': 'Liam',
      'level': 4,
      'points': 2000,
      'highlighted': false,
    },
    {
      'rank': 8,
      'name': 'Maya',
      'level': 6,
      'points': 2000,
      'highlighted': false,
    },
    {
      'rank': 9,
      'name': 'Jordan',
      'level': 2,
      'points': 2000,
      'highlighted': false,
    },
    {
      'rank': 10,
      'name': 'Sofia',
      'level': 7,
      'points': 2000,
      'highlighted': false,
    },
  ].obs;

  final List<int> scores = [110, 570, 480, 390, 420, 510, 330, 600];

  void changeTimeFrame(String timeframe) {
    selectedTimeFrame.value = timeframe;
    // In a real app, you would fetch new data based on the selected timeframe
  }
}