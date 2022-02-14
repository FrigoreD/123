import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main/main_screen.dart';
import 'registration_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<IntroScreen> {

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('userLogin') ?? false;
  }

  void checkingTheSavedData() {
    isUserLoggedIn().then((isLogged) {
      if (isLogged) {
        final Route route = MaterialPageRoute(builder: (context) =>  const MainScreen());
        Navigator.pushReplacement(context, route);
      } else {
        final Route route =
            MaterialPageRoute(builder: (context) => const RegistrationScreen());
        Navigator.pushReplacement(context, route);
      }
    });
  }
}
