import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:game_app/data/response/api_response.dart';
import '../../generated/models/requests/challange_mode/join_challange_request.dart';
import '../../repository/challange_repositories/join_challange_repository.dart';

class JoinChallengeViewModel extends GetxController {
  final JoinChallengeRepository _repository = JoinChallengeRepository();

  final Rx<ApiResponse> _joinChallengeResponse = ApiResponse.notStarted().obs;
  ApiResponse get joinChallengeResponse => _joinChallengeResponse.value;

  final isJoining = false.obs;

  Future<void> joinChallenge(String code) async {
    print('JoinChallengeViewModel: joinChallenge called with code: $code');
    try {
      isJoining.value = true;
      _joinChallengeResponse.value = ApiResponse.loading();
      print('JoinChallengeViewModel: Set isJoining to true, response to loading');

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      print('JoinChallengeViewModel: Retrieved userId: $userId');

      if (userId == null) {
        print('JoinChallengeViewModel: Error - User ID not found in SharedPreferences');
        _joinChallengeResponse.value = ApiResponse.error("User ID not found");
        return;
      }

      final request = JoinChallengeRequest(userId: userId);
      print('JoinChallengeViewModel: Sending join request with code: $code, userId: $userId');

      final response = await _repository.joinChallenge(code, request);
      print('JoinChallengeViewModel: Received response: $response');

      _joinChallengeResponse.value = ApiResponse.completed(response);
      print('JoinChallengeViewModel: Set response to completed');
      // ✅ Save joined challenge ID for later use
      try {
        final prefs = await SharedPreferences.getInstance();
        // Assuming response is a Map (based on your API response)
        final challengeId = response['id']?.toString();
        if (challengeId != null) {
          await prefs.setString('joinChallengeId', challengeId);
          print('✅ Saved joinChallengeId: $challengeId');
        } else {
          print('⚠️ No challenge ID found in join challenge response');
        }
      } catch (e) {
        print('⚠️ Error saving joinChallengeId to SharedPreferences: $e');
      }

    } catch (error) {
      print('JoinChallengeViewModel: Error occurred: $error');
      _joinChallengeResponse.value = ApiResponse.error(error.toString());
    } finally {
      isJoining.value = false;
      print('JoinChallengeViewModel: Set isJoining to false');
    }

  }
}