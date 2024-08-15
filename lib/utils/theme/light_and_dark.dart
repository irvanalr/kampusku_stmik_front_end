import 'package:flutter/material.dart';

class LightAndDarkMode {
  static Color primaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? const Color(0xFF87832D) : const Color(0xFF5D5C58);
  }
  static Color backgroundSplashScreen(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? const Color(0xFF87832D) : Colors.black;
  }
  static Color bottomNavBar(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? const Color(0xFF87832D) : Theme.of(context).scaffoldBackgroundColor;
  }
  static Color informasiColor1(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? const Color(0xFF87832D) : const Color(0xFF5D5C58);
  }
  static Color textColor1(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white;
  }
  static Color textColor2(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black;
  }
}