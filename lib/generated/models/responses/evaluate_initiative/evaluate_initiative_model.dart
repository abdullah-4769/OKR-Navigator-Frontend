class EvaluateInitiativeModel {
  final int score;
  final String decision;
  final String explanation;

  EvaluateInitiativeModel({
    required this.score,
    required this.decision,
    required this.explanation,
  });

  Map<String, dynamic> toJson() => {
    'score': score,
    'decision': decision,
    'explanation': explanation,
  };

  factory EvaluateInitiativeModel.fromJson(Map<String, dynamic> json) {
    return EvaluateInitiativeModel(
      score: json['score'] as int? ?? 0,
      decision: json['decision'] as String? ?? 'Pending',
      explanation: json['explanation'] as String? ?? 'No analysis available',
    );
  }
}
