// lib/data/repositories/team_repo.dart
import 'package:game_app/data/datasources/team_api.dart';
import 'package:game_app/generated/models/requests/team_mode/add_member_request.dart';

import 'package:game_app/generated/models/requests/team_mode/update_team_member_request.dart';
import 'package:game_app/generated/models/responses/team_mode/add_member_response.dart';
import 'package:game_app/generated/models/responses/team_mode/assign_roles_response.dart/assign_roles_response.dart';
import 'package:game_app/generated/models/responses/team_mode/create_team_response.dart'; // Need Team model
import 'package:game_app/generated/models/responses/team_mode/team_lobby_response.dart';
import 'package:game_app/generated/models/responses/team_mode/update_team_member_response.dart';
import '../../generated/models/requests/team_mode/edit_team_request.dart';
import '../../generated/models/requests/team_mode/join_team.dart';
import '../../generated/network.dart';

class TeamRepository {
  final TeamApi _teamApi = TeamApi(dio); // Initialize API client

  // 1. Edit Team (PATCH /team/{id})
  Future<Team> editTeam(int teamId, EditTeamRequest request) async {
    return _teamApi.editTeam(teamId, request);
  }

  // 2. Join Team (POST /team/join)
  // Handles both wrapped response { "message": "...", "team": {...} } and direct response
  // Also handles cases where members might be an array of strings (user IDs) instead of objects
  Future<TeamLobbyResponse> joinTeam(JoinTeamRequest request) async {
    final response = await dio.post(
      '/team/join',
      data: request.toJson(),
    );
    final responseData = response.data;
    
    // Handle wrapped response: { "message": "...", "team": {...} }
    Map<String, dynamic> teamData;
    if (responseData is Map<String, dynamic>) {
      if (responseData.containsKey('team')) {
        final teamObj = responseData['team'];
        if (teamObj is Map<String, dynamic>) {
          teamData = Map<String, dynamic>.from(teamObj);
        } else {
          teamData = Map<String, dynamic>.from(responseData);
        }
      } else {
        // If not wrapped, use response data directly
        teamData = Map<String, dynamic>.from(responseData);
      }
    } else {
      teamData = <String, dynamic>{};
    }
    
    // Handle case where members might be an array of strings (user IDs) instead of objects
    if (teamData['members'] != null && teamData['members'] is List) {
      final membersList = teamData['members'] as List;
      if (membersList.isNotEmpty && membersList.first is String) {
        // Convert array of strings to array of member objects
        final hostId = teamData['hostId'] as String?;
        final convertedMembers = membersList.map<Map<String, dynamic>>((userId) {
          return <String, dynamic>{
            'userId': userId,
            'role': userId == hostId ? 'HOST' : 'PLAYER',
          };
        }).toList();
        teamData['members'] = convertedMembers;
      }
    }
    
    // Create TeamLobbyResponse from the processed data
    final teamLobbyResponse = TeamLobbyResponse.fromJson(teamData);
    return teamLobbyResponse;
  }

  // 3. Get Team Details (GET /team/{id}/details)
  Future<TeamLobbyResponse> getTeamDetails(int teamId) async {
    return _teamApi.getTeamDetails(teamId);
  }

  // 4. Add Team Member (POST /team/{teamId}/add-member)
  Future<AddMemberResponse> addMember(int teamId, AddMemberRequest request) async {
    return _teamApi.addMember(teamId, request);
  }

  // 5. Get Team Members to assign role (GET /team/{teamId}/members)
  Future<List<AssignRoleResponse>> getTeamMembers(int teamId) async {
    return _teamApi.getTeamMembers(teamId);
  }

  // 6. Update Team Member Role (POST /team/{teamId}/update-role)
  Future<UpdateTeamMemberResponse> updateMemberRole(
      int teamId, UpdateTeamMemberRequest request) async {
    return _teamApi.updateMemberRole(teamId, request);
  }

  // 7. Send WS Invite (POST /ws/invite)
  Future<void> sendWsInvite(String teamToken) async {
    // Note: The Retrofit method uses Map<String, dynamic> body
    return _teamApi.sendWsInvite({"teamToken": teamToken});
  }

  // 8. Join WS Team (POST /ws/join-team)
  Future<void> joinWsTeam(String teamToken, String userId) async {
    // Note: The Retrofit method uses Map<String, dynamic> body
    return _teamApi.joinWsTeam({
      "teamToken": teamToken,
      "userId": userId,
    });
  }

  // 9. Send WS Message (POST /ws/message)
  Future<void> sendWsMessage(String teamToken, String message) async {
    return _teamApi.sendWsMessage({
      "teamToken": teamToken,
      "message": message,
    });
  }

  Future<void> sendFCMNotification(Map<String, dynamic> payload) async {
    return _teamApi.sendNotification(payload);
  }
}