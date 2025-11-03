// lib/generated/models/responses/final_evaluation_response.dart
class FinalEvaluationResponse {
  final int? score;
  final String? weightedScore;
  final String? feedback;
  final EvaluationBreakdown? breakdown;
  final GamificationHint? gamification;

  FinalEvaluationResponse({
    this.score,
    this.weightedScore,
    this.feedback,
    this.breakdown,
    this.gamification,
  });

  factory FinalEvaluationResponse.fromJson(Map<String, dynamic> json) =>
      FinalEvaluationResponse(
        score: json['score'] as int?,
        weightedScore: json['weightedScore'] as String?,
        feedback: json['feedback'] as String?,
        breakdown: json['breakdown'] == null
            ? null
            : EvaluationBreakdown.fromJson(
                json['breakdown'] as Map<String, dynamic>),
        gamification: json['gamification'] == null
            ? null
            : GamificationHint.fromJson(
                json['gamification'] as Map<String, dynamic>),
      );
}

class EvaluationBreakdown {
  final String? strategyRelevance;
  final String? objectiveQuality;
  final String? keyResultsQuality;
  final String? initiativesQuality;
  final String? overallCoherence;

  EvaluationBreakdown({
    this.strategyRelevance,
    this.objectiveQuality,
    this.keyResultsQuality,
    this.initiativesQuality,
    this.overallCoherence,
  });

  factory EvaluationBreakdown.fromJson(Map<String, dynamic> json) =>
      EvaluationBreakdown(
        strategyRelevance: json['strategy-relevance'] as String?,
        objectiveQuality: json['objective-quality'] as String?,
        keyResultsQuality: json['keyresults-quality'] as String?,
        initiativesQuality: json['initiatives-quality'] as String?,
        overallCoherence: json['overall-coherence'] as String?,
      );
}

class GamificationHint {
  final String? badgeHint;
  final String? visualFeedback;

  GamificationHint({
    this.badgeHint,
    this.visualFeedback,
  });

  factory GamificationHint.fromJson(Map<String, dynamic> json) =>
      GamificationHint(
        badgeHint: json['badgeHint'] as String?,
        visualFeedback: json['visualFeedback'] as String?,
      );
}