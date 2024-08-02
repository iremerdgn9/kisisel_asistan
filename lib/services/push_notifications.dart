import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
//import 'package:push_notification/push_notification.dart';
import 'message_api.dart';

class PushNotification extends StatelessWidget {
  const PushNotification({super.key});
  static const String route= '/push-notifications';


  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: Text('Push Notification'),
      ),
      body: Center(
        child: Column(
          children: message != null ? [
            Text(message['notification']?['title'] ?? ''),
            Text(message['notification']?['body'] ?? Intl.message('no_notification', name: 'no_notification_key')),
            Text(message['data'] ?? Intl.message('no_data', name: 'no_data_key')),
          ]:
          [
            Text(Intl.message('no_notification', name: 'no_notification_key')),
          ],
        ),
      ),
    );
  }
}
