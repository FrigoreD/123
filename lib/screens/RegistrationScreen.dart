import 'dart:convert';
import 'dart:io';
import 'package:astrology_app/Screens/Otp.dart';
import 'package:astrology_app/controller/auth_controller.dart';
import 'package:astrology_app/generated/l10n.dart';
import 'package:astrology_app/helper/dialog_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:astrology_app/Class/CountryClass.dart';
import 'package:astrology_app/Page/RegistrationPage.dart';
import 'package:astrology_app/Widgets/ButtionLine.dart';
import 'package:astrology_app/Widgets/SelectorWiget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'main/main_screen.dart';


final AuthController _authController=AuthController();
class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}
TextEditingController emailController=TextEditingController();
List<countryClass> countryList = [
  countryClass("Русский", "ru"),
  countryClass("English", "en")
];


class _RegistrationState extends State<RegistrationScreen> {
  final controller = PageController(initialPage: 0);
  String name = "";
  String dateBurn = "";
  String timeBurn = "";
  String language = "";
  String login = "";
  String timeBirth = "";
  String tokenUser='';
  String country = "";
  String placeId='';

  void connection()async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
    messaging.getToken().then((token) => tokenUser=token);


  }


  @override
  void initState() {
    connection();
    super.initState();
  }

  bool showLoad=false;
  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context);
    return SafeArea(
        child: PageView(
          physics: new NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          controller: controller,
          children: [

            Scaffold(
          body: Padding(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 32),
                  child: Text(
                    S.of(context).registration_page_set_email_title,
                  ),
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (term) {
                    if (emailController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      if(!showLoad){
                        checkEmail(emailController.text);
                        setState(() {
                          showLoad=true;
                        });
                      }
                    }
                  },
                  decoration: InputDecoration(
                      hintText: S.of(context).registration_page_set_email_hint),
                ),
                Container(
                  margin: EdgeInsets.only(top: 12),
                  child: ElevatedButton(
                    onPressed: () {
                      if (emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        if(!showLoad){
                          checkEmail(emailController.text);
                          setState(() {
                            showLoad=true;
                          });
                        }
                      }

                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Align(
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                Visibility(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  ),
                                  visible: showLoad,
                                ),
                                SizedBox(width: 12,),
                                Text(
                                  S.of(context).next_button,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'SF Pro Display',
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 32),
          ),
        ),
            Scaffold(
              body: Center(
                  child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              S.of(context).registration_page_select_language,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'SF Pro Display',
                                  color: Colors.blue,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          margin: EdgeInsets.only(bottom: 32),
                        ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: countryList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return selectorWidget(
                                onClick: (value) {
                                  var locale = Locale(countryList[index].cod,'');
                                  Get.updateLocale(locale);
                                  setState(() {
                                    language = value;
                                  });
                                  controller.animateToPage(2,
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeIn);
                                  },
                                countryItem: countryList[index],
                              );
                            })
                      ],
                    ),
                  )),
            ),
            RegistrationPageModel(
              context: context,
              onClick: (text,key) {
                debugPrint("messsage = $text");
                setState(() {
                  //    FocusScope.of(context).unfocus();
                    name = text;
                });
                controller.animateToPage(3,
                    duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                },
              Title: S.of(context).registration_page_set_name_title,
              Hint: S.of(context).registration_page_set_name_hint,
              type: TYPE_TEXT,
            ),
            RegistrationPageModel(
              context: context,
              onClick: (text,key) {
                debugPrint("messsage = $text");
                setState(() {
                  dateBurn = text;
                });
                controller.animateToPage(4,
                    duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                },
              Title: S.of(context).registration_page_set_date_birth_title,
              Hint: S.of(context).registration_page_set_date_birth_hint,
              type: TYPE_DATE,
            ),
            RegistrationPageModel(
              context: context,
              onClick: (text,key) {
                debugPrint("messsage = $text");
                setState(() {
                  timeBurn = text;
                  DateTime dateTime = DateFormat('dd.MM.yyyy HH:mm')
                      .parseLoose(dateBurn + ' ' + timeBurn);
                  timeBirth = DateFormat("yyyy-MM-dd HH:mm").format(dateTime);
                });
                controller.animateToPage(5,
                    duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                },
              Title: S.of(context).registration_page_set_time_birth_title,
              Hint: S.of(context).registration_page_set_time_birth_hint,
              type: TYPE_TIME,
            ),
            RegistrationPageModel(
              context: context,
              onClick: (text,key) {
                if(key!=''){
                  debugPrint("messsage = $key");
                  placeId=key;
                }
                if(text!=''){
                  setState(() {
                    country = text;
                  });
                }
                controller.animateToPage(6,
                    duration: Duration(milliseconds: 300), curve: Curves.easeIn);
              },
              Title: S.of(context).registration_page_set_location,
              Hint: S.of(context).registration_page_set_location,
              type: TYPE_COUNTRY,
            ),
            Scaffold(
              body: Padding(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        S.of(context).registration_page_check_info,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'SF Pro Display',
                            color: Colors.blue,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Table(
                      children: [
                        TableRow(children: [
                          Text(
                            S.of(context).name,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'SF Pro Display',
                                color: Colors.blue,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            name,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontSize: 24,
                            ),
                          )
                        ]),
                        TableRow(children: [
                          Text(
                            S.of(context).date_burn,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'SF Pro Display',
                                color: Colors.blue,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                        dateBurn,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontSize: 24,
                        ),
                      )
                    ]),
                    TableRow(children: [
                      Text(
                        S.of(context).time_burn,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'SF Pro Display',
                            color: Colors.blue,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        timeBurn,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontSize: 24,
                        ),
                      )
                    ])
                  ],
                ),
                    Text(jsonEncode({
                      "firstName": name,
                      "dateBirth": dateBurn,
                      "lang": language,
                      "login": login,
                      "timeBirth": timeBirth,
                      "country": country,
                      "token":tokenUser
                    })),
                    ButtonLine(
                      onClick: () {
                        registration();
                        },
                      title: S.of(context).registration_page_button_create_account,
                    )
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 32),
              ),
            ),
          ],
        ));
  }



  void checkEmail(email) async {
    try {
      var url = Uri.parse('https://astrologyspica.dev-prod.com.ua/api/customers/checkEmail');
      var response = await http.post(url,
          body: jsonEncode({
            "email": email,
          }),
          headers: {'Content-Type': 'application/json'});

      setState(() {
        showLoad=false;
      });

      switch(response.statusCode){
        case 200:
          Map<String, dynamic> map = jsonDecode(response.body);
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Otp(
                  email: email,
                )),
          );
          if (result == 'done') {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('userLogin', true);
            Route route = MaterialPageRoute(builder: (context) => MainScreen());
            Navigator.pushReplacement(context, route);
          }
          break;
        case 204:
          controller.animateToPage(1,
              duration: Duration(milliseconds: 300), curve: Curves.easeIn);
          break;
        case 400:
          final snackBar = SnackBar(content: Text(jsonDecode(response.body)[0]));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
        case 404:
          controller.animateToPage(1,
              duration: Duration(milliseconds: 300), curve: Curves.easeIn);
          break;
        default:
          final snackBar = SnackBar(content: Text("response code "+response.statusCode.toString()+'\n'+response.body));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
      }
    } on SocketException {
      print('No Internet connection 😑');
      final snackBar = SnackBar(content: Text("SocketException "));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on HttpException {
      print("Couldn't find the post 😱");
      final snackBar = SnackBar(content: Text("HttpException"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on FormatException {
      print("Bad response format 👎");
      final snackBar = SnackBar(content: Text("FormatException"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  Future<void> registration() async{
    DateTime timeBurn=new DateFormat("yyyy-MM-dd hh:mm").parse(timeBirth);
    final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    if(placeId==''){
      placeId='ChIJS9tioOplwUMRIH9W99dDAtU';
    }
    var data={
      "name": name,
      "dateTimeBirth":timeBurn.toIso8601String(),
      "lang": language,
      "email": emailController.text,
      "city": country,
      "token":tokenUser,
      "timeZone":currentTimeZone,
      "placeId":placeId
    };
    var result= await _authController.registration(data);
    if(result){
      await saveUser();
      Get.offAll(()=>MainScreen());
    }else{
      DialogHelper.showErrorDialog(title: 'Ошибка',description: 'Ошибка регистрации');
    }
  }

  Future<void> saveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    await prefs.setBool('userLogin', true);
    await prefs.setString('firstName', name);
    await prefs.setString('timeBirth', timeBirth);
    await prefs.setString('timeZone', currentTimeZone);
    await prefs.setString('city', country);
    await prefs.setString('lang', language);
  }
}

final storage = new FlutterSecureStorage();
