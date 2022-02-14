part of 'main_bloc.dart';

class MainState extends Equatable {
  const MainState(
      {this.selectedDateTime,
      this.healthList,
      this.recommendList,
      this.statusCode});

  final UnmodifiableListView<Predictions> recommendList;
  final UnmodifiableListView<Predictions> healthList;
  final DateTime selectedDateTime;
  final bool statusCode;

  @override
  List<Object> get props => [healthList, recommendList, selectedDateTime, statusCode];

  MainState copyWith(
      {UnmodifiableListView<Predictions> recommendList,
      UnmodifiableListView<Predictions> healthList,
      DateTime selectedDateTime,
      bool statusCode}) {
    return MainState(
        recommendList: recommendList ?? this.recommendList,
        healthList: healthList ?? this.healthList,
        selectedDateTime: selectedDateTime ?? this.selectedDateTime,
        statusCode: statusCode ?? this.statusCode);
  }
}
