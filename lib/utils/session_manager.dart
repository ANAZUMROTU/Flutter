// 4. session_manager.dart simpan accessToken ke SharedPreferences
  //↓
//Navigasi ke halaman Home
//File ini berfungsi Menyimpan accessToken ke memori lokal HP menggunakan SharedPreferences. 
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class SessionManager {
  Future<void> saveSession(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, accessToken);
  }

  Future<String> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.tokenKey) ?? '';
  }

  Future<void> removeAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
  }
}