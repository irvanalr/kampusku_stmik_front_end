import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/cupertino.dart';
import 'package:kampusku/api/api_main.dart';
import 'package:kampusku/api/api_services.dart';
import 'package:kampusku/models/login_model.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginModel loginModel = LoginModel();
  ApiServices apiServices = ApiMain();
  var logger = Logger();

  bool get kataSandiVisible => loginModel.kataSandiVisible;
  String get email => loginModel.email;
  String get password => loginModel.password;

  void kataSandiVisibility() {
    loginModel.kataSandiVisible = !loginModel.kataSandiVisible;
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    loginModel.email = newEmail;
    updateButtonStatus();
    notifyListeners();
  }

  void updatePassword(String newPassword) {
    loginModel.password = newPassword;
    updateButtonStatus();
    notifyListeners();
  }

  void updateButtonStatus() {
    if (email.isNotEmpty && password.isNotEmpty) {
      loginModel.isButtonEnabled = true;
    } else {
      loginModel.isButtonEnabled = false;
    }
  }

  Future<bool> saveValue(String value, String issuer, String secretKey, String prefKey) async {
    try {
      final jwt = JWT(
        {
          'value': value,
        },
        issuer: issuer,
      );

      final encryptedValue = jwt.sign(SecretKey(secretKey));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(prefKey, encryptedValue);
      await prefs.remove('namaPengguna');
      await prefs.remove('token');
      await prefs.remove('name');
      await prefs.remove('apiKeyToken');
      return true;
    } catch (e) {
      // handle the exception
      return false;
    }
  }

  Future<String> getValue(String secretKey, String prefKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encryptedValue = prefs.getString(prefKey) ?? '';

    try {
      final jwt = JWT.verify(encryptedValue, SecretKey(secretKey));
      return jwt.payload['value'] as String;
    } on JWTExpiredException {
      //logger.e('jwt expired');
      return '';
    } on JWTException catch (_) {
      //logger.e('getValue = ${ex.message}');
      return '';
    }
  }

  Future<void> clearValue(String prefKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(prefKey);
    await prefs.remove('namaPengguna');
    await prefs.remove('token');
    await prefs.remove('name');
    await prefs.remove('apiKeyToken');
    // await prefs.setString(prefKey, '');
  }

  Future<Map<String, dynamic>> login() async {
    try {
      final response = await apiServices.Login(
          loginModel.email,
          loginModel.password
      );
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      logger.i(responseBody);

      return {
        'statusCode': response.statusCode,
        'responseBody': responseBody,
      };
    } catch (e) {
      throw Exception('Gagal Login, Silahkan coba lagi nanti !!!');
    }
  }
}