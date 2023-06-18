// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stay_safe/ui/NavBar.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    Key? key,
  }) : super(
            backgroundColor: Colors.purpleAccent,
            elevation: 5.0,
            leading: IconButton(
              onPressed: () {
                NavBar();
              },
              icon: Icon(Icons.menu),
              color: Colors.black,
            ));
}
