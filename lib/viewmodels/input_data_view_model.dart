import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kampusku/api/api_main.dart';
import 'package:kampusku/api/api_services.dart';
import 'package:kampusku/models/input_data_model.dart';
import 'package:kampusku/viewmodels/login_view_model.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class InputDataViewModel extends ChangeNotifier {
  final InputDataModel inputDataModel = InputDataModel();
  final LoginViewModel loginViewModel = LoginViewModel();
  ApiServices apiServices = ApiMain();
  final logger = Logger();

  final String lgnTkn1 = dotenv.get('LOGINTOKENSECRETKEY');
  final String lgnTkn2 = dotenv.get('LOGINTOKENSHAREDPREFERENCES');

  String get nama => inputDataModel.nama;
  String get nomer_handphone => inputDataModel.nomer_handphone;
  String get tanggal_lahir => inputDataModel.tanggal_lahir;
  String get jenis_kelamin => inputDataModel.jenis_kelamin;
  String get alamat => inputDataModel.alamat;
  String get npm => inputDataModel.npm;

  void updateNama (String newNama) {
    inputDataModel.nama = newNama;
    updateButtonStatus();
  }

  void updateNomerHandPhone (String newNomerHandPhone) {
    inputDataModel.nomer_handphone = newNomerHandPhone;
    updateButtonStatus();
  }

  void updateTanggalLahir (String newTanggalLahir) {
    inputDataModel.tanggal_lahir = newTanggalLahir;
    updateButtonStatus();
  }

  void updateJenisKelamin (String newJenisKelamin) {
    inputDataModel.jenis_kelamin = newJenisKelamin;
    updateButtonStatus();
  }

  void updateAlamat (String newAlamat) {
    inputDataModel.alamat = newAlamat;
    updateButtonStatus();
  }

  void updateNpm (String newNpm) {
    inputDataModel.npm = newNpm;
    updateButtonStatus();
  }

  void updateButtonStatus() {
    if (
        nama.isNotEmpty &&
        nomer_handphone.isNotEmpty &&
        tanggal_lahir.isNotEmpty &&
        jenis_kelamin.isNotEmpty &&
        alamat.isNotEmpty &&
        npm.isNotEmpty
    ) {
      inputDataModel.isButtonEnabled = true;
      // logger.i('Harusnya true ${inputDataModel.isButtonEnabled}');
    } else {
      inputDataModel.isButtonEnabled = false;
      // logger.i('Harusnya false ${inputDataModel.isButtonEnabled}');
    }
  }

  Future<Map<String, dynamic>> inputDataMahasiswa() async {
    try {
      final token = await loginViewModel.getValue(lgnTkn1, lgnTkn2);
      final response = await apiServices.InputMahasiswa(
        token,
        inputDataModel.nama,
        inputDataModel.nomer_handphone,
        inputDataModel.tanggal_lahir,
        inputDataModel.jenis_kelamin,
        inputDataModel.alamat,
        inputDataModel.npm
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