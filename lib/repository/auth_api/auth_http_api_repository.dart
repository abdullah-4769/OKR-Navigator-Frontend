
import '../../data/network/base_api_services.dart';
import '../../data/network/network_api_services.dart';
import 'auth_repository.dart';

class AuthHttpApiRepository implements AuthRepository {

  final BaseApiServices _apiServices = NetworkApiService() ;

  @override
  Future loginApi(dynamic data )async{
    // dynamic response = await _apiServices.getPostApiResponse(AppUrl.loginEndPint, data);
    // return UserModel.fromJson(response) ;
  }


}