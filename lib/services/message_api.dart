import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:kisisel_asistan/main.dart';
import 'package:kisisel_asistan/services/push_notifications.dart';

class MessageApi{
  final _firebaseMessaging = FirebaseMessaging.instance;

  void handleMessage(RemoteMessage? message){
    if(message == null) return;
    navigatorKey.currentState?.pushNamed(
      PushNotification.route,
      arguments: message,
    );
  }
  Future initPushNotifications() async{
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> initNotifications() async{
    await _firebaseMessaging.requestPermission(
      criticalAlert: true,
    );
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
    //FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    initPushNotifications();
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    if (kDebugMode) {
      print('title: ${message.notification?.title}');
    }
    if (kDebugMode) {
      print('body: ${message.notification?.body}');
    }
    if (kDebugMode) {
      print('payload: ${message.data}');
    }
  }
}
