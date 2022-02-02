import 'dart:convert';
import 'package:astrology_app/controller/base_controller.dart';
import 'package:astrology_app/services/base_client.dart';

class SettingController extends BaseController{
  Future<bool> updateName(String newName) async{
    var response=await BaseClient.post('/customers/updateCustomer', {'key':'Name','value':newName}).catchError(handleError);
    if(response==null) return false;
    return true;

  }
  Future<bool> updateCity(String name,String key) async{
    var response=await BaseClient.post('/customers/updateCity', {'key':key,'name':name}).catchError(handleError);
    if(response==null) return false;
    return true;

  }
  Future<bool> updateDate(DateTime dateTime) async{
    var response=await BaseClient.post('/customers/updateCustomer', {'key':'Date','value':dateTime.toIso8601String()}).catchError(handleError);
    if(response==null) return false;
    return true;

  }
}