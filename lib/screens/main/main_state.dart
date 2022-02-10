part of 'main_bloc.dart';

class MainState extends Equatable {
  const MainState({this.selectedDateTime, this.healthList, this.recommendList});

  final UnmodifiableListView<Predictions> recommendList;
  final UnmodifiableListView<Predictions> healthList;
  final DateTime selectedDateTime;

  @override
  List<Object> get props => [healthList, recommendList, selectedDateTime];

  MainState copyWith({
    UnmodifiableListView<Predictions> recommendList,
    UnmodifiableListView<Predictions> healthList,
    DateTime selectedDateTime,
  }) {
    return MainState(
      recommendList: recommendList ?? this.recommendList,
      healthList: healthList ?? this.healthList,
      selectedDateTime: selectedDateTime ?? this.selectedDateTime,
    );
  }
}
