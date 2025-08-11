import '../../domain/entities/push_message.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/fcm_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final FcmRemoteDataSource remote;
  NotificationRepositoryImpl(this.remote);

  @override
  Stream<PushMessage> onForegroundMessages() => remote.onForegroundMessages();

  @override
  Future<String?> getFcmToken() => remote.getToken();
}
