import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class DialerButton extends StatelessWidget {
  final String phoneNumber;
  final String buttonLabel;

  const DialerButton(
      {super.key, required this.phoneNumber, required this.buttonLabel});

  void _launchDialer() async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    if (!res!) {
      throw 'Could not launch the dialer';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _launchDialer,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
        padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(horizontal: 60)),
        textStyle: MaterialStateProperty.all<TextStyle>(
            const TextStyle(fontSize: 16, color: Colors.black)),
      ),
      child: Text(buttonLabel),
    );
  }
}
