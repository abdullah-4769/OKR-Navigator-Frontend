class CampaignSuggestion {
  final String name;
  final String description;

  CampaignSuggestion({required this.name, required this.description});

  factory CampaignSuggestion.fromJson(Map<String, dynamic> json) {
    return CampaignSuggestion(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
