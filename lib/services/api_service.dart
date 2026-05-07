// 2. Dio mengirim ke POST ke dummyjson.com/auth/login

// File ini berfungsi sebagai Gateway (gerbang) yang menghubungkan 
//aplikasi Flutter dengan layanan luar (DummyJSON) menggunakan protokol HTTP.
import 'package:dio/dio.dart'; 
import '../constants/app_constants.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

class ApiService {
  final Dio _dio = Dio(); //// Menggunakan package Dio untuk kirim POST ke https://dummyjson.com/auth/login

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      // Pakai proxy corsproxy.io untuk bypass CORS di Flutter Web sebelumnya menggunakan (Cross-Origin) dan Akan diblokir oleh browser karena masalah keamanan
      const proxyUrl = 'https://corsproxy.io/?url=';
      const targetUrl = 'https://dummyjson.com/auth/login';

      final response = await _dio.post(
        '$proxyUrl${Uri.encodeComponent(targetUrl)}',
        data: request.toJson(), // ini mengubah mengubah objek LoginRequestModel menjadi format JSON
        options: Options( //memberi tahu server bahwa "Saya mengirimkan data dalam format JSON", sehingga server bisa membacanya dengan benar.
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      // return login... bertugas mengambil data mentah dari server lalu mengubahnya kembali menjadi objek Dart agar mudah dibaca oleh Flutter.
      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] ?? 'Login gagal';
      throw Exception(msg);
    }
  }
}