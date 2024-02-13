import 'package:flutter/material.dart';

import '../constants.dart';


/// A widget that displays a back button icon and allows the user to navigate back.
class BackButtonWidget extends StatefulWidget {

   /// Constructor for the BackButtonWidget class.
  const BackButtonWidget({super.key});

  
  @override
  State<BackButtonWidget> createState() => _BackButtonWidgetState();
}

class _BackButtonWidgetState extends State<BackButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: AppColors.lgColor3,
          size: 45 ,
          weight: 200.0,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}