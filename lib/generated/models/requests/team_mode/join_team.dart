import 'package:game_app/generated/models/requests/base_request.dart';

class JoinTeamRequest extends BaseRequest {
  final String? token;
  final String? userId;

  const JoinTeamRequest({this.token, this.userId});

  @override
  Map<String, dynamic> toJson() => {
    'token': token,
    'userId': userId,
  };
}