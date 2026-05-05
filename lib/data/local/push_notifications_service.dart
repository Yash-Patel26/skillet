import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'notifications_service.dart';

class PushNotificationsService {
  PushNotificationsService(this._localNotifications);

  final NotificationsService _localNotifications;
  bool _initialized = false;

  Future<void> init({required void Function(String recipeId) onOpenRecipe}) async {
    if (_initialized) return;

    await _localNotifications.init(onNotificationTap: (payload) {
      if (payload != null && payload.isNotEmpty) {
        onOpenRecipe(payload);
      }
    });

    final settings = await FirebaseMessaging.instance.requestPermission();
    debugPrint('FCM permission status: ${settings.authorizationStatus}');

    final token = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM token: $token');

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      debugPrint('FCM token refreshed: $newToken');
    });

    FirebaseMessaging.onMessage.listen((message) async {
      final title = message.notification?.title ?? message.data['title'];
      final body = message.notification?.body ?? message.data['body'];
      if (title == null || body == null) return;

      final recipeId = message.data['recipeId'];
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await _localNotifications.showInstant(
        id: id,
        title: title,
        body: body,
        payload: recipeId,
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _openFromMessage(message, onOpenRecipe);
    });

    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      _openFromMessage(initial, onOpenRecipe);
    }

    _initialized = true;
  }

  void _openFromMessage(
    RemoteMessage message,
    void Function(String recipeId) onOpenRecipe,
  ) {
    final recipeId = message.data['recipeId'];
    if (recipeId is String && recipeId.isNotEmpty) {
      onOpenRecipe(recipeId);
    }
  }
}
