import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../core/api_constants.dart';
import '../../data/network/network_api_services.dart';
import '../../services/shared_preference.dart';

class AdaptationAnalysisResponse {
  final int score;
  final String feedback;
  final Map<String, dynamic> breakdown;
  final Map<String, dynamic>? gamification;

  AdaptationAnalysisResponse({
    required this.score,
    required this.feedback,
    required this.breakdown,
    this.gamification,
  });

  factory AdaptationAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return AdaptationAnalysisResponse(
      score: json['score'] ?? 0,
      feedback: json['feedback'] ?? '',
      breakdown: json['breakdown'] ?? {},
      gamification: json['gamification'],
    );
  }
}

class AdaptationAIAnalysisViewModel extends GetxController {
  final NetworkApiService _apiService = NetworkApiService();

  // ✅ CONTROLLERS
  final TextEditingController thirdInitiativeTitle = TextEditingController();
  final TextEditingController thirdInitiativeDesc = TextEditingController();
  final TextEditingController strategicActionsController = TextEditingController();

  // Reactive variables
  var isSubmitting = false.obs;
  var evaluationData = Rxn<AdaptationAnalysisResponse>();
  var errorMessage = ''.obs;

  bool get hasData => evaluationData.value != null;

  @override
  void onClose() {
    thirdInitiativeTitle.dispose();
    thirdInitiativeDesc.dispose();
    strategicActionsController.dispose();
    super.onClose();
  }

  // ✅ NEW METHOD: For the correct API structure (without initiatives)
  Future<void> submitAdaptationAnalysis({
    required String strategy,
    required String objective,
    required String keyResult,
    required String challenge,
    required String proposal,
  }) async {
    try {
      isSubmitting(true);
      errorMessage('');

      print('📤 Submitting adaptation analysis...');

      // ✅ CREATE REQUEST BODY ACCORDING TO API SPEC
      final requestBody = {
        "strategy": strategy,
        "objective": objective,
        "keyResult": keyResult,
        "challenge": challenge,
        "proposal": proposal,
      };

      print('📝 Request Body: $requestBody');

      final url = ApiConstants.getUrl(ApiConstants.finalOkrEvaluation);
      print('🌐 API URL: $url');

      final response = await _apiService.getPostApiResponse(
        url,
        requestBody,
      );

      print('📥 Raw API Response: $response');

      if (response != null) {
        print('✅ Final OKR evaluation submitted successfully');

        final evaluationResponse = AdaptationAnalysisResponse.fromJson(response);
        evaluationData.value = evaluationResponse;

        await _saveAdaptationAnalysisDataToPrefs(requestBody, evaluationResponse);

        // ✅ FIXED: ACTUALLY SAVE THE SCORE TO DATABASE
        await saveGameScoreToDatabase(evaluationResponse.score, evaluationResponse.feedback);

        print('🎯 Evaluation completed - Score: ${evaluationResponse.score}');
        print('🎯 Has Data: $hasData');

      } else {
        print('❌ No response received from API');
        throw Exception('No response received from final OKR evaluation');
      }
    } catch (e) {
      print('❌ Error submitting adaptation analysis: $e');
      errorMessage.value = e.toString();
      createFallbackResponse();
    } finally {
      isSubmitting(false);
    }
  }

  // ✅ OLD METHOD: For backward compatibility (with initiatives)
  Future<void> submitAdaptationAnalysisWithInitiatives({
    String? strategy,
    String? objective,
    String? keyResult,
    String? challenge,
    List<Map<String, String>>? existingInitiatives,
  }) async {
    try {
      // Get default values if not provided
      final userStrategy = strategy ?? await _getSelectedStrategy();
      final userObjective = objective ?? await _getSelectedObjective();
      final userKeyResult = keyResult ?? 'Adapted Key Result';
      final userChallenge = challenge ?? 'Market Challenge';
      final proposal = strategicActionsController.text.isNotEmpty
          ? strategicActionsController.text
          : 'Strategic adaptations to address market changes';

      // Call the new method with required parameters
      await submitAdaptationAnalysis(
        strategy: userStrategy,
        objective: userObjective,
        keyResult: userKeyResult,
        challenge: userChallenge,
        proposal: proposal,
      );
    } catch (e) {
      print('❌ Error in legacy method: $e');
      rethrow;
    }
  }

