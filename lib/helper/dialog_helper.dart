import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogHelper{
  static void showErrorDialog({String title="Error",String description="unknown error"}){
    Get.dialog(
        Dialog(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title ?? '',style: Get.textTheme.headline4,),
                Text(description??'',style: Get.textTheme.headline6,),
                ElevatedButton(onPressed: (){
                  if(Get.isDialogOpen)Get.back();
                }, child: Text("OK"))
              ],
            ),
          ),
        )
    );
  }
  static void showSnackbar(String title,String message){
    Get.snackbar(title, message);
  }
}