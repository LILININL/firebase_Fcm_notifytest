import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notify/feature/notifications/domain/entities/push_message.dart';
import 'package:notify/feature/notifications/domain/repositories/notification_repository.dart';
import 'package:notify/feature/notifications/domain/usecases/get_fcm_token.dart';
import 'package:notify/feature/notifications/presentation/bloc/notification_bloc.dart';

class MockRepo extends Mock implements NotificationRepository {}

void main() {
  group('NotificationBloc', () {
    late MockRepo repo;
    late GetFcmToken usecase;

    setUp(() {
      repo = MockRepo();
      usecase = GetFcmToken(repo);
    });

    blocTest<NotificationBloc, NotificationState>(
      'emits messages when received',
      build: () {
        when(() => repo.onForegroundMessages())
            .thenAnswer((_) => Stream.value(const PushMessage(title: 't')));
        when(() => repo.getFcmToken()).thenAnswer((_) async => 'token');
        return NotificationBloc(repo: repo, getFcmToken: usecase);
      },
      act: (b) => b..add(const NotificationStarted()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<NotificationState>().having((s) => s.messages.length, 'has msg', 1),
      ],
    );

    blocTest<NotificationBloc, NotificationState>(
      'gets token on request',
      build: () {
        when(() => repo.onForegroundMessages()).thenAnswer((_) => const Stream.empty());
        when(() => repo.getFcmToken()).thenAnswer((_) async => 'abc');
        return NotificationBloc(repo: repo, getFcmToken: usecase);
      },
      act: (b) => b..add(const NotificationGetTokenRequested()),
      expect: () => [
        isA<NotificationState>().having((s) => s.loadingToken, 'loading', true),
        isA<NotificationState>().having((s) => s.fcmToken, 'token', 'abc'),
      ],
    );
  });
}
