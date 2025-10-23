import '../base_response.dart';

class StrategyResponse extends BaseResponse {
  final int? id;
  final String? title;
  final String? fileUrl;
  final int? cardId;
  final int? strategyId;
  final DateTime? createdAt;

  const StrategyResponse({
    super.statusCode,
    super.message,
    this.id,
    this.title,
    this.fileUrl,
    this.cardId,
    this.strategyId,
    this.createdAt,
  });

  factory StrategyResponse.fromJson(Map<String, dynamic> json) =>
      StrategyResponse(
        statusCode: json['statusCode'] as int?,
        message: json['message'],
        id: json['id'],
        title: json['title'],
        fileUrl: json['fileUrl'],
        cardId: json['cardId'],
        strategyId: json['strategyID'],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
      );
}

class GetTeamStrategyRequest {
  final int teamId;
  final String role; // "HOST"

  GetTeamStrategyRequest({required this.teamId, required this.role});

  Map<String, dynamic> toJson() => {
        "teamId": teamId,
        "role": role,
      };
}
