import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../generated/models/responses/team_mode/team_lobby_response.dart';

part 'team_api.g.dart';

@RestApi()
abstract class TeamApi {
  factory TeamApi(Dio dio, {String baseUrl}) = _TeamApi;

  @GET('/team/{id}/details')
  Future<TeamLobbyResponse> getTeamDetails(@Path('id') int teamId);
}
