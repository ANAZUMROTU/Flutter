class LoginRequestModel {
  final String username;
  final String password;
  final int expiresInMins;

  LoginRequestModel({
    required this.username,
    required this.password,
    this.expiresInMins = 30,
  });

// Fungsi toJson() untuk mengubah object Dart menjadi format JSON. 
//Format data yang dikirim ke API: username, password, expiresInMins
  Map<String, dynamic> toJson() => { 
        'username': username,
        'password': password,
        'expiresInMins': expiresInMins,
      };
}