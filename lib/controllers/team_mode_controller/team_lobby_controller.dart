import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:get/get.dart';

class TeamLobbyController extends GetxController {
  var players = <String>["You", "Johnson", "Tasha"].obs;


  @override
  void onInit() {
    super.onInit();
    Future.microtask(() {
      players.assignAll(["You", "Johnson", "Tasha"]);
    });
  }

  void beginMission() {
   Get.toNamed(AppRoutes.teamStrategySelection);
  }

  void inviteMembers() {
    print("Invite logic here");
  }

}
