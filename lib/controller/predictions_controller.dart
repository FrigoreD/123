import 'dart:developer';

import 'base_controller.dart';
import '../models/prediction.dart';
import '../services/base_client.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

//@LazySingleton(as: PredictionsControllerI)
class PredictionsController with BaseController {
  //
  Future<List<Predictions>> getListPredictions(
      DateTime selectedDateTime) async {
    final String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDateTime);
    dynamic response =
        await BaseClient.get('/predictions/findPredictionByData/$formattedDate')
            .catchError(handleError);
    if (response == null) return null;
    log(response.toString());
    return Predictions.predictionsFromJson(response.toString());
  }

  Future<bool> setFavorite(int id) async {
    dynamic response = await BaseClient.get('/predictions/setFavorite/${id}')
        .catchError(handleError);
    if (response == null) return false;
    Get.snackbar('Сохранено', 'Предсказание сохранено');
    return true;
  }

  Future<List<Predictions>> search(String request) async {
    dynamic response = await BaseClient.get('/predictions/search/${request}')
        .catchError(handleError);
    if (response == null) return null;
    return Predictions.predictionsFromJson(response.toString());
  }

  Future<List<Predictions>> getPredictionsByRange(
      DateTime start, DateTime end) async {
    dynamic response = await BaseClient.get(
            '/predictions/getPredictionsByRange/${start.toIso8601String()}&${end.toIso8601String()}')
        .catchError(handleError);
    if (response == null) return null;
    return Predictions.predictionsFromJson(response.toString());
  }
}

/*
abstract class PredictionsControllerI {
  Future<List<Predictions>> getListPredictions(DateTime selectedDateTime);

  Future<bool> setFavorite(int id);

  Future<List<Predictions>> search(String request);

  Future<List<Predictions>> getPredictionsByRange(DateTime start, DateTime end);
}
*/
