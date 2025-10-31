// lib/generated/models/requests/final_okr_evaluation_request.dart

class FinalOkrEvaluationRequest {
  final String strategy;
  final String objective;
  final String keyResult;
  final String challenge;
  final String proposal;
  final List<Initiative> initiatives;

  FinalOkrEvaluationRequest({
    required this.strategy,
    required this.objective,
    required this.keyResult,
    required this.challenge,
    required this.proposal,
    required this.initiatives,
  });

  Map<String, dynamic> toJson() => {
    'strategy': strategy,
    'objective': objective,
    'keyResult': keyResult,
    'challenge': challenge,
    'proposal': proposal,
    'initiatives': initiatives.map((x) => x.toJson()).toList(),
  };
}

class Initiative {
  final String title;
  final String description;

  Initiative({
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
  };
}
// lib/generated/models/responses/final_okr_evaluation_response.dart

class FinalOkrEvaluationResponse {
  final int? statusCode;
  final String? message;
  final EvaluationData? data;

  FinalOkrEvaluationResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory FinalOkrEvaluationResponse.fromJson(Map<String, dynamic> json) {
    return FinalOkrEvaluationResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      data: json['data'] != null ? EvaluationData.fromJson(json['data']) : null,
    );
  }
}

class EvaluationData {
  final int score;
  final String feedback;
  final Breakdown breakdown;
  final Gamification gamification;

  EvaluationData({
    required this.score,
    required this.feedback,
    required this.breakdown,
    required this.gamification,
  });

  factory EvaluationData.fromJson(Map<String, dynamic> json) {
    return EvaluationData(
      score: json['score'],
      feedback: json['feedback'],
      breakdown: Breakdown.fromJson(json['breakdown']),
      gamification: Gamification.fromJson(json['gamification']),
    );
  }
}

class Breakdown {
  final String strategyRelevance;
  final String objectiveQuality;
  final String keyResultsQuality;
  final String initiativesQuality;
  final String overallCoherence;

  Breakdown({
    required this.strategyRelevance,
    required this.objectiveQuality,
    required this.keyResultsQuality,
    required this.initiativesQuality,
    required this.overallCoherence,
  });

  factory Breakdown.fromJson(Map<String, dynamic> json) {
    return Breakdown(
      strategyRelevance: json['strategy-relevance'],
      objectiveQuality: json['objective-quality'],
      keyResultsQuality: json['keyresults-quality'],
      initiativesQuality: json['initiatives-quality'],
      overallCoherence: json['overall-coherence'],
    );
  }
}

class Gamification {
  final String badgeHint;
  final String visualFeedback;

  Gamification({
    required this.badgeHint,
    required this.visualFeedback,
  });

  factory Gamification.fromJson(Map<String, dynamic> json) {
    return Gamification(
      badgeHint: json['badgeHint'],
      visualFeedback: json['visualFeedback'],
    );
  }
}