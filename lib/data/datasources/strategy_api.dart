import 'package:dio/dio.dart';
import 'package:game_app/generated/models/requests/generate_initiatives_request.dart';
import 'package:game_app/generated/models/responses/key_results/key_results_response.dart';
import 'package:game_app/generated/models/responses/objectives/objectives_response.dart';
import 'package:game_app/generated/models/responses/team_mode/final_evaluation_response.dart';
import 'package:game_app/generated/models/responses/team_mode/strategy_response.dart';
import 'package:retrofit/retrofit.dart';

// NEW MODEL IMPORTS FOR INTEGRATION
import '../../generated/models/responses/contexual_challenge/contextual_challenge_model.dart';

import '../../generated/models/responses/strategy/generate_intiatives_response.dart';
import '../../generated/models/responses/strategy/strategy_response.dart' hide GetTeamStrategyRequest;

part 'strategy_api.g.dart';

@RestApi()
abstract class StrategyApi {
 factory StrategyApi(Dio dio, {String? baseUrl}) = _StrategyApi;

 /// ✅ Random strategy
 @GET('/game/random-strategy')
 Future<StrategyResponse> getRandomStrategy();

 /// ✅ Generate objectives
 @POST('/objectives/generate')
 Future<ObjectivesResponse> generateObjectives(
  @Body() Map<String, dynamic> body,
 );

 /// ✅ Fetch objectives by strategy ID
 @GET('/objectives/fetch-strategy-id-based')
 Future<ObjectivesResponse> fetchObjectivesByStrategyId(
  @Query('strategyId') int strategyId,
 );

 /// ✅ Fetch objectives for challenge
 @GET('/objectives/fetch-objective-for-challenge')
 Future<ObjectivesResponse> fetchObjectivesForChallenge(
  @Query('strategyId') int strategyId,
 );

 /// ✅ Fetch key results by strategy
 @GET('/key-result/by-strategy')
 Future<List<KeyResultResponse>> getKeyResultsByStrategy(
  @Query('strategyId') int strategyId,
 );

 /// ✅ Create batch key results
 @POST('/key-result/batch')
 Future<List<KeyResultResponse>> createBatchKeyResults(
  @Body() Map<String, dynamic> body,
 );

 /// ✅ Evaluate AI suggestion for key results
  
 @POST('/team/keyresults/evaluate')
 Future<EvaluateKeyResultsResponse> evaluateKeyResults(
   @Body() Map<String, dynamic> body);

 @POST('/keywordbase-innovative')
 Future<AddInnovativeResponse> addInnovativeIdea(@Body() Map<String, dynamic> body);

 @GET('/keywordbase-innovative/strategy/{strategyId}')
 Future<InnovativeIdeasResponse> fetchInnovativeIdeas(@Path('strategyId') int strategyId);

 /// ✅ Evaluate initiatives
 @POST('/evaluate-initiatives')
 Future<GenerateInitiativesResponse> evaluateInitiatives(
  @Body() GenerateInitiativesRequest body,
 );

 /// ✅ Get team strategy
 @POST('/game/team-strategy')
 Future<TeamStrategyResponse> getTeamStrategy(
  @Body() GetTeamStrategyRequest body,
 );

 
 /// 1. Generate challenge (POST /challenge)
 @POST('/challenge')
 Future<ChallengeResponse> getChallenge(
  @Body() Map<String, dynamic> body,
 );

 /// 2. Final Challenge OKR Evaluation (POST /team-challenges/evaluation)
 @POST('/team-challenges/evaluation')
 Future<FinalEvaluationResponse> evaluateFinalChallenge(
  @Body() Map<String, dynamic> body,
 );
@POST('/final-team-score')
Future<Map<String, dynamic>> submitFinalTeamScore(@Body() Map<String, dynamic> body);

@GET('/final-team-score/{teamId}/summary')
Future<Map<String, dynamic>> getFinalTeamScoreSummary(@Path('teamId') int teamId);

@GET('/final-team-score/{teamId}/user/{userId}/score')
Future<Map<String, dynamic>> getUserFinalScoreInTeam(
  @Path('teamId') int teamId,
  @Path('userId') String userId,
);

@GET('/final-team-score/team/{teamId}/rewards-summary')
Future<Map<String, dynamic>> getTeamRewardsSummary(@Path('teamId') int teamId);
}