class RouteArgument {
  RouteArgument({this.id, this.heroTag, this.param});

  int id;
  String heroTag;
  dynamic param;

  @override
  String toString() {
    return '{id: $id, heroTag:${heroTag.toString()}}';
  }
}
