import '../../repositories/notification_repository.dart';

class UpdateFCMTokenUsecase {
  final NotificationRepository repository;

  UpdateFCMTokenUsecase(this.repository);

  Future<void> execute(String fcmToken) async {
    return await repository.updateFCMToken(fcmToken);
  }
}
