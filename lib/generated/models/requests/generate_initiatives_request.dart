import 'base_request.dart';

class GenerateInitiativesRequest extends BaseRequest {
  final String? strategy;
  final String? objective;
  final String? keyResult;
  final List<String>? initiatives;
  final String? language;

  const GenerateInitiativesRequest({
    this.strategy,
    this.objective,
    this.keyResult,
    this.initiatives,
    this.language,
  });

  @override
  Map<String, dynamic> toJson() => {
    'strategy': strategy,
    'objective': objective,
    'keyResult': keyResult,
    'initiatives': initiatives == null
        ? []
        : List<dynamic>.from(initiatives!.map((x) => x)),
    'language': language,
  };
}
