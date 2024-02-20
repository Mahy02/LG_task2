import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lg_task2/reusable_widgets.dart/app_bar.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../helpers/lg_connection_shared_pref.dart';
import '../providers/connection_provider.dart';
import '../providers/ssh_provider.dart';
import '../reusable_widgets.dart/back_button.dart';
import '../reusable_widgets.dart/connection_indicator.dart';
import '../reusable_widgets.dart/dialog_builder.dart';
import '../reusable_widgets.dart/sub_text.dart';
import '../reusable_widgets.dart/text_field.dart';
import '../services/lg_functionalities.dart';

class Configuration extends StatefulWidget {
  const Configuration({super.key});

  @override
  State<Configuration> createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  /// `form key` for our configuration form
  final _formKey = GlobalKey<FormState>();

  /// `is loading` to Track the loading state
  bool _isLoading = false;

  final TextEditingController _ipController =
      TextEditingController(text: LgConnectionSharedPref.getIP());
  final TextEditingController _portController =
      TextEditingController(text: LgConnectionSharedPref.getPort());
  final TextEditingController _userNameController =
      TextEditingController(text: LgConnectionSharedPref.getUserName());
  final TextEditingController _passwordController =
      TextEditingController(text: LgConnectionSharedPref.getPassword());
  final TextEditingController _screenAmountController = TextEditingController(
      text: LgConnectionSharedPref.getScreenAmount().toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: const LgAppBar(), body: buildLayout(context));
  }

  Widget buildLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<Connectionprovider>(
        builder: (BuildContext context, model, Widget? child) {
          return Padding(
            padding: const EdgeInsets.all(50.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    //const BackButtonWidget(),
                    Consumer<Connectionprovider>(
                      builder: (context, connectionProvider, child) {
                        return ConnectionIndicator(
                            isConnected: connectionProvider.isConnected);
                      },
                    ),
                    // ConnectionIndicator(isConnected: model.isConnected),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 50,
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SubText(
                          subTextContent: 'LG Configuration Settings',
                          fontSize: 35,
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Connection Status: ',
                          style: TextStyle(
                            fontSize: 38,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                            color: AppColors.lgColor1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 30),
                        Text(
                          model.isConnected == true
                              ? "Connected"
                              : "Not Connected",
                          style: TextStyle(
                            fontSize: 35,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                            color: model.isConnected == true
                                ? AppColors.lgColor4
                                : AppColors.lgColor2,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: TextFormFieldWidget(
                                  fontSize: 30,
                                  label: 'LG User Name',
                                  key: const ValueKey("username"),
                                  textController: _userNameController,
                                  isSuffixRequired: true,
                                  isHidden: false,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: TextFormFieldWidget(
                                  fontSize: 30,
                                  label: 'LG Password',
                                  key: const ValueKey("lgpass"),
                                  textController: _passwordController,
                                  isSuffixRequired: true,
                                  isHidden: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: TextFormFieldWidget(
                                  fontSize: 30,
                                  key: const ValueKey("ip"),
                                  label: 'LG Master IP address',
                                  textController: _ipController,
                                  isSuffixRequired: true,
                                  isHidden: false,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: TextFormFieldWidget(
                                  fontSize: 30,
                                  label: 'LG Port Number',
                                  key: const ValueKey("port"),
                                  textController: _portController,
                                  isSuffixRequired: true,
                                  isHidden: false,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: TextFormFieldWidget(
                                  fontSize: 30,
                                  label: 'Number of LG screens',
                                  key: const ValueKey("lgscreens"),
                                  textController: _screenAmountController,
                                  isSuffixRequired: true,
                                  isHidden: false,
                                ),
                              ),
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: ElevatedButton(
                        onPressed: () async {
                          /// checking first if form is valid
                          if (_formKey.currentState!.validate()) {
                            //saving date in shared pref
                            await LgConnectionSharedPref.setUserName(
                                _userNameController.text);
                            await LgConnectionSharedPref.setIP(
                                _ipController.text);
                            await LgConnectionSharedPref.setPassword(
                                _passwordController.text);
                            await LgConnectionSharedPref.setPort(
                                _portController.text);
                            await LgConnectionSharedPref.setScreenAmount(
                                int.parse(_screenAmountController.text));
                          }

                          final sshData =
                              Provider.of<SSHprovider>(context, listen: false);

                          ///start the loading process by setting `isloading` to true
                          setState(() {
                            _isLoading = true;
                          });

                          /// Call the init function to set up the SSH client with the connection data
                          String? result = await sshData.init(context);

                          Connectionprovider connection =
                              Provider.of<Connectionprovider>(context,
                                  listen: false);

                          ///checking on the connection status:
                          if (result == '') {
                            connection.isConnected = true;

                            ///If connected, the logos should appear by calling `setLogos` from the `LGService` calss
                            LgService(sshData).setLogos();
                          } else {
                            connection.isConnected = false;

                            ///show an error message
                            //showConnectionError(context, result!);
                            // ignore: use_build_context_synchronously
                            // showPopUp(context, 'Not Connected to LG !!',
                            //     result!, 'OK', null, null);
                            // ignore: use_build_context_synchronously
                            dialogBuilder(
                                context,
                                'NOT connected to LG !! \n Please Connect to LG',
                                true,
                                'OK',
                                null);
                          }

                          ///stop the loading process by setting `isloading` to false
                          setState(() {
                            _isLoading = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lgColor4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80),
                          ),
                          //  minimumSize: ,
                        ),
                        child: const Text(
                          'CONNECT TO LG',
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 30,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_isLoading)

                  /// Show the loading indicator if `_isLoading` is true
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.3,
                    //color: Color.fromARGB(126, 234, 234, 234),
                    child: const CircularProgressIndicator(
                      color: AppColors.accent,
                      backgroundColor: AppColors.lgColor3,
                      semanticsLabel: 'Loading',
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
