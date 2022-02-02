import 'package:astrology_app/Screens/MenuScreen.dart';
import 'package:astrology_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_EditScreenState();

}
class _EditScreenState extends State<EditScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0.0,
        leading: IconButton(
          icon: Container(
            child: Center(
              child: Icon(Icons.arrow_back_rounded,color: Colors.grey,),
            ),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MenuScreen()),
            );
          },
        ),
        title: Text(S.of(context).EDIT_TITLE,textAlign: TextAlign.center,style: TextStyle(color: Colors.black),),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.grey[100]
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  textInputAction: TextInputAction.next,
                  onSubmitted: (text){

                  },
                  decoration: InputDecoration(
                      labelText: S.of(context).EDIT_HINT_NAME,
                  ),

                )
              ],
            ),
        ),

        ),
      ),
    );
  }

}