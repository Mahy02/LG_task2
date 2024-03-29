import 'package:flutter/material.dart';
import 'package:lg_task2/screens/configuration_screen.dart';

import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/connection_provider.dart';
import '../providers/ssh_provider.dart';
import '../reusable_widgets.dart/app_bar.dart';
import '../reusable_widgets.dart/connection_indicator.dart';
import '../reusable_widgets.dart/dialog_builder.dart';
import '../reusable_widgets.dart/lg_elevated_button.dart';
import '../reusable_widgets.dart/sub_text.dart';
import '../services/lg_functionalities.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
        const Align(
            alignment: Alignment.center,
            child: SubText(
              subTextContent: 'LG Settings',
              fontSize: 40,
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LgElevatedButton(
                elevatedButtonContent: 'Reboot',
                buttonColor: AppColors.lgColor1,
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.25,
                imagePath: 'assets/images/reboot2.png',
                imageHeight: MediaQuery.of(context).size.height * 0.1,
                imageWidth: MediaQuery.of(context).size.height * 0.1,
                fontSize: 25,
                isPoly: false,
                onpressed: () {
                  /// retrieving the ssh data from the `ssh provider`
                  final sshData =
                      Provider.of<SSHprovider>(context, listen: false);

                  ///checking the connection status first
                  if (sshData.client != null) {
                    /// calling `reboot` from `LGService`

                    dialogBuilder(context, 'Are you sure you want to Reboot?',
                        false, 'YES', () {
                      LgService(sshData).reboot();
                      
                    });
                  } else {
                    ///Showing error message
                    
                    dialogBuilder(
                        context,
                        'NOT connected to LG !! \n Please Connect to LG',
                        true,
                        'OK',
                        null);
                  }
                }),
            LgElevatedButton(
                elevatedButtonContent: 'Shut Down',
                buttonColor: AppColors.lgColor2,
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.25,
                imagePath: 'assets/images/shutdown.png',
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
                    //warning message first

                    dialogBuilder(
                        context,
                        'Are you sure you want to Shut Down?',
                        false,
                        'YES', () {
                      try {
                        LgService(sshData).shutdown();
                      } catch (e) {
                        // ignore: avoid_print
                        print(e);
                      }
                    });
                  } else {
                    ///Showing error message

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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LgElevatedButton(
                elevatedButtonContent: 'Relaunch',
                buttonColor: AppColors.lgColor3,
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.25,
                imagePath: 'assets/images/relaunch.png',
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

                    dialogBuilder(context, 'Are you sure you want to Relaunch?',
                        false, 'YES', () {
                      LgService(sshData).relaunch();
                    });
                  } else {
                    dialogBuilder(
                        context,
                        'NOT connected to LG !! \n Please Connect to LG',
                        true,
                        'OK',
                        null);
                  }
                }),
            LgElevatedButton(
                elevatedButtonContent: 'Clear KML',
                buttonColor: AppColors.lgColor4,
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.25,
                imagePath: 'assets/images/clear.png',
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
                    LgService(sshData).clearKml();
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
      ],
    );
  }
}
