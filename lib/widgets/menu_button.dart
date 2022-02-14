import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget{
   const MenuButton({Key key, this.onClick, this.title}) : super(key: key);
  final VoidCallback  onClick;
  final String title;



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
          elevation: 0
        ),
        onPressed: onClick,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(

              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Align(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'SF Pro Display',
                    color: Colors.grey,
                    fontSize: 24
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