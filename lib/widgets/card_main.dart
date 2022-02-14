
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../generated/l10n.dart';
import '../models/prediction.dart';

class CardMain extends StatelessWidget{
   const CardMain({Key key, this.onClick, this.card}) : super(key: key);
  final VoidCallback  onClick;
  final Predictions card;

 

  @override
  Widget build(BuildContext context) {
    
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child:Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        // ignore: unrelated_type_equality_checks
        color: (card.type==2)?Colors.green:Colors.blue,
        child: Container(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                children: [
                  Text(card.title,style: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
                  const Spacer(),
                  Text(DateFormat('dd MMM HH:mm').format(card.datePrediction),style: const TextStyle(color: Colors.white),)
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Text(card.message,style: const TextStyle(color: Colors.white),),
              const SizedBox(
                height: 24,
              ),
              if (card.favorite) const Text('') else GestureDetector(
                onTap: onClick,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    S.of(context).search_result_add,
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
        
      ),
    );
  }


}