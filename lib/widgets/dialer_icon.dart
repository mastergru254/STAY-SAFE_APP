import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class DialerIcon extends StatelessWidget {
  final String phoneNumber;
  const DialerIcon({super.key, required this.phoneNumber});

  void _launchDialer() async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    if (!res!) {
      throw 'Could not launch the dialer';
    }
  }
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: (){
        _launchDialer();
        print('Clicked dialer icon');
    }, 
    icon: const Icon(Icons.call),);
  }
}