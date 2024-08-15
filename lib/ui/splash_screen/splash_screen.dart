import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kampusku/utils/routes/route_paths.dart';
import 'package:kampusku/utils/theme/light_and_dark.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  /// Animation Fade in
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigatetohome();
    });
  }

  /// Navigasi ke page Login
  _navigatetohome() async {
    await Future.delayed(const Duration(milliseconds: 5000), () {});
    if (mounted) {
      await Navigator.pushReplacementNamed(context, RoutePaths.login);
    }
  }

  /// Menghilangkan object yang di miliki SplashScreen
  /// untuk mencegah memory leaks saat widget ini tidak di butuhkan
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Uncomment untuk melihat logic pixel di terminal tab
    // print('width = ${MediaQuery.of(context).size.width}');
    // print('height = ${MediaQuery.of(context).size.height}');
    /// Status bar dan navigation bar warna
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: LightAndDarkMode.primaryColor(context),
      systemNavigationBarColor: LightAndDarkMode.bottomNavBar(context),
    ));
    return Scaffold(
      backgroundColor: LightAndDarkMode.backgroundSplashScreen(context),
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Image.asset(
            'assets/stmik.png',
            scale: 1,
          ),
        ),
      ),
    );
  }
}
