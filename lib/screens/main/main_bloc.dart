import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../../controller/predictions_controller.dart';
import '../../models/prediction.dart';

part 'main_event.dart';

part 'main_state.dart';

//@LazySingleton()
class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc()
      : super(MainState(
            healthList: UnmodifiableListView([]),
            recommendList: UnmodifiableListView([]),
            selectedDateTime: DateTime.now())) {
    //
    on<UpdatePredictionMainEvent>((event, emit) {
      emit(state.copyWith(
          healthList: UnmodifiableListView(event.healthList),
          recommendList: UnmodifiableListView(event.recommendList)));
    });

    on<SelectDateMainEvent>((event, emit) {
      selectedDateTime = event.selectedDateTime;
      loadData(event.selectedDateTime);
    });

    loadData(DateTime.now());
  }

  DateTime selectedDateTime = DateTime.now();

  PredictionsController predictionsController = PredictionsController();

  void loadData(DateTime dateTime) {
    predictionsController
        .getListPredictions(dateTime)
        .then((List<Predictions> allList) {
      if (allList == null) {
        allList = [];
      } else {
        filter(allList);
      }
    });
  }

  void filter(List<Predictions> allList) {
    final List<Predictions> recommendList = [];
    final List<Predictions> healthList = [];

    for (int i = 0; i < allList.length; i++) {
      final Predictions card = allList[i];
      /*if (card.datePrediction.day == selectedDateTime.day &&
          card.datePrediction.month == selectedDateTime.month &&
          card.datePrediction.year == selectedDateTime.year) {
      }*/
      healthList.add(card);
      recommendList.add(card);
    }
    debugPrint('@@@ recommendList=${recommendList.length}');
    debugPrint('@@@ healthList=${healthList.length}');

    add(UpdatePredictionMainEvent(
        recommendList: recommendList, healthList: healthList));
  }
}
