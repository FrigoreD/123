import 'package:astrology_app/Page/RegistrationPage.dart';
import 'package:astrology_app/Screens/MenuScreen.dart';
import 'package:astrology_app/Screens/RegistrationScreen.dart';
import 'package:astrology_app/controller/setting_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:astrology_app/generated/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';

SettingController _settingController=SettingController();
TextEditingController controller=TextEditingController();
DateTime dateTime=DateTime.now();
bool _switchValue=true;
class SettingScreen extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}
class _SettingState extends State<SettingScreen>{

  String name="";
  String dateB="";
  String location='';
  String timeB='';

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
        title: Text(S.of(context).SETTINGS_TITLE
            ,textAlign: TextAlign.center,style: TextStyle(color: Colors.black),),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100]
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                child: Row(
                  children: [
                    Text(S.of(context).SETTINGS_NOTIFICATION,
                      style: TextStyle(
                          fontSize: 18
                      ),
                    ),
                    Spacer(),
                    CupertinoSwitch(
                      value: _switchValue,
                      onChanged: (value) {
                        setState(() {
                          _switchValue = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Divider(height: 1,),
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                  child: Row(
                    children: [
                      Text(S.of(context).SETTINGS_LOCATION,
                        style: TextStyle(
                            fontSize: 18
                        ),
                      ),
                      Spacer(),
                      Text(location,style: TextStyle(
                          fontSize: 18
                      ),),
                    ],
                  ),
                ),
                onTap: () async {
                  print('Prediction=>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>start');
                  Prediction p = await PlacesAutocomplete.show(
                    offset: 0,
                    radius: 1000,
                    strictbounds: false,
                    context: context,
                    mode: Mode.overlay,
                    language: 'ru',
                    apiKey: kGoogleApiKey,
                    components: [
                    //  new Component(Component.country, "us"),
                    //  new Component(Component.country, "ru")
                    ],
                    types: ["(cities)"],
                    hint: "Укажите город рождения",
                    //   startText: city == null || city == "" ? "" : city
                  );
                  if (p != null) {
                    // print('Prediction=>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+p.id);
                    GoogleMapsPlaces _places = GoogleMapsPlaces(
                      apiKey: kGoogleApiKey,
                      apiHeaders: await GoogleApiHeaders().getHeaders(),
                    );
                    PlacesDetailsResponse detail = await _places
                        .getDetailsByPlaceId(p.placeId);
                    print('placeKey====================>>>>>>>>>>${p.placeId}');

                    var result= await _settingController.updateCity(detail.result.name,p.placeId);
                    if(result){
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setString('city',detail.result.name);
                      Get.snackbar('Обновлено', 'Ваш город рождения обновлен');
                      setState(() {
                        location=detail.result.name;
                      });

                    }

                  }
                }
              ),
              Divider(height: 1,),
              //name
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                  child: Row(
                    children: [
                      Text(S.of(context).SETTINGS_NAME,
                        style: TextStyle(
                            fontSize: 18
                        ),
                      ),
                      Spacer(),
                      Text(name,
                        style: TextStyle(
                            fontSize: 18
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  _modalBottomSheetMenu();
                },
              ),
              Divider(height: 1,),
              //дата рождения
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                  child: Row(
                    children: [
                      Text(S.of(context).SETTINGS_DATE_BURN,
                        style: TextStyle(
                            fontSize: 18
                        ),
                      ),
                      Spacer(),
                      Text(dateB,
                        style: TextStyle(
                            fontSize: 18
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  _showDatePicker(context);
                },
              ),
              Divider(height: 1,),
              //время рождения
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                  child: Row(
                    children: [
                      Text(S.of(context).SETTINGS_TIME_BURN,
                        style: TextStyle(
                            fontSize: 18
                        ),
                      ),
                      Spacer(),
                      Text(timeB,
                        style: TextStyle(
                            fontSize: 18
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  _selectTime(context);
                },
              ),
              Divider(height: 1,),
              Spacer(),
              SizedBox(
                child: OutlinedButton(
                    onPressed: (){
                      logOut();
                    },
                    child: Text(S.of(context).SETTINGS_LOG_OUT)
                ),
                width: double.infinity,
              )


            ],
          ),
        ),
      ),
    );
  }
  void logOut() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('userLogin',false);
    Get.offAll(()=>RegistrationScreen());
  }
  void load() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name=prefs.getString("firstName");
      location=prefs.getString('city');
      dateTime = DateFormat('yyyy-MM-dd HH:mm').parseLoose(prefs.getString("timeBirth"));
      dateB=DateFormat('dd.MM.yyyy').format(dateTime);
      timeB=DateFormat('HH:mm').format(dateTime);
    });
  }

  void _showDatePicker(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
          height: 500,
          color: Color.fromARGB(255, 255, 255, 255),
          child: Column(
            children: [
              Container(
                height: 400,
                child: CupertinoDatePicker(
                    initialDateTime: dateTime,
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (val) {
                      //_selectedDate = val;
                      dateTime=new DateTime(val.year,val.month,val.day,dateTime.hour,dateTime.minute);
                    }),
              ),
              // Close the modal
              CupertinoButton(
                child: Text('OK'),
                onPressed: ()async {

                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setString('timeBirth', DateFormat('yyyy-MM-dd HH:mm').format(dateTime));
                  Get.snackbar('Обновлено', 'Ваше дата рождения обновлена');
                  setState(() {
                    dateB=DateFormat('HH:mm').format(dateTime);
                  });
                  Navigator.of(ctx).pop();

                },
              )
            ],
          ),
        ));
  }
  _selectTime(BuildContext context) async {
    TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },);

    if (picked != null) {
      dateTime=new DateTime(dateTime.year,dateTime.month,dateTime.day,picked.hour,picked.minute);
      var result= await _settingController.updateDate(dateTime);
      if(result){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('timeBirth', DateFormat('yyyy-MM-dd HH:mm').format(dateTime));
        Get.snackbar('Обновлено', 'Ваше время рождения обновленно');
        setState(() {
          timeB=DateFormat('HH:mm').format(dateTime);
        });
       // Navigator.pop(context);

      }
    }else{
    }
  }
  void _modalBottomSheetMenu(){
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
          padding: const EdgeInsets.symmetric(horizontal:18 ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          hintText: S.of(context).registration_page_set_name_hint
                      ),
                      autofocus: true,
                      controller: controller,
                      //  controller: _newMediaLinkAddressController,
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton (
                          onPressed: ()async{
                            if(controller.text.isEmpty){
                              Get.snackbar('Укажите новое имя', 'Укажите новое имя');
                              return;
                            }
                            var result= await _settingController.updateName(controller.text);
                            if(result){
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              await prefs.setString('firstName', controller.text);
                              Get.snackbar('Обновлено', 'Ваше имя обновленно');
                              setState(() {
                                name=controller.text;
                              });
                              Navigator.pop(context);

                            }
                          },
                          child: Text(S.of(context).EDIT_SAVE)
                      ),
                    ),

                  ],
                ),
              ),

              SizedBox(height: 10),

            ],
          ),
        ));
  }
  @override
  void initState() {
    super.initState();
    load();
  }
}