import 'package:game_app/generated/models/requests/base_request.dart';


class EditTeamRequest extends BaseRequest {
  final String? title;
  final String? mission;
  final String? teamavatorid;

  const EditTeamRequest({this.title, this.mission, this.teamavatorid});

  @override
  Map<String, dynamic> toJson() => {
    'title': title,
    'mission': mission,
    'teamavatorid': teamavatorid,
  };
}