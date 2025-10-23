// lib/generated/models/responses/challenge_mode_score_response/challenge_mode_score_response.dart
class ChallengeModeScoreResponse {
  final int id;
  final String userId;
  final int challengeId;
  final int score;
  final String title;
  final int alignmentStrategy;
  final int objectiveClarity;
  final int keyResultQuality;
  final int initiativeRelevance;
  final int challengeAdoption;
  final String time;
  final Map<String, dynamic> strategyAlignment;
  final Map<String, dynamic> objectiveAlignment;
  final Map<String, dynamic> keyResultQualityLog;
  final String createdAt;
  final String updatedAt;

  ChallengeModeScoreResponse({
    required this.id,
    required this.userId,
    required this.challengeId,
    required this.score,
    required this.title,
    required this.alignmentStrategy,
    required this.objectiveClarity,
    required this.keyResultQuality,
    required this.initiativeRelevance,
    required this.challengeAdoption,
    required this.time,
    required this.strategyAlignment,
    required this.objectiveAlignment,
    required this.keyResultQualityLog,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChallengeModeScoreResponse.fromJson(Map<String, dynamic> json) {
    return ChallengeModeScoreResponse(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? '',
      challengeId: json['challengeId'] ?? 0,
      score: json['score'] ?? 0,
      title: json['title'] ?? '',
      alignmentStrategy: json['alignmentStrategy'] ?? 0,
      objectiveClarity: json['objectiveClarity'] ?? 0,
      keyResultQuality: json['keyResultQuality'] ?? 0,
      initiativeRelevance: json['initiativeRelevance'] ?? 0,
      challengeAdoption: json['challengeAdoption'] ?? 0,
      time: json['time'] ?? '',
      strategyAlignment: Map<String, dynamic>.from(json['strategyAlignment'] ?? {}),
      objectiveAlignment: Map<String, dynamic>.from(json['objectiveAlignment'] ?? {}),
      keyResultQualityLog: Map<String, dynamic>.from(json['keyResultQualityLog'] ?? {}),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}