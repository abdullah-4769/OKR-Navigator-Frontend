// lib/generated/models/responses/campaign_scenario_response.dart
class CampaignScenarioResponse {
  final String scenario;
  final List<Strategy> strategies;
  final int correctStrategyId;
  final String language;

  CampaignScenarioResponse({
    required this.scenario,
    required this.strategies,
    required this.correctStrategyId,
    required this.language,
  });

  factory CampaignScenarioResponse.fromJson(Map<String, dynamic> json) {
    return CampaignScenarioResponse(
      scenario: json['scenario'] ?? '',
      strategies: (json['strategies'] as List<dynamic>?)
          ?.map((strategy) => Strategy.fromJson(strategy))
          .toList() ?? [],
      correctStrategyId: json['correct_strategy_id'] ?? 1,
      language: json['language'] ?? 'English',
    );
  }

  // Get the correct strategy
  Strategy? get correctStrategy {
    return strategies.firstWhere(
          (strategy) => strategy.id == correctStrategyId,
      orElse: () => strategies.isNotEmpty ? strategies.first : Strategy.empty(),
    );
  }
}

class Strategy {
  final int id;
  final String title;
  final String text;

  Strategy({
    required this.id,
    required this.title,
    required this.text,
  });

  factory Strategy.fromJson(Map<String, dynamic> json) {
    return Strategy(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      text: json['text'] ?? '',
    );
  }

  static Strategy empty() {
    return Strategy(
      id: 0,
      title: '',
      text: '',
    );
  }
}