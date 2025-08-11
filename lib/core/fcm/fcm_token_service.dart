import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer';

class FcmTokenService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// ดึง FCM Token ปัจจุบัน
  static Future<String?> getToken() async {
    try {
      final token = await _messaging.getToken();
      if (kDebugMode) {
        print('=== FCM TOKEN SERVICE ===');
        print('FCM Token: $token');
        print('Token length: ${token?.length ?? 0}');
        log('FCM Token: $token', name: 'FCM_TOKEN_SERVICE');
      }
      return token;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting FCM token: $e');
      }
      return null;
    }
  }

  /// รีเฟรช FCM Token
  static Future<String?> refreshToken() async {
    try {
      await _messaging.deleteToken();
      final newToken = await _messaging.getToken();
      if (kDebugMode) {
        print('=== FCM TOKEN REFRESHED ===');
        print('New FCM Token: $newToken');
        log('New FCM Token: $newToken', name: 'FCM_TOKEN_REFRESH');
      }
      return newToken;
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing FCM token: $e');
      }
      return null;
    }
  }

  /// ตั้งค่า listener สำหรับ token refresh
  static void setupTokenRefreshListener() {
    _messaging.onTokenRefresh.listen((token) {
      if (kDebugMode) {
        print('=== FCM TOKEN AUTO REFRESHED ===');
        print('Auto refreshed token: $token');
        log('Auto refreshed token: $token', name: 'FCM_AUTO_REFRESH');
      }
    });
  }
}
