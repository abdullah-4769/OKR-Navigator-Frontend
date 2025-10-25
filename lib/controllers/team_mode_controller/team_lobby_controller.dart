import 'package:game_app/data/repositories/team_repo.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:get/get.dart';
import '../../../generated/network.dart';
import '../../../generated/models/responses/team_mode/team_lobby_response.dart';

import '../../../data/repositories/storage_repository.dart';
import '../../../utils/snackbar_helper.dart'; // ✅ NEW IMPORT
import 'create_team_controller.dart';

class TeamLobbyController extends GetxController {
  var players = <String>[].obs; 
  var isLoading = false.obs;
  var isInvitingMember = false.obs;
  var teamData = Rxn<TeamLobbyResponse>();
  var errorMessage = ''.obs;

  final TeamRepository _teamRepository = Get.find<TeamRepository>();
  final StorageRepository _storageRepository = Get.find<StorageRepository>();

  @override
  void onInit() {
    super.onInit();
    fetchTeamDetails(); // ✅ Screen load hote hi details fetch karein
  }

  // ------------------------------------------------
  // ✅ 1. GET TEAM DETAILS (API INTEGRATION)
  // ------------------------------------------------
  Future<void> fetchTeamDetails() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final createTeamController = Get.find<CreateTeamController>();
      // createdTeamId pichli screen (CreateTeam) se set hota hai
      final teamId = createTeamController.createdTeamId.value; 
      
      if (teamId == null) {
        errorMessage.value = 'No team ID found. Please create a team first.';
        SnackbarHelper.error('No team ID found.');
        return;
      }
      
      // Call repository method: GET /team/{id}/details
      final teamLobbyResponse = await _teamRepository.getTeamDetails(teamId);
      teamData.value = teamLobbyResponse;
      
      if (teamLobbyResponse.members != null) {
        // UI ke liye players list update karein
        players.assignAll(teamLobbyResponse.members!.map((member) => member.user?.name ?? 'Unknown').toList());
      } else {
        players.clear();
      }
      
      SnackbarHelper.success('Team Lobby details loaded!');

    } catch (e) {
      errorMessage.value = 'Failed to load team details: ${e.toString()}';
      SnackbarHelper.error('Failed to load team details.');
      print('Error fetching team details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void beginMission() {
    // Validation check: Minimum 2 players
    if (players.length < 2) {
      SnackbarHelper.warning("Minimum 2 players required to start the mission.");
      return;
    }
Get.toNamed(AppRoutes.assignRoleScreen);
  }

  // ------------------------------------------------
  // ✅ 2. INVITE MEMBERS (WS INVITE INTEGRATION) - MODIFIED
  // ------------------------------------------------
  Future<String?> inviteMembers() async {
    final teamToken = teamData.value?.token;

    if (teamToken == null) {
      SnackbarHelper.error("Error: Team Code missing.");
      return null;
    }

    try {
      isInvitingMember.value = true;

      // 1. Call WS Invite API to notify potential members
      await _teamRepository.sendWsInvite(teamToken);

      SnackbarHelper.success("Invite sent! Share the team code.");

      // 2. Return the token for the UI to display/copy
      return teamToken;

    } catch (e) {
      SnackbarHelper.error("Failed to send invite: ${e.toString()}");
      print('Error sending invite: $e');
      return null;
    } finally {
      isInvitingMember.value = false;
    }
  }
}