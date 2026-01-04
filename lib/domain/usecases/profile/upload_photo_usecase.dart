import '../../repositories/profile_repository.dart';

class UploadPhotoUsecase {
  final ProfileRepository repository;

  UploadPhotoUsecase(this.repository);

  Future<Map<String, dynamic>> execute(List<int> photoBytes) async {
    return await repository.uploadPhoto(photoBytes);
  }
}

