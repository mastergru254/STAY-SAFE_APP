// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stay_safe/const/AppColors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  User? _currentUser;
  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    setState(() {
      _currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(_currentUser!.displayName ?? ''),
            accountEmail: Text(_currentUser!.email ?? ''),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipOval(),
            ),
            decoration: BoxDecoration(
              color: green,
            ),
          ),
          const ListTile(
            title: Text('Exit'),
            leading: Icon(Icons.exit_to_app),
          ),
        ],
      ),
    );
  }
}
