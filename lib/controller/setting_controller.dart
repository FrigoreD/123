import '../services/base_client.dart';
import 'base_controller.dart';

class SettingController extends BaseController{
  Future<bool> updateName(String newName) async{
    final response=await BaseClient.post('/customers/updateCustomer', {'key':'Name','value':newName}).catchError(handleError);
    if(response==null) return false;
    return true;

  }
  Future<bool> updateCity(String name,String key) async{
    final response=await BaseClient.post('/customers/updateCity', {'key':key,'name':name}).catchError(handleError);
    if(response==null) return false;
    return true;

  }
  Future<bool> updateDate(DateTime dateTime) async{
    final response=await BaseClient.post('/customers/updateCustomer', {'key':'Date','value':dateTime.toIso8601String()}).catchError(handleError);
    if(response==null) return false;
    return true;

  }
  
}