// ignore_for_file: non_constant_identifier_names, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'noti.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotifyAlert extends StatefulWidget {
  const NotifyAlert({super.key});

  @override
  State<NotifyAlert> createState() => _NotifyState();
}

class _NotifyState extends State<NotifyAlert> {
  final CollectionReference _Alerts =
      FirebaseFirestore.instance.collection('Alerts');

  @override
  void initState() {
    super.initState();
    Noti.initialize(flutterLocalNotificationsPlugin);
  }

  @override
  Widget build(BuildContext context) {
    double dh = MediaQuery.of(context).size.height;
    double dw = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: dw,
          height: dh,
          child: StreamBuilder(
            stream: _Alerts.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    print(documentSnapshot['alert'] + ':' + index.toString());
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: const Icon(
                          Icons.notifications_active_rounded,
                          color: Colors.red,
                        ),
                        title: Text(documentSnapshot['alert']),
                        subtitle: Text(
                          documentSnapshot['content'],
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
      ),
    );
  }
}
