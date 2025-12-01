class TeamLobbyResponse {
  /// For full lobby responses this is the team id.
  /// For join-team responses this is often the membership id, while
  /// [teamId] below contains the actual team id.
  int? id;

  /// Explicit team id field to support /team/join responses
  /// which return `{ id: <memberId>, teamId: <teamId>, ... }`.
  int? teamId;

  String? title;
  String? mission;
  String? teamavatorid;
  String? token;
  int? totalMembers;
  List<Members>? members;

  TeamLobbyResponse({
    this.id,
    this.teamId,
    this.title,
    this.mission,
    this.teamavatorid,
    this.token,
    this.totalMembers,
    this.members,
  });

  TeamLobbyResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // Some endpoints (like /team/join) return teamId separately.
    teamId = json['teamId'];
    title = json['title'];
    mission = json['mission'];
    teamavatorid = json['teamavatorid'];
    token = json['token'];
    totalMembers = json['totalMembers'];
    if (json['members'] != null) {
      members = <Members>[];
      json['members'].forEach((v) {
        members!.add(Members.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (teamId != null) {
      data['teamId'] = teamId;
    }
    data['title'] = title;
    data['mission'] = mission;
    data['teamavatorid'] = teamavatorid;
    data['token'] = token;
    data['totalMembers'] = totalMembers;
    if (members != null) {
      data['members'] = members!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Members {
  int? id;
  int? teamId;
  String? userId;
  String? role;
  String? joinedAt;
  User? user;

  Members(
      {this.id, this.teamId, this.userId, this.role, this.joinedAt, this.user});

  Members.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    teamId = json['teamId'];
    userId = json['userId'];
    role = json['role'];
    joinedAt = json['joinedAt'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['teamId'] = this.teamId;
    data['userId'] = this.userId;
    data['role'] = this.role;
    data['joinedAt'] = this.joinedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? avatarPicId;

  User({this.id, this.name, this.avatarPicId});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatarPicId = json['avatarPicId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['avatarPicId'] = this.avatarPicId;
    return data;
  }
}