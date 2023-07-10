// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, unused_element, file_names

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:stay_safe/ui/home_Screen.dart';

class Alert extends StatefulWidget {
  const Alert({super.key});

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final CollectionReference _notifications =
      FirebaseFirestore.instance.collection('notifications');
  var currentUser = FirebaseAuth.instance.currentUser;

  final TextEditingController _alertController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String? mtoken = " ";
  List<String> tokens = [];
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
      criticalAlert: true,
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

  Future<void> _sendAlert([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _alertController.text = documentSnapshot['title'];
      _contentController.text = documentSnapshot['body'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _alertController,
                  decoration: const InputDecoration(labelText: 'Alert Title'),
                ),
                TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Alert Message',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final String alert = _alertController.text;
                        final String content = _contentController.text;
                        if (alert.isNotEmpty && content.isNotEmpty) {
                          await _notifications.doc().set({
                            "title": alert,
                            "body": content,
                            "Timestamp": DateTime.now()
                          });
                          QuerySnapshot snap = await FirebaseFirestore.instance
                              .collection("UserTokens")
                              .get();

                          for (QueryDocumentSnapshot documentSnapshot
                              in snap.docs) {
                            String token =
                                documentSnapshot.get('token') as String;
                            tokens.add(token);
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: 'Please fill in all feilds');
                        }
                        sendPushMessage(tokens, alert, content);

                        _alertController.text = '';
                        _contentController.text = '';
                        Navigator.pop(context);
                      },
                      child: const Text('Send'),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'))
                  ],
                )
              ],
            ),
          );
        });
  }

  Future<void> _updateAlert([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _alertController.text = documentSnapshot['title'];
      _contentController.text = documentSnapshot['body'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _alertController,
                  decoration: const InputDecoration(labelText: 'Alert Title'),
                ),
                TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Alert Message',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final String alert = _alertController.text;
                        final String content = _contentController.text;
                        if (alert.isNotEmpty && content.isNotEmpty) {
                          await _notifications.doc(documentSnapshot!.id).set({
                            "title": alert,
                            "body": content,
                            "Timestamp": DateTime.now()
                          });
                          QuerySnapshot snap = await FirebaseFirestore.instance
                              .collection("UserTokens")
                              .get();

                          for (QueryDocumentSnapshot documentSnapshot
                              in snap.docs) {
                            String token =
                                documentSnapshot.get('token') as String;
                            tokens.add(token);
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: 'Please fill in all feilds');
                        }
                        sendPushMessage(tokens, alert, content);
                        _alertController.text = '';
                        _contentController.text = '';
                        Navigator.pop(context);
                      },
                      child: const Text('Update'),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _alertController.text = '';
                          _contentController.text = '';
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'))
                  ],
                )
              ],
            ),
          );
        });
  }

  Future<void> _delete(String productId) async {
    await _notifications.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted an Alert')));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Messages'),
          backgroundColor: Colors.green,
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: _notifications
              .orderBy("Timestamp", descending: false)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: const Icon(Icons.notifications_active_rounded,
                          color: Colors.green),
                      title: Text(documentSnapshot['title']),
                      subtitle: Text(
                        documentSnapshot['body'],
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
