import 'dart:convert';

import 'package:astrology_app/controller/base_controller.dart';
import 'package:astrology_app/services/base_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthController with BaseController{
  final storage = new FlutterSecureStorage();
  Future<bool> checkCode(){
  }
  Future<bool> registration(dynamic data) async{
    var response=await BaseClient.post('/customers/registration',data,authorization: false).catchError(handleError);
    if(response==null) return false;
    Map<String, dynamic> map =jsonDecode(response);
    if(map.containsKey('token')){
      await storage.write(key: "session", value: map['token']);
      return true;
    }else{
      return false;
    }
  }
}