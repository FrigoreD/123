import 'package:flutter/material.dart';


import 'router.dart';

class RouteGenerator {
  final version = 1;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    /*final args = settings.arguments;
    switch (settings.name) {
      case RouterI.forgotPasswordPage:
        {
          return _navigate(const ForgotPasswordPage());
        }
      case RouterI.authorizationPage:
        {
          return _navigate(const AuthorizationPage());
        }
      case RouterI.occupationSelectorPage:
        {
          return _navigate(const OccupationPage());
        }
      case RouterI.checkYourEmail:
        {
          return _navigate(CheckEmailSplashScreen(
            email: args as String,
          ));
        }
      case RouterI.homePage:
        {
          return _navigate(const HomePage());
        }
      case RouterI.loginHomePage:
        {
          return _navigate(const LoginHomePage());
        }
      case RouterI.splashScreen:
        {
          return _navigate(const SplashScreen());
        }
      case RouterI.serviceDetailsPage:
        {
          return _navigate(ServiceDetailsPage(
            arguments: args as ServiceDetailsArguments,
          ));
        }
      case RouterI.onBoardingMainPage:
        {
          return _navigate(const OnboardingMainPage());
        }
      case RouterI.createReviewPage:
        {
          final CreateReviewPageArguments arguments =
              args as CreateReviewPageArguments;
          return _navigate(CreateReviewPage(placeId: arguments.placeId));
        }
      case RouterI.claimBusinessPage:
        {
          final ClaimBusinessPageArguments arguments =
              args as ClaimBusinessPageArguments;
          return _navigate(ClaimBusinessPage(
            placeId: arguments.placeId,
            placeName: arguments.placeName,
            claimBusiness: arguments.claimBusiness,
          ));
        }
      case RouterI.favoritesPage:
        {
          return _navigate(const FavoritesPage());
        }
      case RouterI.myLocationsPage:
        {
          return _navigate(const MyLocationsPage());
        }
      case RouterI.createLocationPage:
        {
          return _navigate(const CreateLocationPage());
        }
      case RouterI.newPasswordPage:
        {
          return _navigate(
              NewPasswordPage(code: (args as NewPasswordPageArguments).code));
        }
      case RouterI.successPasswordChangedPage:
        {
          return _navigate(const SuccessPasswordSplashScreen());
        }
      default:
        return null;
      //return _navigate(NotAvailablePage(route: settings.name));
    }*/
  }

  static MaterialPageRoute<dynamic> _navigate(Widget widget) {
    return MaterialPageRoute<dynamic>(builder: (context) => widget);
  }
}
