class CreateTeamResponse {
  Team? team;
  String? token;

  CreateTeamResponse({this.team, this.token});

  CreateTeamResponse.fromJson(Map<String, dynamic> json) {
    team = json['team'] != null ? new Team.fromJson(json['team']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.team != null) {
      data['team'] = this.team!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class Team {
  int? id;
  String? title;
  String? mission;
  String? hostId;
  String? createdAt;
  String? teamavatorid;

  Team(
      {this.id,
      this.title,
      this.mission,
      this.hostId,
      this.createdAt,
      this.teamavatorid});

  Team.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    mission = json['mission'];
    hostId = json['hostId'];
    createdAt = json['createdAt'];
    teamavatorid = json['teamavatorid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['mission'] = this.mission;
    data['hostId'] = this.hostId;
    data['createdAt'] = this.createdAt;
    data['teamavatorid'] = this.teamavatorid;
    return data;
  }
}