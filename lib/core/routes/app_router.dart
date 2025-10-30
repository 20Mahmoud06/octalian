import 'package:flutter/material.dart';
import 'package:octalian_task1/presentation/auth/signin/signin_screen.dart';
import 'package:octalian_task1/presentation/auth/signup/signup_screen.dart';
import 'package:octalian_task1/presentation/onboarding/view/onboarding_screens.dart';
import 'package:octalian_task1/presentation/splash/splash_screen.dart';
import '../widgets/page_transition.dart';
import 'route_names.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case RouteNames.onboarding:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
          const OnboardingScreens(),
          transitionsBuilder: PageTransition.slideFromRight,
        );

      case RouteNames.signin:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              SigninScreen(),
          transitionsBuilder: PageTransition.slideFromRight,
        );

      case RouteNames.signup:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              SignupScreen(),
          transitionsBuilder: PageTransition.slideFromRight,
        );

      default:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) =>
              SigninScreen(),
          transitionsBuilder: PageTransition.slideFromRight,
        );
    }
  }
}
