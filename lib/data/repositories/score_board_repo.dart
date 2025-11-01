import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/api_constants.dart';
import '../../generated/models/responses/dashboard_for_all/campainmode_model.dart';
import '../../generated/models/responses/dashboard_for_all/challenge_mode_model.dart';
import '../../generated/models/responses/dashboard_for_all/solo_model.dart';
import '../../generated/models/responses/dashboard_for_all/team_mode_model.dart';

class ScoreboardRepository {
  Future<SoloModeModel?> getSoloScoreboard(String userId) async {
    try {
      final url = ApiConstants.soloScoreBoard(userId);
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return SoloModeModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load solo scoreboard: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching solo scoreboard: $e');
    }
  }

  Future<TeamModeModel?> getTeamScoreboard(String userId) async {
    try {
      final url = ApiConstants.teamScoreboard(userId);
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return TeamModeModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load team scoreboard: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching team scoreboard: $e');
    }
  }

  Future<CampaignModeModel?> getCampaignScoreboard(String campaignId) async {
    try {
      final url = ApiConstants.compaignModeScore(campaignId);
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return CampaignModeModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load campaign scoreboard: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching campaign scoreboard: $e');
    }
  }

  Future<ChallengeModeModel?> getChallengeScoreboard(String userId) async {
    try {
      final url = ApiConstants.challengeMode(userId);
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ChallengeModeModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load challenge scoreboard: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching challenge scoreboard: $e');
    }
  }
}
