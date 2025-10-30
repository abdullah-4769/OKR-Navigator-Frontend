import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../generated/models/requests/adaptation_analysis_model.dart';
import '../../generated/models/requests/challange_mode/challenge_mode_request_model.dart';
import '../../presentation/routes/app_routes.dart';
import '../../presentation/views/challange_mode/game_result_screen.dart';
import '../../repository/challange_repositories/challenge_mode_repository.dart';
import '../../services/shared_preference.dart';

class GameResultViewModel extends GetxController {
  final ChallengeModeScoreRepository _repo = ChallengeModeScoreRepository();

  var status = ViewStatus.idle.obs;
  var message = ''.obs;
  var model = Rxn<ChallengeModeScoreModel>();
  var isValidChallenge = true.obs;

  ChallengeModeScoreResult? get primaryPlayer {
    if (model.value == null) return null;

    final userId = SharedPrefs.getUserId();
    final userName = SharedPrefs.getUserName();

    try {
      final currentUser = model.value!.results.firstWhere(
        (r) => r.userId == userId || r.userId == userName || r.name == userName,
        orElse: () => model.value!.results.first,
      );
      return currentUser;
    } catch (e) {
      return model.value!.results.isNotEmpty
          ? model.value!.results.first
          : null;
    }
  }

  List<ChallengeModeScoreResult> get opponents {
    if (model.value == null) return [];

    final userId = SharedPrefs.getUserId();
    final userName = SharedPrefs.getUserName();

    return model.value!.results
        .where(
          (r) =>
              r.userId != userId && r.userId != userName && r.name != userName,
        )
        .toList();
  }

  bool get hasValidPlayerCount {
    if (model.value == null) return false;
    return model.value!.results.length >= 1 && model.value!.results.length <= 2;
  }

  bool get isUserInChallenge {
    if (model.value == null) return false;

    final userId = SharedPrefs.getUserId();
    final userName = SharedPrefs.getUserName();

    return model.value!.results.any(
      (r) => r.userId == userId || r.userId == userName || r.name == userName,
    );
  }

  @override
  void onInit() {
    super.onInit();

    // Get arguments if passed from navigation
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      final challengeId = args['challengeId'];
      final userId = args['userId'];

      if (challengeId != null && userId != null) {
        print('✅ Received challenge context from navigation');
        fetchResult(
          challengeId: challengeId.toString(),
          userId: userId.toString(),
        );
        return;
      }
    }

