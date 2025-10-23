// lib/data/datasources/team_api.dart
import 'package:dio/dio.dart';
import 'package:game_app/generated/models/requests/team_mode/edit_team_request.dart';
import 'package:game_app/generated/models/requests/team_mode/join_team.dart';
import 'package:retrofit/retrofit.dart';

import '../../generated/models/requests/team_mode/add_member_request.dart';
import '../../generated/models/requests/team_mode/update_team_member_request.dart';

import '../../generated/models/responses/team_mode/add_member_response.dart';
import '../../generated/models/responses/team_mode/team_lobby_response.dart';
import '../../generated/models/responses/team_mode/assign_roles_response.dart/assign_roles_response.dart';
import '../../generated/models/responses/team_mode/update_team_member_response.dart';
import '../../generated/models/responses/team_mode/create_team_response.dart'; // Need Team model

part 'team_api.g.dart';

@RestApi()
abstract class TeamApi {
  factory TeamApi(Dio dio, {String baseUrl}) = _TeamApi;

  // 1. Edit Team (PUTCH /team/{id})
  @PATCH('/team/{id}')
  Future<Team> editTeam(@Path('id') int teamId, @Body() EditTeamRequest request);

  // 2. Join Team (POST /team/join)
  @POST('/team/join')
  Future<TeamLobbyResponse> joinTeam(@Body() JoinTeamRequest request);

  // 3. Get Team Details (GET /team/{id}/details)
  @GET('/team/{id}/details')
  Future<TeamLobbyResponse> getTeamDetails(@Path('id') int teamId);

  // 4. Add Team Member (POST /team/{teamId}/add-member)
  @POST('/team/{teamId}/add-member')
  Future<AddMemberResponse> addMember(
    @Path('teamId') int teamId,
    @Body() AddMemberRequest request,
  );
  
  // 5. Get Team Members to assign role (GET /team/{teamId}/members)
  @GET('/team/{teamId}/members')
  Future<List<AssignRoleResponse>> getTeamMembers(@Path('teamId') int teamId);

  // 6. Update Team Member Role (POST /team/{teamId}/update-role)
  @POST('/team/{teamId}/update-role')
  Future<UpdateTeamMemberResponse> updateMemberRole(
    @Path('teamId') int teamId,
    @Body() UpdateTeamMemberRequest request,
  );

  
  @POST('/ws/invite')
  Future<void> sendWsInvite(@Body() Map<String, dynamic> body);

  // 9. Join Team Room (POST /ws/join-team)
  @POST('/ws/join-team')
  Future<void> joinWsTeam(@Body() Map<String, dynamic> body);

  // 10. Send Message to Team (POST /ws/message)
  @POST('/ws/message')
  Future<void> sendWsMessage(@Body() Map<String, dynamic> body);
}