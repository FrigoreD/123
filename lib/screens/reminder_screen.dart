import 'dart:math';

import 'package:astrology_app/screens/menu_screen.dart';
import 'package:astrology_app/widgets/card_main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import '../controller/reminder_controller.dart';
import '../dto/expanded_model.dart';
import '../generated/l10n.dart';
import '../models/prediction.dart';

bool loadData=true;

final ReminderController _reminderController=ReminderController();
class ReminderScreen extends StatefulWidget {
  const ReminderScreen({Key key}) : super(key: key);

  @override
  _ReminderState createState() => _ReminderState();
}
List<ExpandedClass>data=[];
List<Predictions> remindersList =[];
class _ReminderState extends State<ReminderScreen>{


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0.0,
        leading: IconButton(
          icon: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Icon(Icons.arrow_back_rounded,color: Colors.grey,),
            ),
          ),
          onPressed: (){
            Navigator.push<void>(
              context,
              MaterialPageRoute(builder: (context) => const MenuScreen()),
            );
          },
        ),
        title: Text(S.of(context).menu_reminder,textAlign: TextAlign.center,style: const TextStyle(color: Colors.black),),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.grey[100]
          ),
          child: Column(
            children: [
              Visibility(
                visible: loadData,
                child: Column(
                  children: const [
                    LinearProgressIndicator(),
                    SizedBox(height: 12,)
                  ],
                ),
              ),
              Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, i) {
                      return ExpansionTile(
                        title: Row(
                          children: [
                            Text(DateFormat('dd MMM').format(data[i].headExpanded),style: const TextStyle(),),
                            const Spacer(),
                            GestureDetector(
                              child: const Text('Удалить',style: TextStyle(color: Colors.blue),),
                              onTap: (){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Remove ${data[i].headExpanded.toIso8601String()}'),

                                  ),
                                );
                              },
                            )

                          ],
                        ),
                        children: <Widget>[
                          Column(
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
  List<Widget> _buildExpandableContent(ExpandedClass card) {
    final List<Widget> columnContent = [];
    for (final Predictions content in card.cardExpanded) {
      columnContent.add(CardMain(card: content));
    }
    return columnContent;
  }

  @override
  void initState() {
    load();
    super.initState();
  }
  Future<void> load()async{
    remindersList.clear();
    remindersList =await _reminderController.getRemainderList();
    print(remindersList.length);
    data.clear();
    final List<String> datesList=[];
    remindersList.forEach((element) {
      final List<Predictions> dataList=[];
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
  final int count=Random().nextInt(5);
  return List.generate(numberOfItems, (int index) {
    return ExpandedClass(
      headExpanded: DateTime.now(),
      cardExpanded: generateList(count),
    );
  });
}
