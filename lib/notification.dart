import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data.containsKey('data')) {
    // Handle data message
    final data = message.data['data'];
  }

  if (message.data.containsKey('notification')) {
    // Handle notification message
    final notification = message.data['notification'];
  }
  // Or do other work.
}

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final streamCtlr = StreamController<String>.broadcast();
  final titleCtlr = StreamController<String>.broadcast();
  final bodyCtlr = StreamController<String>.broadcast();

  setNotifications() {
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    FirebaseMessaging.onMessage.listen(
          (message) async {
        if (message.data.containsKey('data')) {
          // Handle data message
          streamCtlr.sink.add(message.data['data']);
        }
        if (message.data.containsKey('notification')) {
          // Handle notification message
          streamCtlr.sink.add(message.data['notification']);
        }
        // Or do other work.
        titleCtlr.sink.add(message.notification!.title!);
        bodyCtlr.sink.add(message.notification!.body!);
      },
    );
    // With this token you can test it easily on your phone
    final token =
    _firebaseMessaging.getToken().then((value) => print('Token: $value'));
  }

  dispose() {
    streamCtlr.close();
    bodyCtlr.close();
    titleCtlr.close();
  }

  static sendNotification({String? title, String? body}) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    ////Set the settings for various platform
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/ic_appicon');
    // const IOSInitializationSettings initializationSettingsIOS =
    // IOSInitializationSettings(
    //   requestAlertPermission: true,
    //   requestBadgePermission: true,
    //   requestSoundPermission: true,
    // );




    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: false,
      requestAlertPermission: false,


    );

    const LinuxInitializationSettings initializationSettingsLinux =
    LinuxInitializationSettings(
      defaultActionName: 'hello',
    );
     InitializationSettings initializationSettings = const InitializationSettings(
        android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        linux: initializationSettingsLinux);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    ///
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_channel', 'High Importance Notification',
        description: "This channel is for important notification",
        importance: Importance.max);

    flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(channel.id, channel.name,
            channelDescription: channel.description),
      ),
    );
  }
}