// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stay_safe/const/AppColors.dart';
import 'package:stay_safe/ui/bottom_navigation_controller.dart';
import 'package:stay_safe/widgets/myTextField.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final RegExp _digitRegExp = RegExp(r'^\d+$');
  List<String> gender = ["Male", "Female", "Other"];
  bool _isPhoneValid = true;
  bool _isAgeValid = true;

  void _validatePhoneNumber(String input) {
    setState(() {
      _isPhoneValid = input.length == 10 && _digitRegExp.hasMatch(input);
    });
  }

  void _validateAge(String input) {
    setState(() {
      _isAgeValid = input.length == 2 && _digitRegExp.hasMatch(input);
    });
  }

  void sendUserDataToDB() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var currentUser = auth.currentUser;

    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection("users-form-data");
    return collectionRef
        .doc(currentUser!.email)
        .set({
          "name": _nameController.text,
          "phone": _phoneController.text,
          "gender": _genderController.text,
          "age": _ageController.text,
        })
        .then((value) => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const BottomNavigation())))
        .catchError((error) => print("something is wrong. $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Submit the form to continue.",
                  style: TextStyle(fontSize: 22.sp, color: green),
                ),
                Text(
                  "We will not share your information with anyone.",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFFBBBBBB),
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: "Enter Your Name",
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF414041),
                        ),
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          fontSize: 15.sp,
                          color: green,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      onChanged: _validatePhoneNumber,
                      decoration: InputDecoration(
                          hintText: "Enter Your phone number",
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF414041),
                          ),
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(
                            fontSize: 15.sp,
                            color: green,
                          ),
                          errorText: _isPhoneValid
                              ? null
                              : 'Please enter a valid phone number 0712345678'),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _genderController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "Choose your gender",
                        labelText: 'Gender',
                        labelStyle: TextStyle(
                          fontSize: 15.sp,
                          color: green,
                        ),
                        prefixIcon: DropdownButton<String>(
                          items: gender.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                              onTap: () {
                                setState(() {
                                  _genderController.text = value;
                                });
                              },
                            );
                          }).toList(),
                          onChanged: (_) {},
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      onChanged: _validateAge,
                      decoration: InputDecoration(
                          hintText: "Enter Your Age",
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF414041),
                          ),
                          labelText: 'Age',
                          labelStyle: TextStyle(
                            fontSize: 15.sp,
                            color: green,
                          ),
                          errorText: _isAgeValid
                              ? null
                              : 'Please enter your age eg.20'),
                    ),
                  ],
                ),

                SizedBox(
                  height: 50.h,
                ),

                // elevated button
                ElevatedButton(
                  onPressed: () {
                    String name = _nameController.text.trim();
                    String phone = _phoneController.text.trim();
                    String gender = _genderController.text;
                    String age = _ageController.text;
                    if (name.isNotEmpty &&
                        phone.isNotEmpty &&
                        gender.isNotEmpty &&
                        age.isNotEmpty) {
                      if (_isAgeValid && _isPhoneValid) {
                        sendUserDataToDB();
                        Fluttertoast.showToast(msg: 'Signing in');
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Please fill in all the fields');
                    }
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
