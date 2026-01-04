import '../../repositories/profile_repository.dart';

class UpdateProfileUsecase {
  final ProfileRepository repository;

  UpdateProfileUsecase(this.repository);

  Future<Map<String, dynamic>> execute({
    String? firstName,
    String? lastName,
  }) async {
    return await repository.updateProfile(
      firstName: firstName,
      lastName: lastName,
    );
  }
}

