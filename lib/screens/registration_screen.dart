import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../class/country_model.dart';
import '../controller/auth_controller.dart';
import '../generated/l10n.dart';
import '../helper/dialog_helper.dart';
import '../page/registration_page.dart';
import '../widgets/button_line.dart';
import '../widgets/selector_widget.dart';
import 'main/main_screen.dart';
import 'otp.dart';


final AuthController _authController=AuthController();
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}
TextEditingController emailController=TextEditingController();
List<Country> countryList = [
  Country('Русский', 'ru'),
  Country('English', 'en')
];


class _RegistrationState extends State<RegistrationScreen> {
  final controller = PageController();
  String name = '';
  String dateBurn = '';
  String timeBurn = '';
  String language = '';
  String login = '';
  String timeBirth = '';
  String tokenUser='';
  String country = '';
  String placeId='';

  Future<void> connection()async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    final NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
    await messaging.getToken().then((token) => tokenUser=token);


  }


  @override
  void initState() {
    connection();
    super.initState();
  }

  bool showLoad=false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller,
          children: [

            Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 32),
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
                  margin: const EdgeInsets.only(top: 12),
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
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Align(
                            child: Row(
                              children: [
                                Visibility(
                                  visible: showLoad,
                                  child: const CircularProgressIndicator(
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12,),
                                Text(
                                  S.of(context).next_button,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
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
          ),
        ),
            Scaffold(
              body: Center(
                  child: SingleChildScrollView(
                    physics: const ScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 32),
                          child: Align(
                            child: Text(
                              S.of(context).registration_page_select_language,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'SF Pro Display',
                                  color: Colors.blue,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: countryList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return SelectorWidget(
                                onClick: (value) {
                                  final locale = Locale(countryList[index].code,'');
                                  Get.updateLocale(locale);
                                  setState(() {
                                    language = value;
                                  });
                                  controller.animateToPage(2,
                                      duration: const Duration(milliseconds: 300),
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
                debugPrint('messsage = $text');
                setState(() {
                  //    FocusScope.of(context).unfocus();
                    name = text;
                });
                controller.animateToPage(3,
                    duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                },
              title: S.of(context).registration_page_set_name_title,
              hint: S.of(context).registration_page_set_name_hint,
              type: typeText,
            ),
            RegistrationPageModel(
              context: context,
              onClick: (text,key) {
                debugPrint('messsage = $text');
                setState(() {
                  dateBurn = text;
                });
                controller.animateToPage(4,
                    duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                },
              title: S.of(context).registration_page_set_date_birth_title,
              hint: S.of(context).registration_page_set_date_birth_hint,
              type: typeDate,
            ),
            RegistrationPageModel(
              context: context,
              onClick: (text,key) {
                debugPrint('messsage = $text');
                setState(() {
                  timeBurn = text;
                  final DateTime dateTime = DateFormat('dd.MM.yyyy HH:mm')
                      .parseLoose('$dateBurn $timeBurn');
                  timeBirth = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
                });
                controller.animateToPage(5,
                    duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                },
              title: S.of(context).registration_page_set_time_birth_title,
              hint: S.of(context).registration_page_set_time_birth_hint,
              type: typeTime,
            ),
            RegistrationPageModel(
              context: context,
              onClick: (text,key) {
                if(key!=''){
                  debugPrint('messsage = $key');
                  placeId=key;
                }
                if(text!=''){
                  setState(() {
                    country = text;
                  });
                }
                controller.animateToPage(6,
                    duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
              },
              title: S.of(context).registration_page_set_location,
              hint: S.of(context).registration_page_set_location,
              type: typeCountry,
            ),
            Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      child: Text(
                        S.of(context).registration_page_check_info,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
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
                            style: const TextStyle(
                                fontFamily: 'SF Pro Display',
                                color: Colors.blue,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            name,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontFamily: 'SF Pro Display',
                              fontSize: 24,
                            ),
                          )
                        ]),
                        TableRow(children: [
                          Text(
                            S.of(context).date_burn,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontFamily: 'SF Pro Display',
                                color: Colors.blue,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                        dateBurn,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontSize: 24,
                        ),
                      )
                    ]),
                    TableRow(children: [
                      Text(
                        S.of(context).time_burn,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontFamily: 'SF Pro Display',
                            color: Colors.blue,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        timeBurn,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontSize: 24,
                        ),
                      )
                    ])
                  ],
                ),
                    Text(jsonEncode({
                      'firstName': name,
                      'dateBirth': dateBurn,
                      'lang': language,
                      'login': login,
                      'timeBirth': timeBirth,
                      'country': country,
                      'token':tokenUser
                    })),
                    ButtonLine(
                      onClick: () {
                        registration();
                        },
                      title: S.of(context).registration_page_button_create_account,
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }



  Future<void> checkEmail(String email) async {
    try {
      final url = Uri.parse('https://astrologyspica.dev-prod.com.ua/api/customers/checkEmail');
      final response = await http.post(url,
          body: jsonEncode({
            'email': email,
          }),
          headers: {'Content-Type': 'application/json'});

      setState(() {
        showLoad=false;
      });

      switch(response.statusCode){
        case 200:
          final dynamic result = await Navigator.push<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
                builder: (context) => Otp(
                  email: email,
                )),
          );
          if (result == 'done') {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('userLogin', true);
            final Route route = MaterialPageRoute(builder: (context) => const MainScreen());
            await Navigator.pushReplacement(context, route);
          }
          break;
        case 204:
          await controller.animateToPage(1,
              duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
          break;
        case 400:
          final snackBar = SnackBar(content: Text(jsonDecode(response.body)[0]));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
        case 404:
          await controller.animateToPage(1,
              duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
          break;
        default:
          final snackBar = SnackBar(content: Text('response code ${response.statusCode}\n${response.body}'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          break;
      }
    } on SocketException {
      print('No Internet connection 😑');
      const snackBar = SnackBar(content: Text('SocketException '));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on HttpException {
      print("Couldn't find the post 😱");
      const snackBar = SnackBar(content: Text('HttpException'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on FormatException {
      print('Bad response format 👎');
      const snackBar = SnackBar(content: Text('FormatException'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
  Future<void> registration() async{
    final DateTime timeBurn=DateFormat('yyyy-MM-dd hh:mm').parse(timeBirth);
    final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    if(placeId==''){
      placeId='ChIJS9tioOplwUMRIH9W99dDAtU';
    }
    final data={
      'name': name,
      'dateTimeBirth':timeBurn.toIso8601String(),
      'lang': language,
      'email': emailController.text,
      'city': country,
      'token':tokenUser,
      'timeZone':currentTimeZone,
      'placeId':placeId
    };
    final result= await _authController.registration(data);
    if(result){
      await saveUser();
      await Get.offAll<void>(()=>const MainScreen());
    }else{
      DialogHelper.showErrorDialog(title: 'Ошибка',description: 'Ошибка регистрации');
    }
  }

  Future<void> saveUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    await prefs.setBool('userLogin', true);
    await prefs.setString('firstName', name);
    await prefs.setString('timeBirth', timeBirth);
    await prefs.setString('timeZone', currentTimeZone);
    await prefs.setString('city', country);
    await prefs.setString('lang', language);
  }
}

const storage = FlutterSecureStorage();
