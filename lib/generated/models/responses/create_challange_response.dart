// Create a response model in your models folder
class ChallengeCreateResponse {
  final int id;
  final String code;
  final String hostId;
  final String? playerId;
  final String status;
  final String createdAt;
  final String updatedAt;

  ChallengeCreateResponse({
    required this.id,
    required this.code,
    required this.hostId,
    this.playerId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChallengeCreateResponse.fromJson(Map<String, dynamic> json) {
    return ChallengeCreateResponse(
      id: json['id'],
      code: json['code'],
      hostId: json['hostId'],
      playerId: json['playerId'],
      status: json['status'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}