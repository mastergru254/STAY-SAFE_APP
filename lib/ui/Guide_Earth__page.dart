// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stay_safe/const/AppColors.dart';

class EarthquakeScreen extends StatelessWidget {
  const EarthquakeScreen({Key? key}) : super(key: key);

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
                    'Earthquake',
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
              child: Text(
                "• Make sure everyone knows where to find your disaster supply kit and Go-bags.\n\n• Have a flashlight and a pair of shoes under everyone’s bed in case there is an earthquake during the night. Use a plastic bag tied to the leg of the bed to keep these items from moving during an earthquake. \n\n • Determine the best escape routes from your home. Try to identify two escape routes.\n\n• Locate the gas main and other utilities and make sure family members know when and how to turn them off.\n\n• Practice your evacuation routes, Drop, Cover & Hold and Stop, Drop & Roll drills.\n\n\n\n Home Safety - \n\n • Install smoke detectors on each level of your home and change batteries every 6 months.\n\n• Store heavy items on the lowest shelves.\n\n• Store flammable or highly reactive chemicals (such as bleach, ammonia, and paint thinners) securely and separate from each other.\n\n• Keep fire extinguishers on each level and know how and when to use them.\n\n• Ensure that all window safety bars have emergency releases.\n\n• Store food items that are familiar, rather than buying special emergency food. Consider any dietary restrictions and preferences you may have.\n\n• Ideal foods are: Shelf-stable (no refrigeration required), low in salt, and do not require cooking (e.g. canned fruit, vegetables, peanut butter, jam, low-salt crackers, cookies, cereals, nuts, dried fruit, canned soup or meats, juices and non-fat dry milk).",
                style: TextStyle(fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }
}
