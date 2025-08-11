part of 'notification_bloc.dart';

class NotificationState extends Equatable {
  final List<PushMessage> messages;
  final bool loadingToken;
  final String? fcmToken;

  const NotificationState({
    required this.messages,
    required this.loadingToken,
    required this.fcmToken,
  });

  const NotificationState.initial()
      : messages = const [],
        loadingToken = false,
        fcmToken = null;

  NotificationState copyWith({
    List<PushMessage>? messages,
    bool? loadingToken,
    String? fcmToken,
  }) {
    return NotificationState(
      messages: messages ?? this.messages,
      loadingToken: loadingToken ?? this.loadingToken,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  @override
  List<Object?> get props => [messages, loadingToken, fcmToken];
}
