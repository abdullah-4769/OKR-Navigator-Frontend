// import 'package:game_app/generated/models/responses/base_response.dart';
//
// class GenerateInitiativesResponse extends BaseResponse {
//   final int? score;
//   final String? decision;
//   final String? explanation;
//
//   const GenerateInitiativesResponse({
//     super.statusCode,
//     super.message,
//     this.score,
//     this.decision,
//     this.explanation,
//   });
//
//   factory GenerateInitiativesResponse.fromJson(Map<String, dynamic> json) =>
//       GenerateInitiativesResponse(
//         statusCode: json['statusCode'],
//         message: json['message'],
//         score: json['score'],
//         decision: json['decision'],
//         explanation: json['explanation'],
//       );
// }
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

  factory GenerateInitiativesResponse.fromJson(Map<String, dynamic> json) {
    dynamic data = json['data'];

    // Handle if backend returns a list
    if (data is List && data.isNotEmpty) {
      data = data.first;
    }

    // Handle if backend returns nested object
    if (data is Map<String, dynamic>) {
      return GenerateInitiativesResponse(
        statusCode: json['statusCode'],
        message: json['message'],
        score: data['score'],
        decision: data['decision'],
        explanation: data['explanation'],
      );
    }

    // Fallback (in case response has no data key)
    return GenerateInitiativesResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      score: json['score'],
      decision: json['decision'],
      explanation: json['explanation'],
    );
  }
}
