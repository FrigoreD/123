import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:astrology_app/services/app_exception.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class BaseClient{
  static final TIME_OUT=20;
  static const BASE_URL='https://astrologyspica.dev-prod.com.ua/api';

  static Future<dynamic> get(String api,{bool authorization=true,String baseUrl=BASE_URL,})async{
    var headers=await getHeaders(authorization);
    var uri=Uri.parse(baseUrl+api);
    try{
      var response=await http.get(uri,headers: headers).timeout((Duration(seconds: TIME_OUT)));
      return _processResponse(response);
    }on SocketException{
      print('no internet connection');
      throw FetchDataException('no internet connection',uri.toString());
    }
    on TimeoutException{
      print('Api not response in time');
      throw ApiNotRespondingException('Api not response in time',uri.toString());
    }
  }
  static Future<dynamic> post( String api,dynamic payloadObj,{bool authorization=true,String baseUrl=BASE_URL,})async{
    var uri=Uri.parse(baseUrl+api);
    var headers=await getHeaders(authorization);

    var payload=json.encode(payloadObj).toString();
    print('payload $payload');
    print('headers $headers');
    try{
      var response=await http.post(uri, body: payload,headers: headers).timeout((Duration(seconds: TIME_OUT)));
      return _processResponse(response);
    }on SocketException{
      throw FetchDataException('no internet connection',uri.toString());
    }
    on TimeoutException{
      throw ApiNotRespondingException('Api not response in time',uri.toString());
    }
  }
  static dynamic _processResponse(http.Response response){
    print(response.statusCode);
    switch (response.statusCode){
      case 200:
        var responseJson=utf8.decode(response.bodyBytes);
        return responseJson;
      case 201:
        var responseJson=utf8.decode(response.bodyBytes);
        return responseJson;
      case 400:
        print('400');
        throw BadRequestException(utf8.decode(response.bodyBytes),response.request.url.toString());
      case 404:
        throw NotFoundException(utf8.decode(response.bodyBytes),response.request.url.toString());
      default:
        throw FetchDataException('Error occurred with code ${response.statusCode}',response.request.url.toString());

    }
  }
  static Future <dynamic> getHeaders(bool authorization) async{
    final storage = new FlutterSecureStorage();
    String t=await storage.read(key: 'session');
    if(authorization){
      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer '+t
      };
    }else{
      return {
        'Content-Type': 'application/json',
      };
    }
  }
}