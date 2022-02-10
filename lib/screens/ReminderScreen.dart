import 'dart:math';

import 'package:astrology_app/Screens/MenuScreen.dart';
import 'package:astrology_app/Widgets/CardMain.dart';
import 'package:astrology_app/controller/reminder_controller.dart';
import 'package:astrology_app/dto/expandedClass.dart';
import 'package:astrology_app/models/prediction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/generated/l10n.dart';
import 'package:intl/intl.dart';

bool loadData=true;

final ReminderController _reminderController=ReminderController();
class ReminderScreen extends StatefulWidget {
  @override
  _ReminderState createState() => _ReminderState();
}
List<ExpandedClass>data=[];
List<Predictions> remindersList =[];
var persons;
class _ReminderState extends State<ReminderScreen>{


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0.0,
        leading: IconButton(
          icon: Container(
            child: Center(
              child: Icon(Icons.arrow_back_rounded,color: Colors.grey,),
            ),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MenuScreen()),
            );
          },
        ),
        title: Text(S.of(context).menu_reminder,textAlign: TextAlign.center,style: TextStyle(color: Colors.black),),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.grey[100]
          ),
          child: Column(
            children: [
              Visibility(
                child: Column(
                  children: [
                    LinearProgressIndicator(),
                    SizedBox(height: 12,)
                  ],
                ),
                visible: loadData,
              ),
              Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, i) {
                      return new ExpansionTile(
                        title: Row(
                          children: [
                            Text(DateFormat("dd MMM").format(data[i].headExpanded),style: TextStyle(),),
                            Spacer(),
                            GestureDetector(
                              child: Text("Удалить",style: TextStyle(color: Colors.blue),),
                              onTap: (){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Remove "+data[i].headExpanded.toIso8601String()),

                                  ),
                                );
                              },
                            )

                          ],
                        ),
                        children: <Widget>[
                          new Column(
                            children: _buildExpandableContent(data[i]),
                          ),
                        ],
                      );
                    },
                  )
              )
            ],
          )
        ),
      ),
    );
  }
  _buildExpandableContent(ExpandedClass card) {
    List<Widget> columnContent = [];
    for (Predictions content in card.cardExpanded)
      columnContent.add(CardMain(card: content));
    return columnContent;
  }

  @override
  void initState() {
    load();
    super.initState();
  }
  void load()async{
    remindersList.clear();
    remindersList =await _reminderController.getRemainderList();
    print(remindersList.length);
    data.clear();
    List<String> datesList=[];
    remindersList.forEach((element) {
      List<Predictions> dataList=[];
      dataList.clear();
      if(datesList.contains(DateFormat.yMd().format(element.datePrediction))){
        data.firstWhere((element1) =>
        DateFormat.yMd().format(element1.headExpanded)==DateFormat.yMd().format(element.datePrediction)).cardExpanded.add(element);
      }else{
        datesList.add(DateFormat.yMd().format(element.datePrediction));
        dataList.add(element);
        data.add(ExpandedClass(headExpanded: element.datePrediction,cardExpanded: dataList));
      }
    });
    setState(() {
      loadData=false;
    });

  }

  @override
  void dispose() {
    persons.close();
    super.dispose();
  }
}

List<Predictions> generateList(int numberOfItems){
  return List.generate(numberOfItems, (index){
    return Predictions(
    );
  });
}
List<ExpandedClass> generateItems(int numberOfItems) {
  int count=Random().nextInt(5);
  return List.generate(numberOfItems, (int index) {
    return ExpandedClass(
      headExpanded: DateTime.now(),
      cardExpanded: generateList(count),
    );
  });
}