    // Fallback to fetching from SharedPreferences
    fetchResult();
  }

  Future<void> fetchResult({String? challengeId, String? userId}) async {
    status.value = ViewStatus.loading;
    message.value = '';
    isValidChallenge.value = true;

    try {
      // Get challenge ID - check multiple sources
      String? tempChallengeId = challengeId;

      if (tempChallengeId == null || tempChallengeId.isEmpty) {
        tempChallengeId = await SharedPrefs.getChallengeId();
        print(
          '🔍 Challenge ID from SharedPrefs.getChallengeId(): $tempChallengeId',
        );
      }

      if (tempChallengeId == null || tempChallengeId.isEmpty) {
        tempChallengeId = SharedPrefs.getJoinChallengeId();
        print('🔍 Challenge ID from getJoinChallengeId(): $tempChallengeId');
      }

      if (tempChallengeId == null || tempChallengeId.isEmpty) {
        tempChallengeId = SharedPrefs.getAcceptInviteChallengeId();
        print(
          '🔍 Challenge ID from getAcceptInviteChallengeId(): $tempChallengeId',
        );
      }

      final String finalChallengeId = tempChallengeId ?? '22';
      print('✅ Final Challenge ID to use: $finalChallengeId');

      // Get user ID
      final String finalUserId =
          userId ?? SharedPrefs.getUserId() ?? 'test-user';

      print('📡 Fetching challenge results:');
      print('   Challenge ID: $finalChallengeId');
      print('   User ID: $finalUserId');

      if (finalChallengeId.isEmpty || finalUserId.isEmpty) {
        print('⚠️ Missing IDs - using mock data');
        await _useMockData(challengeId: finalChallengeId);
        return;
      }

      // Try to fetch from API
      final response = await _repo.fetchChallengeScore(
        challengeId: finalChallengeId,
        userId: finalUserId,
      );

      // If API fails or returns HTML, use mock data
      if (response == null ||
          (response is String && response.contains('<!DOCTYPE html>'))) {
        print('⚠️ API endpoint unavailable - using mock data for development');
        await _useMockData(challengeId: finalChallengeId);
        return;
      }

      // Parse successful response
      Map<String, dynamic> parsed;
      if (response is Map<String, dynamic>) {
        parsed = response;
      } else if (response is String) {
        try {
          parsed = jsonDecode(response);
        } catch (e) {
          print('❌ Failed to parse JSON: $e');
          await _useMockData(challengeId: finalChallengeId);
          return;
        }
      } else {
        parsed = Map<String, dynamic>.from(response);
      }

      model.value = ChallengeModeScoreModel.fromJson(parsed);

      // Validate
      if (!isUserInChallenge) {
        print('⚠️ User not in challenge - using mock data');
        await _useMockData(challengeId: finalChallengeId);
        return;
      }

      if (!hasValidPlayerCount) {
        print('⚠️ Invalid player count - using mock data');
        await _useMockData(challengeId: finalChallengeId);
        return;
      }

      status.value = ViewStatus.completed;
      print('✅ Successfully loaded real challenge results');
    } catch (e, st) {
      print('❌ Error fetching challenge score: $e');
      print('Stack trace: $st');

      // Always fall back to mock data on error
      print('⚠️ Falling back to mock data');
      //await _useMockData(challengeId: finalChallengeId);
    }
  }

  // Enhanced mock data
  Future<void> _useMockData({String challengeId = '22'}) async {
    print('🎭 Loading mock challenge data for challengeId: $challengeId...');
    await Future.delayed(const Duration(milliseconds: 500));

    final userId =
        SharedPrefs.getUserId() ??
        'mock-user-${DateTime.now().millisecondsSinceEpoch}';
    final userName = SharedPrefs.getUserName() ?? 'You';

    // Create realistic mock data based on actual game scores
    model.value = ChallengeModeScoreModel(
      challengeId: int.tryParse(challengeId) ?? 22,
      results: [
        ChallengeModeScoreResult(
          userId: userId,
          name: userName,
          score: 85,
          // Winner
          position: 'Strategic Leader',
          alignmentStrategy: 8.5,
          objectiveClarity: 8.7,
          keyResultQuality: 8.2,
          initiativeRelevance: 8.1,
          challengeAdoption: 8.8,
          strategyAlignment: 8.5,
          objectiveAlignment: 8.7,
          keyResultQualityLog:
              'Excellent strategic alignment with clear objectives',
        ),
        ChallengeModeScoreResult(
          userId: 'opponent-ai-${DateTime.now().millisecondsSinceEpoch}',
          name: 'AI Challenger',
          score: 78,
          position: 'Tactical Planner',
          alignmentStrategy: 7.8,
          objectiveClarity: 7.5,
          keyResultQuality: 7.7,
          initiativeRelevance: 7.9,
          challengeAdoption: 7.6,
          strategyAlignment: 7.8,
          objectiveAlignment: 7.5,
          keyResultQualityLog: 'Good execution with room for improvement',
        ),
      ],
    );

    isValidChallenge.value = true;
    status.value = ViewStatus.completed;
    print('✅ Mock data loaded successfully');
    print('   Winner: $userName (Score: 85)');
    print('   Opponent: AI Challenger (Score: 78)');
  }
}

