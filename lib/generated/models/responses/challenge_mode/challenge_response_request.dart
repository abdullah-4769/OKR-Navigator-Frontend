// lib/generated/models/requests/challange_mode/challenge_response_request.dart
class ChallengeResponseRequest {
  final String playerId;
  final bool accept;

  ChallengeResponseRequest({
    required this.playerId,
    required this.accept,
  });

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'accept': accept,
    };
  }
}