// lib/models/evaluate_initiative_model.dart

class EvaluateInitiativeModel {
  int? score;
  String? decision;
  String? explanation;

  EvaluateInitiativeModel({this.score, this.decision, this.explanation});

  EvaluateInitiativeModel.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    decision = json['decision'];
    explanation = json['explanation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['score'] = score;
    data['decision'] = decision;
    data['explanation'] = explanation;
    return data;
  }
}