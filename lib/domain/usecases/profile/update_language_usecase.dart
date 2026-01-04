import '../../repositories/profile_repository.dart';

class UpdateLanguageUsecase {
  final ProfileRepository repository;

  UpdateLanguageUsecase(this.repository);

  Future<void> execute(String language) async {
    return await repository.updateLanguage(language);
  }
}

