import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class MyHomePageController extends GetxController {
  var userList = [].obs;
  var _notificationsEnabled = false.obs;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    _isAndroidPermissionGranted();
    _requestPermissions();
    getCollectionData();
  }

  Future<void> getCollectionData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('TestUsers').get();
    List<DocumentSnapshot> documents = querySnapshot.docs;
    for (var document in documents) {
      if (FirebaseAuth.instance.currentUser != null &&
          FirebaseAuth.instance.currentUser!.email != document.id) {
        userList.add(document.id);
      }
      print(document.id); // prints the document ID
    }
  }

  getDocumentData(String user) async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('TestUsers')
            .doc(user)
            .get();
    final allData = querySnapshot;
    sendNotification(allData['deviceToken'], "Check Message");
  }

  var postUrl = "https://fcm.googleapis.com/fcm/send";

  Future<void> sendNotification(receiver, msg) async {
    print('token : $receiver');

    final data = {
      "notification": {
        "body": "",
        "title": "",
      },
      "priority": "high",
      "data": {
        "title": "Your notification title",
        "body": "Your notification body",
        "action": "OPEN_ACTIVITY",
        "action_button": "Click here",
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      },
      "to": "$receiver"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAANb7e7ZE:APA91bHRDrtDZIAJQs5aIwKpVefIVe3pY1aFRNPMGL5B8TTEsnhTfXWQx5KOkDFrgTP238aBWiXGXBhWhEFlAr5A75X6v43WbszpAx5kJevAqVP-m8qIYYuZi8GoIwznT-4_R2zzHJc6'
    };

    BaseOptions options = BaseOptions(
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 3000),
      headers: headers,
    );

    try {
      final response = await Dio(options).post(postUrl, data: data);

      if (response.statusCode == 200) {
        print("message sent to receiver");
      } else {
        print('notification sending failed');
        // on failure do sth
      }
    } catch (e) {
      print('exception $e');
    }
  }

  Future<void> _isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted = await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;

      _notificationsEnabled(granted);
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();
      _notificationsEnabled(grantedNotificationPermission);
    }
  }
}
