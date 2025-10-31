class JoinChallengeRequest {
  final String userId;

  JoinChallengeRequest({required this.userId});

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
    };
  }
}
