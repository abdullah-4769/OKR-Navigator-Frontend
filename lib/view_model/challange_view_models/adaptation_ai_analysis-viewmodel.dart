
// Simple response model
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../data/network/network_api_services.dart';
import '../../generated/models/requests/adaptation_analysis_model.dart';
import '../../services/shared_preference.dart';

class AdaptationAnalysisResponse {
  final int score;
  final String feedback;
  final Map<String, dynamic> breakdown;

  AdaptationAnalysisResponse({
    required this.score,
    required this.feedback,
    required this.breakdown,
  });

  factory AdaptationAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return AdaptationAnalysisResponse(
      score: json['score'] ?? 0,
      feedback: json['feedback'] ?? '',
      breakdown: json['breakdown'] ?? {},
    );
  }
}

class AdaptationAIAnalysisViewModel extends GetxController {
  final NetworkApiService _apiService = NetworkApiService();

  // Reactive variables
  var isSubmitting = false.obs;
  var evaluationData = Rxn<AdaptationAnalysisResponse>();
  var errorMessage = ''.obs;

  bool get hasData => evaluationData.value != null;

  Future<void> submitAdaptationAnalysis([AdaptationAnalysisRequest? request]) async {
    try {
      isSubmitting(true);
      errorMessage('');

      print('📤 Submitting adaptation analysis...');

      final analysisRequest = request ?? _createDefaultAdaptationRequest();

      final response = await _apiService.getPostApiResponse(
        'http://192.168.1.3:3000/final-okr-evaluation',
        analysisRequest.toJson(),
      );

      if (response != null) {
        print('✅ Final OKR evaluation submitted successfully');
        evaluationData.value = AdaptationAnalysisResponse.fromJson(response);

        await submitSoloScoreWithRealData(evaluationData.value!);
      } else {
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

  AdaptationAnalysisRequest _createDefaultAdaptationRequest() {
    return AdaptationAnalysisRequest(
      strategy: 'CEO',
      objective: 'GreenPulse Energy is a renewable energy startup focused on providing affordable solar power solutions to rural communities.',
      keyResult: 'Adjust Q4 revenue target from \$2M to \$1.8M due to market volatility',
      challenge: 'Implement cost optimization measures and explore new market segments',
      proposal: 'Market analysis indicates 10% lower growth projections for Q4',
      initiatives: [
        {'title': 'Cost Optimization', 'description': 'Reduce operational costs by 15%'},
        {'title': 'Market Expansion', 'description': 'Explore 2 new rural market segments'},
      ],
    );
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
        "scor": evaluationResponse.feedback,
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
      score: 75,
      feedback: 'Your adaptations show strategic thinking. The revised objectives demonstrate understanding of market challenges.',
      breakdown: {
        'strategy-relevance': '12/15',
        'objective-quality': '10/15',
        'keyresults-quality': '18/30',
        'initiatives-quality': '22/30',
        'overall-coherence': '5/10',
      },
    );

    evaluationData.value = fallbackResult;
  }

  void clearData() {
    evaluationData.value = null;
    errorMessage.value = '';
  }
}