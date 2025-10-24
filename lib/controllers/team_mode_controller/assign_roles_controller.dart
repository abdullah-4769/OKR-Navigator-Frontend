
import 'package:game_app/generated/models/requests/team_mode/set_team_role_for_game_request.dart';
import 'package:game_app/generated/models/responses/team_mode/set_team_role_for_game_response.dart';
import 'package:game_app/utils/snackbar_helper.dart';
import 'package:get/get.dart';
import '../../../generated/network.dart';
import '../../../generated/models/responses/team_mode/assign_roles_response.dart/assign_roles_response.dart';
import '../../../generated/models/requests/team_mode/update_team_member_request.dart';
import '../../../generated/models/responses/team_mode/update_team_member_response.dart';
import '../../../data/repositories/storage_repository.dart';
import '../../data/repositories/team_repository.dart';
import 'create_team_controller.dart';

class AssignRolesController extends GetxController {
  var isLoading = false.obs;
  var isUpdatingRole = false.obs;
  var isAutoUpdatingRole =false.obs;
  var members = <AssignRoleResponse>[].obs;
  var errorMessage = ''.obs;
final TeamRepository _teamRepository = Get.find<TeamRepository>(); // ✅ Inject Repository

  @override
  void onInit() {
    super.onInit();
    // ✅ Load members as soon as the controller is initialized (when screen opens)
    fetchTeamMembers(); 
  }

  Future<void> fetchTeamMembers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Get team ID from create team controller
      final createTeamController = Get.find<CreateTeamController>();
      final teamId = createTeamController.createdTeamId.value;
      
      if (teamId == null) {
        errorMessage.value = 'No team ID found. Please create a team first.';
        SnackbarHelper.error('Cannot load members: Team ID missing.');
        return;
      }
      
      // ✅ API Call: GET /team/{teamId}/members via Repository
      // Note: Humne pichle steps mein TeamRepository mein getTeamMembers method define kiya tha.
      final membersList = await _teamRepository.getTeamMembers(teamId);
      
      members.assignAll(membersList);
      
    } catch (e) {
      errorMessage.value = 'Failed to load team members: ${e.toString()}';
      SnackbarHelper.error('Failed to load team members.');
      print('Error fetching team members: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> assignRole(String userId, String role) async {
    try {
      isUpdatingRole.value = true;
      
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
      final request = UpdateTeamMemberRequest(
        hostId: hostId,
        userId: userId,
        role: role,
      );
      
      final response = await dio.post('/team/$teamId/update-role', data: request.toJson());
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final updateResponse = UpdateTeamMemberResponse.fromJson(response.data);
        
        // Update the member's role in the local list
        final memberIndex = members.indexWhere((member) => member.userId == userId);
        if (memberIndex != -1) {
          members[memberIndex].role = updateResponse.role;
          members.refresh(); // Trigger UI update
        }
        
        SnackbarHelper.success("Role updated successfully!");
      } else {
        Get.snackbar("Error", "Failed to update role. Please try again.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update role: ${e.toString()}");
      print('Error updating role: $e');
    } finally {
      isUpdatingRole.value = false;
    }
  }


   Future<void> setRoleForGame() async {
    try {
      isAutoUpdatingRole.value = true;
      
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
      final request = SetTeamRoleForGameRequest(teamId: teamId,role: 'HOST');
      
      final response = await dio.post('/game/set-role', data: request.toJson());
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final updateResponse = SetTeamRoleForGameResponse.fromJson(response.data);
        
        // Update the member's role in the local list
       
        Get.snackbar("Success", "Role updated successfully!");
      } else {
        Get.snackbar("Error", "Failed to update role. Please try again.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update role: ${e.toString()}");
      print('Error updating role: $e');
    } finally {
      isAutoUpdatingRole.value = false;
    }
  }
}

