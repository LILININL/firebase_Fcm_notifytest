import '../entities/push_message.dart';

abstract class NotificationRepository {
  Stream<PushMessage> onForegroundMessages();
  Future<String?> getFcmToken();
}
