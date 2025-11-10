import 'package:get/get.dart';

import '../../data/repositories/score_board_repo.dart';
import '../../generated/models/responses/dashboard_for_all/dashboard_all.dart';

enum GameMode { solo, team, campaign, challenge }

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
    print('ScoreboardController initialized');
    fetchScoreboard();
  }

  void changeMode(GameMode mode) {
    selectedMode.value = mode;
    print('Mode changed to: ${getModeName()}');
    fetchScoreboard();
  }

  Future<void> fetchScoreboard() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      topThree.clear();
      remaining.clear();
      userDetails.value = null;

      print('Fetching scoreboard for mode: ${getModeName()}');

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

      print('Scoreboard fetch complete for ${getModeName()}');
      print('Top 3 count: ${topThree.length}');
      print('Remaining count: ${remaining.length}');
      if (userDetails.value != null) {
        print('User details fetched: ${userDetails.value}');
      } else {
        print('No user details found.');
      }

    } catch (e) {
      errorMessage.value = e.toString();
      print('Error fetching scoreboard for ${getModeName()}: $e');
    } finally {
      isLoading.value = false;
      print('Loading state set to false for ${getModeName()}');
    }
  }

  // ======================= FETCH METHODS WITH SORTING =======================
  Future<void> _fetchSoloScoreboard() async {
    print('Calling getSoloScoreboard API for userId: $userId');
    final data = await _repository.getSoloScoreboard(userId);
    if (data != null) {
      topThree.value = data.topThree ?? [];
      remaining.value = data.remaining ?? [];
      userDetails.value = data.userDetails;
      _sortAndAssignPlayers(); // <-- SORT HERE
    } else {
      print('Solo API returned null data');
    }
  }

  Future<void> _fetchTeamScoreboard() async {
    print('Calling getTeamScoreboard API for userId: $userId');
    final data = await _repository.getTeamScoreboard(userId);
    if (data != null) {
      topThree.value = data.topThree ?? [];
      remaining.value = data.remaining ?? [];
      userDetails.value = data.userDetails;
      _sortAndAssignPlayers(); // <-- SORT HERE
    } else {
      print('Team API returned null data');
    }
  }

  Future<void> _fetchCampaignScoreboard() async {
    print('Calling getCampaignScoreboard API for campaignId: $campaignId');
    final data = await _repository.getCampaignScoreboard(campaignId);
    if (data != null) {
      topThree.value = data.topThree ?? [];
      remaining.value = data.remaining ?? [];
      userDetails.value = data.userDetails;
      _sortAndAssignPlayers(); // <-- SORT HERE
    } else {
      print('Campaign API returned null data');
    }
  }

  Future<void> _fetchChallengeScoreboard() async {
    print('Calling getChallengeScoreboard API for userId: $userId');
    final data = await _repository.getChallengeScoreboard(userId);
    if (data != null) {
      topThree.value = data.topThree ?? [];
      remaining.value = data.remaining ?? [];
      userDetails.value = data.userDetails;
      _sortAndAssignPlayers(); // <-- SORT HERE
    } else {
      print('Challenge API returned null data');
    }
  }

  // ======================= SORTING LOGIC =======================
  void _sortAndAssignPlayers() {
    final allPlayers = <PlayerModel>[];
    allPlayers.addAll(topThree);
    allPlayers.addAll(remaining);

    // Sort by totalScore DESC (null-safe)
    allPlayers.sort((a, b) {
      final scoreA = a.totalScore ?? 0;
      final scoreB = b.totalScore ?? 0;
      return scoreB.compareTo(scoreA);
    });

    // Re-assign top 3 and remaining
    topThree.assignAll(allPlayers.take(3).toList());
    remaining.assignAll(allPlayers.skip(3).toList());

    // Optional: Re-compute rank if backend doesn't send it
    for (int i = 0; i < allPlayers.length; i++) {
      allPlayers[i].rank = i + 1;
    }
  }

  // ======================= GETTERS =======================
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

