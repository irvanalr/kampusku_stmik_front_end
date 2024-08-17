import 'dart:convert';

import 'package:kampusku/api/api_services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiMain implements ApiServices {
  final String baseUrl = dotenv.get('BASE_URL');

  @override
  Future<http.Response> Login(String email, String password) async {
    return await http.post(
        Uri.parse('$baseUrl/sessions/login'),
        headers: <String, String>{
          'mobile-app': 'mobile-application',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
    );
  }

  @override
  Future<http.Response> ListMahasiswa(String token) async {
    return await http.get(
        Uri.parse('$baseUrl/sessions/get-list-mahasiswa'),
        headers: <String, String>{
          'mobile-app': 'mobile-application',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': token
        }
    );
  }

  @override
  Future<http.Response> InputMahasiswa(String token, String nama, String nomer_handphone, String tanggal_lahir, String jenis_kelamin, String alamat, String npm) async{
    return await http.post(
      Uri.parse('$baseUrl/sessions/input-mahasiswa'),
      headers: <String, String>{
        'mobile-app': 'mobile-application',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token
      },
      body: jsonEncode(<String, String>{
        "nama": nama,
        "nomer_handphone": nomer_handphone,
        "tanggal_lahir": tanggal_lahir,
        "jenis_kelamin" : jenis_kelamin,
        "alamat" : alamat,
        "npm" : npm
      }),
    );
  }

  @override
  Future<http.Response> UpdateMahasiswa(String token, String nameParam, String nama, String nomer_telephone, String tanggal_lahir, String jenis_kelamin, String alamat, String npm) async {
    return await http.put(
      Uri.parse('$baseUrl/sessions/mahasiswa/$nameParam'),
      headers: <String, String>{
        'mobile-app': 'mobile-application',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': token
      },
      body: jsonEncode(<String, String>{
        "nama": nama,
        "nomor_telephone": nomer_telephone,
        "tanggal_lahir": tanggal_lahir,
        "jenis_kelamin" : jenis_kelamin,
        "alamat" : alamat,
        "npm" : npm
      }),
    );
  }

  @override
  Future<http.Response> InformasiMahasiswa(String token, String nama) async {
    return await http.get(
        Uri.parse('$baseUrl/sessions/get-mahasiswa/${nama}'),
        headers: <String, String>{
          'mobile-app': 'mobile-application',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': token
        }
    );
  }

  @override
  Future<http.Response> DeleteMahasiswa(String token, String name) async {
    return await http.delete(
        Uri.parse('$baseUrl/sessions/deleted-mahasiswa/$name'),
        headers: <String, String>{
          'mobile-app': 'mobile-application',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': token
        }
    );
  }

}