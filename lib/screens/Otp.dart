
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

import '../generated/l10n.dart';

class Otp extends StatefulWidget {
  final String email;
  final String newEmail;
  final bool isGuestCheckOut;
  final String token;

  const Otp({
    Key key,
    @required this.email,
    this.newEmail = '',
    this.isGuestCheckOut,
    this.token='',
  }) : super(key: key);

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> with SingleTickerProviderStateMixin {
  // Constants
  final int time = 180;
  AnimationController _controller;

  // Variables
  Size _screenSize;
  int _currentDigit;
  int _firstDigit;
  int _secondDigit;
  int _thirdDigit;
  int _fourthDigit;

  Timer timer;
  int totalTimeInSeconds;
  bool _hideResendButton;

  String userName = '';
  bool didReadNotifications = false;
  int unReadNotificationsCount = 0;

  // Returns "Appbar"
  AppBar get _getAppbar {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: InkWell(
        borderRadius: BorderRadius.circular(30.0),
        child: const Icon(
          Icons.arrow_back,
          color: Colors.black54,
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
    );
  }

  // Return "Verification Code" label
  Text get _getVerificationCodeLabel {
    return Text(
      S.of(context).OTP_TITLE,
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontSize: 28.0, color: Colors.black, fontWeight: FontWeight.bold),
    );
  }

  // Return "Email" label
  Text get _getEmailLabel {
    return Text(
      S.of(context).OTP_MESSAGE,
      textAlign: TextAlign.center,
      style: const TextStyle(
          fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w600),
    );
  }

  // Return "OTP" input field
  Row get _getInputField {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _otpTextField(_firstDigit),
        _otpTextField(_secondDigit),
        _otpTextField(_thirdDigit),
        _otpTextField(_fourthDigit),
      ],
    );
  }

  // Returns "OTP" input part
  Column get _getInputPart {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _getVerificationCodeLabel,
        _getEmailLabel,
        _getInputField,
        if (_hideResendButton) _getTimerText else _getResendButton,
        _getOtpKeyboard
      ],
    );
  }

  // Returns "Timer" label
  SizedBox get _getTimerText {
    return SizedBox(
      height: 32,
      child: Offstage(
        offstage: !_hideResendButton,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.access_time),
            const SizedBox(
              width: 5.0,
            ),
            OtpTimer(_controller, 15.0, Colors.black)
          ],
        ),
      ),
    );
  }

  // Returns "Resend" button
  InkWell get _getResendButton {
    return InkWell(
      child: Container(
        height: 32,
        width: 120,
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(32)),
        alignment: Alignment.center,
        child: Text(
          S.of(context).OTP_RESEND,
          style:
          const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      onTap: () {
        // Resend you OTP via API or anything
      },
    );
  }

  // Returns "Otp" keyboard
  SizedBox get _getOtpKeyboard {
    return SizedBox(
        height: _screenSize.width - 80,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: '1',
                      onPressed: () {
                        _setCurrentDigit(1);
                      }),
                  _otpKeyboardInputButton(
                      label: '2',
                      onPressed: () {
                        _setCurrentDigit(2);
                      }),
                  _otpKeyboardInputButton(
                      label: '3',
                      onPressed: () {
                        _setCurrentDigit(3);
                      }),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: '4',
                      onPressed: () {
                        _setCurrentDigit(4);
                      }),
                  _otpKeyboardInputButton(
                      label: '5',
                      onPressed: () {
                        _setCurrentDigit(5);
                      }),
                  _otpKeyboardInputButton(
                      label: '6',
                      onPressed: () {
                        _setCurrentDigit(6);
                      }),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _otpKeyboardInputButton(
                      label: '7',
                      onPressed: () {
                        _setCurrentDigit(7);
                      }),
                  _otpKeyboardInputButton(
                      label: '8',
                      onPressed: () {
                        _setCurrentDigit(8);
                      }),
                  _otpKeyboardInputButton(
                      label: '9',
                      onPressed: () {
                        _setCurrentDigit(9);
                      }),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const SizedBox(
                    width: 80.0,
                  ),
                  _otpKeyboardInputButton(
                      label: '0',
                      onPressed: () {
                        _setCurrentDigit(0);
                      }),
                  _otpKeyboardActionButton(
                      label: const Icon(
                        Icons.backspace,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_fourthDigit != null) {
                            _fourthDigit = null;
                          } else if (_thirdDigit != null) {
                            _thirdDigit = null;
                          } else if (_secondDigit != null) {
                            _secondDigit = null;
                          } else if (_firstDigit != null) {
                            _firstDigit = null;
                          }
                        });
                      }),
                ],
              ),
            ),
          ],
        ));
  }

  // Overridden methods
  @override
  void initState() {
    totalTimeInSeconds = time;
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: Duration(seconds: time))
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          setState(() {
            _hideResendButton = !_hideResendButton;
          });
        }
      });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
    _startCountdown();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _getAppbar,
      backgroundColor: Colors.white,
      body: SizedBox(
        width: _screenSize.width,
//        padding: new EdgeInsets.only(bottom: 16.0),
        child: _getInputPart,
      ),
    );
  }

  // Returns "Otp custom text field"
  Widget _otpTextField(int digit) {
    return Container(
      width: 35.0,
      height: 45.0,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
//            color: Colors.grey.withOpacity(0.4),
          border: Border(
              bottom: BorderSide(
                width: 2.0,
              ))),
      child: Text(
        digit != null ? digit.toString() : '',
        style: const TextStyle(
          fontSize: 30.0,
          color: Colors.black,
        ),
      ),
    );
  }

  // Returns "Otp keyboard input Button"
  Widget _otpKeyboardInputButton({String label, VoidCallback onPressed}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(40.0),
        child: Container(
          height: 80.0,
          width: 80.0,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 30.0,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Returns "Otp keyboard action Button"
  InkWell _otpKeyboardActionButton({Widget label, VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(40.0),
      child: Container(
        height: 80.0,
        width: 80.0,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Center(
          child: label,
        ),
      ),
    );
  }

  // Current digit
  Future<void> _setCurrentDigit(int i) async {

    setState(() {
      _currentDigit = i;
      if (_firstDigit == null) {
        _firstDigit = _currentDigit;
      } else if (_secondDigit == null) {
        _secondDigit = _currentDigit;
      } else if (_thirdDigit == null) {
        _thirdDigit = _currentDigit;
      } else if (_fourthDigit == null) {
        _fourthDigit = _currentDigit;

        final otp = _firstDigit.toString() +
            _secondDigit.toString() +
            _thirdDigit.toString() +
            _fourthDigit.toString();

        checkCode(otp,context,widget.email);

      }
    });
  }

  Future<void> _startCountdown() async {
    setState(() {
      _hideResendButton = true;
      totalTimeInSeconds = time;
    });
    await _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
  }

  void clearOtp() {
    _fourthDigit = null;
    _thirdDigit = null;
    _secondDigit = null;
    _firstDigit = null;
    setState(() {});
  }
  Future<void> checkCode(code,BuildContext context, email)async{
    final ProgressDialog pr = ProgressDialog(context);
    try{
      await pr.show();
      final url = Uri.parse('https://astrologyspica.dev-prod.com.ua/api/customers/checkCode');
      final response = await http.post(url, body: jsonEncode({
        'email': email,
        'code': code,
        'token': widget.token
      }),headers: {'Content-Type':'application/json'});
      if(response.statusCode==200){
        final Map<String,dynamic> map=jsonDecode(response.body);
        await storage.write(key: 'session', value: map['token']);
        print( map['token']);
        await pr.hide();
        Navigator.pop(context, 'done');
      }else if(response.statusCode==401||response.statusCode==204){
        await pr.hide();
        const snackBar = SnackBar(content: Text('Ошибка в коде'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }else{
        await pr.hide();
        const snackBar = SnackBar(content: Text('Неизвестная ошибка'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }on SocketException {
      await pr.hide();
      print('No Internet connection 😑');
      const snackBar = SnackBar(content: Text('SocketException'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on HttpException {
      await pr.hide();
      print("Couldn't find the post 😱");
      const snackBar = SnackBar(content: Text('HttpException'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on FormatException {
      await pr.hide();
      print('Bad response format 👎');
      const snackBar = SnackBar(content: Text('FormatException'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

}
const storage = FlutterSecureStorage();
class OtpTimer extends StatelessWidget {
  final AnimationController controller;
  double fontSize;
  Color timeColor = Colors.black;

  OtpTimer(this.controller, this.fontSize, this.timeColor);

  String get timerString {
    final Duration duration = controller.duration * controller.value;
    if (duration.inHours > 0) {
      return '${duration.inHours}:${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '${duration.inMinutes % 60}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Duration get duration {
    final Duration duration = controller.duration;
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          return Text(
            timerString,
            style: TextStyle(
                fontSize: fontSize,
                color: timeColor,
                fontWeight: FontWeight.w600),
          );
        });
  }
}
