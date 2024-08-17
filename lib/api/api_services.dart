import 'package:http/http.dart' as http;

abstract class ApiServices {
  Future<http.Response> Login(String email, String password);
  Future<http.Response> ListMahasiswa(String token);
  Future<http.Response> InputMahasiswa(String token, String nama, String nomer_handphone, String tanggal_lahir, String jenis_kelamin, String alamat, String npm);
  Future<http.Response> UpdateMahasiswa(String token, String nameParam, String nama, String nomer_telephone, String tanggal_lahir, String jenis_kelamin, String alamat, String npm);
  Future<http.Response> InformasiMahasiswa(String token, String nama);
  Future<http.Response> DeleteMahasiswa(String token, String name);
}