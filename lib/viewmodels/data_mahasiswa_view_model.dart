import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kampusku/api/api_main.dart';
import 'package:kampusku/api/api_services.dart';
import 'package:kampusku/models/data_mahasiswa_model.dart';
import 'package:kampusku/viewmodels/login_view_model.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DataMahasiswaViewModel extends ChangeNotifier {
  final DataMahasiswaModel dataMahasiswaModel = DataMahasiswaModel();
  final LoginViewModel loginViewModel = LoginViewModel();
  ApiServices apiServices = ApiMain();
  var logger = Logger();

  Future<Map<String, dynamic>> listDataMahasiswa() async {
    final String lgnTkn1 = dotenv.get('LOGINTOKENSECRETKEY');
    final String lgnTkn2 = dotenv.get('LOGINTOKENSHAREDPREFERENCES');

    try {
      final token = await loginViewModel.getValue(lgnTkn1, lgnTkn2);

      final response = await apiServices.ListMahasiswa(token);
      Map<String, dynamic> responseBody = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'responseBody': responseBody,
      };
    } catch (e) {
      throw Exception('Gagal Login, Silahkan coba lagi nanti !!!');
    }
  }
}