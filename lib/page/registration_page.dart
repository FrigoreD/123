import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:intl/intl.dart';


import '../class/country_model.dart';
import '../generated/l10n.dart';
const String typeText='TYPE_TEXT';
const String typeDate='TYPE_DATE';
const String typeTime='TYPE_TIME';
const String typeLanguage='TYPE_LANGUAGE';
const String typeCountry='TYPE_COUNTRY';
TextEditingController controller = TextEditingController();
DateTime _selectedDate;
TimeOfDay  _selectedTime;

final f = DateFormat('dd.MM.yyyy');

String countryName;
String placeKey='';
const kGoogleApiKey = 'AIzaSyCux-PGZ8l7y9rO266damgpyxM6h1SxfLM';

class RegistrationPageModel extends StatelessWidget{
   const RegistrationPageModel({Key key, this.context, this.title, this.hint,  this.type, this.onClick}) : super(key: key);
  final BuildContext context;
  final String title;
  final String hint;
  final String type;
  final Function(String text,String key) onClick;



 

  @override
  Widget build(BuildContext context) {
    controller=TextEditingController();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 32),
              child: Text(
                  title,

              ),
            ),
            textInput(),
            Container(
              margin: const EdgeInsets.only(top: 12),
              child: ElevatedButton(
                onPressed: () {
                  if(countryName!=null){
                    onClick(countryName,'');
                  }
                  if(placeKey!=''){
                    onClick(controller.text, placeKey);
                  }
                  if(controller.text.isEmpty){
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }else{
                    onClick(controller.text,'');
                    return;
                  }

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Align(
                        child: Text(
                          S.of(context).next_button,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'SF Pro Display',
                          ),
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
    );
  }
  void onError(PlacesAutocompleteResponse response) {
   print(response);
  }
  dynamic textInput(){
    switch(type){
      case 'TYPE_TEXT':
        return TextFormField(
          textInputAction: TextInputAction.next,
          controller: controller,
          onFieldSubmitted: (term) {
            if(controller.text.isEmpty){
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }else{
              onClick(controller.text,'');
            }
          },
          decoration: InputDecoration(
              hintText: hint
          ),
        );
      case 'TYPE_DATE':
        return TextFormField(
          textInputAction: TextInputAction.next,
          controller: controller,
          onFieldSubmitted: (term) {
            if(controller.text.isEmpty){
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }else{
              onClick(controller.text,'');
            }
          },
          onTap: (){
            //_selectDate(context);
            _showDatePicker(context);
            /*
            DatePicker.showDatePicker(context,
                showTitleActions: true,
                minTime: DateTime(1930),
                maxTime: DateTime(2025), onChanged: (date) {
                  print('change $date');
                }, onConfirm: (date) {
                  _selectedDate = date;
                  controller.text=f.format(_selectedDate);
                }, currentTime: DateTime.now(), locale: LocaleType.ru);
                */

          },
          focusNode: AlwaysDisabledFocusNode(),
          decoration: InputDecoration(
              hintText: hint
          ),
        );
      case 'TYPE_TIME':
        return TextFormField(
          textInputAction: TextInputAction.next,
          controller: controller,
          onFieldSubmitted: (term) {
            if(controller.text.isEmpty){
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }else{
              onClick(controller.text,'');
            }

          },
          onTap: (){
            _selectTime(context);
            /*
            DatePicker.showTimePicker(context,
                showTitleActions: true,
                onChanged: (date) {
                }, onConfirm: (t) {
                  _selectedTime=TimeOfDay.fromDateTime(t);
                  debugPrint("not nuul  SKA "+formatTimeOfDay(_selectedTime));
                  controller.text=formatTimeOfDay(_selectedTime);
                }, currentTime: DateTime.now(), locale: LocaleType.ru);
            */
          },
          focusNode: AlwaysDisabledFocusNode(),
          decoration: InputDecoration(
              hintText: hint
          ),
        );
      case 'TYPE_LANGUAGE':
        return ListView.builder(
          itemCount: countryList.length,
            itemBuilder: (BuildContext context,int index){
              return GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Align(
                        child: Text(
                          countryList[index].name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: 'SF Pro Display',
                              color: Colors.grey,
                              fontSize: 24
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                onTap: (){
                  onClick(countryList[index].code,'');
                },
              );
            }
        );
      case 'TYPE_COUNTRY':
        return TextFormField(
          key: key,
          textInputAction: TextInputAction.next,
          controller: controller,

          onTap: ()async{
            final Prediction p = await PlacesAutocomplete.show(
                offset: 0,
                radius: 1000,
                strictbounds: false,
                context: context,
                mode: Mode.overlay,
                language: 'ru',
                apiKey: kGoogleApiKey,
              components:[

              ],
                //components: [new Component(Component.country, "us"),new Component(Component.country, "ru")],
                types: ['(cities)'],
                hint: 'Укажите город рождения',
             //   startText: city == null || city == "" ? "" : city
            );
            if(p!=null){
             // print('Prediction=>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'+p.id);
              final GoogleMapsPlaces _places = GoogleMapsPlaces(
                apiKey: kGoogleApiKey,
                apiHeaders: await const GoogleApiHeaders().getHeaders(),
              );
              final PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
              placeKey=p.placeId;
              print('placeKey====================>>>>>>>>>>${p.placeId}');
              controller.text=detail.result.name;
            }
          },
          decoration: InputDecoration(
              filled: true,
              hintText: hint
          ),
        );
    }

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
                    initialDateTime: DateTime.now(),
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (val) {
                      _selectedDate = val;
                      controller.text=f.format(_selectedDate);
                    }),
              ),

              // Close the modal
              CupertinoButton(
                child: const Text('OK'),
                onPressed: () => Navigator.of(ctx).pop(),
              )
            ],
          ),
        ));
  }


  Future<void>_selectDate(BuildContext context) async {
    final DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2022),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      controller.text=f.format(_selectedDate);

    }
  }
 Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },);

    if (picked != null) {

      _selectedTime = picked;
      controller.text=formatTimeOfDay(_selectedTime);
    }else{
    }
  }
  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat('HH:mm');
    return format.format(dt);
  }
}
List<Country> countryList=[Country('Русский','ru'),Country('English','en')];

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
const snackBar = SnackBar(
  content: Text('Fill in the field'),
);