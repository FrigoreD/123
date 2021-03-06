
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

class Reminder {
  Reminder(this.id, this.title, this.message, this.dateTime);
 final int id;
 final String title;
 final String message;
 final DateTime dateTime;

  

  static Future<void> createRemainder(BuildContext context,dynamic scheduledNotificationDateTime,String title,String message,int id)async{
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        '0', 'remainder', 'Сохраненые напоминания',
        importance: Importance.max,
        priority: Priority.high);
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        message,
        scheduledNotificationDateTime,
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }
}