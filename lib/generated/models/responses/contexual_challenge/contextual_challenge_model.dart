// lib/generated/models/responses/challenge/challenge_response.dart
class ChallengeResponse {
  final String? title;
  final String? text;
  final String? id;

  ChallengeResponse({
    this.title,
    this.text,
    this.id,
  });

  factory ChallengeResponse.fromJson(Map<String, dynamic> json) {
    // UTF-8 decode ensure karo
    return ChallengeResponse(
      title: json['title']?.toString(), // Safe string conversion
      text: json['text']?.toString(),   // Safe string conversion
      id: json['id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'text': text,
      'id': id,
    };
  }

  @override
  String toString() {
    return 'ChallengeResponse(title: $title, text: ${text?.substring(0, 50)}...)';
  }
}