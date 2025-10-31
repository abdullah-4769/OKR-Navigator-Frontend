// lib/generated/models/requests/adaptation_analysis_request/adaptation_analysis_request.dart
class AdaptationAnalysisRequest {
  final String strategy;
  final String objective;
  final String keyResult;
  final String challenge;
  final String proposal;
  final List<Map<String, String>> initiatives;

  AdaptationAnalysisRequest({
    required this.strategy,
    required this.objective,
    required this.keyResult,
    required this.challenge,
    required this.proposal,
    required this.initiatives,
  });

  Map<String, dynamic> toJson() {
    return {
      'strategy': strategy,
      'objective': objective,
      'keyResult': keyResult,
      'challenge': challenge,
      'proposal': proposal,
      'initiatives': initiatives,
    };
  }

  factory AdaptationAnalysisRequest.fromJson(Map<String, dynamic> json) {
    return AdaptationAnalysisRequest(
      strategy: json['strategy'] ?? '',
      objective: json['objective'] ?? '',
      keyResult: json['keyResult'] ?? '',
      challenge: json['challenge'] ?? '',
      proposal: json['proposal'] ?? '',
      initiatives: (json['initiatives'] as List<dynamic>?)?.map((item) => Map<String, String>.from(item)).toList() ?? [],
    );
  }
}