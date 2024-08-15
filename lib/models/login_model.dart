class LoginModel {
  bool isLoading = true;
  bool kataSandiVisible = false;
  bool isButtonEnabled = false;
  String email = '';
  String password = '';

  /// data api login
  String timeStamp = '';
  int status = 0;
  String message = 'Maaf server sedang dalam kendala, silahkan tutup applikasi dan coba lagi nanti!!';
  String token = '';
}