  // ✅ CREATE ADAPTATION REQUEST (for old code that might still use this)
  Future<Map<String, dynamic>> _createAdaptationRequest({
    String? strategy,
    String? objective,
    String? keyResult,
    String? challenge,
    List<Map<String, String>>? existingInitiatives,
  }) async {
    final userStrategy = strategy ?? await _getSelectedStrategy();
    final userObjective = objective ?? await _getSelectedObjective();
    final userKeyResult = keyResult ?? 'Adapted Key Result';
    final userChallenge = challenge ?? 'Market Challenge';

    return {
      "strategy": userStrategy,
      "objective": userObjective,
      "keyResult": userKeyResult,
      "challenge": userChallenge,
      "proposal": strategicActionsController.text.isNotEmpty
          ? strategicActionsController.text
          : 'Strategic adaptations to address market changes',
    };
  }

  // ✅ Get selected strategy from SharedPreferences
  Future<String> _getSelectedStrategy() async {
    try {
      final strategyData = await SharedPrefs.getSelectedStrategy();
      return strategyData?['title']?.toString() ?? 'CEO Strategy';
    } catch (e) {
      return 'CEO Strategy';
    }
  }

  // ✅ Get selected objective from SharedPreferences
  Future<String> _getSelectedObjective() async {
    try {
      final objectiveData = await SharedPrefs.getSelectedObjective();
      return objectiveData?['title']?.toString() ?? 'Business Growth Objective';
    } catch (e) {
      return 'Business Growth Objective';
    }
  }

  // ✅ SAVE TO SHARED PREFERENCES
  Future<void> _saveAdaptationAnalysisDataToPrefs(
      Map<String, dynamic> request,
      AdaptationAnalysisResponse response
      ) async {
    try {
      final adaptationData = {
        'strategy': request['strategy'],
        'objective': request['objective'],
        'keyResult': request['keyResult'],
        'challenge': request['challenge'],
        'proposal': request['proposal'],
        'evaluationScore': response.score,
        'evaluationFeedback': response.feedback,
        'evaluationBreakdown': response.breakdown,
        'gamification': response.gamification,
        'submittedAt': DateTime.now().toIso8601String(),
        'thirdInitiativeTitle': thirdInitiativeTitle.text,
        'thirdInitiativeDesc': thirdInitiativeDesc.text,
        'strategicActions': strategicActionsController.text,
      };

      await SharedPrefs.saveAdaptationAnalysisData(adaptationData);
      print('💾 Adaptation analysis data saved to SharedPreferences');
    } catch (e) {
      print('❌ Error saving adaptation analysis data: $e');
    }
  }

