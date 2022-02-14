import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import 'menu_screen.dart';

class EditScreen extends StatefulWidget{
  const EditScreen({Key key}) : super(key: key);

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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Icon(Icons.arrow_back_rounded,color: Colors.grey,),
            ),
          ),
          onPressed: (){
            Navigator.push<void>(
              context,
              MaterialPageRoute(builder: (context) => const MenuScreen()),
            );
          },
        ),
        title: Text(S.of(context).EDIT_TITLE,textAlign: TextAlign.center,style: const TextStyle(color: Colors.black),),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8),
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