import 'package:dio/dio.dart';
import 'package:game_app/data/network/app_url.dart';
import 'package:retrofit/retrofit.dart';

import '../../generated/models/requests/register_request.dart';
import '../../generated/models/responses/auth/login_response.dart';
import '../../generated/models/responses/auth/register_response.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST('${AppUrls.loginUrl}')
  Future<LoginResponse> login(@Body() Map<String, dynamic> request);

  @POST('${AppUrls.signUpUrl}')
  Future<RegisterResponse> register(@Body() RegisterRequest request);

}
