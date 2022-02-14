// ignore_for_file: inference_failure_on_function_return_type

import 'package:flutter/material.dart';

import '../class/country_model.dart';



class SelectorWidget extends StatelessWidget{
  const SelectorWidget({Key key, this.onClick, this.countryItem}) : super(key: key);
  final Function(String)  onClick;
  final Country countryItem;

  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Align(
              child: Text(
                countryItem.name,
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
      onTap: (){
        debugPrint('select languge ${countryItem.code}');
        onClick(countryItem.code);
      },
    );
  }


}