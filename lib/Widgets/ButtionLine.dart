import 'package:flutter/material.dart';

  class ButtonLine extends StatelessWidget{
  final VoidCallback  onClick;
  final String title;

  const ButtonLine({Key key, this.onClick, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      child: ElevatedButton(
        onPressed: () =>onClick(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
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