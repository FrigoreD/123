import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

import '../service/context_provider/context_provider.dart';
import 'route_argument.dart';

@Singleton(as: RouterI)
class Router implements RouterI {
  Router({this.contextProvider});

  final ContextProviderI contextProvider;

  @override
  Future<dynamic> navigateTo(String routeName, {Object arg}) {
    return contextProvider
        .getNavigationKey()
        .currentState
        .pushNamed(routeName, arguments: arg);
  }

  @override
  Future<dynamic> navigateReplacementTo(String routeName, {RouteArgument arg}) {
    return contextProvider
        .getNavigationKey()
        .currentState
        .pushReplacementNamed(routeName, arguments: arg);
  }

  @override
  Future<dynamic> pushNamedAndRemoveUntil(String routeName,
      {RouteArgument arg}) {
    return contextProvider
        .getNavigationKey()
        .currentState
        .pushNamedAndRemoveUntil(routeName, ModalRoute.withName('home_page'),
            arguments: arg);
  }

  @override
  void pop<T extends Object>([T result]) {
    return contextProvider.getNavigationKey().currentState.pop(result);
  }
}

abstract class RouterI {
  static const String authorizationPage = 'AuthorizationPage';
  static const String forgotPasswordPage = 'ForgotPasswordPage';
  static const String occupationSelectorPage = 'WhatDoYouDoPage';
  static const String homePage = 'HomePage';
  static const String checkYourEmail = 'CheckYourEmail';
  static const String splashScreen = 'SplashScreen';
  static const String loginHomePage = 'LoginHomePage';
  static const String serviceDetailsPage = 'ServiceDetailsPage';
  static const String onBoardingMainPage = 'OnBoardingFirstPage';
  static const String claimBusinessPage = 'ClaimBusinessPage';
  static const String createReviewPage = 'CreateReviewPage';
  static const String favoritesPage = 'FavoritesPage';
  static const String myLocationsPage = 'MyLocationsPage';
  static const String createLocationPage = 'CreateLocationPage';
  static const String newPasswordPage = 'ChangePasswordPage';
  static const String successPasswordChangedPage = 'SuccessPasswordChangedPage';

  Future<dynamic> navigateTo(String routeName, {Object arg});

  Future<dynamic> navigateReplacementTo(String routeName, {RouteArgument arg});

  Future<dynamic> pushNamedAndRemoveUntil(String routeName,
      {RouteArgument arg});

  void pop<T extends Object>([T result]);
}

class RouteModel {
  RouteModel({this.routeName, this.arguments});

  final String routeName;
  final Object arguments;
}
