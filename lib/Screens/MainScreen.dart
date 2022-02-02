import 'package:astrology_app/Screens/MenuScreen.dart';
import 'package:astrology_app/Widgets/EventWiget.dart';
import 'package:astrology_app/Widgets/TitleToolbar.dart';
import 'package:astrology_app/controller/predictions_controller.dart';
import 'package:astrology_app/dto/cardClass.dart';
import 'package:astrology_app/helper/dialog_helper.dart';
import 'package:astrology_app/models/prediction.dart';
import 'package:flutter/material.dart';
import 'package:astrology_app/generated/l10n.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


DateTime select=DateTime.now();


List<Predictions> allList=[];
List<Predictions> recommendList=[];
List<Predictions> healthList=[];
PredictionsController _predictionsController=PredictionsController();

String monthName="month_name";
class MainScreen extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}
class _MainState extends State with  SingleTickerProviderStateMixin {

  TabController _tabController;
  Color tabColor = Colors.blue;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.animation.addListener(onTabChanged);
    loadData();
    super.initState();

  }

  double last = 0.0;

  void onTabChanged() {
    final aniValue = _tabController.animation.value;
    if (aniValue < 0.5) {
      setState(() {
        tabColor = Colors.blue;
      });
    } else {
      setState(() {
        tabColor = Colors.green;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    String recommendation = S
        .of(context)
        .main_page_tab_recommendation;
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Container(
            child: Center(
              child: Icon(Icons.dehaze, color: Colors.grey,),
            ),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MenuScreen(contextItem: context,)),
            );
          },
        ),
        title: TitleToolbar(
          date: select,
          onClick: () {
            {
              showGeneralDialog(
                context: context,
                barrierDismissible: true,
                transitionDuration: Duration(milliseconds: 500),
                barrierLabel: MaterialLocalizations
                    .of(context)
                    .dialogLabel,
                barrierColor: Colors.black.withOpacity(0.5),
                pageBuilder: (context, _, __) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(

                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        padding: EdgeInsets.only(top: 24),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                              child: Container(
                                child: SfDateRangePicker(
                                  selectionMode: DateRangePickerSelectionMode
                                      .single,
                                  onSelectionChanged: (date) {
                                    select = date.value;
                                    debugPrint(
                                        "select data " + date.value.toString());
                                    Navigator.of(context).pop();

                                    setState(() {

                                    });
                                    filter();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                transitionBuilder: (context, animation, secondaryAnimation,
                    child) {
                  return SlideTransition(
                    position: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOut,
                    ).drive(Tween<Offset>(
                      begin: Offset(0, -1.0),
                      end: Offset.zero,
                    )),
                    child: child,
                  );
                },
              );
            }
          },
        ),
        actions: [
          Container(
            child: Text(
              DateFormat("d MMM").format(select),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24
              ),
            ),
            margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // give the tab bar a height [can change hheight to preferred height]
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                  color: tabColor,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(
                    text: recommendation,
                  ),

                  Tab(
                    text: S
                        .of(context)
                        .main_page_tab_health,
                  ),
                ],
              ),
            ),
            // tab bar view here
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Container(
                    child: EventWidget(
                      eventList: recommendList, page: 1,
                    ),
                    margin: EdgeInsets.only(top: 24),
                  ),
                  Center(
                      child: EventWidget(
                        eventList: healthList,
                        page: 2,
                      )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  final storage = new FlutterSecureStorage();

  void filter(){
    recommendList.clear();
    healthList.clear();
    for(int i=0;i<allList.length;i++){
      Predictions card=allList[i];
      if(card.datePrediction.day==select.day&&card.datePrediction.month==select.month&&card.datePrediction.year==select.year){
        healthList.add(card);
      }
    }
    setState(() {

    });

  }

  void loadData() async {
    allList.clear();
    allList = await _predictionsController.getListPredictions();

    if(allList==null){
      allList=[];
     // DialogHelper.showErrorDialog(title: 'Error',description: 'Вернулся пустой лист');
    }else{
      filter();
    }
    setState(() {

    });
  }
}
