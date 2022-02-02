
import 'package:astrology_app/dto/cardClass.dart';
import 'package:astrology_app/generated/l10n.dart';
import 'package:astrology_app/models/prediction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardMain extends StatelessWidget{
  final VoidCallback  onClick;
  final Predictions card;

  const CardMain({Key key, this.onClick, this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Container(
      margin: EdgeInsets.only(top: 12),
      child:Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          padding: EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                children: [
                  Text(card.title,style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                  Spacer(),
                  Text(DateFormat("dd MMM HH:mm").format(card.datePrediction),style: TextStyle(color: Colors.white),)
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Text(card.message,style: TextStyle(color: Colors.white),),
              SizedBox(
                height: 24,
              ),
              (card.favorite)?Text(''):GestureDetector(
                child: Align(
                  child: Text(
                    S.of(context).search_result_add,
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                  alignment: Alignment.bottomRight,
                ),
                onTap: ()=>onClick(),
              )
            ],
          ),
        ),
        color: (card.type=='Здоровье')?Colors.green:Colors.blue,
        
      ),
    );
  }


}