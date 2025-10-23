import 'package:dio/dio.dart';
import 'package:game_app/data/network/app_url.dart';
import 'package:game_app/generated/models/requests/generate_initiatives_request.dart';
import 'package:game_app/generated/models/responses/key_results/key_results_response.dart';
import 'package:game_app/generated/models/responses/objectives/objectives_response.dart';
import 'package:retrofit/retrofit.dart';

import '../../generated/models/responses/strategy/generate_intiatives_response.dart';
import '../../generated/models/responses/strategy/strategy_response.dart';

part 'strategy_api.g.dart';

@RestApi()
abstract class StrategyApi {
  factory StrategyApi(Dio dio, {String? baseUrl}) = _StrategyApi;

  @GET(AppUrls.randomStrategy)
  Future<StrategyResponse> getRandomStrategy();

  @POST(AppUrls.objectivesGenerate)
  Future<ObjectivesResponse> generateObjectives(
    @Body() Map<String, dynamic> body,
  );

  @GET(AppUrls.keyResultsByStrategy)
  Future<List<KeyResultResponse>> getKeyResultsByStrategy(
    @Query('strategyId') int strategyId,
  );

  @POST(AppUrls.evaluateInitiative)
  Future<GenerateInitiativesResponse> evaluateInitiatives(
    @Body() GenerateInitiativesRequest body,
  );
}
