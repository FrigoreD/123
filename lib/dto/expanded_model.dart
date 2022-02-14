import '../models/prediction.dart';

class ExpandedClass{
  ExpandedClass({this.headExpanded,this.cardExpanded,this.isExpanded=false});
  DateTime headExpanded;
  List<Predictions> cardExpanded;
  bool isExpanded;
  
}