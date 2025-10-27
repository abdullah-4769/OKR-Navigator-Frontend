class TeamLobbyResponse {
  int? id;
  String? title;
  String? mission;
  String? teamavatorid;
  String? token;
  int? totalMembers;
  List<Members>? members;

  TeamLobbyResponse(
      {this.id,
      this.title,
      this.mission,
      this.teamavatorid,
      this.token,
      this.totalMembers,
      this.members});

  TeamLobbyResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    mission = json['mission'];
    teamavatorid = json['teamavatorid'];
    token = json['token'];
    totalMembers = json['totalMembers'];
    if (json['members'] != null) {
      members = <Members>[];
      json['members'].forEach((v) {
        members!.add(new Members.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['mission'] = this.mission;
    data['teamavatorid'] = this.teamavatorid;
    data['token'] = this.token;
    data['totalMembers'] = this.totalMembers;
    if (this.members != null) {
      data['members'] = this.members!.map((v) => v.toJson()).toList();
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