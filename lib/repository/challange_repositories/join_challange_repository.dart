import 'dart:convert';
import '../../core/api_constants.dart';
import '../../data/network/base_api_services.dart';
import '../../data/network/network_api_services.dart';
import '../../generated/models/requests/challange_mode/join_challange_request.dart';


class JoinChallengeRepository {
  final BaseApiServices _apiServices = NetworkApiService();

  Future<dynamic> joinChallenge(String code, JoinChallengeRequest request) async {
    try {
      final url = ApiConstants.joinChallenge(code);
      print('JoinChallengeRepository: Sending POST to $url with data: ${jsonEncode(request.toJson())}');
      final response = await _apiServices.getPostApiResponse(url, request.toJson());
      print('JoinChallengeRepository: Received response: $response');
      return response;
    } catch (e) {
      print('JoinChallengeRepository: Error during API call: $e');
      rethrow;
    }
  }
}








// import 'dart:convert';
//
// import '../../data/network/base_api_services.dart';
// import '../../data/network/network_api_services.dart';
// import '../../generated/models/requests/challange_mode/join_challange_request.dart';
//
// class JoinChallengeRepository {
//   final BaseApiServices _apiServices = NetworkApiService();
//
//   static const String baseUrl = 'http://192.168.43.101:3000';
//
//   Future<dynamic> joinChallenge(String code, JoinChallengeRequest request) async {
//     try {
//       final url = '$baseUrl/challenges/join/$code';
//       print('JoinChallengeRepository: Sending POST to $url with data: ${jsonEncode(request.toJson())}');
//       final response = await _apiServices.getPostApiResponse(url, request.toJson());
//       print('JoinChallengeRepository: Received response: $response');
//       return response;
//     } catch (e) {
//       print('JoinChallengeRepository: Error during API call: $e');
//       rethrow;
//     }
//   }
// }
//
//
//
//
//
//
//
//
//
// // import 'dart:convert';
// //
// // import '../../data/network/base_api_services.dart';
// // import '../../data/network/network_api_services.dart';
// // import '../../generated/models/requests/challange_mode/join_challange_request.dart';
// //
// //
// // class JoinChallengeRepository {
// //   final BaseApiServices _apiServices = NetworkApiService();
// //
// //   // Base URL
// //   static const String baseUrl = '
// //   http://192.168.1.8:3000';
// //
// //   Future<dynamic> joinChallenge(String code, JoinChallengeRequest request) async {
// //     try {
// //       final url = '$baseUrl/challenges/join/$code';
// //       final response = await _apiServices.getPostApiResponse(url, request.toJson());
// //       return response;
// //     } catch (e) {
// //       rethrow;
// //     }
// //   }
// // }
