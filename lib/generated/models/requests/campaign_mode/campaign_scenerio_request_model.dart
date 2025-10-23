// lib/generated/models/requests/campaign_scenario_request.dart
import '../../../../services/shared_preference.dart';

class CampaignScenarioRequest {
  final String sector;
  final String role;
  final String language;

  CampaignScenarioRequest({
    required this.sector,
    required this.role,
    required this.language,
  });

  Map<String, dynamic> toJson() {
    return {
      'sector': sector,
      'role': role,
      'language': language,
    };
  }

  factory CampaignScenarioRequest.fromSharedPreferences() {
    final role = SharedPrefs.getUserRole() ?? 'Chief Executive Officer';
    final industry = SharedPrefs.getSelectedIndustry();
    final sector = industry?['titleKey']?.toString() ?? 'Technology';

    return CampaignScenarioRequest(
      sector: sector,
      role: role,
      language: 'English', // You can get this from language controller
    );
  }
}