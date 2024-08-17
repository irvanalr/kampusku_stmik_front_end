class DataMahasiswaModel {
  /// data api list-mahasiswa
  String timeStamp = '';
  int status = 0;
  String message = 'Maaf server sedang dalam kendala, silahkan tutup applikasi dan coba lagi nanti!!';
  List<Data> data = [];
}

class Data {
  String name;

  Data({
    required this.name
  });
}