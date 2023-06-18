// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stay_safe/const/AppColors.dart';

class LandslidesScreen extends StatelessWidget {
  const LandslidesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: green,
        title: Text('Guidance'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                  color: green,
                  height: 60,
                  width: 300,
                  alignment: Alignment.center,
                  child: Text(
                    'Landslides/ DebrisFlow',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: const Text(
                "Safety Measures During Landslides/debrisflow \n\n• Keep your emergency kits ready and handy.\n\n •Make a plan for your household, including your pets, so that you and your family know what to do and where to go in the event of a landslide.\n\n• Sign up for your community’s warning system..\n\n• Repair your roof shed or tiles. Try not to keep any loose debris lying about.\n\n. Consult a professional for advice on appropriate preventative measures for your home or business, such as flexible pipe fittings, which can resist breakage better.\n\n. In mud and debris flow areas, consider building channels or deflection walls to try to direct the flow around buildings. Be aware, however, that when a flow is big enough, it goes where it pleases. Also, you may be liable for damages if you divert a flow and it flows on a neighbor's property.\n\nFollowing these safety measures during landslides is a must for all.",
                style: TextStyle(fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }
}
