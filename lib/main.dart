import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:schooltrackingsystem/repo/childrens.dart';
import 'package:schooltrackingsystem/screens/DashBoardScreen.dart';
import 'package:schooltrackingsystem/screens/Otp.dart';
import 'package:schooltrackingsystem/screens/admin/RouteAllPoints.dart';
import 'package:schooltrackingsystem/screens/parent/EntrySplashScreen.dart';
import 'package:schooltrackingsystem/utils/Constants.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // print foreground message here.
    print('Handling a foreground message ${message.messageId}');
    print('Notification Message: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification!.body}');
      AndroidNotification androidNotification = message.notification!.android!;
      FCM.sendNotification(title: message.notification!.title!, body: message.notification!.body);

    }

  });

  void sendNotification({String? title, String? body}) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    ////Set the settings for various platform
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/ic_appicon');
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    // var initializationSettingsIOS = new IOSInitializationSettings();

    const LinuxInitializationSettings initializationSettingsLinux =
    LinuxInitializationSettings(
      defaultActionName: 'hello',
    );
    const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        linux: initializationSettingsLinux);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

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
  //FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  await FirebaseMessaging.instance
      .setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    //sound: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _PushMessagingExampleState createState() => _PushMessagingExampleState();
}
class _PushMessagingExampleState extends State<MyApp> {

  @override
  void initState() {
    // init();
    super.initState();
  }

 

  

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => LoginRepository(),
          ),

        ],
        child: MaterialApp(
          title: Constants.appName,
          theme: Constants.lighTheme(context),
          debugShowCheckedModeBanner: false,
          home: const EntrySplashScreen(),
          routes: <String, WidgetBuilder>{
            '/Otp': (BuildContext ctx) => const Otp(),
            '/RoutePoints': (BuildContext ctx) => const RouteAllPoints(),
            '/DashBoardScreen': (BuildContext ctx) => const DashBoardScreen(),
          },
        ));
  }
}




