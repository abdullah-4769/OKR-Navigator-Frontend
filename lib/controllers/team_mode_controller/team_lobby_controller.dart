import 'package:game_app/data/repositories/team_repo.dart';
import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:get/get.dart';
import '../../../generated/network.dart';
import '../../../generated/models/responses/team_mode/team_lobby_response.dart';
import '../../../generated/models/requests/team_mode/add_member_request.dart';
import '../../../generated/models/responses/team_mode/add_member_response.dart';
import '../../../data/repositories/storage_repository.dart';
import '../../../utils/snackbar_helper.dart'; // ✅ NEW IMPORT
import 'create_team_controller.dart';

class TeamLobbyController extends GetxController {
  // players list ko ab teamData.value.members se dynamically populate karenge
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
  // ✅ 2. INVITE MEMBERS / ADD MEMBER (API INTEGRATION)
  // ------------------------------------------------
  Future<void> inviteMembers() async {
    try {
      isInvitingMember.value = true;
      
      final teamId = teamData.value?.id;
      final hostId = _storageRepository.getUser()?.id;
      
      if (teamId == null || hostId == null) {
        SnackbarHelper.error("Error: Team ID or Host ID missing.");
        return;
      }

      // **NOTE:** Since actual user ID selection/input is missing from UI,
      // we mock a request for a generic "Invite" action for now, 
      // typically this API would use a token or QR code. 
      // If this API adds a member directly, we use a placeholder user ID.

      // Placeholder for invited user ID (Should come from user search/input in a real app)
      final invitedUserId = 'temp_member_${DateTime.now().millisecondsSinceEpoch}';

      final request = AddMemberRequest(
        hostId: hostId,
        userId: invitedUserId, 
        role: "MEMBER",
      );
      
      // Call repository method: POST /team/{teamId}/add-member
      final addMemberResponse = await _teamRepository.addMember(teamId, request);
      
      if (addMemberResponse.id != null) {
        SnackbarHelper.success("Member invited successfully! Lobby refreshing...");
        // API response ke baad lobby ko refresh karein taaki naya member list mein aa jaaye
        await fetchTeamDetails(); 
      } else {
        SnackbarHelper.error("Failed to invite member. Please try again.");
      }
    } catch (e) {
      SnackbarHelper.error("Failed to invite member: ${e.toString()}");
      print('Error inviting member: $e');
    } finally {
      isInvitingMember.value = false;
    }
  }
}