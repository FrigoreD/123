import 'package:astrology_app/Screens/IntroScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
//  Hive.registerAdapter(ReminderAdapter());
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingsAndroid=AndroidInitializationSettings('@mipmap/ic_launcher_new');
  var initializationSettingsIOS=IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification:
    (int id,String title,String body, String payload) async{}
  );
  var initializationSettings=InitializationSettings(
    iOS: initializationSettingsIOS,android: initializationSettingsAndroid
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,onSelectNotification: (String payload) async{
    if(payload!=null){
      print('notification payload ${payload}');
    }
  });
  runApp(MyApp());
}



class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/images/vector.png"), context);

    return GetMaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IntroScreen(),
    );
  }
}
