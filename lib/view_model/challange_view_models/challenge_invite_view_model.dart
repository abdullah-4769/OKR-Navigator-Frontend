// import 'package:get/get.dart';
// import '../../../data/response/api_response.dart';
// import '../../../data/response/status.dart';
// import '../../repository/challange_repositories/challenge_send__invite_repostory.dart';
//
// class SendInviteViewModel extends GetxController {
//   final SendInviteRepo _repo = SendInviteRepo();
//
//   var sendInviteResponse = ApiResponse<dynamic>.initial("Initial").obs;
//
//   Future<void> sendInvites(int challengeId, List<String> playerIds) async {
//     sendInviteResponse.value = ApiResponse.loading();
//
//     try {
//       final res = await _repo.sendMultipleInvites(challengeId: challengeId, playerIds: playerIds);
//       sendInviteResponse.value = ApiResponse.completed(res);
//     } catch (e) {
//       sendInviteResponse.value = ApiResponse.error(e.toString());
//     }
//   }
// }
