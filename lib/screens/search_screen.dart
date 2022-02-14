import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../generated/l10n.dart';
import 'menu_screen.dart';
import 'search_result_screen.dart';

class SearchScreen extends StatelessWidget{
  const SearchScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      home: const SearchPage(),
    );
  }

}
TextEditingController searchController = TextEditingController();

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}
String errorText;
class _SearchState extends State<SearchPage>{

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
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.grey[100]
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  const SizedBox(
                    height:120,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(24)
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: TextField(
                          textInputAction: TextInputAction.search,
                          controller: searchController,
                          onSubmitted: (text){
                            if(text.isNotEmpty){
                              errorText=null;
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute(builder: (context) => SettingResultScreen(request: text,)),
                              );
                            }
                            if(text.isEmpty){
                              errorText='Заполните поле';
                            }
                            setState(() {
                            });
                          },
                          decoration: InputDecoration(
                            labelText: S.of(context).search_hint,
                            errorText: errorText,
                            suffixIcon: IconButton(
                              onPressed: () {
                                final String text=searchController.value.text;
                                if(text.isNotEmpty){
                                  errorText=null;
                                  Navigator.push<void>(
                                    context,
                                    MaterialPageRoute(builder: (context) => SettingResultScreen(request: text,)),
                                  );
                                }
                                if(text.isEmpty){
                                  errorText='Заполните поле';
                                }
                                setState(() {
                                });
                              } ,
                              icon: const Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}