import 'package:flutter/material.dart';
import 'package:lg_task2/screens/configuration_screen.dart';

import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/kml/KMLModel.dart';
import '../models/kml/placemark_model.dart';
import '../providers/connection_provider.dart';
import '../providers/ssh_provider.dart';
import '../reusable_widgets.dart/app_bar.dart';
import '../reusable_widgets.dart/connection_indicator.dart';
import '../reusable_widgets.dart/dialog_builder.dart';
import '../reusable_widgets.dart/lg_elevated_button.dart';
import '../reusable_widgets.dart/sub_text.dart';
import '../services/lg_functionalities.dart';

class HomeCityPage extends StatefulWidget {
  const HomeCityPage({super.key});

  @override
  State<HomeCityPage> createState() => _HomeCityPageState();
}

class _HomeCityPageState extends State<HomeCityPage> {
  _buildBallon() async {
    final sshData = Provider.of<SSHprovider>(context, listen: false);

    //https://github.com/Mahy02/LG_task2/blob/main/assets/images/cairo.png?raw=true
    final placemark = PlacemarkModel(
      id: '1',
      name: 'Cairo, Egypt',
      balloonContent: '''
    <div style="text-align:center;">
      <b><font size="+3"> 'Cairo, Egypt' <font color="#5D5D5D"></font></font></b>
      </div>
      <br/><br/>
      <div style="text-align:center;">
      <img src="https://github.com/Mahy02/HAPIS-Refurbishment--Humanitarian-Aid-Panoramic-Interactive-System-/blob/week4/hapis/assets/images/cityBallon.png?raw=true" style="display: block; margin: auto; width: 150px; height: 100px;"/><br/><br/>
     </div>
      <b>MAHINOUR ELSARKY</b>
      <br/>
    ''',
    );
    final kmlBalloon = KMLModel(
      name: 'City-balloon',
      content: placemark.balloonOnlyTag,
    );

    try {
      /// sending kml to slave where we send to `balloon screen` and send the `kml balloon ` body
      await LgService(sshData).sendKMLToSlave(
        LgService(sshData).balloonScreen,
        kmlBalloon.body,
      );
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

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
              subTextContent: 'Explore Home City !',
              fontSize: 40,
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LgElevatedButton(
                elevatedButtonContent: 'Start Orbit',
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
                      await LgService(sshData).startTour('Orbit');
                    } catch (e) {
                      // ignore: avoid_print
                      print(e);
                    }
                  } else {
                    // showPopUp(context, 'Not Connected to LG !!',
                    //     'Please Connect to LG', 'OK', null, null);
                     dialogBuilder(
                        context,
                        'NOT connected to LG !! \n Please Connect to LG',
                        true,
                        'OK',
                        null);
                  }
                }),
            LgElevatedButton(
                elevatedButtonContent: 'Stop Orbit',
                buttonColor: AppColors.lgColor2,
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.25,
                imagePath: 'assets/images/stop.png',
                imageHeight: MediaQuery.of(context).size.height * 0.1,
                imageWidth: MediaQuery.of(context).size.height * 0.1,
                fontSize: 25,
                isPoly: false,
                onpressed: () async {
                  final sshData =
                      Provider.of<SSHprovider>(context, listen: false);

                  if (sshData.client != null) {
                    try {
                      await LgService(sshData).stopTour();
                    } catch (e) {
                      // ignore: avoid_print
                      print(e);
                    }
                  } else {
                    // showPopUp(context, 'Not Connected to LG !!',
                    //     'Please Connect to LG', 'OK', null, null);
                     dialogBuilder(
                        context,
                        'NOT connected to LG !! \n Please Connect to LG',
                        true,
                        'OK',
                        null);
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
                onpressed: () async {
                  try {
                    final sshData =
                        Provider.of<SSHprovider>(context, listen: false);

                    if (sshData.client != null) {
                      _buildBallon();
                    } else {
                      // ignore: use_build_context_synchronously
                      // showPopUp(context, 'Not Connected to LG !!',
                      //     'Please Connect to LG', 'OK', null, null);
                       dialogBuilder(
                        context,
                        'NOT connected to LG !! \n Please Connect to LG',
                        true,
                        'OK',
                        null);
                    }
                  } catch (e) {
                    // ignore: avoid_print
                    print(e);
                  }
                }),
          ],
        ),
      ],
    );
  }
}
