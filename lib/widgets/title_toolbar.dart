import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TitleToolbar extends StatelessWidget {
  const TitleToolbar({Key key, this.onClick, @required this.date})
      : super(key: key);
  final VoidCallback onClick;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        decoration: const BoxDecoration(),
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: DateFormat('LLLL').format(date),
              style: const TextStyle(color: Colors.black, fontSize: 24),
            ),
            const WidgetSpan(
                child: Icon(
              Icons.keyboard_arrow_down_outlined,
              color: Colors.black,
            ))
          ]),
        ),
      ),
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