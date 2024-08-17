import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kampusku/api/api_main.dart';
import 'package:kampusku/api/api_services.dart';
import 'package:kampusku/models/informasi_data_mahasiswa_model.dart';
import 'package:kampusku/viewmodels/login_view_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

class InformasiDataMahasiswaViewModel extends ChangeNotifier {
  final InformasiDataMahasiswaModel informasiDataMahasiswaModel = InformasiDataMahasiswaModel();
  final LoginViewModel loginViewModel = LoginViewModel();
  ApiServices apiServices = ApiMain();
  final logger = Logger();

  final String lgnTkn1 = dotenv.get('LOGINTOKENSECRETKEY');
  final String lgnTkn2 = dotenv.get('LOGINTOKENSHAREDPREFERENCES');

  Future<Map<String, dynamic>> informasiDataMahasiswa() async {
    try {
      final token = await loginViewModel.getValue(lgnTkn1, lgnTkn2);
      final response = await apiServices.InformasiMahasiswa(
        token,
        informasiDataMahasiswaModel.namaKirim
      );
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