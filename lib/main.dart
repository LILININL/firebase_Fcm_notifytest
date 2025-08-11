import 'package:flutter/material.dart';
import 'core/firebase/firebase_bootstrap.dart';
import 'feature/notifications/presentation/pages/notification_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseBootstrapper.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notify FCM',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const NotificationPage(),
    );
  }
}