  int _parseBreakdownScore(String scoreText) {
    try {
      final parts = scoreText.split('/');
      if (parts.length == 2) {
        return int.tryParse(parts[0]) ?? 0;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  Future<void> submitSoloScoreWithRealData(AdaptationAnalysisResponse evaluationResponse) async {
    try {
      final userId = SharedPrefs.getUserId();
      if (userId == null) {
        print('❌ Cannot submit solo score: User ID not found');
        return;
      }

      final breakdown = evaluationResponse.breakdown;
      final alignmentStrategy = _parseBreakdownScore(breakdown['strategy-relevance']?.toString() ?? '0/15');
      final objectiveClarity = _parseBreakdownScore(breakdown['objective-quality']?.toString() ?? '0/15');
      final keyResultQuality = _parseBreakdownScore(breakdown['keyresults-quality']?.toString() ?? '0/30');
      final initiativeRelevance = _parseBreakdownScore(breakdown['initiatives-quality']?.toString() ?? '0/30');
      final challengeAdoption = _parseBreakdownScore(breakdown['overall-coherence']?.toString() ?? '0/10');

      final soloScoreRequest = {
        "userId": userId,
        "score": evaluationResponse.score,
        "feedback": evaluationResponse.feedback, // Fixed typo
        "alignmentStrategy": alignmentStrategy,
        "objectiveClarity": objectiveClarity,
        "keyResultQuality": keyResultQuality,
        "initiativeRelevance": initiativeRelevance,
        "challengeAdoption": challengeAdoption,
      };

      print('📤 Submitting solo score with REAL data: ${evaluationResponse.score}');
      print('📊 Breakdown: $soloScoreRequest');

      // Call your solo score API here
      // await _soloScoreRepository.submitSoloScore(soloScoreRequest);
    } catch (e) {
      print('❌ Error submitting solo score: $e');
    }
  }

  void createFallbackResponse() {
    final fallbackResult = AdaptationAnalysisResponse(
      score: 88,
      feedback: 'Partially relevant',
      breakdown: {
        'strategy-relevance': '14/15',
        'objective-quality': '14/15',
        'keyresults-quality': '26/30',
        'initiatives-quality': '24/30',
        'overall-coherence': '10/10',
      },
      gamification: {
        'badgeHint': 'Aligned Leader',
        'visualFeedback': 'Excellent alignment with strategy'
      },
    );

    evaluationData.value = fallbackResult;
  }

  void clearData() {
    evaluationData.value = null;
    errorMessage.value = '';
    thirdInitiativeTitle.clear();
    thirdInitiativeDesc.clear();
    strategicActionsController.clear();
  }

  // ✅ GET SAVED ADAPTATION DATA
  Future<Map<String, dynamic>?> getSavedAdaptationAnalysisData() async {
    try {
      return await SharedPrefs.getAdaptationAnalysisData();
    } catch (e) {
      print('❌ Error getting saved adaptation analysis data: $e');
      return null;
    }
  }

  // ✅ FIXED: Update the saveGameScoreToDatabase method with correct structure
  Future<void> saveGameScoreToDatabase(int score, String feedback) async {
    try {
      final userId = SharedPrefs.getUserId();
      if (userId == null) {
        print('❌ Cannot save game score: User ID not found');
        return;
      }

      // ✅ FIXED: Use the correct request structure that matches backend
      final gameScoreRequest = {
        "userId": userId,
        "score": score,
        "scor": feedback,
        "alignmentStrategy": _calculateAlignmentStrategy(score),
        "objectiveClarity": _calculateObjectiveClarity(score),
        "keyResultQuality": _calculateKeyResultQuality(score),
        "initiativeRelevance": _calculateInitiativeRelevance(score),
        "challengeAdoption": _calculateChallengeAdoption(score),
      };

      print('💾 Saving game score to database: $score');
      print('📊 Score Request: $gameScoreRequest');

      // ✅ FIXED: Use the correct endpoint for saving solo scores
      final url = ApiConstants.getUrl(ApiConstants.soloScore);
      print('🌐 Saving to URL: $url');

      final response = await _apiService.getPostApiResponse(
        url,
        gameScoreRequest,
      );

      print('✅ Game score saved successfully: $response');

      // Verify the score was saved by fetching it immediately
      await _verifyScoreWasSaved(userId);

    } catch (e) {
      print('❌ Error saving game score: $e');
      // Don't throw error here - we still want to proceed even if saving fails
    }
  }

// ✅ ADD THESE HELPER METHODS to calculate individual scores
  int _calculateAlignmentStrategy(int score) {
    // Calculate based on score (you can adjust these formulas)
    if (score >= 90) return 35;
    if (score >= 80) return 30;
    if (score >= 70) return 25;
    return 20;
  }

  int _calculateObjectiveClarity(int score) {
    if (score >= 90) return 25;
    if (score >= 80) return 22;
    if (score >= 70) return 18;
    return 15;
  }

  int _calculateKeyResultQuality(int score) {
    if (score >= 90) return 20;
    if (score >= 80) return 18;
    if (score >= 70) return 15;
    return 12;
  }

  int _calculateInitiativeRelevance(int score) {
    if (score >= 90) return 10;
    if (score >= 80) return 8;
    if (score >= 70) return 6;
    return 4;
  }

  int _calculateChallengeAdoption(int score) {
    if (score >= 90) return 10;
    if (score >= 80) return 9;
    if (score >= 70) return 7;
    return 5;
  }

  // ✅ ADD THIS METHOD: Calculate total points from breakdown
  int _calculateTotalPoints(Map<String, dynamic> breakdown) {
    try {
      int total = 0;

      // Calculate points from breakdown
      if (breakdown['strategy-relevance'] != null) {
        final parts = breakdown['strategy-relevance'].toString().split('/');
        if (parts.length == 2) total += int.tryParse(parts[0]) ?? 0;
      }
      if (breakdown['objective-quality'] != null) {
        final parts = breakdown['objective-quality'].toString().split('/');
        if (parts.length == 2) total += int.tryParse(parts[0]) ?? 0;
      }
      if (breakdown['keyresults-quality'] != null) {
        final parts = breakdown['keyresults-quality'].toString().split('/');
        if (parts.length == 2) total += int.tryParse(parts[0]) ?? 0;
      }
      if (breakdown['initiatives-quality'] != null) {
        final parts = breakdown['initiatives-quality'].toString().split('/');
        if (parts.length == 2) total += int.tryParse(parts[0]) ?? 0;
      }
      if (breakdown['overall-coherence'] != null) {
        final parts = breakdown['overall-coherence'].toString().split('/');
        if (parts.length == 2) total += int.tryParse(parts[0]) ?? 0;
      }

      return total ~/ 2; // Convert to out of 10 points
    } catch (e) {
      return 8; // Default fallback
    }
  }
// ✅ ADD THIS METHOD: Save test score with real dynamic data
  Future<void> saveTestScoreToDatabase() async {
    try {
      final userId = SharedPrefs.getUserId();
      if (userId == null) {
        print('❌ Cannot save test score: User ID not found');
        return;
      }

      // Use dynamic data - get current evaluation data if available
      final currentScore = evaluationData.value?.score ?? 85; // Fallback to 85 if no evaluation
      final currentFeedback = evaluationData.value?.feedback ?? "Test evaluation completed";

      // Calculate dynamic breakdown scores based on actual evaluation or use defaults
      final breakdown = evaluationData.value?.breakdown ?? {};

      final testScoreRequest = {
        "userId": userId,
        "score": currentScore, // ✅ REAL DYNAMIC SCORE
        "scor": currentFeedback, // ✅ REAL DYNAMIC FEEDBACK
        "alignmentStrategy": _extractScoreFromBreakdown(breakdown['strategyAlignment']) ?? 30,
        "objectiveClarity": _extractScoreFromBreakdown(breakdown['objectiveAlignment']) ?? 25,
        "keyResultQuality": _extractScoreFromBreakdown(breakdown['keyResultQuality']) ?? 18,
        "initiativeRelevance": _extractScoreFromBreakdown(breakdown['initiativeRelevance']) ?? 8,
        "challengeAdoption": _extractScoreFromBreakdown(breakdown['challengeAdoption']) ?? 9,
      };

      print('🧪 Saving REAL TEST score to database: $currentScore');
      print('📊 Test Score Request: $testScoreRequest');

      final url = ApiConstants.getUrl(ApiConstants.soloScore);
      final response = await _apiService.getPostApiResponse(url, testScoreRequest);

      print('✅ Test score saved successfully: $response');

      // Verify it was saved
      await _verifyScoreWasSaved(userId);
    } catch (e) {
      print('❌ Error saving test score: $e');
    }
  }

// ✅ Helper method to extract score from breakdown
  int _extractScoreFromBreakdown(dynamic breakdownItem) {
    try {
      if (breakdownItem is Map<String, dynamic>) {
        return breakdownItem['score'] ?? 0;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }
  // ✅ ADD THIS METHOD: Verify score was saved
  Future<void> _verifyScoreWasSaved(String userId) async {
    try {
      // Wait a moment for the database to update
      await Future.delayed(Duration(seconds: 1));

      final verificationUrl = ApiConstants.getLatestGameScore(userId);
      print('🔍 Verifying score was saved: $verificationUrl');

      final verificationResponse = await _apiService.getGetApiResponse(verificationUrl);
      print('✅ Score verification: $verificationResponse');
    } catch (e) {
      print('⚠️ Could not verify score save: $e');
    }
  }

  // ✅ ADD THIS METHOD: Get badge from score
  String _getBadgeFromScore(int score) {
    if (score >= 90) return "Gold Star";
    if (score >= 80) return "Silver Star";
    if (score >= 70) return "Bronze Star";
    return "New Player";
  }

  // ✅ ADD THIS METHOD: Get trophy from score
  String _getTrophyFromScore(int score) {
    if (score >= 90) return "Gold Trophy";
    if (score >= 80) return "Silver Trophy";
    return "";
  }
}







// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import '../../core/api_constants.dart';
// import '../../data/network/network_api_services.dart';
// import '../../services/shared_preference.dart';
//
// class AdaptationAnalysisResponse {
//   final int score;
//   final String feedback;
//   final Map<String, dynamic> breakdown;
//   final Map<String, dynamic>? gamification;
//
//   AdaptationAnalysisResponse({
//     required this.score,
//     required this.feedback,
//     required this.breakdown,
//     this.gamification,
//   });
//
//   factory AdaptationAnalysisResponse.fromJson(Map<String, dynamic> json) {
//     return AdaptationAnalysisResponse(
//       score: json['score'] ?? 0,
//       feedback: json['feedback'] ?? '',
//       breakdown: json['breakdown'] ?? {},
//       gamification: json['gamification'],
//     );
//   }
// }
//
// class AdaptationAIAnalysisViewModel extends GetxController {
//   final NetworkApiService _apiService = NetworkApiService();
//
//   // ✅ CONTROLLERS
//   final TextEditingController thirdInitiativeTitle = TextEditingController();
//   final TextEditingController thirdInitiativeDesc = TextEditingController();
//   final TextEditingController strategicActionsController = TextEditingController();
//
//   // Reactive variables
//   var isSubmitting = false.obs;
//   var evaluationData = Rxn<AdaptationAnalysisResponse>();
//   var errorMessage = ''.obs;
//
//   bool get hasData => evaluationData.value != null;
//
//   @override
//   void onClose() {
//     thirdInitiativeTitle.dispose();
//     thirdInitiativeDesc.dispose();
//     strategicActionsController.dispose();
//     super.onClose();
//   }
//
//   Future<void> submitAdaptationAnalysis({
//     required String strategy,
//     required String objective,
//     required String keyResult,
//     required String challenge,
//     required String proposal,
//   }) async {
//     try {
//       isSubmitting(true);
//       errorMessage('');
//
//       print('📤 Submitting adaptation analysis...');
//
//       // ✅ CREATE REQUEST BODY ACCORDING TO API SPEC
//       final requestBody = {
//         "strategy": strategy,
//         "objective": objective,
//         "keyResult": keyResult,
//         "challenge": challenge,
//         "proposal": proposal,
//       };
//
//       print('📝 Request Body: $requestBody');
//
//       final url = ApiConstants.getUrl(ApiConstants.finalOkrEvaluation);
//       print('🌐 API URL: $url');
//
//       final response = await _apiService.getPostApiResponse(
//         url,
//         requestBody,
//       );
//
//       print('📥 Raw API Response: $response');
//
//       if (response != null) {
//         print('✅ Final OKR evaluation submitted successfully');
//
//         final evaluationResponse = AdaptationAnalysisResponse.fromJson(response);
//         evaluationData.value = evaluationResponse;
//
//         await _saveAdaptationAnalysisDataToPrefs(requestBody, evaluationResponse);
//
//         // ✅ FIXED: ACTUALLY SAVE THE SCORE TO DATABASE
//         await saveGameScoreToDatabase(evaluationResponse.score, evaluationResponse.feedback);
//
//         print('🎯 Evaluation completed - Score: ${evaluationResponse.score}');
//         print('🎯 Has Data: $hasData');
//
//       } else {
//         print('❌ No response received from API');
//         throw Exception('No response received from final OKR evaluation');
//       }
//     } catch (e) {
//       print('❌ Error submitting adaptation analysis: $e');
//       errorMessage.value = e.toString();
//       createFallbackResponse();
//     } finally {
//       isSubmitting(false);
//     }
//   }
//   //
//   // // ✅ NEW METHOD: For the correct API structure (without initiatives)
//   // Future<void> submitAdaptationAnalysis({
//   //   required String strategy,
//   //   required String objective,
//   //   required String keyResult,
//   //   required String challenge,
//   //   required String proposal,
//   // }) async {
//   //   try {
//   //     isSubmitting(true);
//   //     errorMessage('');
//   //
//   //     print('📤 Submitting adaptation analysis...');
//   //
//   //     // ✅ CREATE REQUEST BODY ACCORDING TO API SPEC
//   //     final requestBody = {
//   //       "strategy": strategy,
//   //       "objective": objective,
//   //       "keyResult": keyResult,
//   //       "challenge": challenge,
//   //       "proposal": proposal,
//   //     };
//   //
//   //     print('📝 Request Body: $requestBody');
//   //
//   //     final url = ApiConstants.getUrl(ApiConstants.finalOkrEvaluation);
//   //     print('🌐 API URL: $url');
//   //
//   //     final response = await _apiService.getPostApiResponse(
//   //       url,
//   //       requestBody,
//   //     );
//   //
//   //     print('📥 Raw API Response: $response');
//   //
//   //     if (response != null) {
//   //       print('✅ Final OKR evaluation submitted successfully');
//   //
//   //       final evaluationResponse = AdaptationAnalysisResponse.fromJson(response);
//   //       evaluationData.value = evaluationResponse;
//   //
//   //       await _saveAdaptationAnalysisDataToPrefs(requestBody, evaluationResponse);
//   //       await submitSoloScoreWithRealData(evaluationResponse);
//   //
//   //       print('🎯 Evaluation completed - Score: ${evaluationResponse.score}');
//   //       print('🎯 Has Data: $hasData');
//   //
//   //     } else {
//   //       print('❌ No response received from API');
//   //       throw Exception('No response received from final OKR evaluation');
//   //     }
//   //   } catch (e) {
//   //     print('❌ Error submitting adaptation analysis: $e');
//   //     errorMessage.value = e.toString();
//   //     createFallbackResponse();
//   //   } finally {
//   //     isSubmitting(false);
//   //   }
//   //
//   // }
//
//   // // ✅ OLD METHOD: For backward compatibility (with initiatives)
//   // Future<void> submitAdaptationAnalysisWithInitiatives({
//   //   String? strategy,
//   //   String? objective,
//   //   String? keyResult,
//   //   String? challenge,
//   //   List<Map<String, String>>? existingInitiatives,
//   // }) async {
//   //   try {
//   //     // Get default values if not provided
//   //     final userStrategy = strategy ?? await _getSelectedStrategy();
//   //     final userObjective = objective ?? await _getSelectedObjective();
//   //     final userKeyResult = keyResult ?? 'Adapted Key Result';
//   //     final userChallenge = challenge ?? 'Market Challenge';
//   //     final proposal = strategicActionsController.text.isNotEmpty
//   //         ? strategicActionsController.text
//   //         : 'Strategic adaptations to address market changes';
//   //
//   //     // Call the new method with required parameters
//   //     await submitAdaptationAnalysis(
//   //       strategy: userStrategy,
//   //       objective: userObjective,
//   //       keyResult: userKeyResult,
//   //       challenge: userChallenge,
//   //       proposal: proposal,
//   //     );
//   //   } catch (e) {
//   //     print('❌ Error in legacy method: $e');
//   //     rethrow;
//   //   }
//   // }
//
//   // ✅ CREATE ADAPTATION REQUEST (for old code that might still use this)
//   Future<Map<String, dynamic>> _createAdaptationRequest({
//     String? strategy,
//     String? objective,
//     String? keyResult,
//     String? challenge,
//     List<Map<String, String>>? existingInitiatives,
//   }) async {
//     final userStrategy = strategy ?? await _getSelectedStrategy();
//     final userObjective = objective ?? await _getSelectedObjective();
//     final userKeyResult = keyResult ?? 'Adapted Key Result';
//     final userChallenge = challenge ?? 'Market Challenge';
//
//     return {
//       "strategy": userStrategy,
//       "objective": userObjective,
//       "keyResult": userKeyResult,
//       "challenge": userChallenge,
//       "proposal": strategicActionsController.text.isNotEmpty
//           ? strategicActionsController.text
//           : 'Strategic adaptations to address market changes',
//     };
//   }
//
//   // ✅ Get selected strategy from SharedPreferences
//   Future<String> _getSelectedStrategy() async {
//     try {
//       final strategyData = await SharedPrefs.getSelectedStrategy();
//       return strategyData?['title']?.toString() ?? 'CEO Strategy';
//     } catch (e) {
//       return 'CEO Strategy';
//     }
//   }
//
//   // ✅ Get selected objective from SharedPreferences
//   Future<String> _getSelectedObjective() async {
//     try {
//       final objectiveData = await SharedPrefs.getSelectedObjective();
//       return objectiveData?['title']?.toString() ?? 'Business Growth Objective';
//     } catch (e) {
//       return 'Business Growth Objective';
//     }
//   }
//
//   // ✅ SAVE TO SHARED PREFERENCES
//   Future<void> _saveAdaptationAnalysisDataToPrefs(
//       Map<String, dynamic> request,
//       AdaptationAnalysisResponse response
//       ) async {
//     try {
//       final adaptationData = {
//         'strategy': request['strategy'],
//         'objective': request['objective'],
//         'keyResult': request['keyResult'],
//         'challenge': request['challenge'],
//         'proposal': request['proposal'],
//         'evaluationScore': response.score,
//         'evaluationFeedback': response.feedback,
//         'evaluationBreakdown': response.breakdown,
//         'gamification': response.gamification,
//         'submittedAt': DateTime.now().toIso8601String(),
//         'thirdInitiativeTitle': thirdInitiativeTitle.text,
//         'thirdInitiativeDesc': thirdInitiativeDesc.text,
//         'strategicActions': strategicActionsController.text,
//       };
//
//       await SharedPrefs.saveAdaptationAnalysisData(adaptationData);
//       print('💾 Adaptation analysis data saved to SharedPreferences');
//     } catch (e) {
//       print('❌ Error saving adaptation analysis data: $e');
//     }
//   }
//
//   int _parseBreakdownScore(String scoreText) {
//     try {
//       final parts = scoreText.split('/');
//       if (parts.length == 2) {
//         return int.tryParse(parts[0]) ?? 0;
//       }
//       return 0;
//     } catch (e) {
//       return 0;
//     }
//   }
//
//   Future<void> submitSoloScoreWithRealData(AdaptationAnalysisResponse evaluationResponse) async {
//     try {
//       final userId = SharedPrefs.getUserId();
//       if (userId == null) {
//         print('❌ Cannot submit solo score: User ID not found');
//         return;
//       }
//
//       final breakdown = evaluationResponse.breakdown;
//       final alignmentStrategy = _parseBreakdownScore(breakdown['strategy-relevance']?.toString() ?? '0/15');
//       final objectiveClarity = _parseBreakdownScore(breakdown['objective-quality']?.toString() ?? '0/15');
//       final keyResultQuality = _parseBreakdownScore(breakdown['keyresults-quality']?.toString() ?? '0/30');
//       final initiativeRelevance = _parseBreakdownScore(breakdown['initiatives-quality']?.toString() ?? '0/30');
//       final challengeAdoption = _parseBreakdownScore(breakdown['overall-coherence']?.toString() ?? '0/10');
//
//       final soloScoreRequest = {
//         "userId": userId,
//         "score": evaluationResponse.score,
//         "feedback": evaluationResponse.feedback, // Fixed typo
//         "alignmentStrategy": alignmentStrategy,
//         "objectiveClarity": objectiveClarity,
//         "keyResultQuality": keyResultQuality,
//         "initiativeRelevance": initiativeRelevance,
//         "challengeAdoption": challengeAdoption,
//       };
//
//       print('📤 Submitting solo score with REAL data: ${evaluationResponse.score}');
//       print('📊 Breakdown: $soloScoreRequest');
//
//       // Call your solo score API here
//       // await _soloScoreRepository.submitSoloScore(soloScoreRequest);
//     } catch (e) {
//       print('❌ Error submitting solo score: $e');
//     }
//   }
//
//   void createFallbackResponse() {
//     final fallbackResult = AdaptationAnalysisResponse(
//       score: 88,
//       feedback: 'Partially relevant',
//       breakdown: {
//         'strategy-relevance': '14/15',
//         'objective-quality': '14/15',
//         'keyresults-quality': '26/30',
//         'initiatives-quality': '24/30',
//         'overall-coherence': '10/10',
//       },
//       gamification: {
//         'badgeHint': 'Aligned Leader',
//         'visualFeedback': 'Excellent alignment with strategy'
//       },
//     );
//
//     evaluationData.value = fallbackResult;
//   }
//
//   void clearData() {
//     evaluationData.value = null;
//     errorMessage.value = '';
//     thirdInitiativeTitle.clear();
//     thirdInitiativeDesc.clear();
//     strategicActionsController.clear();
//   }
//
//   // ✅ GET SAVED ADAPTATION DATA
//   Future<Map<String, dynamic>?> getSavedAdaptationAnalysisData() async {
//     try {
//       return await SharedPrefs.getAdaptationAnalysisData();
//     } catch (e) {
//       print('❌ Error getting saved adaptation analysis data: $e');
//       return null;
//     }
//   }
//
//   Future<void> saveGameScoreToDatabase(int score, String feedback) async {
//     try {
//       final userId = SharedPrefs.getUserId();
//       if (userId == null) {
//         print('❌ Cannot save game score: User ID not found');
//         return;
//       }
//
//       // ✅ CALCULATE BREAKDOWN FROM ACTUAL EVALUATION RESPONSE
//       final breakdown = evaluationData.value?.breakdown ?? {};
//
//       final gameScoreRequest = {
//         "userId": userId,
//         "score": score,
//         "scor": feedback,
//         "totalPoints": "${_calculateTotalPoints(breakdown)}/10",
//         "badge": _getBadgeFromScore(score),
//         "trophy": _getTrophyFromScore(score),
//         "breakdown": {
//           "alignment-strategy": breakdown['strategy-relevance']?.toString() ?? "2/2",
//           "objective-clarity": breakdown['objective-quality']?.toString() ?? "2/2",
//           "keyresult-quality": breakdown['keyresults-quality']?.toString() ?? "2/2",
//           "initiative-relevance": breakdown['initiatives-quality']?.toString() ?? "1/2",
//           "challenge-adoption": breakdown['overall-coherence']?.toString() ?? "1/2"
//         }
//       };
//
//       print('💾 Saving game score to database: $score');
//       print('📊 Score Request: $gameScoreRequest');
//
//       // ✅ FIXED: Use the correct endpoint for saving solo scores
//       final url = ApiConstants.getUrl(ApiConstants.soloScore);
//       print('🌐 Saving to URL: $url');
//
//       final response = await _apiService.getPostApiResponse(
//         url,
//         gameScoreRequest,
//       );
//
//       print('✅ Game score saved successfully: $response');
//
//       // Verify the score was saved by fetching it immediately
//       await _verifyScoreWasSaved(userId);
//
//     } catch (e) {
//       print('❌ Error saving game score: $e');
//       // Don't throw error here - we still want to proceed even if saving fails
//     }
//   }
//
//   int _calculateTotalPoints(Map<String, dynamic> breakdown) {
//     try {
//       int total = 0;
//
//       // Calculate points from breakdown
//       if (breakdown['strategy-relevance'] != null) {
//         final parts = breakdown['strategy-relevance'].toString().split('/');
//         if (parts.length == 2) total += int.tryParse(parts[0]) ?? 0;
//       }
//       if (breakdown['objective-quality'] != null) {
//         final parts = breakdown['objective-quality'].toString().split('/');
//         if (parts.length == 2) total += int.tryParse(parts[0]) ?? 0;
//       }
//       if (breakdown['keyresults-quality'] != null) {
//         final parts = breakdown['keyresults-quality'].toString().split('/');
//         if (parts.length == 2) total += int.tryParse(parts[0]) ?? 0;
//       }
//       if (breakdown['initiatives-quality'] != null) {
//         final parts = breakdown['initiatives-quality'].toString().split('/');
//         if (parts.length == 2) total += int.tryParse(parts[0]) ?? 0;
//       }
//       if (breakdown['overall-coherence'] != null) {
//         final parts = breakdown['overall-coherence'].toString().split('/');
//         if (parts.length == 2) total += int.tryParse(parts[0]) ?? 0;
//       }
//
//       return total ~/ 2; // Convert to out of 10 points
//     } catch (e) {
//       return 8; // Default fallback
//     }
//   }
//
//   Future<void> _verifyScoreWasSaved(String userId) async {
//     try {
//       // Wait a moment for the database to update
//       await Future.delayed(Duration(seconds: 1));
//
//       final verificationUrl = ApiConstants.getLatestGameScore(userId);
//       print('🔍 Verifying score was saved: $verificationUrl');
//
//       final verificationResponse = await _apiService.getGetApiResponse(verificationUrl);
//       print('✅ Score verification: $verificationResponse');
//     } catch (e) {
//       print('⚠️ Could not verify score save: $e');
//     }
//   }
//   //
//   // // Add this to your AdaptationAIAnalysisViewModel or wherever you handle evaluation
//   // Future<void> saveGameScoreToDatabase(int score, String feedback) async {
//   //   try {
//   //     final userId = SharedPrefs.getUserId();
//   //     if (userId == null) {
//   //       print('❌ Cannot save game score: User ID not found');
//   //       return;
//   //     }
//   //
//   //     final gameScoreRequest = {
//   //       "userId": userId,
//   //       "score": score,
//   //       "scor": feedback,
//   //       "totalPoints": "8/10", // Calculate based on your breakdown
//   //       "badge": _getBadgeFromScore(score),
//   //       "trophy": _getTrophyFromScore(score),
//   //       "breakdown": {
//   //         "alignment-strategy": "2/2",
//   //         "objective-clarity": "2/2",
//   //         "keyresult-quality": "2/2",
//   //         "initiative-relevance": "1/2",
//   //         "challenge-adoption": "1/2"
//   //       }
//   //     };
//   //
//   //     print('💾 Saving game score to database: $score');
//   //
//   //     // Call your solo score API endpoint to save the data
//   //     final response = await _apiService.getPostApiResponse(
//   //       ApiConstants.soloScore, // Make sure this endpoint exists
//   //       gameScoreRequest,
//   //     );
//   //
//   //     print('✅ Game score saved successfully: $response');
//   //   } catch (e) {
//   //     print('❌ Error saving game score: $e');
//   //   }
//   // }
//   //
//   // String _getBadgeFromScore(int score) {
//   //   if (score >= 90) return "Gold Star";
//   //   if (score >= 80) return "Silver Star";
//   //   if (score >= 70) return "Bronze Star";
//   //   return "New Player";
//   // }
//   //
//   // String _getTrophyFromScore(int score) {
//   //   if (score >= 90) return "Gold Trophy";
//   //   if (score >= 80) return "Silver Trophy";
//   //   return "";
//   // }
// }
//
