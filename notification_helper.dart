import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up: ${message.messageId}');
}

class NotificationHelper {
  static getFirebaseMessagingInBackground() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      print(message.toMap().toString());
      if (notification != null && android != null) {
        if (message.data["image"] != null) {
          final imageUrl = message.data['image'];
          BigPictureStyleInformation? bigPictureStyleInformation;
          try {
            final response = await http.get(Uri.parse(imageUrl));
            if (response.statusCode == 200) {
              final byteArray = response.bodyBytes;
              bigPictureStyleInformation = BigPictureStyleInformation(
                ByteArrayAndroidBitmap(byteArray),
                largeIcon: ByteArrayAndroidBitmap(byteArray),
                contentTitle: notification.title,
                summaryText: notification.body,
              );
            }
          } catch (e) {
            print('Failed to fetch image: $e');
          }

          flutterLocalNotificationsPlugin.show(
            message.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel',
                'High Importance Notifications',
                channelDescription:
                    'This channel is used for important notifications.',
                importance: Importance.high,
                priority: Priority.high,
                icon: '@mipmap/ic_launcher',
                colorized: true,
                color: const Color(0xffE28B2D),
                styleInformation: bigPictureStyleInformation,
              ),
              iOS: const DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
            payload: jsonEncode(message.data),
          );
        } else {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  icon: '@mipmap/ic_launcher',
                ),
              ));
        }
      } else {
        print("Something went wrong");
      }
    });
  }

  getFirebaseMessagingInForeground(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        if (message.data["image"] != null) {
          final imageUrl = message.data['image'];
          BigPictureStyleInformation? bigPictureStyleInformation;
          try {
            final response = await http.get(Uri.parse(imageUrl));
            if (response.statusCode == 200) {
              final byteArray = response.bodyBytes;
              bigPictureStyleInformation = BigPictureStyleInformation(
                ByteArrayAndroidBitmap(byteArray),
                largeIcon: ByteArrayAndroidBitmap(byteArray),
                contentTitle: notification.title,
                summaryText: notification.body,
              );
            }
          } catch (e) {
            print('Failed to fetch image: $e');
          }

          flutterLocalNotificationsPlugin.show(
            message.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel',
                'High Importance Notifications',
                channelDescription:
                    'This channel is used for important notifications.',
                importance: Importance.high,
                priority: Priority.high,
                icon: '@mipmap/ic_launcher',
                colorized: true,
                color: const Color(0xffE28B2D),
                styleInformation: bigPictureStyleInformation,
              ),
              iOS: const DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
            payload: jsonEncode(message.data),
          );
        } else {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  icon: '@mipmap/ic_launcher',
                ),
              ));
        }
      } else {
        print("Something went wrong");
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        if (message.data["image"] != null) {
          final imageUrl = message.data['image'];
          BigPictureStyleInformation? bigPictureStyleInformation;
          try {
            final response = await http.get(Uri.parse(imageUrl));
            if (response.statusCode == 200) {
              final byteArray = response.bodyBytes;
              bigPictureStyleInformation = BigPictureStyleInformation(
                ByteArrayAndroidBitmap(byteArray),
                largeIcon: ByteArrayAndroidBitmap(byteArray),
                contentTitle: notification.title,
                summaryText: notification.body,
              );
            }
          } catch (e) {
            print('Failed to fetch image: $e');
          }

          flutterLocalNotificationsPlugin.show(
            message.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel',
                'High Importance Notifications',
                channelDescription:
                    'This channel is used for important notifications.',
                importance: Importance.high,
                priority: Priority.high,
                icon: '@mipmap/ic_launcher',
                colorized: true,
                color: const Color(0xffE28B2D),
                styleInformation: bigPictureStyleInformation,
              ),
              iOS: const DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
            payload: jsonEncode(message.data),
          );
        } else {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Text(notification.title!),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(notification.body!)],
                    ),
                  ),
                );
              });
        }
      }
    });
  }

  Future<void> requestNotificationPermission(BuildContext context) async {
    final PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      Fluttertoast.showToast(msg: "notification-permission-enabled.");

      getFcmToken();
      getFirebaseMessagingInBackground();
      getFirebaseMessagingInForeground(context);
    } else if (status.isDenied) {
      Fluttertoast.showToast(
          msg: "Enable notification permission to get notifications.");
    } else if (status.isPermanentlyDenied) {
      Fluttertoast.showToast(
          msg: "Enable notification permission to get notifications.");
      await openAppSettings();
    }
  }

  Future<String?> getFcmToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print("FCM TOken: $token");
    return token;
  }
}
