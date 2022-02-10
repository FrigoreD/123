import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TitleToolbar extends StatelessWidget{
  final VoidCallback  onClick;
  final DateTime date;

  const TitleToolbar({Key key, this.onClick, @required this.date}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: RichText(
          text: TextSpan(
              children: [
                TextSpan(
                    text: DateFormat("LLLL").format(date),
                    style: TextStyle(
                        color: Colors.black,
                      fontSize: 24
                    ),
                ),
                WidgetSpan(
                    child: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.black,)
                )
              ]
          ),
        ),
        decoration: BoxDecoration(
        ),
      ),
      onTap: (){
        onClick();
      },
    );
  }


}

/*
[
            Expanded(child: Text(
              DateFormat("LLLL").format(date),
              style: TextStyle(
                  color: Colors.black
              ),
            )),
            Expanded(child: Container(
              child: Center(
                child: Icon(Icons.keyboard_arrow_down_outlined,color: Colors.black,),
              ),

            ))
          ]
 */