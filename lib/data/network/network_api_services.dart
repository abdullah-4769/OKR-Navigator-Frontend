// lib/data/network/network_api_services.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../app_exceptions.dart';
import 'base_api_services.dart';

class NetworkApiService implements BaseApiServices {
  @override
  Future getGetApiResponse(String url) async {
    if (kDebugMode) print("GET: $url");
    dynamic responseJson;
    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 20));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Network Request timed out');
    }
    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    if (kDebugMode) {
      print("POST: $url");
      print("DATA: $data");
    }
    dynamic responseJson;
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 20));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Network Request timed out');
    }
    return responseJson;
  }

  // PATCH METHOD
  Future getPatchApiResponse(String url, dynamic data) async {
    if (kDebugMode) {
      print("PATCH: $url");
      print("DATA: $data");
    }
    dynamic responseJson;
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 20));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Network Request timed out');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    if (kDebugMode) {
      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");
    }

    // Check if response is HTML instead of JSON
    if (response.body.trim().startsWith('<!DOCTYPE') ||
        response.body.trim().startsWith('<html')) {
      if (kDebugMode) {
        print("⚠️ ERROR: Received HTML instead of JSON");
        print("This usually means the API endpoint doesn't exist or there's a routing issue");
      }
      throw FetchDataException(
          'Server returned HTML instead of JSON. Check your API endpoint configuration.'
      );
    }

    switch (response.statusCode) {
      case 200:
      case 201:
      case 204:
        try {
          // Handle empty responses
          if (response.body.isEmpty || response.body.trim().isEmpty) {
            return {'success': true};
          }

          // Try to decode JSON
          final decoded = jsonDecode(response.body);

          if (kDebugMode) {
            print("✅ Successfully decoded JSON");
            print("📦 Response type: ${decoded.runtimeType}");
          }

          return decoded;
        } catch (e) {
          if (kDebugMode) {
            print("❌ JSON decode error: $e");
            print("Raw body: ${response.body}");
          }
          throw FetchDataException('Invalid JSON response: $e');
        }
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 404:
        throw FetchDataException('API endpoint not found (404): ${response.body}');
      case 500:
        throw FetchDataException('Server error (500): ${response.body}');
      default:
        throw FetchDataException(
            'Unexpected error occurred (${response.statusCode}): ${response.body}'
        );
    }
  }
}




