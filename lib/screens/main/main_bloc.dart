import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../controller/predictions_controller.dart';
import '../../controller/setting_controller.dart';
import '../../models/prediction.dart';

part 'main_event.dart';

part 'main_state.dart';

//@LazySingleton()
class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc()
      : super(MainState(
            healthList: UnmodifiableListView([]),
            recommendList: UnmodifiableListView([]),
            selectedDateTime: DateTime.now(),
            statusCode: false)) {
    on<UpdatePredictionList>(_onUpdatePredictionList);
    on<GetStatus>(_onGetStatus);

    on<SelectDateMainEvent>(_onSelectDateMainEvent);

    loadData(DateTime.now());
  }

  void _onGetStatus(GetStatus event, Emitter<MainState> emit) {
    emit(state.copyWith(statusCode: event.statusCode));
  }

  void _onUpdatePredictionList(
      UpdatePredictionList event, Emitter<MainState> emit) {
    emit(state.copyWith(
        recommendList: UnmodifiableListView(event.recommendList),
        healthList: UnmodifiableListView(event.healthList)));
  }

  void _onSelectDateMainEvent(
      SelectDateMainEvent event, Emitter<MainState> emit) {
    add(GetStatus(statusCode: false));
    emit(state.copyWith(selectedDateTime: event.selectedDateTime));
    loadData(event.selectedDateTime);
  }

  PredictionsController predictionsController = PredictionsController();

  void loadData(DateTime dateTime) {
    predictionsController
        .getListPredictions(dateTime)
        .then((List<Predictions> allList) {
      if (allList.isEmpty) {
        allList = [];
        add(GetStatus(statusCode: true));
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
      if (card.type == 1) {
        recommendList.add(card);
      } else if (card.type == 2) {
        healthList.add(card);
      }
    }
    debugPrint('@@@ recommendList=${recommendList.length}');
    debugPrint('@@@ healthList=${healthList.length}');

    // add(UpdatePredictionHealthList(
    //     healthList: healthList));

    add(UpdatePredictionList(
        recommendList: recommendList, healthList: healthList));
    add(GetStatus(statusCode: true));
    
    
  }
}
