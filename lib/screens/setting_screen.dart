import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:get/get.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/setting_controller.dart';
import '../generated/l10n.dart';
import '../page/registration_page.dart';
import 'menu_screen.dart';
import 'registration_screen.dart';

SettingController _settingController=SettingController();
TextEditingController controller=TextEditingController();
DateTime dateTime=DateTime.now();
bool _switchValue=true;
class SettingScreen extends StatefulWidget {
  const SettingScreen({Key key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}
class _SettingState extends State<SettingScreen>{

  String name='';
  String dateB='';
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
        title: Text(S.of(context).SETTINGS_TITLE
            ,textAlign: TextAlign.center,style: const TextStyle(color: Colors.black),),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100]
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                child: Row(
                  children: [
                    Text(S.of(context).SETTINGS_NOTIFICATION,
                      style: const TextStyle(
                          fontSize: 18
                      ),
                    ),
                    const Spacer(),
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
              const Divider(height: 1,),
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                  child: Row(
                    children: [
                      Text(S.of(context).SETTINGS_LOCATION,
                        style: const TextStyle(
                            fontSize: 18
                        ),
                      ),
                      const Spacer(),
                      Text(location,style: const TextStyle(
                          fontSize: 18
                      ),),
                    ],
                  ),
                ),
                onTap: () async {
                  print('Prediction=>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>start');
                  final Prediction p = await PlacesAutocomplete.show(
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
                    types: ['(cities)'],
                    hint: 'Укажите город рождения',
                    //   startText: city == null || city == "" ? "" : city
                  );
                  if (p != null) {
                    // print('Prediction=>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+p.id);
                    final GoogleMapsPlaces _places = GoogleMapsPlaces(
                      apiKey: kGoogleApiKey,
                      apiHeaders: await const GoogleApiHeaders().getHeaders(),
                    );
                    final PlacesDetailsResponse detail = await _places
                        .getDetailsByPlaceId(p.placeId);
                    print('placeKey====================>>>>>>>>>>${p.placeId}');

                    final result= await _settingController.updateCity(detail.result.name,p.placeId);
                    if(result){
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setString('city',detail.result.name);
                      Get.snackbar('Обновлено', 'Ваш город рождения обновлен');
                      setState(() {
                        location=detail.result.name;
                      });

                    }

                  }
                }
              ),
              const Divider(height: 1,),
              //name
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                  child: Row(
                    children: [
                      Text(S.of(context).SETTINGS_NAME,
                        style: const TextStyle(
                            fontSize: 18
                        ),
                      ),
                      const Spacer(),
                      Text(name,
                        style: const TextStyle(
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
              const Divider(height: 1,),
              //дата рождения
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                  child: Row(
                    children: [
                      Text(S.of(context).SETTINGS_DATE_BURN,
                        style: const TextStyle(
                            fontSize: 18
                        ),
                      ),
                      const Spacer(),
                      Text(dateB,
                        style: const TextStyle(
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
              const Divider(height: 1,),
              //время рождения
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                  child: Row(
                    children: [
                      Text(S.of(context).SETTINGS_TIME_BURN,
                        style: const TextStyle(
                            fontSize: 18
                        ),
                      ),
                      const Spacer(),
                      Text(timeB,
                        style: const TextStyle(
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
              const Divider(height: 1,),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                    onPressed: (){
                      logOut();
                    },
                    child: Text(S.of(context).SETTINGS_LOG_OUT)
                ),
              )


            ],
          ),
        ),
      ),
    );
  }
  Future<void> logOut() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('userLogin',false);
    await Get.offAll<void>(()=>const RegistrationScreen());
  }
 Future<void> load() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name=prefs.getString('firstName');
      location=prefs.getString('city');
      dateTime = DateFormat('yyyy-MM-dd HH:mm').parseLoose(prefs.getString('timeBirth'));
      dateB=DateFormat('dd.MM.yyyy').format(dateTime);
      timeB=DateFormat('HH:mm').format(dateTime);
    });
  }

  void _showDatePicker(BuildContext ctx) {
    showCupertinoModalPopup<void>(
        context: ctx,
        builder: (_) => Container(
          height: 500,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Column(
            children: [
              SizedBox(
                height: 400,
                child: CupertinoDatePicker(
                    initialDateTime: dateTime,
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (val) {
                      //_selectedDate = val;
                      dateTime=DateTime(val.year,val.month,val.day,dateTime.hour,dateTime.minute);
                    }),
              ),
              // Close the modal
              CupertinoButton(
                child: const Text('OK'),
                onPressed: ()async {

                  final SharedPreferences prefs = await SharedPreferences.getInstance();
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
 Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
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
      dateTime=DateTime(dateTime.year,dateTime.month,dateTime.day,picked.hour,picked.minute);
      final result= await _settingController.updateDate(dateTime);
      if(result){
        final SharedPreferences prefs = await SharedPreferences.getInstance();
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
    showModalBottomSheet<void>(
        shape: const RoundedRectangleBorder(
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

              const SizedBox(
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
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton (
                          onPressed: ()async{
                            if(controller.text.isEmpty){
                              Get.snackbar('Укажите новое имя', 'Укажите новое имя');
                              return;
                            }
                            final result= await _settingController.updateName(controller.text);
                            if(result){
                              final SharedPreferences prefs = await SharedPreferences.getInstance();
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

              const SizedBox(height: 10),

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