import 'package:cochevia_driver/Helper/AppInfoHelper.dart';
import 'package:cochevia_driver/Utils/app_global.dart';
import 'package:cochevia_driver/Utils/constants.dart';
import 'package:cochevia_driver/View/NotificationView/notificaton_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class NotificationHelper {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // Channel ID
    'High Importance Notifications', // Channel Name
    description:
        'This channel is used for important notifications.', // Channel Description
    importance: Importance.high,
  );

  Future<void> initNotification() async {
    // Request notification permissions
    await _firebaseMessaging.requestPermission();

    // Fetch the FCM token
    final fcmToken = await getFcmToken();
    print("FCM Token: $fcmToken");

    // Initialize local notifications
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    // Register the channel with the platform
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await _localNotifications.initialize(initializationSettings);

    // Initialize Firebase Messaging for push notifications
    initPushNotification();
  }

  void readMessage(RemoteMessage? message) {
    if (message == null) return;

    // Check for a tripId in the notification data
    if (message.data["tripId"] != null) {
      Provider.of<AppInfoHelper>(navigatorKey.currentContext!, listen: false)
          .readUserRideRequestInformationFromNotification(
              message.data["tripId"]);
    }
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    // Check for a tripId in the notification data
    if (message.data["tripId"] != null) {
      Provider.of<AppInfoHelper>(navigatorKey.currentContext!, listen: false)
          .readUserRideRequestInformationFromNotification(
              message.data["tripId"],
              clear: true);
    }

    // Navigate to NotificationScreen
    navigatorKey.currentState?.push(MaterialPageRoute(
      builder: (context) => NotificationScreen(message: message),
    ));
  }

  Future<void> initPushNotification() async {
    // Handle notifications when the app is terminated or in the background
    _firebaseMessaging.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((message) async {
      // Display a local notification for foreground messages
      await _showLocalNotification(message);

      // Trigger handleMessage for logic like navigating or updating UI
      readMessage(message);
    });
  }

  Future<String?> getFcmToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      AppGlobal.notificationToken = token;
      return token;
    } catch (e) {
      print("Failed to get FCM token: $e");
    }
    return null;
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    var notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id, // Channel ID
        channel.name, // Channel name
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    if (message.notification != null) {
      await _localNotifications.show(
        message.hashCode,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    }
  }
}
