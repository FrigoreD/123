import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const headerHeight = 50.0;
const hourHeight = 100.0;

class DayView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverPersistentHeader(
          delegate: WeekViewHeaderDelegate(),
          pinned: true,
        ),
        SliverToBoxAdapter(
          child: _buildGrid(),
        )
      ],
    );
  }

  Widget _buildGrid() {
    return SizedBox(
      height: hourHeight * 24,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(7, (d) => _buildColumn(d)),
      ),
    );
  }

  Widget _buildColumn(int d) {
    return Expanded(
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0.0,
            top: d * 25.0,
            right: 0.0,
            height: 50.0 * (d + 1),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 2.0),
              color: Colors.orange[100 + d * 100],
            ),
          )
        ],
      ),
    );
  }
}

class WeekViewHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.red.withOpacity(0.5),
      child: Center(
        child: Text('HEADER'),
      ),
    );
  }

  @override
  double get maxExtent => headerHeight;

  @override
  double get minExtent => headerHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}