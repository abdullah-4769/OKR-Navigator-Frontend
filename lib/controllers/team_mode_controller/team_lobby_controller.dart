import 'package:game_app/presentation/routes/app_routes.dart';
import 'package:get/get.dart';
import '../../../generated/network.dart';
import '../../../generated/models/responses/team_mode/team_lobby_response.dart';
import '../../../generated/models/requests/team_mode/add_member_request.dart';
import '../../../generated/models/responses/team_mode/add_member_response.dart';
import '../../../data/repositories/storage_repository.dart';
import 'create_team_controller.dart';

class TeamLobbyController extends GetxController {
  var players = <String>["You", "Johnson", "Tasha"].obs;
  var isLoading = false.obs;
  var isInvitingMember = false.obs;
  var teamData = Rxn<TeamLobbyResponse>();
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTeamDetails();
  }

  Future<void> fetchTeamDetails() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Get team ID from create team controller
      final createTeamController = Get.find<CreateTeamController>();
      final teamId = createTeamController.createdTeamId.value;
      
      if (teamId == null) {
        errorMessage.value = 'No team ID found. Please create a team first.';
        return;
      }
      
      final response = await dio.get('/team/$teamId/details');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final teamLobbyResponse = TeamLobbyResponse.fromJson(response.data);
        teamData.value = teamLobbyResponse;
        
        // Update players list from API response
        if (teamLobbyResponse.members != null) {
          players.assignAll(teamLobbyResponse.members!.map((member) => member.user?.name ?? 'Unknown').toList());
        }
      } else {
        errorMessage.value = 'Failed to load team details. Please try again.';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load team details: ${e.toString()}';
      print('Error fetching team details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void beginMission() {
   Get.toNamed(AppRoutes.teamStrategySelection);
  }

  Future<void> inviteMembers() async {
    try {
      isInvitingMember.value = true;
      
      // Get team ID from create team controller
      final createTeamController = Get.find<CreateTeamController>();
      final teamId = createTeamController.createdTeamId.value;
      
      if (teamId == null) {
        Get.snackbar("Error", "No team ID found. Please create a team first.");
        return;
      }
      
      // Get current user as host
      final storageRepository = Get.find<StorageRepository>();
      final user = storageRepository.getUser();
      final hostId = user?.id;
      
      if (hostId == null) {
        Get.snackbar("Error", "User not found. Please login again.");
        return;
      }
      
      // Create request object
      final request = AddMemberRequest(
        hostId: hostId,
        userId: "temp_user_id", // You might want to get this from user input or selection
        role: "member",
      );
      
      final response = await dio.post('/team/$teamId/add-member', data: request.toJson());
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final addMemberResponse = AddMemberResponse.fromJson(response.data);
        
        // Add the new member to the existing team data
        if (teamData.value != null && teamData.value!.members != null) {
          // Create a new member object and add it to the list
          final newMember = Members(
            id: addMemberResponse.id,
            teamId: addMemberResponse.teamId,
            userId: addMemberResponse.userId,
            role: addMemberResponse.role,
            joinedAt: addMemberResponse.joinedAt,
            user: User(
              id: addMemberResponse.userId,
              name: "New Member", // You might want to get this from the response or user input
              avatarPicId: null,
            ),
          );
          
          // Create a new list with the existing members plus the new member
          final updatedMembers = List<Members>.from(teamData.value!.members!)..add(newMember);
          
          // Create a new TeamLobbyResponse with updated data
          final updatedTeamData = TeamLobbyResponse(
            id: teamData.value!.id,
            title: teamData.value!.title,
            mission: teamData.value!.mission,
            teamavatorid: teamData.value!.teamavatorid,
            token: teamData.value!.token,
            totalMembers: (teamData.value!.totalMembers ?? 0) + 1,
            members: updatedMembers,
          );
          
          // Update the team data to trigger UI refresh
          teamData.value = updatedTeamData;
          
          // Update players list
          players.add(newMember.user?.name ?? "New Member");
        }
        
        Get.snackbar("Success", "Member invited successfully!");
      } else {
        Get.snackbar("Error", "Failed to invite member. Please try again.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to invite member: ${e.toString()}");
      print('Error inviting member: $e');
    } finally {
      isInvitingMember.value = false;
    }
    
  }

}
