import 'package:astrology_app/dto/cardClass.dart';
import 'package:astrology_app/models/prediction.dart';

class ExpandedClass{
  DateTime headExpanded;
  List<Predictions> cardExpanded;
  bool isExpanded;
  ExpandedClass({this.headExpanded,this.cardExpanded,this.isExpanded=false});
}