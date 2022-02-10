part of 'main_bloc.dart';

@immutable
abstract class MainEvent extends Equatable {}

class UpdatePredictionMainEvent extends MainEvent {
  UpdatePredictionMainEvent({this.recommendList, this.healthList});

  final List<Predictions> recommendList;
  final List<Predictions> healthList;

  @override
  List<Object> get props => [recommendList, healthList];
}

class SelectDateMainEvent extends MainEvent {
  SelectDateMainEvent({this.selectedDateTime});

  final DateTime selectedDateTime;

  @override
  List<Object> get props => throw UnimplementedError();
}
