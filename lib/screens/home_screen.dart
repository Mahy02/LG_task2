import 'package:flutter/material.dart';
import 'package:lg_task2/screens/configuration_screen.dart';
import 'package:lg_task2/screens/home_city_screen.dart';
import 'package:lg_task2/screens/settings_screen.dart';

import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/kml/look_at_model.dart';
import '../models/kml/orbit_model.dart';
import '../providers/connection_provider.dart';
import '../providers/ssh_provider.dart';
import '../reusable_widgets.dart/app_bar.dart';
import '../reusable_widgets.dart/connection_indicator.dart';
import '../reusable_widgets.dart/dialog_builder.dart';
import '../reusable_widgets.dart/lg_elevated_button.dart';
import '../reusable_widgets.dart/sub_text.dart';
import '../services/lg_functionalities.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const LgAppBar(),
      backgroundColor: Colors.white,
      body: buildLayout(context),
    );
  }

  Widget buildLayout(BuildContext context) {
    Connectionprovider connection =
        Provider.of<Connectionprovider>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Configuration()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  fixedSize: const Size(300, 50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SubText(
                      subTextContent: 'Connect to LG!',
                      fontSize: 25,
                    ),
                    Image.asset('assets/images/connect_red.png',
                        width: 40, height: 40),
                  ],
                ),
              ),
            ),
            ConnectionIndicator(
              isConnected: connection.isConnected,
            ),
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SubText(
                subTextContent: 'Welcome to Liquid Galaxy',
                fontSize: 40,
              ),
              Image.asset(
                'assets/images/lg.png',
                width: MediaQuery.of(context).size.width * 0.08,
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              const SubText(
                subTextContent: '!',
                fontSize: 40,
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LgElevatedButton(
                elevatedButtonContent: 'LG Settings',
                buttonColor: AppColors.lgColor1,
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.25,
                imagePath: 'assets/images/settings.png',
                imageHeight: MediaQuery.of(context).size.height * 0.1,
                imageWidth: MediaQuery.of(context).size.height * 0.1,
                fontSize: 25,
                isPoly: false,
                onpressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const Settings()), 
                  );
                }),
            LgElevatedButton(
                elevatedButtonContent: 'Fly To Home',
                buttonColor: AppColors.lgColor2,
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.25,
                imagePath: 'assets/images/fly_to_home_button.png',
                imageHeight: MediaQuery.of(context).size.height * 0.1,
                imageWidth: MediaQuery.of(context).size.height * 0.1,
                fontSize: 25,
                isPoly: false,
                onpressed: () async {
                  final sshData =
                      Provider.of<SSHprovider>(context, listen: false);

                  ///checking the connection status first
                  if (sshData.client != null) {
                    LookAtModel lookAtObj = LookAtModel(
                      longitude: 31.2348283,
                      latitude: 30.0512139,
                      range: '10000',
                      tilt: '0',
                      altitude: 50000.1097385,
                      heading: '0',
                      altitudeMode: 'relativeToSeaFloor',
                    );

                    LookAtModel lookAtObjOrbit = LookAtModel(
                      longitude: 31.2348283,
                      latitude: 30.0512139,
                      range: '8000',
                      tilt: '45',
                      altitude: 10000,
                      heading: '0',
                      altitudeMode: 'relativeToSeaFloor',
                    );
                    final orbit =
                        OrbitModel.buildOrbit(OrbitModel.tag(lookAtObjOrbit));
                    try {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeCityPage()),
                      );
                      await LgService(sshData).flyTo(lookAtObj);
                      await LgService(sshData).sendTour(orbit, 'Orbit');
                    } catch (e) {
                      // ignore: avoid_print
                      print(e);
                    }
                   
                  } else {
                    
                    dialogBuilder(
                        context,
                        'NOT connected to LG !! \n Please Connect to LG',
                        true,
                        'OK',
                        null);
                  }
                }),
          ],
        ),
        Center(
          child: GestureDetector(
            onTap: () async {
              final sshData = Provider.of<SSHprovider>(context, listen: false);

              ///checking the connection status first
              if (sshData.client != null) {
                
                LookAtModel lookAtObj = LookAtModel(
                  longitude: -45.4518936,
                  latitude: 0.0000101,
                  range: '31231212.86',
                  tilt: '0',
                  altitude: 50000.1097385,
                  heading: '0',
                  altitudeMode: 'relativeToSeaFloor',
                );
                await LgService(sshData).flyTo(lookAtObj);
              } else {
               
                dialogBuilder(
                    context,
                    'NOT connected to LG !! \n Please Connect to LG',
                    true,
                    'OK',
                    null);
              }
            },
            child: Image.asset(
              'assets/images/earth.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
