import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../services/base_client.dart';
import 'base_controller.dart';

class AuthController with BaseController{
  final storage = const FlutterSecureStorage();
  Future<bool> checkCode(){
  }
  Future<bool> registration(dynamic data) async{
    var response=await BaseClient.post('/customers/registration',data,authorization: false).catchError(handleError);
    if(response==null) return false;
    final Map<String, dynamic> map =jsonDecode(response);
    if(map.containsKey('token')){
      await storage.write(key: 'session', value: map['token']);
      return true;
    }else{
      return false;
    }
  }
}