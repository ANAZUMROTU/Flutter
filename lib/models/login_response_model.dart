//3. Response diterima → login_response_model.dart parsing JSON
class LoginResponseModel {
  final String accessToken;

  LoginResponseModel({required this.accessToken});

// Fungsi fromJson() untuk mengubah JSON response menjadi object Dart, 
//Format data yang diterima dari API.
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['accessToken'] ?? '',
    );
  }
}