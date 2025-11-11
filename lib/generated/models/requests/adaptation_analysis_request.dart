
// Simple request model for adaptation analysis
class AdaptationAnalysisRequest {
  final String strategy;
  final String objective;
  final String keyResult;
  final String challenge;
  final String proposal;
  final List<Map<String, String>> initiatives;

  AdaptationAnalysisRequest({
    required this.strategy,
    required this.objective,
    required this.keyResult,
    required this.challenge,
    required this.proposal,
    required this.initiatives,
  });

  Map<String, dynamic> toJson() {
    return {
      'strategy': strategy,
      'objective': objective,
      'keyResult': keyResult,
      'challenge': challenge,
      'proposal': proposal,
      'initiatives': initiatives,
    };
  }

  // ✅ FIXED: Factory constructor name matches class name
  factory AdaptationAnalysisRequest.fromJson(Map<String, dynamic> json) {
    return AdaptationAnalysisRequest(
      strategy: json['strategy'] ?? '',
      objective: json['objective'] ?? '',
      keyResult: json['keyResult'] ?? '',
      challenge: json['challenge'] ?? '',
      proposal: json['proposal'] ?? '',
      initiatives: (json['initiatives'] as List<dynamic>?)?.map((item) => Map<String, String>.from(item)).toList() ?? [],
    );
  }
}























// // lib/view_model/challange_view_models/adaptation_ai_analysis-viewmodel.dart
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../data/network/network_api_services.dart';
// import '../../../data/response/api_response.dart';
// import '../../../services/shared_preference.dart';
//
// // Simple request model for adaptation analysis
// class AdaptationAnalysisRequest {
//   final String strategy;
//   final String objective;
//   final String keyResult;
//   final String challenge;
//   final String proposal;
//   final List<Map<String, String>> initiatives;
//
//   AdaptationAnalysisRequest({
//     required this.strategy,
//     required this.objective,
//     required this.keyResult,
//     required this.challenge,
//     required this.proposal,
//     required this.initiatives,
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       'strategy': strategy,
//       'objective': objective,
//       'keyResult': keyResult,
//       'challenge': challenge,
//       'proposal': proposal,
//       'initiatives': initiatives,
//     };
//   }
// }
//
// // Simple response model
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
// class AdaptationAnalysisViewModel extends GetxController {
//   final NetworkApiService _apiService = NetworkApiService();
//
//   // ✅ FIXED: Add both isLoading and isSubmitting for compatibility
//   var isLoading = false.obs;
//   var isSubmitting = false.obs;
//   var evaluationData = Rxn<AdaptationAnalysisResponse>();
//   var errorMessage = ''.obs;
//
//   // ✅ FIXED: Add hasData getter
//   bool get hasData => evaluationData.value != null;
//
//   // ✅ FIXED: Create a default adaptation request for testing
//   AdaptationAnalysisRequest getDefaultAdaptationRequest() {
//     return AdaptationAnalysisRequest(
//       strategy: 'CEO',
//       objective: 'GreenPulse Energy is a renewable energy startup focused on providing affordable solar power solutions to rural communities.',
//       keyResult: 'Adjust Q4 revenue target from \$2M to \$1.8M due to market volatility',
//       challenge: 'Implement cost optimization measures and explore new market segments',
//       proposal: 'Market analysis indicates 10% lower growth projections for Q4',
//       initiatives: [
//         {'title': 'Cost Optimization', 'description': 'Reduce operational costs by 15%'},
//         {'title': 'Market Expansion', 'description': 'Explore 2 new rural market segments'},
//       ],
//     );
//   }
//
//   // ✅ FIXED: Submit adaptation analysis method with parameter
//   Future<void> submitAdaptationAnalysis([AdaptationAnalysisRequest? request]) async {
//     try {
//       isLoading(true);
//       isSubmitting(true);
//       errorMessage('');
//
//       // Use provided request or default one
//       final analysisRequest = request ?? getDefaultAdaptationRequest();
//
//       print('📤 Submitting adaptation analysis...');
//
//       final response = await _apiService.getPostApiResponse(
//         'http://192.168.1.5:3000/final-okr-evaluation',
//         analysisRequest.toJson(),
//       );
//
//       if (response != null) {
//         print('✅ Final OKR evaluation submitted successfully');
//         evaluationData.value = AdaptationAnalysisResponse.fromJson(response);
//
//         // ✅ Submit solo score with real data
//         await submitSoloScoreWithRealData(evaluationData.value!);
//
//       } else {
//         throw Exception('No response received from final OKR evaluation');
//       }
//
//     } catch (e) {
//       print('❌ Error submitting adaptation analysis: $e');
//       errorMessage.value = e.toString();
//       // Create fallback response on error
//       createFallbackResponse();
//     } finally {
//       isLoading(false);
//       isSubmitting(false);
//     }
//   }
//
//   // ✅ FIXED: Define helper method properly
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
//   // ✅ FIXED: Submit solo score method
//   Future<void> submitSoloScoreWithRealData(AdaptationAnalysisResponse evaluationResponse) async {
//     try {
//       final userId = SharedPrefs.getUserId();
//       if (userId == null) {
//         print('❌ Cannot submit solo score: User ID not found');
//         return;
//       }
//
//       // Calculate scores from the actual breakdown
//       final breakdown = evaluationResponse.breakdown;
//       final alignmentStrategy = _parseBreakdownScore(breakdown['strategy-relevance']?.toString() ?? '0/15');
//       final objectiveClarity = _parseBreakdownScore(breakdown['objective-quality']?.toString() ?? '0/15');
//       final keyResultQuality = _parseBreakdownScore(breakdown['keyresults-quality']?.toString() ?? '0/30');
//       final initiativeRelevance = _parseBreakdownScore(breakdown['initiatives-quality']?.toString() ?? '0/30');
//       final challengeAdoption = _parseBreakdownScore(breakdown['overall-coherence']?.toString() ?? '0/10');
//
//       // Prepare solo score request with REAL data
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
//       // Call your solo score API here
//       // await _soloScoreRepository.submitSoloScore(soloScoreRequest);
//
//     } catch (e) {
//       print('❌ Error submitting solo score: $e');
//     }
//   }
//
//   // ✅ FIXED: Create fallback response method
//   void createFallbackResponse() {
//     final fallbackResult = AdaptationAnalysisResponse(
//       score: 75,
//       feedback: 'Your adaptations show strategic thinking. The revised objectives demonstrate understanding of market challenges.',
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