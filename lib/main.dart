import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lg_task2/providers/connection_provider.dart';
import 'package:lg_task2/providers/ssh_provider.dart';
import 'package:lg_task2/screens/splash_screen.dart';
import 'package:lg_task2/services/lg_functionalities.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'helpers/lg_connection_shared_pref.dart';
import 'models/ssh_model.dart';

void main() async {
  /// Initialize the app
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize shared preferences for login session and LG connection
  await LgConnectionSharedPref.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Connectionprovider()),
        ChangeNotifierProvider(create: (_) => SSHprovider())
      ],
      child: const LgApp(),
    ),
  );

  Timer.periodic(const Duration(seconds: 30), (timer) async {
    final sshData =
        Provider.of<SSHprovider>(navigatorKey.currentContext!, listen: false);

    Connectionprovider connection = Provider.of<Connectionprovider>(
        navigatorKey.currentContext!,
        listen: false);

    String? result = await sshData.reconnectClient(
        SSHModel(
          username: LgConnectionSharedPref.getUserName() ?? '',
          host: LgConnectionSharedPref.getIP() ?? '',
          passwordOrKey: LgConnectionSharedPref.getPassword() ?? '',
          port: int.parse(LgConnectionSharedPref.getPort() ?? '22'),
        ),
        navigatorKey.currentContext!);
    if (result == 'fail' || result != '') {
      connection.isConnected = false;
    } else {
      connection.isConnected = true;
    }
  });
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class LgApp extends StatelessWidget {
  const LgApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final sshData = Provider.of<SSHprovider>(context, listen: false);
    LgService(sshData).setLogos();

    return MaterialApp(
      title: 'LG Task 2',
      theme: ThemeData(
          fontFamily: GoogleFonts.montserrat().fontFamily,
          primaryColor: AppColors.primary),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const SplashScreen(),
      navigatorKey: navigatorKey,
    );
  }
  
}
