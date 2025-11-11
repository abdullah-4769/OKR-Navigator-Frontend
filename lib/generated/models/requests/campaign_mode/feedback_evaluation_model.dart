// lib/generated/models/requests/campaign_mode/feedback_evaluation_model.dart
class FeedbackEvaluationModel {
  final int overallScore;
  final String normalizedScore;
  final String title;
  final String feedback;
  final Breakdown breakdown;

  FeedbackEvaluationModel({
    required this.overallScore,
    required this.normalizedScore,
    required this.title,
    required this.feedback,
    required this.breakdown,
  });

  // ✅ ADD THIS FACTORY METHOD TO YOUR EXISTING MODEL CLASS
  factory FeedbackEvaluationModel.fromJson(Map<String, dynamic> json) {
    try {
      return FeedbackEvaluationModel(
        overallScore: json['overallScore'] as int? ?? 0,
        normalizedScore: json['normalizedScore'] as String? ?? '0/0',
        title: json['title'] as String? ?? 'No Title',
        feedback: json['feedback'] as String? ?? 'No feedback available',
        breakdown: Breakdown.fromJson(json['breakdown'] as Map<String, dynamic>? ?? {}),
      );
    } catch (e) {
      print('❌ Error parsing FeedbackEvaluationModel: $e');
      // Return a default model
      return FeedbackEvaluationModel(
        overallScore: 0,
        normalizedScore: '0/0',
        title: 'Error',
        feedback: 'Failed to parse feedback data',
        breakdown: Breakdown(
          strategyAlignment: ScoreItem(title: 'Error', score: 0, suggestion: ''),
          objectiveAlignment: ScoreItem(title: 'Error', score: 0, suggestion: ''),
          keyResultQuality: KeyResultQuality(
              title: 'Error',
              score: 0,
              pointsPerKeyResult: {},
              suggestion: ''
          ),
        ),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'overallScore': overallScore,
      'normalizedScore': normalizedScore,
      'title': title,
      'feedback': feedback,
      'breakdown': breakdown.toJson(),
    };
  }
}

// ✅ ALSO UPDATE THE Breakdown CLASS WITH ERROR HANDLING
class Breakdown {
  final ScoreItem strategyAlignment;
  final ScoreItem objectiveAlignment;
  final KeyResultQuality keyResultQuality;

  Breakdown({
    required this.strategyAlignment,
    required this.objectiveAlignment,
    required this.keyResultQuality,
  });

  factory Breakdown.fromJson(Map<String, dynamic> json) {
    try {
      return Breakdown(
        strategyAlignment: ScoreItem.fromJson(json['strategyAlignment'] as Map<String, dynamic>? ?? {}),
        objectiveAlignment: ScoreItem.fromJson(json['objectiveAlignment'] as Map<String, dynamic>? ?? {}),
        keyResultQuality: KeyResultQuality.fromJson(json['keyResultQuality'] as Map<String, dynamic>? ?? {}),
      );
    } catch (e) {
      print('❌ Error parsing Breakdown: $e');
      return Breakdown(
        strategyAlignment: ScoreItem(title: 'Error', score: 0, suggestion: ''),
        objectiveAlignment: ScoreItem(title: 'Error', score: 0, suggestion: ''),
        keyResultQuality: KeyResultQuality(title: 'Error', score: 0, pointsPerKeyResult: {}, suggestion: ''),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'strategyAlignment': strategyAlignment.toJson(),
      'objectiveAlignment': objectiveAlignment.toJson(),
      'keyResultQuality': keyResultQuality.toJson(),
    };
  }
}

// ✅ UPDATE ScoreItem CLASS WITH ERROR HANDLING
class ScoreItem {
  final String title;
  final int score;
  final String suggestion;

  ScoreItem({
    required this.title,
    required this.score,
    required this.suggestion,
  });

  factory ScoreItem.fromJson(Map<String, dynamic> json) {
    try {
      return ScoreItem(
        title: json['title'] as String? ?? 'No Title',
        score: json['score'] as int? ?? 0,
        suggestion: json['suggestion'] as String? ?? 'No suggestion',
      );
    } catch (e) {
      print('❌ Error parsing ScoreItem: $e');
      return ScoreItem(title: 'Error', score: 0, suggestion: '');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'score': score,
      'suggestion': suggestion,
    };
  }
}

// ✅ UPDATE KeyResultQuality CLASS WITH ERROR HANDLING
class KeyResultQuality {
  final String title;
  final int score;
  final Map<String, int> pointsPerKeyResult;
  final String suggestion;

  KeyResultQuality({
    required this.title,
    required this.score,
    required this.pointsPerKeyResult,
    required this.suggestion,
  });

  factory KeyResultQuality.fromJson(Map<String, dynamic> json) {
    try {
      return KeyResultQuality(
        title: json['title'] as String? ?? 'No Title',
        score: json['score'] as int? ?? 0,
        pointsPerKeyResult: Map<String, int>.from(json['pointsPerKeyResult'] as Map? ?? {}),
        suggestion: json['suggestion'] as String? ?? 'No suggestion',
      );
    } catch (e) {
      print('❌ Error parsing KeyResultQuality: $e');
      return KeyResultQuality(
          title: 'Error',
          score: 0,
          pointsPerKeyResult: {},
          suggestion: ''
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'score': score,
      'pointsPerKeyResult': pointsPerKeyResult,
      'suggestion': suggestion,
    };
  }
}