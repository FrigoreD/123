
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../class/menu_item_model.dart';
import '../generated/l10n.dart';
import '../widgets/menu_button.dart';
import 'main/main_screen.dart';
import 'reminder_screen.dart';
import 'save_days_screen.dart';
import 'search_screen.dart';
import 'setting_screen.dart';



BuildContext contextMain;
class MenuScreen extends StatelessWidget{
   const MenuScreen({Key key, this.contextItem}) : super(key: key);

  final BuildContext contextItem;

  @override
  Widget build(BuildContext context) {
    contextMain=contextItem;
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MenuPage(),
    );
  }

}
List<MenuItem> list=[];
class MenuPage extends StatefulWidget {
  const MenuPage({Key key}) : super(key: key);

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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Icon(Icons.close,color: Colors.grey ,),
            ),
          ),
          onPressed: (){
            Navigator.push<void>(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          },
        ),

      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(bottom: 55),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MenuButton(title: S.of(context).menu_search,onClick: (){
                Navigator.push<void>(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },),
              MenuButton(title: S.of(context).menu_reminder,onClick: (){
                Navigator.push<void>(
                  context,
                  MaterialPageRoute(builder: (context) => const ReminderScreen()),
                );
              },),
              MenuButton(title: S.of(context).menu_save_days,onClick: (){
                Navigator.push<void>(
                  context,
                  MaterialPageRoute(builder: (context) => const SaveDaysScreen()),
                );
              },),
              MenuButton(title: S.of(context).menu_settings,onClick: (){
                Navigator.push<void>(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingScreen()),
                );
              },),
            ],
          ),
        )
      ),
    );
  }


}