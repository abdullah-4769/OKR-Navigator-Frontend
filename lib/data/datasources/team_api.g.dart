// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_api.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter

class _TeamApi implements TeamApi {
  _TeamApi(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<Team> editTeam(int teamId, EditTeamRequest request) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<Team>(
      Options(method: 'PATCH', headers: _headers, extra: _extra)
          .compose(
        _dio.options,
        '/team/${teamId}',
        queryParameters: queryParameters,
        data: _data,
      )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late Team _value;
    try {
      _value = Team.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TeamLobbyResponse> joinTeam(JoinTeamRequest request) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<TeamLobbyResponse>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
        _dio.options,
        '/team/join',
        queryParameters: queryParameters,
        data: _data,
      )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TeamLobbyResponse _value;
    try {
      _value = TeamLobbyResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<TeamLobbyResponse> getTeamDetails(int teamId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<TeamLobbyResponse>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
        _dio.options,
        '/team/${teamId}/details',
        queryParameters: queryParameters,
        data: _data,
      )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late TeamLobbyResponse _value;
    try {
      _value = TeamLobbyResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AddMemberResponse> addMember(
      int teamId,
      AddMemberRequest request,
      ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<AddMemberResponse>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
        _dio.options,
        '/team/${teamId}/add-member',
        queryParameters: queryParameters,
        data: _data,
      )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late AddMemberResponse _value;
    try {
      _value = AddMemberResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<AssignRoleResponse>> getTeamMembers(int teamId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<AssignRoleResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
        _dio.options,
        '/team/${teamId}/members',
        queryParameters: queryParameters,
        data: _data,
      )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<AssignRoleResponse> _value;
    try {
      _value = _result.data!
          .map(
            (dynamic i) =>
            AssignRoleResponse.fromJson(i as Map<String, dynamic>),
      )
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<UpdateTeamMemberResponse> updateMemberRole(
      int teamId,
      UpdateTeamMemberRequest request,
      ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<UpdateTeamMemberResponse>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
        _dio.options,
        '/team/${teamId}/update-role',
        queryParameters: queryParameters,
        data: _data,
      )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late UpdateTeamMemberResponse _value;
    try {
      _value = UpdateTeamMemberResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<void> sendWsInvite(Map<String, dynamic> body) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _options = _setStreamType<void>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
        _dio.options,
        '/ws/invite',
        queryParameters: queryParameters,
        data: _data,
      )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    await _dio.fetch<void>(_options);
  }

  @override
  Future<void> joinWsTeam(Map<String, dynamic> body) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _options = _setStreamType<void>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
        _dio.options,
        '/ws/join-team',
        queryParameters: queryParameters,
        data: _data,
      )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    await _dio.fetch<void>(_options);
  }

  @override
  Future<void> sendWsMessage(Map<String, dynamic> body) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(body);
    final _options = _setStreamType<void>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
        _dio.options,
        '/ws/message',
        queryParameters: queryParameters,
        data: _data,
      )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    await _dio.fetch<void>(_options);
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// dart format on














// // GENERATED CODE - DO NOT MODIFY BY HAND
//
// part of 'team_api.dart';
//
// // dart format off
//
// // **************************************************************************
// // RetrofitGenerator
// // **************************************************************************
//
// // ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter
//
// class _TeamApi implements TeamApi {
//   _TeamApi(this._dio, {this.baseUrl, this.errorLogger});
//
//   final Dio _dio;
//
//   String? baseUrl;
//
//   final ParseErrorLogger? errorLogger;
//
//   @override
//   Future<TeamLobbyResponse> getTeamDetails(int teamId) async {
//     final _extra = <String, dynamic>{};
//     final queryParameters = <String, dynamic>{};
//     final _headers = <String, dynamic>{};
//     const Map<String, dynamic>? _data = null;
//     final _options = _setStreamType<TeamLobbyResponse>(
//       Options(method: 'GET', headers: _headers, extra: _extra)
//           .compose(
//             _dio.options,
//             '/team/${teamId}/details',
//             queryParameters: queryParameters,
//             data: _data,
//           )
//           .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
//     );
//     final _result = await _dio.fetch<Map<String, dynamic>>(_options);
//     late TeamLobbyResponse _value;
//     try {
//       _value = TeamLobbyResponse.fromJson(_result.data!);
//     } on Object catch (e, s) {
//       errorLogger?.logError(e, s, _options);
//       rethrow;
//     }
//     return _value;
//   }
//
//   RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
//     if (T != dynamic &&
//         !(requestOptions.responseType == ResponseType.bytes ||
//             requestOptions.responseType == ResponseType.stream)) {
//       if (T == String) {
//         requestOptions.responseType = ResponseType.plain;
//       } else {
//         requestOptions.responseType = ResponseType.json;
//       }
//     }
//     return requestOptions;
//   }
//
//   String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
//     if (baseUrl == null || baseUrl.trim().isEmpty) {
//       return dioBaseUrl;
//     }
//
//     final url = Uri.parse(baseUrl);
//
//     if (url.isAbsolute) {
//       return url.toString();
//     }
//
//     return Uri.parse(dioBaseUrl).resolveUri(url).toString();
//   }
// }
//
// // dart format on
