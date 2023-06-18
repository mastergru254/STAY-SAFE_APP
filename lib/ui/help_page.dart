// ignore_for_file: unused_field

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stay_safe/const/AppColors.dart';

import 'bottom_navigation_controller.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _donationController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String _location = '';
  final RegExp _digitRegExp = RegExp(r'^\d+$');
  bool _isPhoneValid = true;
  bool _isAgeValid = true;
  void _validateAge(String input) {
    setState(() {
      _isAgeValid = input.length == 2 && _digitRegExp.hasMatch(input);
    });
  }

  void _validatePhoneNumber(String input) {
    setState(() {
      _isPhoneValid = input.length == 10 && _digitRegExp.hasMatch(input);
    });
  }

  void sendUserDataToDB() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;

    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection("Offer_to_help_data");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _location = placemarks[0].street!;
    });
    Fluttertoast.showToast(msg: 'Getting Location');
    print(placemarks);
    double latitude = position.latitude;
    double longitude = position.longitude;
    return collectionRef
        .doc(currentUser!.email)
        .set({
          "name": _nameController.text,
          "phone": _phoneController.text,
          "age": _ageController.text,
          "donation": _donationController.text,
          "location": _location,
          "latitude": latitude,
          "longitude": longitude,
        })
        .then((value) => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const BottomNavigation())))
        .catchError((error) => print("something is wrong. $error"));
  }

  @override
  Widget build(BuildContext context) {
    double dh = MediaQuery.of(context).size.height;
    double dw = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: green,
        title: const Text("Offer to Help"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Material(
            elevation: 10,
            child: Container(
              height: dh,
              width: dw * 0.9,
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Help others during their crisis!!',
                      style: TextStyle(
                        color: green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Name',
                              border: OutlineInputBorder(),
                            ),
                            controller: _nameController,
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'The donation you can make',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.text,
                            controller: _donationController,
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          TextFormField(
                            onChanged: _validatePhoneNumber,
                            decoration: InputDecoration(
                                hintText: 'Phone Number',
                                border: const OutlineInputBorder(),
                                errorText: _isPhoneValid
                                    ? null
                                    : 'Enter a valid phone number with 10 digits'),
                            keyboardType: TextInputType.number,
                            controller: _phoneController,
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          TextFormField(
                            onChanged: _validateAge,
                            keyboardType: TextInputType.number,
                            controller: _ageController,
                            decoration: InputDecoration(
                                hintText: 'Age',
                                border: OutlineInputBorder(),
                                errorText: _isAgeValid
                                    ? null
                                    : 'Input your correct age eg.20'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () {
                                String donation =
                                    _donationController.text.trim();
                                String phone = _phoneController.text.trim();
                                String age = _ageController.text.trim();
                                String name = _nameController.text.trim();
                                if (donation.isNotEmpty &&
                                    phone.isNotEmpty &&
                                    age.isNotEmpty &&
                                    name.isNotEmpty) {
                                  if (_isAgeValid && _isPhoneValid) {
                                    sendUserDataToDB();
                                    Fluttertoast.showToast(
                                        msg: 'Sending Your Request');
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Please input all fields');
                                }
                              },
                              icon: const Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'DONE',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
