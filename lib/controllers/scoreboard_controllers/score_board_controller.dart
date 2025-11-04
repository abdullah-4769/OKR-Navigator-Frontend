import 'package:get/get.dart';

import '../../data/repositories/score_board_repo.dart';
import '../../generated/models/responses/dashboard_for_all/dashboard_all.dart';enum GameMode { solo, team, campaign, challenge }

class ScoreboardController extends GetxController {
  final ScoreboardRepository _repository = ScoreboardRepository();

  final Rx<GameMode> selectedMode = GameMode.solo.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxList<PlayerModel> topThree = <PlayerModel>[].obs;
  final RxList<PlayerModel> remaining = <PlayerModel>[].obs;
  final Rx<PlayerModel?> userDetails = Rx<PlayerModel?>(null);

  final String userId = "user123";
  final String campaignId = "campaign123";

  @override
  void onInit() {
    super.onInit();
    print('🔹 ScoreboardController initialized');
    fetchScoreboard();
  }

  void changeMode(GameMode mode) {
    selectedMode.value = mode;
    print('🔹 Mode changed to: ${getModeName()}');
    fetchScoreboard();
  }

  Future<void> fetchScoreboard() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      topThree.clear();
      remaining.clear();
      userDetails.value = null;

      print('🚀 Fetching scoreboard for mode: ${getModeName()}');

      switch (selectedMode.value) {
        case GameMode.solo:
          await _fetchSoloScoreboard();
          break;
        case GameMode.team:
          await _fetchTeamScoreboard();
          break;
        case GameMode.campaign:
          await _fetchCampaignScoreboard();
          break;
        case GameMode.challenge:
          await _fetchChallengeScoreboard();
          break;
      }

      print('✅ Scoreboard fetch complete for ${getModeName()}');
      print('🏅 Top 3 count: ${topThree.length}');
      print('📋 Remaining count: ${remaining.length}');
      if (userDetails.value != null) {
        print('👤 User details fetched: ${userDetails.value}');
      } else {
        print('⚠️ No user details found.');
      }

    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ Error fetching scoreboard for ${getModeName()}: $e');
    } finally {
      isLoading.value = false;
      print('🕒 Loading state set to false for ${getModeName()}');
    }
  }

  Future<void> _fetchSoloScoreboard() async {
    print('📡 Calling getSoloScoreboard API for userId: $userId');
    final data = await _repository.getSoloScoreboard(userId);
    if (data != null) {
      print('✅ Solo API success: received data');
      topThree.value = data.topThree ?? [];
      remaining.value = data.remaining ?? [];
      userDetails.value = data.userDetails;
    } else {
      print('⚠️ Solo API returned null data');
    }
  }

  Future<void> _fetchTeamScoreboard() async {
    print('📡 Calling getTeamScoreboard API for userId: $userId');
    final data = await _repository.getTeamScoreboard(userId);
    if (data != null) {
      print('✅ Team API success: received data');
      topThree.value = data.topThree ?? [];
      remaining.value = data.remaining ?? [];
      userDetails.value = data.userDetails;
    } else {
      print('⚠️ Team API returned null data');
    }
  }

  Future<void> _fetchCampaignScoreboard() async {
    print('📡 Calling getCampaignScoreboard API for campaignId: $campaignId');
    final data = await _repository.getCampaignScoreboard(campaignId);
    if (data != null) {
      print('✅ Campaign API success: received data');
      topThree.value = data.topThree ?? [];
      remaining.value = data.remaining ?? [];
      userDetails.value = data.userDetails;
    } else {
      print('⚠️ Campaign API returned null data');
    }
  }

  Future<void> _fetchChallengeScoreboard() async {
    print('📡 Calling getChallengeScoreboard API for userId: $userId');
    final data = await _repository.getChallengeScoreboard(userId);
    if (data != null) {
      print('✅ Challenge API success: received data');
      topThree.value = data.topThree ?? [];
      remaining.value = data.remaining ?? [];
      userDetails.value = data.userDetails;
    } else {
      print('⚠️ Challenge API returned null data');
    }
  }

  List<PlayerModel> get allPlayers {
    final List<PlayerModel> all = [];
    all.addAll(topThree);
    all.addAll(remaining);
    return all;
  }

  String getModeName() {
    switch (selectedMode.value) {
      case GameMode.solo:
        return 'Solo';
      case GameMode.team:
        return 'Team';
      case GameMode.campaign:
        return 'Campaign';
      case GameMode.challenge:
        return 'Challenge';
    }
  }
}

// controllers/scoreboard_controller.dart
/*import 'package:get/get.dart';

class ScoreboardController extends GetxController {
  final RxString selectedTimeFrame = 'Today'.obs;
  final List<String> timeFrames = ['Solo', 'Team', 'Campaign','Challenge'];

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
}*/