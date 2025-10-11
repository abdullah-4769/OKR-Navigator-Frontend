import 'package:game_app/generated/models/responses/base_response.dart';

class GenerateInitiativesResponse extends BaseResponse {
  final int? score;
  final String? decision;
  final String? explanation;

  const GenerateInitiativesResponse({
    super.statusCode,
    super.message,
    this.score,
    this.decision,
    this.explanation,
  });

  factory GenerateInitiativesResponse.fromJson(Map<String, dynamic> json) =>
      GenerateInitiativesResponse(
        statusCode: json['statusCode'],
        message: json['message'],
        score: json['score'],
        decision: json['decision'],
        explanation: json['explanation'],
      );
}
