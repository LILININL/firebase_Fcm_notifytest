import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import '../../firebase_options.dart';
import '../notifications/local_notification_service.dart';
import '../fcm/fcm_token_service.dart';

// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized in background isolate
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }

  // Log ใน release mode ด้วย
  print('=== BACKGROUND MESSAGE RECEIVED ===');
  print('Message ID: ${message.messageId}');
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Data: ${message.data}');
  print('Sent Time: ${message.sentTime}');
  print('====================================');

  if (kDebugMode) {
    log('Background Message: ${message.messageId}', name: 'FCM_BACKGROUND');
  }
}

class FirebaseBootstrapper {
  static bool _isInitialized = false;

  static Future<void> ensureInitialized() async {
    if (_isInitialized) {
      if (kDebugMode) {
        print('Firebase already initialized');
      }
      return;
    }

    try {
      // Try to initialize Firebase, handle duplicate app error gracefully
      try {
        await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
        if (kDebugMode) {
          print('Firebase initialized successfully');
        }
      } on FirebaseException catch (e) {
        if (e.code == 'duplicate-app') {
          if (kDebugMode) {
            print('Firebase app already exists, using existing app');
          }
        } else {
          rethrow;
        }
      }

      // Setup FCM and Local Notifications
      await LocalNotificationService.initialize();
      await _setupFirebaseMessaging();
      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('Firebase initialization error: $e');
      }
      rethrow;
    }
  }

  static Future<void> _setupFirebaseMessaging() async {
    final messaging = FirebaseMessaging.instance;

    // Request permission for notifications
    final settings = await messaging.requestPermission(alert: true, badge: true, sound: true, provisional: false);

    if (kDebugMode) {
      print('FCM Permission status: ${settings.authorizationStatus}');
    }

    // Get and display FCM token using FcmTokenService
    await FcmTokenService.getToken();

    // Setup token refresh listener
    FcmTokenService.setupTokenRefreshListener();

    // Register background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Setup handler for when app is opened from terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('=== APP OPENED FROM NOTIFICATION ===');
      print('Message ID: ${message.messageId}');
      print('Title: ${message.notification?.title}');
      print('Data: ${message.data}');
      if (kDebugMode) {
        log('App opened from notification: ${message.messageId}', name: 'FCM_OPENED_APP');
      }
    });

    if (kDebugMode) {
      print('FCM setup completed');
    }
  }
}
