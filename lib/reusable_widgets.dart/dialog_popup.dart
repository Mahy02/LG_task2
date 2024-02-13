import 'package:flutter/material.dart';

import '../constants.dart';

Future<dynamic> showPopUp(
  BuildContext context,
  String text1,
  String text2,
  String confirmMessg1,
  String? confirmMessg2,
  Function? action,
) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            text1,
            style: const TextStyle(fontSize: 30, color: AppColors.lgColor2),
          ),
          content: Text(text2, style: const TextStyle(fontSize: 25)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (action != null) {
                  action();
                }
              },
              child: Text(confirmMessg1, style: const TextStyle(fontSize: 20)),
            ),
            if (confirmMessg2 != null)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child:
                    Text(confirmMessg2, style: const TextStyle(fontSize: 20)),
              ),
          ],
        );
      });
}
