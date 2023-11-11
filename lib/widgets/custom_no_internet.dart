import 'package:connectivity_watcher/controller/connectivity_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomNoInternetWrapper extends StatelessWidget {
  final Widget Function(BuildContext) builder;
  CustomNoInternetWrapper({required this.builder});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConnectivityController(),
      builder: (context, _) {
        return Scaffold(
            backgroundColor: Colors.transparent, body: builder(context));
      },
    );
  }
}
