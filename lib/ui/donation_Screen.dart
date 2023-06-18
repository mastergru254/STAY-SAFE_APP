// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stay_safe/const/AppColors.dart';
import 'package:url_launcher/url_launcher.dart';

class DonationScreen extends StatelessWidget {
  const DonationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: green,
        title: const Text('Donation'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    'Government Initiated',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          height: 200,
                          width: 190,
                          color: Colors.white,
                          child: Column(
                            children: [
                              Image.asset(
                                "asset/global-fund.jpg",
                                height: 180,
                              ),
                              const Text("The Global Fund")
                            ],
                          ),
                        ),
                      ),
                      onTap: () => launchUrl(Uri.parse(
                          'https://www.theglobalfund.org/en/government/profiles/kenya/')),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          height: 200,
                          width: 230,
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "asset/irc.png",
                                height: 180,
                                width: 220,
                              ),
                              const Text("International Rescue Committee")
                            ],
                          ),
                        ),
                      ),
                      onTap: () => launchUrl(Uri.parse('https://rescue.org')),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    "Trusted NGO's",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          height: 200,
                          width: 190,
                          color: Colors.white,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Image.asset(
                                  "asset/kenya-red-cross.png",
                                  height: 180,
                                ),
                                const Text("Kenya RedCross Society")
                              ],
                            ),
                          ),
                        ),
                      ),
                      onTap: () =>
                          launchUrl(Uri.parse('https://www.redcross.or.ke/')),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          height: 200,
                          width: 190,
                          color: Colors.white,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Image.asset(
                                  "asset/global-giving.png",
                                  height: 180,
                                ),
                                const Text("Global Giving")
                              ],
                            ),
                          ),
                        ),
                      ),
                      onTap: () =>
                          launchUrl(Uri.parse('https://www.globalgiving.org')),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          height: 200,
                          width: 190,
                          color: Colors.white,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Image.asset(
                                  "asset/oxfam.png",
                                  height: 180,
                                ),
                                const Text("OXFAM")
                              ],
                            ),
                          ),
                        ),
                      ),
                      onTap: () =>
                          launchUrl(Uri.parse('https://www.oxfam.org/en')),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
