// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stay_safe/const/AppColors.dart';

class Floods extends StatelessWidget {
  const Floods({Key? key}) : super(key: key);

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
                    'Floods',
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
                "During a Flood Watch or Warning -\n\n• Gather emergency supplies, including food and water. Store at least 1 gallon of water per day for each person and each pet. Store at least a 3-day supply. \n\n •Listen to your local radio or television station for updates.\n\n• If evacuation appears necessary, turn off all utilities at the main power switch and close the main gas valve.\n\n• Talk with your local emergency response team. These people are aware of the effects of the disaster and can help the citizens of the local community to organise help and relief accordingly.\n\n\n\n After Flooding Occurs - \n\n • Avoid driving through flooded areas and standing water. As little as six inches of water can cause you to lose control of your vehicle.\n\n• Do not drink flood water, or use it to wash dishes, brush teeth, or wash/prepare food. Drink clean, safe water.\n\n• If you evacuated, return to your home only after local authorities have said it is safe to do so.\n\n• Listen for boil water advisories. Local authorities will let you know if your water is safe for drinking and bathing.\n\n• Prevent carbon monoxide (CO) poisoning. Use generators at least 20 feet from any doors, windows, or vents. If you use a pressure washer, be sure to keep the engine outdoors and 20 feet from windows, doors, or vents as well. Never run your car or truck inside a garage that is attached to a house even with the garage door open.",
                style: TextStyle(fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }
}
