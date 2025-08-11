import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../notifications/data/datasources/fcm_remote_data_source.dart';
import '../../../notifications/data/repositories/notification_repository_impl.dart';
import '../../../notifications/domain/usecases/get_fcm_token.dart';
import '../../../../core/fcm/fcm_token_service.dart';
import '../bloc/notification_bloc.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => NotificationRepositoryImpl(FcmRemoteDataSourceImpl(FirebaseMessaging.instance)),
      child: Builder(
        builder: (context) {
          final repo = context.read<NotificationRepositoryImpl>();
          return BlocProvider(
            create: (_) => NotificationBloc(repo: repo, getFcmToken: GetFcmToken(repo))..add(const NotificationStarted()),
            child: const _NotificationView(),
          );
        },
      ),
    );
  }
}

class _NotificationView extends StatelessWidget {
  const _NotificationView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FCM Notifications'),
        actions: [
          IconButton(icon: const Icon(Icons.vpn_key), onPressed: () => context.read<NotificationBloc>().add(const NotificationGetTokenRequested())),
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => _refreshFcmToken(context)),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          return Column(
            children: [
              if (state.loadingToken) const LinearProgressIndicator(),
              if (state.fcmToken != null) Padding(padding: const EdgeInsets.all(8.0), child: SelectableText('Token: ${state.fcmToken}')),
              Expanded(
                child: ListView.builder(
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final msg = state.messages[index];
                    return ListTile(
                      title: Text(msg.title ?? '(no title)'),
                      subtitle: Text(msg.body ?? '(no body)'),
                      trailing: Container(
                        width: 100,
                        child: Text('${msg.data}', style: TextStyle(fontSize: 10), overflow: TextOverflow.ellipsis, maxLines: 2),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _refreshFcmToken(BuildContext context) async {
    final newToken = await FcmTokenService.refreshToken();
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(newToken != null ? 'FCM Token รีเฟรชสำเร็จ!' : 'รีเฟรช Token ไม่สำเร็จ'), backgroundColor: newToken != null ? Colors.green : Colors.red));
      // รีเฟรช UI
      context.read<NotificationBloc>().add(const NotificationGetTokenRequested());
    }
  }
}
