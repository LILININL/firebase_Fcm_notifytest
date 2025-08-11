part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class NotificationStarted extends NotificationEvent {
  const NotificationStarted();
}

class NotificationReceived extends NotificationEvent {
  final PushMessage message;
  const NotificationReceived(this.message);

  @override
  List<Object?> get props => [message];
}

class NotificationGetTokenRequested extends NotificationEvent {
  const NotificationGetTokenRequested();
}
