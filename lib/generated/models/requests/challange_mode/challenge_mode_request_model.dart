// lib/generated/models/requests/challenge_mode_score_request/challenge_mode_score_request.dart



class ChallengeModeScoreResult {
  final String userId;
  final String name;
  final int score;
  final String position;
  final double? alignmentStrategy;
  final double? objectiveClarity;
  final double? keyResultQuality;
  final double? initiativeRelevance;
  final double? challengeAdoption;
  final double? strategyAlignment;
  final double? objectiveAlignment;
  final String? keyResultQualityLog;

  ChallengeModeScoreResult({
    required this.userId,
    required this.name,
    required this.score,
    required this.position,
    this.alignmentStrategy,
    this.objectiveClarity,
    this.keyResultQuality,
    this.initiativeRelevance,
    this.challengeAdoption,
    this.strategyAlignment,
    this.objectiveAlignment,
    this.keyResultQualityLog,
  });

  factory ChallengeModeScoreResult.fromJson(Map<String, dynamic> json) {
    double? _tryToDouble(dynamic v) {
      if (v == null) return null;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }

    return ChallengeModeScoreResult(
      userId: (json['userId'] ?? json['userID'] ?? '').toString(),
      name: (json['name'] ?? json['user'] ?? json['userId'] ?? '').toString(),
      score: int.tryParse((json['score'] ?? '0').toString()) ?? 0,
      position: (json['position'] ?? '').toString(),
      alignmentStrategy: _tryToDouble(json['alignmentStrategy']),
      objectiveClarity: _tryToDouble(json['objectiveClarity']),
      keyResultQuality: _tryToDouble(json['keyResultQuality']),
      initiativeRelevance: _tryToDouble(json['initiativeRelevance']),
      challengeAdoption: _tryToDouble(json['challengeAdoption']),
      strategyAlignment: _tryToDouble(json['strategyAlignment']),
      objectiveAlignment: _tryToDouble(json['objectiveAlignment']),
      keyResultQualityLog: json['keyResultQualityLog']?.toString(),
    );
  }
}

class ChallengeModeScoreModel {
  final int challengeId;
  final List<ChallengeModeScoreResult> results;

  ChallengeModeScoreModel({
    required this.challengeId,
    required this.results,
  });

  factory ChallengeModeScoreModel.fromJson(Map<String, dynamic> json) {
    final resultsRaw = json['results'] as List<dynamic>? ?? [];
    final results = resultsRaw.map((r) {
      if (r is Map<String, dynamic>) {
        return ChallengeModeScoreResult.fromJson(r);
      } else {
        return ChallengeModeScoreResult.fromJson(Map<String, dynamic>.from(r));
      }
    }).toList();

    return ChallengeModeScoreModel(
      challengeId: int.tryParse((json['challengeId'] ?? json['challengeId']).toString()) ?? 0,
      results: results,
    );
  }
}




class ChallengeModeScoreRequest {
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

  ChallengeModeScoreRequest({
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
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'challengeId': challengeId,
      'score': score,
      'title': title,
      'alignmentStrategy': alignmentStrategy,
      'objectiveClarity': objectiveClarity,
      'keyResultQuality': keyResultQuality,
      'initiativeRelevance': initiativeRelevance,
      'challengeAdoption': challengeAdoption,
      'time': time,
      'strategyAlignment': strategyAlignment,
      'objectiveAlignment': objectiveAlignment,
      'keyResultQualityLog': keyResultQualityLog,
    };
  }

  factory ChallengeModeScoreRequest.fromJson(Map<String, dynamic> json) {
    return ChallengeModeScoreRequest(
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
    );
  }
}