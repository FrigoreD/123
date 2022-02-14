import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: avoid_classes_with_only_static_members
class DialogHelper{
  static void showErrorDialog({String title='Error',String description='unknown error'}){
    Get.dialog(
        Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title ?? '',style: Get.textTheme.headline4,),
                Text(description??'',style: Get.textTheme.headline6,),
                ElevatedButton(onPressed: (){
                  if(Get.isDialogOpen)Get.back();
                }, child: const Text('OK'))
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