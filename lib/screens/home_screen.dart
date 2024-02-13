import 'package:flutter/material.dart';
import 'package:lg_task2/screens/configuration_screen.dart';

import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/kml/look_at_model.dart';
import '../providers/connection_provider.dart';
import '../providers/ssh_provider.dart';
import '../reusable_widgets.dart/app_bar.dart';
import '../reusable_widgets.dart/connection_indicator.dart';
import '../reusable_widgets.dart/dialog_popup.dart';
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
                        builder: (context) =>
                            const Configuration()), // Replace SecondPage with your desired destination page
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
        const Align(
            alignment: Alignment.center,
            child: SubText(
              subTextContent: 'Welcome to Liquid Galaxy !',
              fontSize: 40,
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LgElevatedButton(
                elevatedButtonContent: 'Reboot LG',
                buttonColor: AppColors.lgColor1,
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.25,
                imagePath: 'assets/images/reboot2.png',
                imageHeight: MediaQuery.of(context).size.height * 0.1,
                imageWidth: MediaQuery.of(context).size.height * 0.1,
                fontSize: 25,
                isPoly: false,
                onpressed: () async {
                  /// retrieving the ssh data from the `ssh provider`
                  final sshData =
                      Provider.of<SSHprovider>(context, listen: false);

                  ///checking the connection status first
                  if (sshData.client != null) {
                    /// calling `reboot` from `LGService`

                    //warning message first
                    showPopUp(context, 'Are you sure you want to Reboot?', '',
                        'YES', 'CANCEL', () {
                      LgService(sshData).reboot();
                    });
                  } else {
                    ///Showing error message
                    showPopUp(context, 'Not Connected to LG !!',
                        'Please Connect to LG', 'OK', null, null);
                  }
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
                    await LgService(sshData).flyTo(LookAtModel(
                      longitude: 31.2348283,
                      latitude: 30.0512139,
                      range: '10000',
                      tilt: '0',
                      altitude: 50000.1097385,
                      heading: '0',
                      altitudeMode: 'relativeToSeaFloor',
                    ));
                  } else {
                    ///Showing error message
                    showPopUp(context, 'Not Connected to LG !!',
                        'Please Connect to LG', 'OK', null, null);
                  }
                }),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LgElevatedButton(
                elevatedButtonContent: 'Orbit',
                buttonColor: AppColors.lgColor3,
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.25,
                imagePath: 'assets/images/orbit1.png',
                imageHeight: MediaQuery.of(context).size.height * 0.1,
                imageWidth: MediaQuery.of(context).size.height * 0.1,
                fontSize: 25,
                isPoly: false,
                onpressed: () async {
                  final sshData =
                      Provider.of<SSHprovider>(context, listen: false);

                  if (sshData.client != null) {
                    try {
                      // await LgService(sshData).stopTour();
                      await LgService(sshData).sendTour('orbit', 'Orbit');
                      await LgService(sshData).startTour('Orbit');
                    } catch (e) {
                      // ignore: avoid_print
                      print(e);
                    }
                  } else {
                    showPopUp(context, 'Not Connected to LG !!',
                        'Please Connect to LG', 'OK', null, null);
                  }
                }),
            LgElevatedButton(
                elevatedButtonContent: 'Show Info',
                buttonColor: AppColors.lgColor4,
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.25,
                imagePath: 'assets/images/bubble_info2.png',
                imageHeight: MediaQuery.of(context).size.height * 0.1,
                imageWidth: MediaQuery.of(context).size.height * 0.1,
                fontSize: 25,
                isPoly: false,
                onpressed: () async {}),
          ],
        ),
      ],
    );
  }
}
