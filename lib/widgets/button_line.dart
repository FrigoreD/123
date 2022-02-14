import 'package:flutter/material.dart';

  class ButtonLine extends StatelessWidget{
     const ButtonLine({Key key, this.onClick, this.title}) : super(key: key);
  final VoidCallback  onClick;
  final String title;

 

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: ElevatedButton(
        onPressed: onClick,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Align(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'SF Pro Display',
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


}