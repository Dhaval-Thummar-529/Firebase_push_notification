import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationHandler {
  FirebaseMessaging _fcm = FirebaseMessaging.instance;
  String darwinNotificationCategoryPlain = 'plainCategory';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  int id = 1;

  final StreamController<String?> selectNotificationStream =
  StreamController<String?>.broadcast();

  Future initialize() async {
    id = 1;
    initializeNotification();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      await showNotificationWithActions();
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    // Get the token
    await getToken();
  }

  Future<String?> getToken() async {
    String? token = await _fcm.getToken();
    print('Token: $token');
    return token;
  }

  Future<void> showNotificationWithActions() async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher',
      ongoing: true,
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          "id_1",
          'Reject',
          icon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          showsUserInterface: true,
          contextual: true,
          titleColor: Color.fromARGB(255, 255, 0, 0),
          cancelNotification: true,
          // By default, Android plugin will dismiss the notification when the
          // user tapped on a action (this mimics the behavior on iOS).
        ),
        AndroidNotificationAction(
          'id_2',
          'Approve',
          titleColor: Colors.green,
          showsUserInterface: true,
          contextual: true,
          icon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          cancelNotification: true,
        ),
      ],
    );

    DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      categoryIdentifier: darwinNotificationCategoryPlain,
    );

    DarwinNotificationDetails macOSNotificationDetails =
        DarwinNotificationDetails(
      categoryIdentifier: darwinNotificationCategoryPlain,
    );

    const LinuxNotificationDetails linuxNotificationDetails =
        LinuxNotificationDetails(
      actions: <LinuxNotificationAction>[
        LinuxNotificationAction(
          key: "id_2",
          label: 'Action 1',
        ),
        LinuxNotificationAction(
          key: "id_3",
          label: 'Action 2',
        ),
      ],
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
      macOS: macOSNotificationDetails,
      linux: linuxNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
        0, '', "Your Delivery from amazon is at the gate", notificationDetails,
        payload: 'item z');
  }

  void initializeNotification() async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) {
          switch (notificationResponse.notificationResponseType) {
            case NotificationResponseType.selectedNotification:
              break;
            case NotificationResponseType.selectedNotificationAction:
              if (notificationResponse.actionId == "id_2") {
                selectNotificationStream.add(notificationResponse.payload);
              }
              break;
          }
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }
}