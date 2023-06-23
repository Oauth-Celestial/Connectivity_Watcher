import 'package:connectivity_watcher/NetworkService/ConnectivityWidget/connectivity_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConnectivityWatcherAppWrapper extends StatelessWidget {
  /// [app] will accept MaterialApp or CupertinoApp must be non-null
  final Widget app;

  ConnectivityWatcherAppWrapper({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConnectivityController(),
      builder: (context, child) {
        return Builder(builder: (context) {
          Provider.of<ConnectivityController>(context, listen: false)
              .setupConnectivityListner();
          return app;
        });
      },
    );
  }
}
