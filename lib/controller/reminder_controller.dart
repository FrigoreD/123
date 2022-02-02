import 'dart:convert';

import 'package:astrology_app/controller/base_controller.dart';
import 'package:astrology_app/models/prediction.dart';
import 'package:astrology_app/services/base_client.dart';

class ReminderController with BaseController {
  Future<List<Predictions>> getRemainderList() async{
    print('start controller');
    var response=await BaseClient.get('/predictions/getFavorite').catchError(handleError);
    if(response==null) return null;
    print(response);
    return predictionsFromJson(response);
  }
  List<Predictions> predictionsFromJson(String str) => List<Predictions>.from(json.decode(str).map((x) => Predictions.fromJson(x)));

}