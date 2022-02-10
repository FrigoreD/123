import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

@Singleton(as:ContextProviderI)
class ContextProvider implements ContextProviderI {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  BuildContext getBuildContext() {
    return navigatorKey.currentContext;
  }

  @override
  GlobalKey<NavigatorState> getNavigationKey() {
    return navigatorKey;
  }
}

abstract class ContextProviderI {
  BuildContext getBuildContext();

  GlobalKey<NavigatorState> getNavigationKey();
}
