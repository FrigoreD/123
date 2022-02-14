// ignore_for_file: avoid_classes_with_only_static_members, unnecessary_parenthesis

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../generated/l10n.dart';
import '../module/shared_void.dart';
import 'app_exception.dart';

class BaseClient {
  static const timeOut = 20;
  static const baseUrl = 'https://astrologyspica.dev-prod.com.ua/api';

  static Future<dynamic> get(
    String api, {
    bool authorization = true,
    String baseUrl = baseUrl,
  }) async {
    final Map<String, String> headers = await getHeaders(authorization);
    final uri = Uri.parse(baseUrl + api);
    debugPrint('@@@ GET url=${uri.toString()}');

    try {
      final response = await http
          .get(uri, headers: headers)
          .timeout((const Duration(seconds: timeOut)));

      return _processResponse(response);
    } on SocketException {
      print('no internet connection');
      throw FetchDataException('no internet connection', uri.toString());
    } on TimeoutException {
      print('Api not response in time');
      throw ApiNotRespondingException(
          'Api not response in time', uri.toString());
    }
  }

  static Future<dynamic> post(
    String api,
    dynamic payloadObj, {
    bool authorization = true,
    String baseUrl = baseUrl,
  }) async {
    final uri = Uri.parse(baseUrl + api);
    debugPrint('@@@ POST url=${uri.toString()}');

    final Map<String, String> headers = await getHeaders(authorization);

    final payload = json.encode(payloadObj).toString();
    try {
      final response = await http
          .post(uri, body: payload, headers: headers)
          .timeout((const Duration(seconds: timeOut)));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('no internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'Api not response in time', uri.toString());
    }
  }

  static dynamic _processResponse(http.Response response) {
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        final responseJson = utf8.decode(response.bodyBytes);
        return responseJson;
      case 201:
        final responseJson = utf8.decode(response.bodyBytes);
        return responseJson;
      case 400:
        throw BadRequestException(
            utf8.decode(response.bodyBytes), response.request.url.toString());
      case 404:
        throw NotFoundException(
            utf8.decode(response.bodyBytes), response.request.url.toString());
      default:
        throw FetchDataException(
            'Error occurred with code ${response.statusCode}',
            response.request.url.toString());
    }
  }

  static Future<Map<String, String>> getHeaders(bool authorization) async {
    const storage = FlutterSecureStorage();
    final String t = await storage.read(key: 'session');
    if (authorization) {
      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $t',
        'Locale': 'ru_RU',
      };
    } else {
      return {
        'Content-Type': 'application/json',
      };
    }
  }
}
