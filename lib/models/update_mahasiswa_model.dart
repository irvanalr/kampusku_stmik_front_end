class UpdateMahasiswaModel {
  /// data api mendapatkan mahasiswa
  String timeStamp = '';
  int status = 0;
  String message = 'Maaf server sedang dalam kendala, silahkan tutup applikasi dan coba lagi nanti!!';
  String namaKirim = '';
  List<Data> data = [];

  /// data api mengupdate mahasiswa
  String namaUpdate = '';
  String nomerHandphoneUpdate = '';
  String tanggalLahirUpdate = '';
  String jenisKelaminUpdate = '';
  String alamatUpdate = '';
  String npmUpdate = '';
}

class Data {
  String nama;
  String nomer_handphone;
  String tanggal_lahir;
  String jenis_kelamin;
  String alamat;
  String npm;

  Data({
    required this.nama,
    required this.nomer_handphone,
    required this.tanggal_lahir,
    required this.jenis_kelamin,
    required this.alamat,
    required this.npm
  });
}