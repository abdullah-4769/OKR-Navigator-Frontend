class ChallengeCreateRequest {
  String? hostId;

  ChallengeCreateRequest({this.hostId});

  ChallengeCreateRequest.fromJson(Map<String, dynamic> json) {
    hostId = json['hostId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['hostId'] = hostId;
    return data;
  }
}
