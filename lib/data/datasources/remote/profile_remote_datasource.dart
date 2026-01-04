import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';

abstract class ProfileRemoteDatasource {
  Future<Map<String, dynamic>> getProfile();
  Future<Map<String, dynamic>> updateProfile({
    String? firstName,
    String? lastName,
  });
  Future<Map<String, dynamic>> uploadPhoto(List<int> photoBytes);
  Future<void> updateLanguage(String language);
}

class ProfileRemoteDatasourceImpl implements ProfileRemoteDatasource {
  final ApiClient apiClient;

  ProfileRemoteDatasourceImpl(this.apiClient);

  @override
  Future<Map<String, dynamic>> getProfile() async {
    final response = await apiClient.get(ApiConstants.profile);
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> updateProfile({
    String? firstName,
    String? lastName,
  }) async {
    final response = await apiClient.put(
      ApiConstants.updateProfile,
      data: {
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
      },
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> uploadPhoto(List<int> photoBytes) async {
    final formData = FormData.fromMap({
      'photo': MultipartFile.fromBytes(
        photoBytes,
        filename: 'photo.jpg',
      ),
    });
    final response = await apiClient.post(
      ApiConstants.uploadPhoto,
      data: formData,
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> updateLanguage(String language) async {
    await apiClient.put(
      ApiConstants.updateLanguage,
      data: {'language': language},
    );
  }
}

