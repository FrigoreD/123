import 'package:flutter/material.dart';

class TextLink extends StatelessWidget{
  const TextLink({Key key, this.onClick, @required this.text}) : super(key: key);
  final VoidCallback  onClick;
  final String text;

  


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
              color:Colors.blue,
              fontSize: 9
          ),
        ),
      ),
    );
  }


}