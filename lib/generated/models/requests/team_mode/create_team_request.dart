class CreateTeamRequest {
  String? title;
  String? mission;
  String? hostId;
  String? teamavatorid;

  CreateTeamRequest({this.title, this.mission, this.hostId, this.teamavatorid});

  CreateTeamRequest.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    mission = json['mission'];
    hostId = json['hostId'];
    teamavatorid = json['teamavatorid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['mission'] = this.mission;
    data['hostId'] = this.hostId;
    data['teamavatorid'] = this.teamavatorid;
    return data;
  }
}