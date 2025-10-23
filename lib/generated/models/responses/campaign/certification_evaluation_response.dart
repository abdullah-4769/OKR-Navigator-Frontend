class CertificationEvaluationResponse {
  final int score;
  final EvaluationBreakdown breakdown;
  final EvaluationFeedback feedback;
  final String certificateLevel;

  CertificationEvaluationResponse({
    required this.score,
    required this.breakdown,
    required this.feedback,
    required this.certificateLevel,
  });

  factory CertificationEvaluationResponse.fromJson(Map<String, dynamic> json) {
    return CertificationEvaluationResponse(
      score: json['score'] ?? 0,
      breakdown: EvaluationBreakdown.fromJson(json['breakdown'] ?? {}),
      feedback: EvaluationFeedback.fromJson(json['feedback'] ?? {}),
      certificateLevel: json['certificate_level'] ?? 'Bronze',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'breakdown': breakdown.toJson(),
      'feedback': feedback.toJson(),
      'certificate_level': certificateLevel,
    };
  }
}

class EvaluationBreakdown {
  final int strategyScore;
  final int objectiveScore;
  final int keyResultScore;
  final int initiativeScore;
  final int coherenceScore;

  EvaluationBreakdown({
    required this.strategyScore,
    required this.objectiveScore,
    required this.keyResultScore,
    required this.initiativeScore,
    required this.coherenceScore,
  });

  factory EvaluationBreakdown.fromJson(Map<String, dynamic> json) {
    return EvaluationBreakdown(
      strategyScore: json['strategy_score'] ?? 0,
      objectiveScore: json['objective_score'] ?? 0,
      keyResultScore: json['key_result_score'] ?? 0,
      initiativeScore: json['initiative_score'] ?? 0,
      coherenceScore: json['coherence_score'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'strategy_score': strategyScore,
      'objective_score': objectiveScore,
      'key_result_score': keyResultScore,
      'initiative_score': initiativeScore,
      'coherence_score': coherenceScore,
    };
  }
}

class EvaluationFeedback {
  final List<String> strengths;
  final List<String> areasForImprovement;

  EvaluationFeedback({
    required this.strengths,
    required this.areasForImprovement,
  });

  factory EvaluationFeedback.fromJson(Map<String, dynamic> json) {
    return EvaluationFeedback(
      strengths: List<String>.from(json['strengths'] ?? []),
      areasForImprovement: List<String>.from(json['areas_for_improvement'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'strengths': strengths,
      'areas_for_improvement': areasForImprovement,
    };
  }
}