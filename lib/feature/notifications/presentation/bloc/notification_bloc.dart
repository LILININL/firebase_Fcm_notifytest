import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/push_message.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/get_fcm_token.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repo;
  final GetFcmToken getFcmToken;

  StreamSubscription<PushMessage>? _sub;

  NotificationBloc({required this.repo, required this.getFcmToken})
      : super(const NotificationState.initial()) {
    on<NotificationStarted>(_onStarted);
    on<NotificationReceived>(_onReceived);
    on<NotificationGetTokenRequested>(_onGetTokenRequested);
  }

  Future<void> _onStarted(
    NotificationStarted event,
    Emitter<NotificationState> emit,
  ) async {
    await _sub?.cancel();
    _sub = repo.onForegroundMessages().listen((msg) {
      add(NotificationReceived(msg));
    });
  }

  void _onReceived(
    NotificationReceived event,
    Emitter<NotificationState> emit,
  ) {
    final updated = List<PushMessage>.from(state.messages)..insert(0, event.message);
    emit(state.copyWith(messages: updated));
  }

  Future<void> _onGetTokenRequested(
    NotificationGetTokenRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(loadingToken: true));
    final token = await getFcmToken();
    emit(state.copyWith(loadingToken: false, fcmToken: token));
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
