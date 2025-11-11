class PlayerModel {
  String? userId;
  String? name;
  String? avatarPicId;
  int? totalScore;
  String? level;
  int? rank;

  PlayerModel({
    this.userId,
    this.name,
    this.avatarPicId,
    this.totalScore,
    this.level,
    this.rank,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      userId: json['userId'],
      name: json['name'],
      avatarPicId: json['avatarPicId'],
      totalScore: json['totalScore'],
      level: json['level'],
      rank: json['rank'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'avatarPicId': avatarPicId,
      'totalScore': totalScore,
      'level': level,
      'rank': rank,
    };
  }
}

/*class ChallengeModeModel {
  List<TopThree>? topThree;
  List<Remaining>? remaining;
  Null? userDetails;

  ChallengeModeModel({this.topThree, this.remaining, this.userDetails});

  ChallengeModeModel.fromJson(Map<String, dynamic> json) {
    if (json['topThree'] != null) {
      topThree = <TopThree>[];
      json['topThree'].forEach((v) {
        topThree!.add(new TopThree.fromJson(v));
      });
    }
    if (json['remaining'] != null) {
      remaining = <Remaining>[];
      json['remaining'].forEach((v) {
        remaining!.add(new Remaining.fromJson(v));
      });
    }
    userDetails = json['userDetails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.topThree != null) {
      data['topThree'] = this.topThree!.map((v) => v.toJson()).toList();
    }
    if (this.remaining != null) {
      data['remaining'] = this.remaining!.map((v) => v.toJson()).toList();
    }
    data['userDetails'] = this.userDetails;
    return data;
  }
}

class TopThree {
  String? userId;
  String? name;
  Null? avatarPicId;
  int? totalScore;
  String? level;
  int? rank;

  TopThree(
      {this.userId,
        this.name,
        this.avatarPicId,
        this.totalScore,
        this.level,
        this.rank});

  TopThree.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['name'];
    avatarPicId = json['avatarPicId'];
    totalScore = json['totalScore'];
    level = json['level'];
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['avatarPicId'] = this.avatarPicId;
    data['totalScore'] = this.totalScore;
    data['level'] = this.level;
    data['rank'] = this.rank;
    return data;
  }
}
class CampaignModeModel {
  List<TopThree>? topThree;
  List<Null>? remaining;
  Null? userDetails;

  CampaignModeModel({this.topThree, this.remaining, this.userDetails});

  CampaignModeModel.fromJson(Map<String, dynamic> json) {
    if (json['topThree'] != null) {
      topThree = <TopThree>[];
      json['topThree'].forEach((v) {
        topThree!.add(new TopThree.fromJson(v));
      });
    }
    if (json['remaining'] != null) {
      remaining = <Null>[];
      json['remaining'].forEach((v) {
        remaining!.add(new Null.fromJson(v));
      });
    }
    userDetails = json['userDetails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.topThree != null) {
      data['topThree'] = this.topThree!.map((v) => v.toJson()).toList();
    }
    if (this.remaining != null) {
      data['remaining'] = this.remaining!.map((v) => v.toJson()).toList();
    }
    data['userDetails'] = this.userDetails;
    return data;
  }
}

class TopThreeCompaignMode {
  String? userId;
  String? name;
  Null? avatarPicId;
  int? totalScore;
  String? level;
  int? rank;

  TopThreeCompaignMode(
      {this.userId,
        this.name,
        this.avatarPicId,
        this.totalScore,
        this.level,
        this.rank});

  TopThreeCompaignMode.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['name'];
    avatarPicId = json['avatarPicId'];
    totalScore = json['totalScore'];
    level = json['level'];
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['avatarPicId'] = this.avatarPicId;
    data['totalScore'] = this.totalScore;
    data['level'] = this.level;
    data['rank'] = this.rank;
    return data;
  }
}

class TeamModeModel {
  List<TopThree>? topThree;
  List<Remaining>? remaining;
  TopThree? userDetails;

  TeamModeModel({this.topThree, this.remaining, this.userDetails});

  TeamModeModel.fromJson(Map<String, dynamic> json) {
    if (json['topThree'] != null) {
      topThree = <TopThree>[];
      json['topThree'].forEach((v) {
        topThree!.add(new TopThree.fromJson(v));
      });
    }
    if (json['remaining'] != null) {
      remaining = <Remaining>[];
      json['remaining'].forEach((v) {
        remaining!.add(new Remaining.fromJson(v));
      });
    }
    userDetails = json['userDetails'] != null
        ? new TopThree.fromJson(json['userDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.topThree != null) {
      data['topThree'] = this.topThree!.map((v) => v.toJson()).toList();
    }
    if (this.remaining != null) {
      data['remaining'] = this.remaining!.map((v) => v.toJson()).toList();
    }
    if (this.userDetails != null) {
      data['userDetails'] = this.userDetails!.toJson();
    }
    return data;
  }
}

class TopThreeTeam {
  String? userId;
  String? name;
  Null? avatarPicId;
  int? totalScore;
  String? level;
  int? rank;

  TopThreeTeam(
      {this.userId,
        this.name,
        this.avatarPicId,
        this.totalScore,
        this.level,
        this.rank});

  TopThreeTeam.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['name'];
    avatarPicId = json['avatarPicId'];
    totalScore = json['totalScore'];
    level = json['level'];
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['avatarPicId'] = this.avatarPicId;
    data['totalScore'] = this.totalScore;
    data['level'] = this.level;
    data['rank'] = this.rank;
    return data;
  }
}
class SoloModeModel {
  List<TopThree>? topThree;
  List<Remaining>? remaining;
  Remaining? userDetails;

  SoloModeModel({this.topThree, this.remaining, this.userDetails});

  SoloModeModel.fromJson(Map<String, dynamic> json) {
    if (json['topThree'] != null) {
      topThree = <TopThree>[];
      json['topThree'].forEach((v) {
        topThree!.add(new TopThree.fromJson(v));
      });
    }
    if (json['remaining'] != null) {
      remaining = <Remaining>[];
      json['remaining'].forEach((v) {
        remaining!.add(new Remaining.fromJson(v));
      });
    }
    userDetails = json['userDetails'] != null
        ? new Remaining.fromJson(json['userDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.topThree != null) {
      data['topThree'] = this.topThree!.map((v) => v.toJson()).toList();
    }
    if (this.remaining != null) {
      data['remaining'] = this.remaining!.map((v) => v.toJson()).toList();
    }
    if (this.userDetails != null) {
      data['userDetails'] = this.userDetails!.toJson();
    }
    return data;
  }
}

class TopThreeSolo {
  String? userId;
  String? name;
  String? avatarPicId;
  int? totalScore;
  String? level;
  int? rank;

  TopThreeSolo(
      {this.userId,
        this.name,
        this.avatarPicId,
        this.totalScore,
        this.level,
        this.rank});

  TopThreeSolo.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['name'];
    avatarPicId = json['avatarPicId'];
    totalScore = json['totalScore'];
    level = json['level'];
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['avatarPicId'] = this.avatarPicId;
    data['totalScore'] = this.totalScore;
    data['level'] = this.level;
    data['rank'] = this.rank;
    return data;
  }
}

class Remaining {
  String? userId;
  String? name;
  Null? avatarPicId;
  int? totalScore;
  String? level;
  int? rank;

  Remaining(
      {this.userId,
        this.name,
        this.avatarPicId,
        this.totalScore,
        this.level,
        this.rank});

  Remaining.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['name'];
    avatarPicId = json['avatarPicId'];
    totalScore = json['totalScore'];
    level = json['level'];
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['avatarPicId'] = this.avatarPicId;
    data['totalScore'] = this.totalScore;
    data['level'] = this.level;
    data['rank'] = this.rank;
    return data;
  }
}*/

