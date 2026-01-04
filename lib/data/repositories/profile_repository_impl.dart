import '../../domain/repositories/profile_repository.dart';
import '../datasources/remote/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource remoteDatasource;

  ProfileRepositoryImpl(this.remoteDatasource);

  @override
  Future<Map<String, dynamic>> getProfile() async {
    try {
      return await remoteDatasource.getProfile();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> updateProfile({
    String? firstName,
    String? lastName,
  }) async {
    try {
      return await remoteDatasource.updateProfile(
        firstName: firstName,
        lastName: lastName,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> uploadPhoto(List<int> photoBytes) async {
    try {
      return await remoteDatasource.uploadPhoto(photoBytes);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateLanguage(String language) async {
    try {
      await remoteDatasource.updateLanguage(language);
    } catch (e) {
      rethrow;
    }
  }
}

