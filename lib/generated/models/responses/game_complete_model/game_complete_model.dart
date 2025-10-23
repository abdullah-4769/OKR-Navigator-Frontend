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

  GameCompleteModel(
      {this.id,
        this.userId,
        this.score,
        this.scor,
        this.breakdown,
        this.totalPoints,
        this.badge,
        this.trophy,
        this.createdAt,
        this.updatedAt});

  GameCompleteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    score = json['score'];
    scor = json['scor'];
    breakdown = json['breakdown'] != null
        ? new Breakdown.fromJson(json['breakdown'])
        : null;
    totalPoints = json['totalPoints'];
    badge = json['badge'];
    trophy = json['trophy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['score'] = this.score;
    data['scor'] = this.scor;
    if (this.breakdown != null) {
      data['breakdown'] = this.breakdown!.toJson();
    }
    data['totalPoints'] = this.totalPoints;
    data['badge'] = this.badge;
    data['trophy'] = this.trophy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Breakdown {
  String? alignmentStrategy;
  String? objectiveClarity;
  String? keyresultQuality;
  String? initiativeRelevance;
  String? challengeAdoption;

  Breakdown(
      {this.alignmentStrategy,
        this.objectiveClarity,
        this.keyresultQuality,
        this.initiativeRelevance,
        this.challengeAdoption});

  Breakdown.fromJson(Map<String, dynamic> json) {
    alignmentStrategy = json['alignment-strategy'];
    objectiveClarity = json['objective-clarity'];
    keyresultQuality = json['keyresult-quality'];
    initiativeRelevance = json['initiative-relevance'];
    challengeAdoption = json['challenge-adoption'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alignment-strategy'] = this.alignmentStrategy;
    data['objective-clarity'] = this.objectiveClarity;
    data['keyresult-quality'] = this.keyresultQuality;
    data['initiative-relevance'] = this.initiativeRelevance;
    data['challenge-adoption'] = this.challengeAdoption;
    return data;
  }
}
