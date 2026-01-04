import '../../repositories/profile_repository.dart';

class GetProfileUsecase {
  final ProfileRepository repository;

  GetProfileUsecase(this.repository);

  Future<Map<String, dynamic>> execute() async {
    return await repository.getProfile();
  }
}

