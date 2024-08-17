import 'package:flutter/material.dart';
import 'package:kampusku/ui/dashboard/dashboard.dart';
import 'package:kampusku/ui/informasi_data_mahasiswa/informasi_data_mahasiswa.dart';
import 'package:kampusku/ui/login/login.dart';
import 'package:kampusku/ui/splash_screen/splash_screen.dart';
import 'package:kampusku/ui/update_mahasiswa/update_mahasiswa.dart';
import 'package:kampusku/utils/routes/route_paths.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case RoutePaths.root:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RoutePaths.login:
        return MaterialPageRoute(builder: (_) => const Login());
      case RoutePaths.dashboard:
        return MaterialPageRoute(builder: (_) => const Dashboard());
      case RoutePaths.updateMahasiswa:
        if (args is Map<String, dynamic> && args.containsKey('nama')) {
          final nama = args['nama'] as String;
          return MaterialPageRoute(
            builder: (_) => UpdateMahasiswa(nama: nama),
          );
        }
        return _errorRoute();
      case RoutePaths.informasiDataMahasiswa:
        if (args is Map<String, dynamic> && args.containsKey('nama')) {
          final nama = args['nama'] as String;
          return MaterialPageRoute(
            builder: (_) => InformasiDataMahasiswa(nama: nama),
          );
        }
        return _errorRoute();
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