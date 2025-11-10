import 'package:get/get.dart';
import 'package:game_app/data/response/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/response/status.dart';
import '../../repository/challange_repositories/challengers_vs_repository.dart';

class ShowChallengersVsViewModel extends GetxController {
  final ShowChallengersVsRepository _repository = ShowChallengersVsRepository();

  var challengers = ApiResponse.loading().obs;
  String? challengeId;

  @override
  void onInit() {
    super.onInit();
    _loadChallengeId();
  }

  Future<void> _loadChallengeId() async {
    final prefs = await SharedPreferences.getInstance();

    // Check all possible keys in priority order
    challengeId = prefs.getString('acceptInviteChallengeId') ??
        prefs.getString('acceptChallengeId') ??
        prefs.getString('joinChallengeId') ??
        prefs.getString('challengeId');

    if (challengeId != null) {
      print('✅ Loaded challengeId for VS screen: $challengeId');
      await fetchChallengePlayers(challengeId!);
    } else {
      print('⚠️ No challengeId found in SharedPreferences');
      challengers.value = ApiResponse.error("No challenge ID found");
    }
  }

  Future<void> fetchChallengePlayers(String challengeId) async {
    try {
      challengers.value = ApiResponse.loading();
      print('📡 Fetching players for challengeId: $challengeId');

      final response = await _repository.getChallengePlayers(challengeId);
      challengers.value = response;

      print('✅ Players fetched successfully - Count: ${(response.data as List).length}');

      // Debug: Print player details
      if (response.status == Status.completed) {
        final players = response.data as List<dynamic>;
        for (int i = 0; i < players.length; i++) {
          final player = players[i] as Map<String, dynamic>;
          print('🎯 Player $i: ${player['name']} - ID: ${player['id']}');
        }
      }
    } catch (e) {
      print('❌ Error fetching players: $e');
      challengers.value = ApiResponse.error(e.toString());
    }
  }
}
// import 'package:get/get.dart';
// import 'package:game_app/data/response/api_response.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../repository/challange_repositories/challengers_vs_repository.dart';
//
// class ShowChallengersVsViewModel extends GetxController {
//   final ShowChallengersVsRepository _repository = ShowChallengersVsRepository();
//
//   var challengers = ApiResponse.loading().obs;
//   String? challengeId;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _loadChallengeId();
//   }
//
//   Future<void> _loadChallengeId() async {
//     final prefs = await SharedPreferences.getInstance();
//
//     // ✅ Check all possible keys in priority order
//     challengeId = prefs.getString('acceptInviteChallengeId') ??
//         prefs.getString('acceptChallengeId') ??
//         prefs.getString('joinChallengeId') ??
//         prefs.getString('challengeId');
//
//     if (challengeId != null) {
//       print('✅ Loaded challengeId for VS screen: $challengeId');
//       fetchChallengePlayers(challengeId!);
//     } else {
//       print('⚠ No challengeId found in SharedPreferences');
//       challengers.value = ApiResponse.error("No challenge ID found");
//     }
//   }
//
//   Future<void> fetchChallengePlayers(String challengeId) async {
//     try {
//       challengers.value = ApiResponse.loading();
//       print('📡 Fetching players for challengeId: $challengeId');
//
//       final response = await _repository.getChallengePlayers(challengeId);
//       challengers.value = response;
//
//       print('✅ Players fetched successfully');
//     } catch (e) {
//       print('❌ Error fetching players: $e');
//       challengers.value = ApiResponse.error(e.toString());
//     }
//   }
// }

// import 'package:get/get.dart';
// import 'package:game_app/data/response/api_response.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../repository/challange_repositories/challengers_vs_repository.dart';
//
// class ShowChallengersVsViewModel extends GetxController {
//   final ShowChallengersVsRepository _repository = ShowChallengersVsRepository();
//
//   var challengers = ApiResponse.loading().obs;
//   String? challengeId;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _loadChallengeId();
//   }
//
//   Future<void> _loadChallengeId() async {
//     final prefs = await SharedPreferences.getInstance();
//
//     // ✅ Check all possible keys in priority order
//     challengeId = prefs.getString('acceptInviteChallengeId') ??
//         prefs.getString('acceptChallengeId') ??
//         prefs.getString('joinChallengeId') ??
//         prefs.getString('challengeId');
//
//     if (challengeId != null) {
//       print('✅ Loaded challengeId for VS screen: $challengeId');
//       fetchChallengePlayers(challengeId!);
//     } else {
//       print('⚠️ No challengeId found in SharedPreferences');
//       challengers.value = ApiResponse.error("No challenge ID found");
//     }
//   }
//
//   Future<void> fetchChallengePlayers(String challengeId) async {
//     try {
//       challengers.value = ApiResponse.loading();
//       print('📡 Fetching players for challengeId: $challengeId');
//
//       final response = await _repository.getChallengePlayers(challengeId);
//       challengers.value = response;
//
//       print('✅ Players fetched successfully');
//     } catch (e) {
//       print('❌ Error fetching players: $e');
//       challengers.value = ApiResponse.error(e.toString());
//     }
//   }
// }