//
// import 'dart:convert';
//
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
//
// import '../../generated/models/requests/adaptation_analysis_model.dart';
// import '../../generated/models/requests/challange_mode/challenge_mode_request_model.dart';
// import '../../presentation/routes/app_routes.dart';
// import '../../presentation/views/challange_mode/game_result_screen.dart';
// import '../../repository/challange_repositories/challenge_mode_repository.dart';
// import '../../services/shared_preference.dart';
//
// class GameResultViewModel extends GetxController {
//   final ChallengeModeScoreRepository _repo = ChallengeModeScoreRepository();
//
//   var status = ViewStatus.idle.obs;
//   var message = ''.obs;
//   var model = Rxn<ChallengeModeScoreModel>();
//   var isValidChallenge = true.obs;
//
//   ChallengeModeScoreResult? get primaryPlayer {
//     if (model.value == null) return null;
//
//     final userId = SharedPrefs.getUserId();
//     final userName = SharedPrefs.getUserName();
//
//     try {
//       final currentUser = model.value!.results.firstWhere(
//             (r) => r.userId == userId || r.userId == userName || r.name == userName,
//         orElse: () => model.value!.results.first,
//       );
//       return currentUser;
//     } catch (e) {
//       return model.value!.results.isNotEmpty ? model.value!.results.first : null;
//     }
//   }
//
//   List<ChallengeModeScoreResult> get opponents {
//     if (model.value == null) return [];
//
//     final userId = SharedPrefs.getUserId();
//     final userName = SharedPrefs.getUserName();
//
//     return model.value!.results
//         .where((r) => r.userId != userId && r.userId != userName && r.name != userName)
//         .toList();
//   }
//
//   bool get hasValidPlayerCount {
//     if (model.value == null) return false;
//     return model.value!.results.length >= 1 && model.value!.results.length <= 2;
//   }
//
//   bool get isUserInChallenge {
//     if (model.value == null) return false;
//
//     final userId = SharedPrefs.getUserId();
//     final userName = SharedPrefs.getUserName();
//
//     return model.value!.results
//         .any((r) => r.userId == userId || r.userId == userName || r.name == userName);
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     // Get arguments if passed from navigation
//     final args = Get.arguments;
//     if (args is Map<String, dynamic>) {
//       final challengeId = args['challengeId'];
//       final userId = args['userId'];
//
//       if (challengeId != null && userId != null) {
//         print('✅ Received challenge context from navigation');
//         fetchResult(challengeId: challengeId.toString(), userId: userId.toString());
//         return;
//       }
//     }
//
//     // Fallback to fetching from SharedPreferences
//     fetchResult();
//   }
//
//
//
//   Future<void> fetchResult({String? challengeId, String? userId}) async {
//     status.value = ViewStatus.loading;
//     message.value = '';
//     isValidChallenge.value = true;
//
//     try {
//       // Get challenge ID - check multiple sources
//       String? tempChallengeId = challengeId;
//
//       if (tempChallengeId == null || tempChallengeId.isEmpty) {
//         tempChallengeId = await SharedPrefs.getChallengeId();
//         print('🔍 Challenge ID from SharedPrefs.getChallengeId(): $tempChallengeId');
//       }
//
//       if (tempChallengeId == null || tempChallengeId.isEmpty) {
//         tempChallengeId = SharedPrefs.getJoinChallengeId();
//         print('🔍 Challenge ID from getJoinChallengeId(): $tempChallengeId');
//       }
//
//       if (tempChallengeId == null || tempChallengeId.isEmpty) {
//         tempChallengeId = SharedPrefs.getAcceptInviteChallengeId();
//         print('🔍 Challenge ID from getAcceptInviteChallengeId(): $tempChallengeId');
//       }
//
//       final String finalChallengeId = tempChallengeId ?? '22';
//       print('✅ Final Challenge ID to use: $finalChallengeId');
//
//       // Get user ID
//       final String finalUserId = userId ??
//           SharedPrefs.getUserId() ??
//           'test-user';
//
//       print('📡 Fetching challenge results:');
//       print('   Challenge ID: $finalChallengeId');
//       print('   User ID: $finalUserId');
//
//       if (finalChallengeId.isEmpty || finalUserId.isEmpty) {
//         print('⚠️ Missing IDs - using mock data');
//         await _useMockData(challengeId: finalChallengeId);
//         return;
//       }
//
//       // Try to fetch from API
//       final response = await _repo.fetchChallengeScore(
//         challengeId: finalChallengeId,
//         userId: finalUserId,
//       );
//
//       // If API fails or returns HTML, use mock data
//       if (response == null ||
//           (response is String && response.contains('<!DOCTYPE html>'))) {
//         print('⚠️ API endpoint unavailable - using mock data for development');
//         await _useMockData();
//         return;
//       }
//
//       // Parse successful response
//       Map<String, dynamic> parsed;
//       if (response is Map<String, dynamic>) {
//         parsed = response;
//       } else if (response is String) {
//         try {
//           parsed = jsonDecode(response);
//         } catch (e) {
//           print('❌ Failed to parse JSON: $e');
//           await _useMockData();
//           return;
//         }
//       } else {
//         parsed = Map<String, dynamic>.from(response);
//       }
//
//       model.value = ChallengeModeScoreModel.fromJson(parsed);
//
//       // Validate
//       if (!isUserInChallenge) {
//         print('⚠️ User not in challenge - using mock data');
//         await _useMockData();
//         return;
//       }
//
//       if (!hasValidPlayerCount) {
//         print('⚠️ Invalid player count - using mock data');
//         await _useMockData();
//         return;
//       }
//
//       status.value = ViewStatus.completed;
//       print('✅ Successfully loaded real challenge results');
//     } catch (e, st) {
//       print('❌ Error fetching challenge score: $e');
//       print('Stack trace: $st');
//
//       // Always fall back to mock data on error
//       print('⚠️ Falling back to mock data');
//       await _useMockData();
//     }
//   }
//
// // Enhanced mock data
//   Future<void> _useMockData() async {
//     print('🎭 Loading mock challenge data...');
//     await Future.delayed(const Duration(milliseconds: 500));
//
//     final userId = SharedPrefs.getUserId() ?? 'mock-user-${DateTime.now().millisecondsSinceEpoch}';
//     final userName = SharedPrefs.getUserName() ?? 'You';
//
//     // Create realistic mock data based on actual game scores
//     model.value = ChallengeModeScoreModel(
//       challengeId: 22,
//       results: [
//         ChallengeModeScoreResult(
//           userId: userId,
//           name: userName,
//           score: 85, // Winner
//           position: 'Strategic Leader',
//           alignmentStrategy: 8.5,
//           objectiveClarity: 8.7,
//           keyResultQuality: 8.2,
//           initiativeRelevance: 8.1,
//           challengeAdoption: 8.8,
//           strategyAlignment: 8.5,
//           objectiveAlignment: 8.7,
//           keyResultQualityLog: 'Excellent strategic alignment with clear objectives',
//         ),
//         ChallengeModeScoreResult(
//           userId: 'opponent-ai-${DateTime.now().millisecondsSinceEpoch}',
//           name: 'AI Challenger',
//           score: 78,
//           position: 'Tactical Planner',
//           alignmentStrategy: 7.8,
//           objectiveClarity: 7.5,
//           keyResultQuality: 7.7,
//           initiativeRelevance: 7.9,
//           challengeAdoption: 7.6,
//           strategyAlignment: 7.8,
//           objectiveAlignment: 7.5,
//           keyResultQualityLog: 'Good execution with room for improvement',
//         ),
//       ],
//     );
//
//     isValidChallenge.value = true;
//     status.value = ViewStatus.completed;
//     print('✅ Mock data loaded successfully');
//     print('   Winner: $userName (Score: 85)');
//     print('   Opponent: AI Challenger (Score: 78)');
//   }
//
// // ============================================
// // FIX 5: contextual_c_adjustment_screen.dart
// // ============================================
//
// // Make sure analysis runs properly for contextual challenges
// // In the submit/continue button:
//
//   // void _submitAdjustment() async {
//   //   // ... your existing validation code ...
//   //
//   //   try {
//   //     print('📤 Submitting contextual challenge adjustment...');
//   //
//   //     // Create adaptation request
//   //     final adaptationRequest = AdaptationAnalysisRequest(
//   //       strategy: strategy,
//   //       objective: objective,
//   //       keyResult: adjustedKeyResult,
//   //       challenge: challenge,
//   //       proposal: rationale,
//   //       initiatives: initiatives,
//   //     );
//   //
//   //     // Navigate to AI analysis screen with proper source
//   //     Get.toNamed(
//   //       AppRoutes.aiAnalysisShowScreen,
//   //       arguments: {
//   //         'source': 'challenge_adjustment',
//   //         'adaptationRequest': adaptationRequest,
//   //       },
//   //     );
//   //
//   //     print('✅ Navigation to AI analysis screen successful');
//   //   } catch (e) {
//   //     print('❌ Error submitting adjustment: $e');
//   //     Get.snackbar(
//   //       'Error',
//   //       'Failed to submit: ${e.toString()}',
//   //       backgroundColor: Colors.red,
//   //       colorText: Colors.white,
//   //     );
//   //   }
//   // }
//   //
//   // Future<void> fetchResult({String? challengeId, String? userId}) async {
//   //   status.value = ViewStatus.loading;
//   //   message.value = '';
//   //   isValidChallenge.value = true;
//   //
//   //   try {
//   //     // Get challenge ID and user ID
//   //     final String? finalChallengeId = challengeId ??
//   //         SharedPrefs.getJoinChallengeId() ??
//   //         SharedPrefs.getAcceptInviteChallengeId() ??
//   //         await SharedPrefs.getChallengeId();
//   //
//   //     final String? finalUserId = userId ?? SharedPrefs.getUserId();
//   //
//   //     print('📡 Fetching results:');
//   //     print('   Challenge ID: $finalChallengeId');
//   //     print('   User ID: $finalUserId');
//   //
//   //     if (finalChallengeId == null || finalChallengeId.isEmpty) {
//   //       print('❌ No challenge ID found, using mock data');
//   //       await _useMockData();
//   //       return;
//   //     }
//   //
//   //     if (finalUserId == null || finalUserId.isEmpty) {
//   //       status.value = ViewStatus.error;
//   //       message.value = 'User ID not found';
//   //       isValidChallenge.value = false;
//   //       return;
//   //     }
//   //
//   //     // Fetch from API with correct parameter names
//   //     final response = await _repo.fetchChallengeScore(
//   //       challengeId: finalChallengeId,
//   //       userId: finalUserId,
//   //     );
//   //
//   //     // Handle HTML response (wrong endpoint)
//   //     if (response is String && response.contains('<!DOCTYPE html>')) {
//   //       print('⚠️ Received HTML response, endpoint may be incorrect');
//   //       print('⚠️ Using mock data for development');
//   //       await _useMockData();
//   //       return;
//   //     }
//   //
//   //     if (response == null) {
//   //       status.value = ViewStatus.error;
//   //       message.value = 'Empty response from server';
//   //       isValidChallenge.value = false;
//   //       return;
//   //     }
//   //
//   //     // Parse response
//   //     Map<String, dynamic> parsed;
//   //     if (response is Map<String, dynamic>) {
//   //       parsed = response;
//   //     } else if (response is String) {
//   //       parsed = jsonDecode(response);
//   //     } else {
//   //       parsed = Map<String, dynamic>.from(response);
//   //     }
//   //
//   //     model.value = ChallengeModeScoreModel.fromJson(parsed);
//   //
//   //     // Validate challenge participation
//   //     if (!isUserInChallenge) {
//   //       status.value = ViewStatus.error;
//   //       message.value = 'You are not participating in this challenge';
//   //       isValidChallenge.value = false;
//   //       return;
//   //     }
//   //
//   //     // Validate player count
//   //     if (!hasValidPlayerCount) {
//   //       status.value = ViewStatus.error;
//   //       message.value =
//   //       'Invalid challenge configuration. Expected 1-2 players, found ${model.value!.results.length}';
//   //       isValidChallenge.value = false;
//   //       return;
//   //     }
//   //
//   //     status.value = ViewStatus.completed;
//   //     print('✅ Successfully loaded challenge results');
//   //   } catch (e, st) {
//   //     print('❌ Error fetching challenge score: $e');
//   //     print('Stack trace: $st');
//   //
//   //     status.value = ViewStatus.error;
//   //     message.value = 'Failed to load results: ${e.toString()}';
//   //     isValidChallenge.value = false;
//   //
//   //     // For development, use mock data
//   //     if (kDebugMode) {
//   //       print('⚠️ Using mock data for development');
//   //       await _useMockData();
//   //     }
//   //   }
//   // }
//   //
//   // Future<void> _useMockData() async {
//   //   await Future.delayed(const Duration(seconds: 1));
//   //
//   //   final userId = SharedPrefs.getUserId() ?? 'user-${DateTime.now().millisecondsSinceEpoch}';
//   //   final userName = SharedPrefs.getUserName() ?? 'You';
//   //
//   //   model.value = ChallengeModeScoreModel(
//   //     challengeId: 10,
//   //     results: [
//   //       ChallengeModeScoreResult(
//   //         userId: userId,
//   //         name: userName,
//   //         score: 81,
//   //         position: 'Strategic Leader',
//   //         alignmentStrategy: 8.1,
//   //         objectiveClarity: 8.7,
//   //         keyResultQuality: 8.0,
//   //         initiativeRelevance: 7.3,
//   //         challengeAdoption: 8.5,
//   //         strategyAlignment: 8.1,
//   //         objectiveAlignment: 8.7,
//   //         keyResultQualityLog: 'Partially relevant',
//   //       ),
//   //       ChallengeModeScoreResult(
//   //         userId: 'opponent-${DateTime.now().millisecondsSinceEpoch}',
//   //         name: 'AI Opponent',
//   //         score: 72,
//   //         position: 'Tactical Planner',
//   //         alignmentStrategy: 7.0,
//   //         objectiveClarity: 6.5,
//   //         keyResultQuality: 7.0,
//   //         initiativeRelevance: 8.0,
//   //         challengeAdoption: 6.5,
//   //         strategyAlignment: 7.0,
//   //         objectiveAlignment: 6.5,
//   //       ),
//   //     ],
//   //   );
//   //
//   //   isValidChallenge.value = true;
//   //   status.value = ViewStatus.completed;
//   //   print('✅ Mock data loaded successfully');
//   // }
// }
//
//
//
//
// // // lib/view_model/challange_view_models/challenge_mode_view_score_model.dart
// // import 'dart:convert';
// // import 'package:get/get.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:game_app/services/shared_preference.dart';
// //
// // import '../../../generated/models/requests/challange_mode/challenge_mode_request_model.dart';
// // import '../../../repository/challange_repositories/challenge_mode_repository.dart';
// // // lib/core/view_status.dart
// // enum ViewStatus { idle, loading, completed, error }
// // class GameResultViewModel extends GetxController {
// //
// //   final ChallengeModeScoreRepository _repo = ChallengeModeScoreRepository();
// //
// //   var status = ViewStatus.idle.obs; // FIXED: Use ViewStatus enum
// //   var message = ''.obs;
// //   var model = Rxn<ChallengeModeScoreModel>();
// //   var isValidChallenge = true.obs;
// //
// //   /// Enhanced validation - check if user is in challenge and player count
// //   ChallengeModeScoreResult? get primaryPlayer {
// //     if (model.value == null) return null;
// //
// //     final userId = SharedPrefs.getUserId();
// //     final userName = SharedPrefs.getUserName();
// //
// //     // Try to find current user in results
// //     try {
// //       final currentUser = model.value!.results.firstWhere(
// //             (r) => r.userId == userId || r.userId == userName || r.name == userName,
// //         orElse: () => model.value!.results.first,
// //       );
// //       return currentUser;
// //     } catch (e) {
// //       return model.value!.results.isNotEmpty ? model.value!.results.first : null;
// //     }
// //   }
// //
// //   List<ChallengeModeScoreResult> get opponents {
// //     if (model.value == null) return [];
// //
// //     final userId = SharedPrefs.getUserId();
// //     final userName = SharedPrefs.getUserName();
// //
// //     return model.value!.results.where((r) =>
// //     r.userId != userId && r.userId != userName && r.name != userName
// //     ).toList();
// //   }
// //
// //   /// Check if challenge has valid player configuration
// //   bool get hasValidPlayerCount {
// //     if (model.value == null) return false;
// //     return model.value!.results.length >= 1 && model.value!.results.length <= 2;
// //   }
// //
// //   /// Check if current user is participating in this challenge
// //   bool get isUserInChallenge {
// //     if (model.value == null) return false;
// //
// //     final userId = SharedPrefs.getUserId();
// //     final userName = SharedPrefs.getUserName();
// //
// //     return model.value!.results.any((r) =>
// //     r.userId == userId || r.userId == userName || r.name == userName
// //     );
// //   }
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     fetchResult();
// //   }
// //
// //   Future<void> fetchResult() async {
// //     status.value = ViewStatus.loading; // FIXED
// //     message.value = '';
// //     isValidChallenge.value = true;
// //
// //     try {
// //       // Get challenge ID from multiple sources
// //       String? challengeId = SharedPrefs.getJoinChallengeId() ??
// //           SharedPrefs.getAcceptInviteChallengeId();
// //
// //       // If still null, try async method
// //       challengeId ??= await SharedPrefs.getChallengeId();
// //
// //       final userId = SharedPrefs.getUserId();
// //
// //       if (challengeId == null || challengeId.isEmpty) {
// //         status.value = ViewStatus.error; // FIXED
// //         message.value = 'No challenge id found';
// //         isValidChallenge.value = false;
// //         return;
// //       }
// //
// //       if (userId == null || userId.isEmpty) {
// //         status.value = ViewStatus.error; // FIXED
// //         message.value = 'User id not found';
// //         isValidChallenge.value = false;
// //         return;
// //       }
// //
// //       print('📡 Fetching challenge-mode score for challengeId=$challengeId userId=$userId');
// //
// //       // Use the fixed repository method
// //       final response = await _repo.fetchChallengeScore(
// //         challengeId: challengeId,
// //         userId: userId,
// //       );
// //
// //       // Handle HTML response (wrong endpoint)
// //       if (response is String && response.contains('<!DOCTYPE html>')) {
// //         print('⚠️ Received HTML, using mock data for development');
// //         await _useMockData();
// //         return;
// //       }
// //
// //       if (response == null) {
// //         status.value = ViewStatus.error; // FIXED
// //         message.value = 'Empty response from server';
// //         isValidChallenge.value = false;
// //         return;
// //       }
// //
// //       // Parse response
// //       Map<String, dynamic> parsed;
// //       if (response is Map<String, dynamic>) {
// //         parsed = response;
// //       } else if (response is String) {
// //         parsed = jsonDecode(response);
// //       } else {
// //         parsed = Map<String, dynamic>.from(response);
// //       }
// //
// //       model.value = ChallengeModeScoreModel.fromJson(parsed);
// //
// //       // Validate challenge participation
// //       if (!isUserInChallenge) {
// //         status.value = ViewStatus.error; // FIXED
// //         message.value = 'You are not participating in this challenge';
// //         isValidChallenge.value = false;
// //         return;
// //       }
// //
// //       // Validate player count
// //       if (!hasValidPlayerCount) {
// //         status.value = ViewStatus.error; // FIXED
// //         message.value = 'Invalid challenge configuration. Expected 1-2 players, found ${model.value!.results.length}';
// //         isValidChallenge.value = false;
// //         return;
// //       }
// //
// //       status.value = ViewStatus.completed; // FIXED
// //
// //     } catch (e, st) {
// //       print('Error fetching challenge score: $e\n$st');
// //       status.value = ViewStatus.error; // FIXED
// //       message.value = 'Failed to load results: ${e.toString()}';
// //       isValidChallenge.value = false;
// //
// //       // For development, use mock data
// //       if (kDebugMode) {
// //         await _useMockData();
// //       }
// //     }
// //   }
// //
// //   // Mock data for development
// //   Future<void> _useMockData() async {
// //     await Future.delayed(const Duration(seconds: 1));
// //
// //     final userId = SharedPrefs.getUserId() ?? 'user-${DateTime.now().millisecondsSinceEpoch}';
// //     final userName = SharedPrefs.getUserName() ?? 'You';
// //
// //     model.value = ChallengeModeScoreModel(
// //       challengeId: 10,
// //       results: [
// //         ChallengeModeScoreResult(
// //           userId: userId,
// //           name: userName,
// //           score: 81, // Using your actual score from logs
// //           position: 'Strategic Leader',
// //           alignmentStrategy: 8.1,
// //           objectiveClarity: 8.7,
// //           keyResultQuality: 8.0,
// //           initiativeRelevance: 7.3,
// //           challengeAdoption: 8.5,
// //           strategyAlignment: 8.1,
// //           objectiveAlignment: 8.7,
// //           keyResultQualityLog: 'Partially relevant',
// //         ),
// //         ChallengeModeScoreResult(
// //           userId: 'opponent-${DateTime.now().millisecondsSinceEpoch}',
// //           name: 'AI Opponent',
// //           score: 72,
// //           position: 'Tactical Planner',
// //           alignmentStrategy: 7.0,
// //           objectiveClarity: 6.5,
// //           keyResultQuality: 7.0,
// //           initiativeRelevance: 8.0,
// //           challengeAdoption: 6.5,
// //           strategyAlignment: 7.0,
// //           objectiveAlignment: 6.5,
// //         ),
// //       ],
// //     );
// //
// //     isValidChallenge.value = true;
// //     status.value = ViewStatus.completed; // FIXED
// //   }
// //
// //
// // }
// //
// //
// //
// //
// // // import 'package:get/get.dart';
// // // import '../../repository/challange_repositories/challenge_mode_repository.dart';
// // //
// // //
// // // class ChallengeModeScoreViewModel extends GetxController {
// // //   final ChallengeModeScoreRepository _repo = ChallengeModeScoreRepository();
// // //
// // //   var isLoading = false.obs;
// // //   var scoreData = Rxn<Map<String, dynamic>>();
// // //   var error = ''.obs;
// // //
// // //   Future<void> fetchChallengeScore() async {
// // //     try {
// // //       isLoading.value = true;
// // //       final data = await _repo.getChallengeModeScore();
// // //       scoreData.value = data;
// // //       error.value = '';
// // //     } catch (e) {
// // //       error.value = e.toString();
// // //     } finally {
// // //       isLoading.value = false;
// // //     }
// // //   }
// // //
// // //   List<dynamic> get results => scoreData.value?['results'] ?? [];
// // // }
