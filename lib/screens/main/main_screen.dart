import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../Screens/MenuScreen.dart';
import '../../Widgets/event_wiget.dart';
import '../../Widgets/TitleToolbar.dart';
import '../../generated/l10n.dart';
import 'main_bloc.dart';

String monthName = 'month_name';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State with SingleTickerProviderStateMixin {
  MainBloc _bloc;

  TabController _tabController;
  Color tabColor = Colors.blue;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.animation.addListener(onTabChanged);
    _bloc = MainBloc();

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
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      bloc: _bloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              icon: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Center(
                  child: Icon(
                    Icons.dehaze,
                    color: Colors.grey,
                  ),
                ),
              ),
              onPressed: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MenuScreen(
                            contextItem: context,
                          )),
                );
              },
            ),
            title: TitleToolbar(
              date: state.selectedDateTime,
              onClick: () {
                {
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    transitionDuration: const Duration(milliseconds: 500),
                    barrierLabel: MaterialLocalizations.of(context).dialogLabel,
                    barrierColor: Colors.black.withOpacity(0.5),
                    pageBuilder: (context, _, __) {
                      return Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(top: 24),
                            color: Colors.white,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  child: SfDateRangePicker(
                                    onSelectionChanged: (date) {
                                      _bloc.add(SelectDateMainEvent(
                                          selectedDateTime:
                                              date.value as DateTime));

                                      debugPrint('select data ${date.value}');
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    transitionBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOut,
                        ).drive(Tween<Offset>(
                          begin: const Offset(0, -1.0),
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
                margin:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Text(
                  DateFormat('d MMM').format(state.selectedDateTime),
                  style: const TextStyle(color: Colors.black, fontSize: 24),
                ),
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
                        text: S.of(context).main_page_tab_recommendation,
                      ),
                      Tab(
                        text: S.of(context).main_page_tab_health,
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
                        margin: const EdgeInsets.only(top: 24),
                        child: EventWidget(
                          eventList: state.recommendList,
                          page: 1,
                        ),
                      ),
                      Center(
                          child: EventWidget(
                        eventList: state.healthList,
                        page: 2,
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
    _tabController.dispose();
  }
//final storage = new FlutterSecureStorage();
}
