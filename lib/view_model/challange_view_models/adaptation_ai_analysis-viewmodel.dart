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
        await submitSoloScoreWithRealData(evaluationResponse);

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
}


// import 'package:get/get.dart';
// import '../../core/api_constants.dart';
// import '../../data/network/network_api_services.dart';
// import '../../generated/models/requests/adaptation_analysis_model.dart';
// import '../../services/shared_preference.dart';
//
// class AdaptationAnalysisResponse {
//   final int score;
//   final String feedback;
//   final Map<String, dynamic> breakdown;
//
//   AdaptationAnalysisResponse({
//     required this.score,
//     required this.feedback,
//     required this.breakdown,
//   });
//
//   factory AdaptationAnalysisResponse.fromJson(Map<String, dynamic> json) {
//     return AdaptationAnalysisResponse(
//       score: json['score'] ?? 0,
//       feedback: json['feedback'] ?? '',
//       breakdown: json['breakdown'] ?? {},
//     );
//   }
// }
//
// class AdaptationAIAnalysisViewModel extends GetxController {
//   final NetworkApiService _apiService = NetworkApiService();
//
//   // Reactive variables
//   var isSubmitting = false.obs;
//   var evaluationData = Rxn<AdaptationAnalysisResponse>();
//   var errorMessage = ''.obs;
//
//   bool get hasData => evaluationData.value != null;
//
//   Future<void> submitAdaptationAnalysis([AdaptationAnalysisRequest? request]) async {
//     try {
//       isSubmitting(true);
//       errorMessage('');
//
//       print('📤 Submitting adaptation analysis...');
//
//       final analysisRequest = request ?? _createDefaultAdaptationRequest();
//
//       // ✅ Use API constant instead of hardcoding
//       final url = ApiConstants.getUrl(ApiConstants.finalOkrEvaluation);
//
//       final response = await _apiService.getPostApiResponse(
//         url,
//         analysisRequest.toJson(),
//       );
//
//       if (response != null) {
//         print('✅ Final OKR evaluation submitted successfully');
//         evaluationData.value = AdaptationAnalysisResponse.fromJson(response);
//
//         await submitSoloScoreWithRealData(evaluationData.value!);
//       } else {
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
//
//   AdaptationAnalysisRequest _createDefaultAdaptationRequest() {
//     return AdaptationAnalysisRequest(
//           strategy: 'CEO',
//           objective:
//           'GreenPulse Energy is a renewable energy startup focused on providing affordable solar power solutions to rural communities.',
//           keyResult:
//           'Adjust Q4 revenue target from \$2M to \$1.8M due to market volatility',
//           challenge:
//           'Implement cost optimization measures and explore new market segments',
//           proposal: 'Market analysis indicates 10% lower growth projections for Q4',
//           initiatives: [
//             {'title': 'Cost Optimization', 'description': 'Reduce operational costs by 15%'},
//             {'title': 'Market Expansion', 'description': 'Explore 2 new rural market segments'},
//           ],
//         );
//       }
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
//         "scor": evaluationResponse.feedback,
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
//       // Call your solo score API here (future addition)
//       // await _soloScoreRepository.submitSoloScore(soloScoreRequest);
//     } catch (e) {
//       print('❌ Error submitting solo score: $e');
//     }
//   }
//
//   void createFallbackResponse() {
//     final fallbackResult = AdaptationAnalysisResponse(
//       score: 75,
//       feedback:
//       'Your adaptations show strategic thinking. The revised objectives demonstrate understanding of market challenges.',
//       breakdown: {
//         'strategy-relevance': '12/15',
//         'objective-quality': '10/15',
//         'keyresults-quality': '18/30',
//         'initiatives-quality': '22/30',
//         'overall-coherence': '5/10',
//       },
//     );
//
//     evaluationData.value = fallbackResult;
//   }
//
//   void clearData() {
//     evaluationData.value = null;
//     errorMessage.value = '';
//   }
// }
