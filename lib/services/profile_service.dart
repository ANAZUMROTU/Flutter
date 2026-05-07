// File di Flutter yang bertugas berkomunikasi dengan Laravel. 
//Setiap fungsi CRUD di Flutter memanggil endpoint Laravel yang sesuai menggunakan Dio.
import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../models/profile_model.dart';

class ProfileService {
  final Dio _dio = Dio();
  final String _base = AppConstants.laravelBaseUrl;

  // GET semua profil
  Future<List<ProfileModel>> getProfiles() async {
    final res = await _dio.get('$_base/profiles');
    final List data = res.data['data'] ?? res.data;
    return data.map((e) => ProfileModel.fromJson(e)).toList();
  }

  // CREATE profil baru
  Future<ProfileModel> createProfile(ProfileModel profile) async {
    final res = await _dio.post(
      '$_base/profiles',
      data: profile.toJson(),
    );
    return ProfileModel.fromJson(res.data['data'] ?? res.data);
  }

  // UPDATE profil
  Future<ProfileModel> updateProfile(int id, ProfileModel profile) async {
    final res = await _dio.put(
      '$_base/profiles/$id',
      data: profile.toJson(),
    );
    return ProfileModel.fromJson(res.data['data'] ?? res.data);
  }

  // DELETE profil
  Future<void> deleteProfile(int id) async {
    await _dio.delete('$_base/profiles/$id');
  }
}