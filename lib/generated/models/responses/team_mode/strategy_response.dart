// lib/generated/models/responses/team_mode/strategy_response.dart

import 'package:game_app/generated/models/responses/base_response.dart';

class TeamStrategyResponse extends BaseResponse {
  final int? teamId;
  final String? title;
  final String? fileUrl;
  final String? role;
  final int? strategyId;
  final DateTime? createdAt;
  final RemainingTime? remainingTime;

  const TeamStrategyResponse({
    super.statusCode,
    super.message,
    this.teamId,
    this.title,
    this.fileUrl,
    this.role,
    this.strategyId,
    this.createdAt,
    this.remainingTime,
  });

  factory TeamStrategyResponse.fromJson(Map<String, dynamic> json) {
    // Safely extract the nested 'strategy' object
    final Map<String, dynamic>? strategyJson = 
        json['strategy'] is Map ? json['strategy'] : null;
    
    // Determine status code (assume 200 on 'success' status, or use actual status code if present)
    final int? determinedStatusCode = 
        json['statusCode'] as int? ?? 
        (json['status'] == 'success' ? 200 : null);
    
    // Extract values from the nested 'strategy' map
    final int? nestedStrategyId = strategyJson?['id'] as int?;
    final String? nestedTitle = strategyJson?['title'] as String?;
    final String? nestedFileUrl = strategyJson?['fileUrl'] as String?;
    final String? nestedCreatedAt = strategyJson?['createdAt'] as String?;

    // Extract remaining time
    final Map<String, dynamic>? remainingTimeJson = json['remainingTime'] as Map<String, dynamic>?;
    final RemainingTime? remainingTime = remainingTimeJson != null 
        ? RemainingTime.fromJson(remainingTimeJson)
        : null;

    return TeamStrategyResponse(
      // Use determined status and message from root or default
      statusCode: determinedStatusCode,
      message: json['message'] ?? (json['status'] == 'success' ? 'Session active' : 'Failed to fetch strategy'),
      
      // Use nested values for strategy details
      strategyId: nestedStrategyId,
      title: nestedTitle,
      fileUrl: nestedFileUrl,
      
      // Use existing fields if present
      teamId: json['teamId'], 
      role: json['role'],    
      createdAt: nestedCreatedAt == null 
          ? null 
          : DateTime.tryParse(nestedCreatedAt),
      remainingTime: remainingTime,
    );
  }

  Map<String, dynamic> toJson() => {
    'statusCode': statusCode,
    'message': message,
    'teamId': teamId,
    'title': title,
    'fileUrl': fileUrl,
    'role': role,
    'strategyId': strategyId,
    'createdAt': createdAt?.toIso8601String(),
    'remainingTime': remainingTime?.toJson(),
  };
}

class RemainingTime {
  final int minutes;
  final int seconds;

  const RemainingTime({
    required this.minutes,
    required this.seconds,
  });

  factory RemainingTime.fromJson(Map<String, dynamic> json) {
    return RemainingTime(
      minutes: json['minutes'] as int? ?? 0,
      seconds: json['seconds'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'minutes': minutes,
    'seconds': seconds,
  };
}

class GetTeamStrategyRequest {
  final int teamId;
  final String role;

  const GetTeamStrategyRequest({
    required this.teamId,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
    'teamId': teamId,
    'role': role,
  };
}