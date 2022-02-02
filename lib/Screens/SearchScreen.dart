import 'package:astrology_app/Module/SharedVoid.dart';
import 'package:astrology_app/Screens/MenuScreen.dart';
import 'package:astrology_app/Screens/SearchResultScreen.dart';
import 'package:astrology_app/Widgets/menuButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:astrology_app/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
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
      home: SearchPage(),
    );
  }

}
TextEditingController searchController = TextEditingController();

class SearchPage extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}
String errorText=null;
class _SearchState extends State<SearchPage>{

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
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.grey[100]
          ),
          child: Center(
            child: Padding(
              child: ListView(
                children: [
                  SizedBox(
                    height:120,
                  ),
                  Container(
                    child: Center(
                      child: Padding(
                        child: TextField(
                          textInputAction: TextInputAction.search,
                          controller: searchController,
                          onSubmitted: (text){
                            if(text.isNotEmpty){
                              errorText=null;
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SettingResultScreen(request: text,)),
                              );
                            }
                            if(text.isEmpty){
                              errorText="Заполните поле";
                            }
                            setState(() {
                            });
                          },
                          decoration: InputDecoration(
                            labelText: S.of(context).search_hint,
                            errorText: errorText,
                            suffixIcon: IconButton(
                              onPressed: () {
                                String text=searchController.value.text;
                                if(text.isNotEmpty){
                                  errorText=null;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SettingResultScreen(request: text,)),
                                  );
                                }
                                if(text.isEmpty){
                                  errorText="Заполните поле";
                                }
                                setState(() {
                                });
                              } ,
                              icon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        padding: EdgeInsets.only(bottom: 24),
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(24)
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                  ),
                ],
              ),

              padding: EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
        ),
      ),
    );
  }
}