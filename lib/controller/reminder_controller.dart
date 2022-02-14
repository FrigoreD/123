import 'dart:convert';


import '../models/prediction.dart';
import '../services/base_client.dart';
import 'base_controller.dart';

class ReminderController with BaseController {
  Future<List<Predictions>> getRemainderList() async{
    print('start controller');
    final response=await BaseClient.get('/predictions/getFavorite').catchError(handleError);
    if(response==null) return null;
    print(response);
    return predictionsFromJson(response);
  }
  List<Predictions> predictionsFromJson(String str) => List<Predictions>.from(json.decode(str).map((x) => Predictions.fromJson(x)));

}