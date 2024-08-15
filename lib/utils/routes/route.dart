import 'package:flutter/material.dart';
import 'package:kampusku/ui/dashboard/dashboard.dart';
import 'package:kampusku/ui/login/login.dart';
import 'package:kampusku/ui/splash_screen/splash_screen.dart';
import 'package:kampusku/utils/routes/route_paths.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {

    switch (settings.name) {
      case RoutePaths.root:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RoutePaths.login:
        return MaterialPageRoute(builder: (_) => const Login());
      case RoutePaths.dashboard:
        return MaterialPageRoute(builder: (_) => const Dashboard());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}