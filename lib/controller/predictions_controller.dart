import 'package:astrology_app/models/prediction.dart';
import 'package:astrology_app/services/base_client.dart';
import 'package:astrology_app/controller/base_controller.dart';
import 'package:get/get.dart';


class PredictionsController with BaseController{
  Future<List<Predictions>> getListPredictions() async{
    var response=await BaseClient.get('/predictions/findPredictionByData/2021-06-07').catchError(handleError);
    if(response==null) return null;
    print(response);
    return Predictions.predictionsFromJson(response.toString());

  }
  Future<bool> setFavorite(int id) async{
    var response=await BaseClient.get('/predictions/setFavorite/${id}').catchError(handleError);
    if(response==null)return false;
    Get.snackbar('Сохранено', 'Предсказание сохранено');
    return true;
  }
  Future<List<Predictions>> search(String request) async{
    var response=await BaseClient.get('/predictions/search/${request}').catchError(handleError);
    if(response==null) return null;
    return Predictions.predictionsFromJson(response.toString());
  }
  Future<List<Predictions>> getPredictionsByRange(DateTime start,DateTime end) async{
    var response=await BaseClient.get('/predictions/getPredictionsByRange/${start.toIso8601String()}&${end.toIso8601String()}').catchError(handleError);
    if(response==null) return null;
    return Predictions.predictionsFromJson(response.toString());
  }
}