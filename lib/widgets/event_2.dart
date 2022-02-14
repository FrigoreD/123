import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class _Page {
  const _Page(
      this.id,
      this.title,
      this.color,
      )   : assert(id != null),
        assert(title != null),
        assert(color != null);

  final int id;
  final String title;
  final Color color;
}

final List<_Page> _allPages = <_Page>[
  const _Page(1, 'Item 1', Colors.orange),
  const _Page(2, 'Item 2', Colors.red),
  const _Page(3, 'Item 3', Colors.blue),
  const _Page(4, 'Item 4', Colors.green),
];

class Event2 extends StatelessWidget {
  const Event2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _allPages.length,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: _buildSliverAppBar(context),
              ),
            ];
          },
          body: TabBarView(
            children: _allPages
                .map(
                  (page) => SafeArea(
                top: false,
                bottom: false,
                child: Builder(
                  builder: (context) {
                    return _buildTabBarView(context, page);
                  },
                ),
              ),
            )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBarView(BuildContext context, _Page page) {
    final List<Widget> slivers = <Widget>[];

    slivers.add(SliverObstructionInjector(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)));
    slivers.addAll(_buildSideHeaderGrids(0, 5, page.color));

    return CustomScrollView(
      key: PageStorageKey<_Page>(page),
      slivers: slivers,
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 150.0,
      title: const Text('Main AppBar'),
      bottom: TabBar(
        tabs: _allPages
            .map(
              (p) => Tab(
            child: Text(p.title),
          ),
        )
            .toList(),
      ),
    );
  }

  List<Widget> _buildSideHeaderGrids(int firstIndex, int count, Color color) {
    return List.generate(count, (sliverIndex) {
      sliverIndex += firstIndex;
      return SliverStickyHeader(
        overlapsContent: true,
        header: _buildSideHeader(sliverIndex, color),
        sliver: SliverPadding(
          // ignore: prefer_const_constructors
          padding: EdgeInsets.only(left: 60.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
            delegate: SliverChildBuilderDelegate(
                  (context, i) => GridTile(
                footer: Container(
                  color: Colors.white.withOpacity(0.5),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Grid tile #$i',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                child: Card(
                  child: Container(
                    color: color,
                  ),
                ),
              ),
              childCount: 12,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSideHeader(int index, Color color) {
    return Container(
      height: 60.0,
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      alignment: Alignment.centerLeft,
      child: CircleAvatar(
        backgroundColor: color,
        foregroundColor: Colors.white,
        child: Text('$index'),
      ),
    );
  }
}

class SliverObstructionInjector extends SliverOverlapInjector {
  /// Creates a sliver that is as tall as the value of the given [handle]'s
  /// layout extent.
  ///
  /// The [handle] must not be null.
  const SliverObstructionInjector({
    Key key,
    @required SliverOverlapAbsorberHandle handle,
    Widget child,
  })  : assert(handle != null),
        super(key: key, handle: handle, sliver : child);

  @override
  RenderSliverObstructionInjector createRenderObject(BuildContext context) {
    return RenderSliverObstructionInjector(
      handle: handle,
    );
  }
}

/// A sliver that has a sliver geometry based on the values stored in a
/// [SliverOverlapAbsorberHandle].
///
/// The [RenderSliverOverlapAbsorber] must be an earlier descendant of a common
/// ancestor [RenderViewport] (probably a [RenderNestedScrollViewViewport]), so
/// that it will always be laid out before the [RenderSliverObstructionInjector]
/// during a particular frame.
class RenderSliverObstructionInjector extends RenderSliverOverlapInjector {
  /// Creates a sliver that is as tall as the value of the given [handle]'s extent.
  ///
  /// The [handle] must not be null.
  RenderSliverObstructionInjector({
    @required SliverOverlapAbsorberHandle handle,
  })  : assert(handle != null),
        _handle = handle,
        super(handle: handle);

  double _currentLayoutExtent;
  double _currentMaxExtent;

  /// The object that specifies how wide to make the gap injected by this render
  /// object.
  ///
  /// This should be a handle owned by a [RenderSliverOverlapAbsorber] and a
  /// [RenderNestedScrollViewViewport].
  @override
  SliverOverlapAbsorberHandle get handle => _handle;
  SliverOverlapAbsorberHandle _handle;
  @override
  set handle(SliverOverlapAbsorberHandle value) {
    assert(value != null);
    if (handle == value) return;
    if (attached) {
      handle.removeListener(markNeedsLayout);
    }
    _handle = value;
    if (attached) {
      handle.addListener(markNeedsLayout);
      if (handle.layoutExtent != _currentLayoutExtent || handle.scrollExtent != _currentMaxExtent) markNeedsLayout();
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    handle.addListener(markNeedsLayout);
    if (handle.layoutExtent != _currentLayoutExtent || handle.scrollExtent != _currentMaxExtent) markNeedsLayout();
  }

  @override
  void performLayout() {
    _currentLayoutExtent = handle.layoutExtent;
    _currentMaxExtent = handle.layoutExtent;
    geometry = SliverGeometry(
      paintExtent: _currentLayoutExtent,
      maxPaintExtent: _currentMaxExtent,
    );
  }
}