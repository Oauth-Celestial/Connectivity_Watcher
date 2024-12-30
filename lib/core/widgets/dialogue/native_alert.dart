import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showNativeDialogue(BuildContext context, VoidCallback onPressed) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      //isAlertActive = true;
      return Platform.isIOS
          ? CupertinoAlertDialog(
              title: Text('No Internet Connection'),
              content:
                  Text('Please check your internet connection and try again.'),
              actions: [
                CupertinoDialogAction(
                  onPressed: onPressed,
                  child: Text('Try Again'),
                ),
              ],
            )
          : AlertDialog(
              title: Text('No Internet Connection'),
              content:
                  Text('Please check your internet connection and try again.'),
              actions: [
                TextButton(
                  onPressed: onPressed,
                  child: Text('Try Again'),
                ),
              ],
            );
    },
  );
}
