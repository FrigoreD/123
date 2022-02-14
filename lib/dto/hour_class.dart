import '../models/prediction.dart';

class HourClass{
  HourClass(this.start, this.end, this.events);
  final DateTime start;
  final DateTime end;
  final List<Predictions> events;



}