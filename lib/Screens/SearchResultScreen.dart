import 'package:astrology_app/Class/Reminder.dart';
import 'package:astrology_app/Class/ReminderHelper.dart';
import 'package:astrology_app/controller/predictions_controller.dart';
import 'package:astrology_app/models/prediction.dart';
import 'package:astrology_app/Screens/SearchScreen.dart';
import 'package:astrology_app/Widgets/CardMain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:hive/hive.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:astrology_app/generated/l10n.dart';

bool loadData=true;


List<Predictions> list=[];
PredictionsController _predictionsController=PredictionsController();
class SettingResultScreen extends StatefulWidget {
  final String request;

  const SettingResultScreen({Key key,@required this.request}) : super(key: key);
  @override
  _SettingResultState createState() => _SettingResultState(request);
}
class _SettingResultState extends State<SettingResultScreen>{
  final String request;
  ReminderHelper _reminderHelper=ReminderHelper();
  _SettingResultState(this.request);
  var txt = TextEditingController();
  @override
  Widget build(BuildContext context) {
    txt.text=request;
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
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          },
        ),
        title: Text(S.of(context).search_result_title,textAlign: TextAlign.center,style: TextStyle(color: Colors.black),),
      ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.grey[100]
            ),
            child: Column(
              children: [
                Visibility(
                  child: Column(
                    children: [
                      LinearProgressIndicator(),
                      SizedBox(height: 12,)
                    ],
                  ),
                  visible: loadData,
                ),
                Container(
                child: Center(
                  child: Padding(
                    child: TextField(
                      controller: txt,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (text){

                      },
                      decoration: InputDecoration(
                        labelText: S.of(context).search_hint,
                        errorText: errorText,
                          suffixIcon: IconButton(
                            onPressed: () {
                              String text=searchController.value.text;

                            } ,
                            icon: Icon(Icons.search),
                          )
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
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Text(S.of(context).search_result_count.replaceAll("XXX", list.length.toString())),
                    Spacer(),
                    Text("filter")
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index){
                      return CardMain(card: list[index],onClick: (){
                        print('click ${list[index]}');
                        save(list[index]);
                      },);
                      },
                    itemCount: list.length,
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  void loadResult() async{
    list.clear();
    list =await _predictionsController.search(widget.request);
    if(list==null){
      list=[];
    }
    setState(() {
      loadData=false;
    });
  }
  Future<void> saveRemainder(Reminder reminder) async{
    var reminders = await Hive.openBox<Reminder>('Reminder');
    reminders.add(reminder);
    reminders.close();
  }
  void save(Predictions predictions) async{

    setState(() {
      loadData=true;
    });

    bool result=await _predictionsController.setFavorite(predictions.id);
    if(result){
      predictions.favorite=true;
    }
    setState(() {
      loadData=false;
    });
/*
    try {
      String t=await storage.read(key: 'session');
      var url = Uri.parse('https://ekbapp.space//${list[index].id}');
      var response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token '+t
      });
      print(response.body);
      if(response.statusCode==200){
        list.removeAt(index);
        list.insert(index, cardClass.fromJson(json.decode(response.body)));
        final snackBar = SnackBar(content: Text("Добавили предсказание в избранное"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        loadData=false;
        final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
        tz.initializeTimeZones();
        tz.setLocalLocation(tz.getLocation(currentTimeZone));

        var scheduledNotificationDateTime =
        tz.TZDateTime.from(list[index].dateTime,tz.local);

        if(DateTime.now().isBefore(list[index].dateTime)){
          await Reminder.createRemainder(context, scheduledNotificationDateTime, list[index].title, list[index].message, list[index].id);
        }

        _reminderHelper.insertRemainder(list[index]);

        setState(() {
        });
        //

      }


    } on SocketException {
      print('No Internet connection 😑');
      final snackBar = SnackBar(content: Text("SocketException"));
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

 */
  }

  @override
  void initState() {
   // Hive.registerAdapter(ReminderAdapter());
    loadResult();
    _reminderHelper.initializeDatabase().then((value){
      print('----------database initialize----------');
    });
    super.initState();

  }
}