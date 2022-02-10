import 'package:flutter/material.dart';

class TextLink extends StatelessWidget{
  final VoidCallback  onClick;
  final String text;

  const TextLink({Key key, this.onClick, @required this.text}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              color:Colors.blue,
              fontSize: 9
          ),
        ),
      ),
      onTap: (){
        onClick();
      },
    );
  }


}