import 'package:get/get.dart';
import 'package:game_app/utils/snackbar_helper.dart'; 
import 'dart:developer'; 

class TeamScoreboardController extends GetxController {
  final RxString selectedTimeFrame = 'Today'.obs;
  final List<String> timeFrames = ['Today', 'This Week', 'This Month'];

  final RxList<Map<String, dynamic>> leaderboard = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load leaderboard data for the initial timeframe
    fetchLeaderboard(); 
  }
  
  // Method to fetch live data (simulated API call)
  Future<void> fetchLeaderboard() async {
      // In a real application, this method would use a dedicated API endpoint, 
      // like: await _teamRepository.fetchLeaderboard(selectedTimeFrame.value);
      
      try {
          log('Fetching leaderboard for: ${selectedTimeFrame.value}');
          await Future.delayed(const Duration(milliseconds: 700));
          
          // --- Dynamic Mock API Response (REPLACING STATIC DATA) ---
          final mockApiResponse = _generateMockLeaderboard(selectedTimeFrame.value);

          // Update observable with API results
          leaderboard.assignAll(mockApiResponse);
          SnackbarHelper.success('Team Leaderboard loaded for ${selectedTimeFrame.value}!');
      } catch (e) {
          log('Leaderboard fetch error: $e');
          SnackbarHelper.error('Failed to load leaderboard data.');
          leaderboard.clear();
      }
  }

  // Helper to generate different lists per timeframe (for fidelity)
  List<Map<String, dynamic>> _generateMockLeaderboard(String timeframe) {
      if (timeframe == 'This Week') {
           return [
              {'rank': 1, 'name': 'Team Delta', 'level': 8, 'points': 8000, 'score': 900, 'highlighted': false},
              {'rank': 2, 'name': 'Team Alpha', 'level': 7, 'points': 7500, 'score': 850, 'highlighted': false},
              {'rank': 3, 'name': 'You', 'level': 1, 'points': 2000, 'score': 650, 'highlighted': true},
              {'rank': 4, 'name': 'Team Echo', 'level': 5, 'points': 5000, 'score': 600, 'highlighted': false},
          ];
      }
      // Default / Today
      return [
          {'rank': 1, 'name': 'Team Warriors', 'level': 6, 'points': 4500, 'score': 720, 'highlighted': false},
          {'rank': 2, 'name': 'Team Queens', 'level': 5, 'points': 4200, 'score': 700, 'highlighted': false},
          {'rank': 3, 'name': 'Team Titans', 'level': 4, 'points': 3500, 'score': 650, 'highlighted': false},
          {'rank': 4, 'name': 'Team Mavericks', 'level': 3, 'points': 3000, 'score': 600, 'highlighted': false},
          {'rank': 32, 'name': 'You', 'level': 1, 'points': 2000, 'score': 110, 'highlighted': true}, 
      ];
  }


  void changeTimeFrame(String timeframe) {
    selectedTimeFrame.value = timeframe;
    fetchLeaderboard(); // Refetch data based on the new timeframe
  }
}
