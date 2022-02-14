
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


import '../class/reminder_helper.dart';
import '../class/reminder_model.dart';
import '../controller/predictions_controller.dart';
import '../generated/l10n.dart';
import '../models/prediction.dart';
import '../widgets/card_main.dart';
import 'search_screen.dart';

bool loadData=true;


List<Predictions> list=[];
PredictionsController _predictionsController=PredictionsController();
class SettingResultScreen extends StatefulWidget {
  const SettingResultScreen({Key key,@required this.request}) : super(key: key);
  final String request;

  
  @override
  // ignore: no_logic_in_create_state
  _SettingResultState createState() => _SettingResultState(request);
}
class _SettingResultState extends State<SettingResultScreen>{
  _SettingResultState(this.request);
  final String request;
  final ReminderHelper _reminderHelper=ReminderHelper();
  
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child:  Icon(Icons.arrow_back_rounded,color: Colors.grey,),
            ),
          ),
          onPressed: (){
            Navigator.push<void>(
              context,
              MaterialPageRoute(builder: (context) => const SearchScreen()),
            );
          },
        ),
        title: Text(S.of(context).search_result_title,textAlign: TextAlign.center,style: const TextStyle(color: Colors.black),),
      ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.grey[100]
            ),
            child: Column(
              children: [
                Visibility(
                  visible: loadData,
                  child: Column(
                    children: const [
                      LinearProgressIndicator(),
                      SizedBox(height: 12,)
                    ],
                  ),
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
                      controller: txt,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (text){

                      },
                      decoration: InputDecoration(
                        labelText: S.of(context).search_hint,
                        errorText: errorText,
                          suffixIcon: IconButton(
                            onPressed: () {

                            } ,
                            icon: const Icon(Icons.search),
                          )
                      ),

                    ),
                  ),
                ),
              ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    Text(S.of(context).search_result_count.replaceAll('XXX', list.length.toString())),
                    const Spacer(),
                    const Text('filter')
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

  Future<void> loadResult() async{
    list.clear();
    list =await _predictionsController.search(widget.request);
    list ??= [];
    setState(() {
      loadData=false;
    });
  }
  Future<void> saveRemainder(Reminder reminder) async{
    final reminders = await Hive.openBox<Reminder>('Reminder');
    await reminders.add(reminder);
    await reminders.close();
  }
  Future<void> save(Predictions predictions) async{

    setState(() {
      loadData=true;
    });

    final bool result=await _predictionsController.setFavorite(predictions.id);
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