import 'package:astrology_app/Class/MenuItem.dart';
import 'package:astrology_app/Screens/ReminderScreen.dart';
import 'package:astrology_app/Screens/SaveDaysScreen.dart';
import 'package:astrology_app/Screens/SearchScreen.dart';
import 'package:astrology_app/Screens/SettingScreen.dart';
import 'package:astrology_app/Widgets/menuButton.dart';
import 'package:astrology_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'main/main_screen.dart';



BuildContext contextMain;
class MenuScreen extends StatelessWidget{

  final BuildContext contextItem;

  const MenuScreen({Key key, this.contextItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    contextMain=contextItem;
    return MaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MenuPage(),
    );
  }

}
List<menuItem> list=[];
class MenuPage extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<MenuPage>{



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Container(
            child: Center(
              child: Icon(Icons.close,color: Colors.grey ,),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          },
        ),

      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(bottom: 55),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              menuButton(title: S.of(context).menu_search,onClick: (){
                Navigator.push<void>(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              },),
              menuButton(title: S.of(context).menu_reminder,onClick: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReminderScreen()),
                );
              },),
              menuButton(title: S.of(context).menu_save_days,onClick: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SaveDaysScreen()),
                );
              },),
              menuButton(title: S.of(context).menu_settings,onClick: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingScreen()),
                );
              },),
            ],
          ),
        )
      ),
    );
  }


}