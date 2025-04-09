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
              title: const Text('No Internet Connection'),
              content: const Text(
                  'Please check your internet connection and try again.'),
              actions: [
                CupertinoDialogAction(
                  onPressed: onPressed,
                  child: Text('Try Again'),
                ),
              ],
            )
          : AlertDialog(
              title: const Text('No Internet Connection'),
              content: const Text(
                  'Please check your internet connection and try again.'),
              actions: [
                TextButton(
                  onPressed: onPressed,
                  child: const Text('Try Again'),
                ),
              ],
            );
    },
  );
}
