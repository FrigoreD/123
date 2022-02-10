import 'package:astrology_app/Class/CountryClass.dart';
import 'package:flutter/material.dart';

class selectorWidget extends StatelessWidget{
  final Function(String)  onClick;
  final countryClass countryItem;

  const selectorWidget({Key key, this.onClick, this.countryItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                countryItem.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    color: Colors.grey,
                    fontSize: 24
                ),
              ),
            ),
          )
        ],
      ),
      onTap: (){
        debugPrint("select languge "+countryItem.cod);
        onClick(countryItem.cod);
      },
    );
  }


}