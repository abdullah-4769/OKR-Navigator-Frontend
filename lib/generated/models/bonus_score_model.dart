class BonusScoreRequest {
  final int id;
  final String userId;
  final int overallScore;
  final String normalizedScore;
  final String points;
  final String title;
  final String feedback;
  final String strategyAlignmentTitle;
  final int strategyAlignmentScore;
  final String strategyAlignmentSuggestion;
  final String objectiveAlignmentTitle;
  final int objectiveAlignmentScore;
  final String objectiveAlignmentSuggestion;
  final String keyResultQualityTitle;
  final int keyResultQualityScore;
  final String keyResultQualitySuggestion;
  final String createdAt;
  final String updatedAt;

  BonusScoreRequest({
    required this.id,
    required this.userId,
    required this.overallScore,
    required this.normalizedScore,
    required this.points,
    required this.title,
    required this.feedback,
    required this.strategyAlignmentTitle,
    required this.strategyAlignmentScore,
    required this.strategyAlignmentSuggestion,
    required this.objectiveAlignmentTitle,
    required this.objectiveAlignmentScore,
    required this.objectiveAlignmentSuggestion,
    required this.keyResultQualityTitle,
    required this.keyResultQualityScore,
    required this.keyResultQualitySuggestion,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'overallScore': overallScore,
      'normalizedScore': normalizedScore,
      'points': points,
      'title': title,
      'feedback': feedback,
      'strategyAlignmentTitle': strategyAlignmentTitle,
      'strategyAlignmentScore': strategyAlignmentScore,
      'strategyAlignmentSuggestion': strategyAlignmentSuggestion,
      'objectiveAlignmentTitle': objectiveAlignmentTitle,
      'objectiveAlignmentScore': objectiveAlignmentScore,
      'objectiveAlignmentSuggestion': objectiveAlignmentSuggestion,
      'keyResultQualityTitle': keyResultQualityTitle,
      'keyResultQualityScore': keyResultQualityScore,
      'keyResultQualitySuggestion': keyResultQualitySuggestion,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Alternative: If the API expects different field names
  Map<String, dynamic> toApiJson() {
    return {
      'id': id,
      'userId': userId,
      'overallScore': overallScore,
      'normalizedScore': normalizedScore,
      'points': points,
      'title': title,
      'feedback': feedback,
      'strategyAlignmentTitle': strategyAlignmentTitle,
      'strategyAlignmentScore': strategyAlignmentScore,
      'strategyAlignmentSuggestion': strategyAlignmentSuggestion,
      'objectiveAlignmentTitle': objectiveAlignmentTitle,
      'objectiveAlignmentScore': objectiveAlignmentScore,
      'objectiveAlignmentSuggestion': objectiveAlignmentSuggestion,
      'keyResultQualityTitle': keyResultQualityTitle,
      'keyResultQualityScore': keyResultQualityScore,
      'keyResultQualitySuggestion': keyResultQualitySuggestion,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}class BonusScoreResponse {
  final int id;
  final String userId;
  final int overallScore;
  final String normalizedScore;
  final String points;
  final String title;
  final String feedback;
  final String strategyAlignmentTitle;
  final int strategyAlignmentScore;
  final String strategyAlignmentSuggestion;
  final String objectiveAlignmentTitle;
  final int objectiveAlignmentScore;
  final String objectiveAlignmentSuggestion;
  final String keyResultQualityTitle;
  final int keyResultQualityScore;
  final String keyResultQualitySuggestion;
  final String createdAt;
  final String updatedAt;

  BonusScoreResponse({
    required this.id,
    required this.userId,
    required this.overallScore,
    required this.normalizedScore,
    required this.points,
    required this.title,
    required this.feedback,
    required this.strategyAlignmentTitle,
    required this.strategyAlignmentScore,
    required this.strategyAlignmentSuggestion,
    required this.objectiveAlignmentTitle,
    required this.objectiveAlignmentScore,
    required this.objectiveAlignmentSuggestion,
    required this.keyResultQualityTitle,
    required this.keyResultQualityScore,
    required this.keyResultQualitySuggestion,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BonusScoreResponse.fromJson(Map<String, dynamic> json) {
    return BonusScoreResponse(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? '',
      overallScore: json['overallScore'] ?? 0,
      normalizedScore: json['normalizedScore'] ?? '',
      points: json['points'] ?? '',
      title: json['title'] ?? '',
      feedback: json['feedback'] ?? '',
      strategyAlignmentTitle: json['strategyAlignmentTitle'] ?? '',
      strategyAlignmentScore: json['strategyAlignmentScore'] ?? 0,
      strategyAlignmentSuggestion: json['strategyAlignmentSuggestion'] ?? '',
      objectiveAlignmentTitle: json['objectiveAlignmentTitle'] ?? '',
      objectiveAlignmentScore: json['objectiveAlignmentScore'] ?? 0,
      objectiveAlignmentSuggestion: json['objectiveAlignmentSuggestion'] ?? '',
      keyResultQualityTitle: json['keyResultQualityTitle'] ?? '',
      keyResultQualityScore: json['keyResultQualityScore'] ?? 0,
      keyResultQualitySuggestion: json['keyResultQualitySuggestion'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}