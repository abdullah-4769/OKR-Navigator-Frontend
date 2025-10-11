import 'package:get/get.dart';

class TeamScoreboardController extends GetxController {
  final RxString selectedTimeFrame = 'Today'.obs;
  final List<String> timeFrames = ['Today', 'This Week', 'This Month'];

  final RxList<Map<String, dynamic>> leaderboard = <Map<String, dynamic>>[
    {'rank': 32, 'name': 'You', 'level': 1, 'points': 2000, 'score': 110, 'highlighted': true},
    {'rank': 4, 'name': 'Team Queens', 'level': 5, 'points': 2000, 'score': 570},
    {'rank': 5, 'name': 'Team Titans', 'level': 4, 'points': 1500, 'score': 450},
    {'rank': 7, 'name': 'Team Mavericks', 'level': 3, 'points': 1000, 'score': 300},
    {'rank': 6, 'name': 'Team Warriors', 'level': 6, 'points': 3000, 'score': 292},
    {'rank': 8, 'name': 'Team Legends', 'level': 2, 'points': 750, 'score': 254},
    {'rank': 9, 'name': 'Team Innovators', 'level': 7, 'points': 4000, 'score': 180},
    {'rank': 10, 'name': 'Team Pioneers', 'level': 1, 'points': 500, 'score': 178},
  ].obs;

  void changeTimeFrame(String timeframe) {
    selectedTimeFrame.value = timeframe;
    // fetch/update data based on timeframe if needed
  }
}
