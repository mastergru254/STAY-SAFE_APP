// ignore_for_file: use_build_context_synchronously, file_names

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'notificationPage.dart';

class SendAlert extends StatefulWidget {
  const SendAlert({super.key});

  @override
  State<SendAlert> createState() => _HomePageState();
}

class _HomePageState extends State<SendAlert> {
  String? mtoken = " ";
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final CollectionReference _notifications =
      FirebaseFirestore.instance.collection('notifications');
  var currentUser = FirebaseAuth.instance.currentUser;

  TextEditingController username = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();

  @override
  void initState() {
    super.initState();
    requestPermission();
    getToken();
    initInfo();
  }

  void requestPermission() async {
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

    // Handle authorisation status
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      Fluttertoast.showToast(msg: 'User declined Permission');
      print('User declined or has not accepted permission');
    }
  }

  // Get device token
  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print('My token is $mtoken');
      });
      saveToken(token!);
    });
  }

  // Save device token
  void saveToken(String token) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;
    await FirebaseFirestore.instance
        .collection("UserTokens")
        .doc(currentUser!.email)
        .set({'token': token});
  }

  // initializations for local plugins
  initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationsSettings =
        InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("...........onMessage.............");
      print(
          "onMessage: ${message.notification?.title}/${message.notification?.body}");
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          message.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: message.notification!.title.toString(),
          htmlFormatContentTitle: true);
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('myid', 'myid',
              importance: Importance.high,
              styleInformation: bigTextStyleInformation,
              priority: Priority.high,
              playSound: true);
      NotificationDetails plaformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, plaformChannelSpecifics,
          payload: message.data['title']);
      final payload = message.data['title'];
      if (payload != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Alert()));
      }
    });
  }

  void sendPushMessage(List<String> tokens, String title, String body) async {
    try {
      for (String token in tokens) {
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization':
                  'key=AAAAtmfJPag:APA91bGzSq1MqbY-pG4iHApPVpPtO68Si33OdzU2zXAsg-GzUdB5uY2Fk7LTfeKDcmC3BVbEslItYX9wRh1po-EVJd1_wxbbT3689vU91sZA6rWSX13kCQVXSdH3WFTREUqubLL09OzU'
            },
            body: jsonEncode(<String, dynamic>{
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
                'body': body,
                'title': title,
              },
              "notification": <String, dynamic>{
                "title": title,
                "body": body,
                "android_channel_id": "myid"
              },
              "to": token,
            }));
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error Push notification");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Send MSG'),
          backgroundColor: Colors.green,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Alert()));
              },
              icon: const Icon(Icons.notifications),
            )
          ],
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: username,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: title,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextFormField(
                controller: body,
                decoration: const InputDecoration(labelText: 'Content'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    String name = username.text.trim();
                    String titleText = title.text;
                    String bodyText = body.text;

                    if (name.isNotEmpty &&
                        titleText.isNotEmpty &&
                        bodyText.isNotEmpty) {
                      QuerySnapshot snap = await FirebaseFirestore.instance
                          .collection("UserTokens")
                          .get();
                      List<String> tokens = [];
                      for (QueryDocumentSnapshot documentSnapshot
                          in snap.docs) {
                        String token = documentSnapshot.get('token') as String;
                        tokens.add(token);
                        await _notifications.doc(name).set({
                          "title": titleText,
                          "body": bodyText,
                          "Timestamp": Timestamp.now()
                        });
                        username.text = '';
                        title.text = '';
                        body.text = '';
                      }
                      print("All tokens is  $tokens");
                      sendPushMessage(tokens, titleText, bodyText);
                    } else {
                      Fluttertoast.showToast(msg: "Fill in all fields");
                    }
                  },
                  child: Text('SEND'))
            ],
          ),
        )),
      ),
    );
  }
}
