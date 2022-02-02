import 'package:astrology_app/Widgets/CardMain.dart';
import 'package:astrology_app/controller/predictions_controller.dart';
import 'package:astrology_app/dto/HourClass.dart';
import 'package:astrology_app/dto/cardClass.dart';
import 'package:astrology_app/models/prediction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart';

PredictionsController _predictionsController=PredictionsController();

class EventWidget extends StatefulWidget{
  final List<Predictions> eventList;
  final int page;
  const EventWidget({Key key, this.eventList, this.page}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>_DayView(eventList,page);

}
DateTime convertDate(time){
  return DateFormat("HH:mm").parse(time);
}
class _DayView extends State<EventWidget>{
  final List<Predictions> eventList;
  final int page;


  List<HourClass> ec=[
    HourClass(convertDate("00:00"), convertDate("00:59"), []),
    HourClass(convertDate("01:00"), convertDate("01:59"), []),
    HourClass(convertDate("02:00"), convertDate("02:59"), []),
    HourClass(convertDate("03:00"), convertDate("03:59"), []),
    HourClass(convertDate("04:00"), convertDate("04:59"), []),
    HourClass(convertDate("05:00"), convertDate("05:59"), []),
    HourClass(convertDate("06:00"), convertDate("06:59"), []),
    HourClass(convertDate("07:00"), convertDate("07:59"), []),
    HourClass(convertDate("08:00"), convertDate("08:59"), []),
    HourClass(convertDate("09:00"), convertDate("09:59"), []),
    HourClass(convertDate("10:00"), convertDate("10:59"), []),
    HourClass(convertDate("11:00"), convertDate("11:59"), []),
    HourClass(convertDate("12:00"), convertDate("12:59"), []),
    HourClass(convertDate("13:00"), convertDate("13:59"), []),
    HourClass(convertDate("14:00"), convertDate("14:59"), []),
    HourClass(convertDate("15:00"), convertDate("15:59"), []),
    HourClass(convertDate("16:00"), convertDate("16:59"), []),
    HourClass(convertDate("17:00"), convertDate("17:59"), []),
    HourClass(convertDate("18:00"), convertDate("18:59"), []),
    HourClass(convertDate("19:00"), convertDate("19:59"), []),
    HourClass(convertDate("20:00"), convertDate("20:59"), []),
    HourClass(convertDate("21:00"), convertDate("21:59"), []),
    HourClass(convertDate("22:00"), convertDate("22:59"), []),
    HourClass(convertDate("23:00"), convertDate("23:59"), []),
  ];


  _DayView(this.eventList, this.page);

  Widget _buildSideHeader(int index ) {
    return new Container(
      height: 60.0,
      color: Colors.transparent,

      padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Text(DateFormat("HH:mm").format(ec[index].start)),
          Text(DateFormat("HH:mm").format(ec[index].end))
        ],
      )
    );
  }


  List<Widget> gen(){
    return List.generate(ec.length, (index){
      return new SliverStickyHeader(
        overlapsContent: true,
        header: _buildSideHeader(index),
        sliver: new SliverPadding(
          padding: new EdgeInsets.only(left: 60.0),
          sliver: new SliverList(
              delegate: SliverChildBuilderDelegate((BuildContext context, int i){
                return (ec[index].events.length>0)?
                CardMain(card: ec[index].events[i], onClick: (){
                  setFavorite(ec[index].events[i]);
                },)
                    :
                Container(height: 75)
                ;
              },childCount: (ec[index].events.length>0)?ec[index].events.length:1)
          ),
        ),

      );
    });
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> slivers = new List<Widget>();
    slivers.addAll(gen());
    clearEc();
    eventList.forEach((element) {
      ec.forEach((element1) {
        if(element.datePrediction.hour==element1.start.hour){
          element1.events.add(element);
        }
      });
    });
    return CustomScrollView(
      key: PageStorageKey(page),
      slivers: slivers,
    );


  }

  void clearEc(){
    ec.forEach((element) {
      element.events.clear();
    });
    setState(() {

    });
  }
  void setFavorite(Predictions predictions) async{
    bool result=await _predictionsController.setFavorite(predictions.id);
    if(result){
      predictions.favorite=true;
    }
    setState(() {

    });
  }

}

