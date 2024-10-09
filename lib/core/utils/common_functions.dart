import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showAlert(context,strMsg) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (BuildContext context) => CupertinoAlertDialog(
      content: Text(strMsg),
      actions: [
        CupertinoDialogAction(
          child: const Text("Ok"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}