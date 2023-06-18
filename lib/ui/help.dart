// ignore_for_file: avoid_unnecessary_containers, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stay_safe/const/AppColors.dart';
import 'package:stay_safe/widgets/dialer_icon.dart';

import 'help_page.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  final CollectionReference _requestData =
      FirebaseFirestore.instance.collection('Offer_to_help_data');
  @override
  Widget build(BuildContext context) {
    double dh = MediaQuery.of(context).size.height;
    double dw = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Material(
                    elevation: 10,
                    child: SizedBox(
                      height: dh * 0.19,
                      width: dw * 0.9,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "How can you help?",
                              style: TextStyle(
                                  color: green, fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  "Click here to offer help",
                                  style: TextStyle(
                                      color: green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HelpPage()));
                                  },
                                  child: Container(
                                      height: 40,
                                      width: 300,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: const Color(0xFFA2D5C5),
                                      ),
                                      child: const Center(
                                          child: Text("Offer Help")))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: dh * 0.7,
                color: Colors.grey.shade300,
                child: StreamBuilder(
                  stream: _requestData.snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
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
                              title: Text(documentSnapshot['name']),
                              subtitle: Column(
                                children: [
                                  Text('Donation: ' +
                                      documentSnapshot['donation']),
                                  Text('phone: ' + documentSnapshot['phone']),
                                  Text('location: ' +
                                      documentSnapshot['location']),
                                  Text('Age: ' + documentSnapshot['age']),
                                ],
                              ),
                              trailing: DialerIcon(
                                  phoneNumber: documentSnapshot['phone']),
                            ),
                          );
                        },
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
