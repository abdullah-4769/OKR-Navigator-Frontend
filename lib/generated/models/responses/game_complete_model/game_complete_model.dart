
class GameCompleteModel {
  int? id;
  String? userId;
  int? score;
  String? scor;
  Breakdown? breakdown;
  String? totalPoints;
  String? badge;
  String? trophy;
  String? createdAt;
  String? updatedAt;

  GameCompleteModel({
    this.id,
    this.userId,
    this.score,
    this.scor,
    this.breakdown,
    this.totalPoints,
    this.badge,
    this.trophy,
    this.createdAt,
    this.updatedAt,
  });

  GameCompleteModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      userId = json['userId'];

      // Handle score - could be int or string
      if (json['score'] != null) {
        if (json['score'] is int) {
          score = json['score'];
        } else if (json['score'] is String) {
          score = int.tryParse(json['score']);
        }
      }

      scor = json['scor'];

      // Handle breakdown object
      breakdown = json['breakdown'] != null
          ? Breakdown.fromJson(json['breakdown'])
          : null;

      totalPoints = json['totalPoints'];
      badge = json['badge'];
      trophy = json['trophy'];
      createdAt = json['createdAt'];
      updatedAt = json['updatedAt'];

      print('📦 [Model] Parsed GameCompleteModel:');
      print('   - ID: $id');
      print('   - UserID: $userId');
      print('   - Score: $score');
      print('   - Badge: $badge');
      print('   - Trophy: $trophy');
      print('   - Has Breakdown: ${breakdown != null}');

    } catch (e) {
      print('❌ [Model] Error parsing GameCompleteModel: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['score'] = score;
    data['scor'] = scor;
    if (breakdown != null) {
      data['breakdown'] = breakdown!.toJson();
    }
    data['totalPoints'] = totalPoints;
    data['badge'] = badge;
    data['trophy'] = trophy;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Breakdown {
  String? alignmentStrategy;
  String? objectiveClarity;
  String? keyresultQuality;
  String? initiativeRelevance;
  String? challengeAdoption;

  Breakdown({
    this.alignmentStrategy,
    this.objectiveClarity,
    this.keyresultQuality,
    this.initiativeRelevance,
    this.challengeAdoption,
  });

  Breakdown.fromJson(Map<String, dynamic> json) {
    try {
      // Handle both camelCase and kebab-case field names
      alignmentStrategy = json['alignment-strategy'] ?? json['alignmentStrategy'];
      objectiveClarity = json['objective-clarity'] ?? json['objectiveClarity'];
      keyresultQuality = json['keyresult-quality'] ?? json['keyresultQuality'];
      initiativeRelevance = json['initiative-relevance'] ?? json['initiativeRelevance'];
      challengeAdoption = json['challenge-adoption'] ?? json['challengeAdoption'];

      print('📊 [Model] Parsed Breakdown:');
      print('   - Alignment Strategy: $alignmentStrategy');
      print('   - Objective Clarity: $objectiveClarity');
      print('   - Keyresult Quality: $keyresultQuality');
      print('   - Initiative Relevance: $initiativeRelevance');
      print('   - Challenge Adoption: $challengeAdoption');

    } catch (e) {
      print('❌ [Model] Error parsing Breakdown: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['alignment-strategy'] = alignmentStrategy;
    data['objective-clarity'] = objectiveClarity;
    data['keyresult-quality'] = keyresultQuality;
    data['initiative-relevance'] = initiativeRelevance;
    data['challenge-adoption'] = challengeAdoption;
    return data;
  }
}
