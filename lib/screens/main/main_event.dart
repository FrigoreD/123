part of 'main_bloc.dart';

@immutable
abstract class MainEvent extends Equatable {}



class GetStatus extends MainEvent {
  GetStatus({this.statusCode});

  final bool statusCode;

  @override
  List<Object> get props => [statusCode];
}

class UpdatePredictionList extends MainEvent {
  UpdatePredictionList({this.recommendList, this.healthList});
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
