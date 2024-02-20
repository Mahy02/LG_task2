import 'package:flutter/material.dart';
import '../constants.dart';

Future<void> dialogBuilder(BuildContext context, String dialogMessage,
    bool isOne, String confirmMessage, VoidCallback? onConfirm) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Alert!',
          style: TextStyle(fontSize: 18, color: AppColors.lgColor2),
        ),
        content: Text(dialogMessage, style: const TextStyle(fontSize: 30)),
        actions: <Widget>[
          if (isOne == false)
            TextButton(
              child: const Text('CANCEL',
                  style: TextStyle(fontSize: 20, color: AppColors.lgColor2)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                if (onConfirm != null) {
                  try {
                     onConfirm();
                  } catch (e) {
                    // ignore: avoid_print
                    print(e);
                  }
                }
              },
              child: Text(confirmMessage,
                  style: const TextStyle(
                      fontSize: 20, color: AppColors.lgColor4))),
        ],
      );
    },
  );
}
