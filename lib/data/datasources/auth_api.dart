import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../generated/models/requests/register_request.dart';
import '../../generated/models/responses/auth/login_response.dart';
import '../../generated/models/responses/auth/register_response.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST('/auth/login')
  Future<LoginResponse> login(@Body() Map<String, dynamic> request);

  @POST('/auth/register')
  Future<RegisterResponse> register(@Body() RegisterRequest request);
}
