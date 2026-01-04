abstract class ProfileRepository {
  Future<Map<String, dynamic>> getProfile();
  Future<Map<String, dynamic>> updateProfile({
    String? firstName,
    String? lastName,
  });
  Future<Map<String, dynamic>> uploadPhoto(List<int> photoBytes);
  Future<void> updateLanguage(String language);
}
