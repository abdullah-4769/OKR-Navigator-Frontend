import 'dashboard_all.dart';

class ChallengeModeModel {
  List<PlayerModel>? topThree;
  List<PlayerModel>? remaining;
  PlayerModel? userDetails;

  ChallengeModeModel({
    this.topThree,
    this.remaining,
    this.userDetails,
  });

  factory ChallengeModeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModeModel(
      topThree: json['topThree'] != null
          ? (json['topThree'] as List)
          .map((v) => PlayerModel.fromJson(v))
          .toList()
          : null,
      remaining: json['remaining'] != null
          ? (json['remaining'] as List)
          .map((v) => PlayerModel.fromJson(v))
          .toList()
          : null,
      userDetails: json['userDetails'] != null
          ? PlayerModel.fromJson(json['userDetails'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topThree': topThree?.map((v) => v.toJson()).toList(),
      'remaining': remaining?.map((v) => v.toJson()).toList(),
      'userDetails': userDetails?.toJson(),
    };
  }
}
