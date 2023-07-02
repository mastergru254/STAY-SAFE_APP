// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stay_safe/const/AppColors.dart';
import 'package:stay_safe/ui/Ambulance_Screen.dart';
import 'package:stay_safe/ui/NavBar.dart';
import 'package:stay_safe/ui/donation_Screen.dart';
import 'package:stay_safe/ui/guidance_Screen.dart';
import 'package:stay_safe/ui/request_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        backgroundColor: green,
        title: const Text('Stay Safe'),
        centerTitle: true,
      ),
      drawer: NavBar(),
      //bottomNavigationBar: const BottomNavigation(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RequestScreen()),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        "asset/alert_emergency.png",
                        height: 120,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Request',
                      style: TextStyle(
                          color: green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AmbulanceService()),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        "asset/amb.png",
                        height: 120,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Ambulance',
                      style: TextStyle(
                          color: green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DonationScreen()),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          child: Image.asset(
                            "asset/charity_donation.png",
                            height: 120,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Donation',
                          style: TextStyle(
                              color: green,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GuidanceScreen()),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          child: Image.asset(
                            "asset/guide.png",
                            height: 120,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Guidance',
                          style: TextStyle(
                              color: green,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
