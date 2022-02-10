import 'package:astrology_app/Screens/RegistrationScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main/main_screen.dart';

class IntroScreen extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<IntroScreen> {
  var UserId = '';

  @override
  Widget build(BuildContext context) {
    checkingTheSavedData();
    return Scaffold(
      backgroundColor: const Color(0xff2273d2),
      body: Center(
        child: Image.asset('assets/images/vector.png'),
      ),
    );
  }

  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('userLogin') ?? false;
  }

  void checkingTheSavedData() {
    isUserLoggedIn().then((isLogged) {
      if (isLogged) {
        Route route = MaterialPageRoute(builder: (context) => MainScreen());
        Navigator.pushReplacement(context, route);
      } else {
        Route route =
            MaterialPageRoute(builder: (context) => RegistrationScreen());
        Navigator.pushReplacement(context, route);
      }
    });
  }
}
