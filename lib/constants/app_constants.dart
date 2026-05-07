// Menyimpan URL dan key yang dipakai bersama.
class AppConstants {
  //baseUrl untuk DummyJSON
  static const String baseUrl = 'https://dummyjson.com';
  static const String tokenKey = 'token_key';

  // X Gunakan localhost karena Chrome berjalan di komputer yang sama dengan Laravel
  // laravelBaseUrl untuk backend Laravel, tokenKey sebagai nama kunci penyimpanan token.
  static const String laravelBaseUrl = 'http://localhost:8000/api';
}
