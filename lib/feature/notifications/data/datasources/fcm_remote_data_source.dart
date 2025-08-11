import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../core/notifications/local_notification_service.dart';

import '../../domain/entities/push_message.dart';

abstract class FcmRemoteDataSource {
  Stream<PushMessage> onForegroundMessages();
  Future<String?> getToken();
}

class FcmRemoteDataSourceImpl implements FcmRemoteDataSource {
  final FirebaseMessaging _messaging;
  FcmRemoteDataSourceImpl(this._messaging);

  @override
  Stream<PushMessage> onForegroundMessages() {
    return FirebaseMessaging.onMessage.map((m) {
      final pushMessage = PushMessage(title: m.notification?.title, body: m.notification?.body, data: m.data);

      // แสดง local notification บนหน้าจอเมื่อแอปเปิดอยู่
      LocalNotificationService.showNotification(title: pushMessage.title ?? 'แจ้งเตือน', body: pushMessage.body ?? 'มีข้อความใหม่', payload: pushMessage.data.toString());

      return pushMessage;
    });
  }

  @override
  Future<String?> getToken() => _messaging.getToken();
}
