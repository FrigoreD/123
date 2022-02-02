import 'package:astrology_app/Module/DateTimePicker.dart';
import 'package:flutter/material.dart';


class EventCalendar extends StatefulWidget{
  @override
  _EventCalendar createState()=>_EventCalendar();

}
class _EventCalendar extends State<EventCalendar>{
  @override
  Widget build(BuildContext context) {
    return  Container(
      child: CustomMultiChildLayout(
        delegate: YourLayoutDelegate(),
        children: [
          LayoutId(
            id: 1, // The id can be anything, i.e. any Object, also an enum value.
            child: Text('Widget one'), // This is the widget you actually want to show.
          ),
          LayoutId(
            id: 2, // You will need to refer to that id when laying out your children.
            child: Text('Widget two'),
          ),
        ],
      )
    );
  }

}
class YourLayoutDelegate extends MultiChildLayoutDelegate {
  // You can pass any parameters to this class because you will instantiate your delegate
  // in the build function where you place your CustomMultiChildLayout.
  // I will use an Offset for this simple example.

  YourLayoutDelegate({this.position});

  final Offset position;

  @override
  void performLayout(Size size) {
    // TODO: implement performLayout
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    // TODO: implement shouldRelayout
    throw UnimplementedError();
  }
}