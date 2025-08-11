import '../repositories/notification_repository.dart';

class GetFcmToken {
  final NotificationRepository repo;
  GetFcmToken(this.repo);

  Future<String?> call() => repo.getFcmToken();
}
