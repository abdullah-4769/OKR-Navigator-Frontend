// In your EvaluateInitiativeModel class, add:
class EvaluateInitiativeModel {
  final int score;
  final String decision;
  final String explanation;

  EvaluateInitiativeModel({
    required this.score,
    required this.decision,
    required this.explanation,
  });

  // Add this method
  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'decision': decision,
      'explanation': explanation,
    };
  }

  // Optional: Add fromJson factory method
  factory EvaluateInitiativeModel.fromJson(Map<String, dynamic> json) {
    return EvaluateInitiativeModel(
      score: json['score'] as int? ?? 0,
      decision: json['decision'] as String? ?? 'Pending',
      explanation: json['explanation'] as String? ?? 'No analysis available',
    );
  }
}



// // lib/models/evaluate_initiative_model.dart
//
// class EvaluateInitiativeModel {
//   int? score;
//   String? decision;
//   String? explanation;
//
//   EvaluateInitiativeModel({this.score, this.decision, this.explanation});
//
//   EvaluateInitiativeModel.fromJson(Map<String, dynamic> json) {
//     score = json['score'];
//     decision = json['decision'];
//     explanation = json['explanation'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['score'] = score;
//     data['decision'] = decision;
//     data['explanation'] = explanation;
//     return data;
//   }
// }