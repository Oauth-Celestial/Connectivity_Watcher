import 'package:connectivity_watcher/NetworkService/ConnectivityWidget/connectivity_controller.dart';
import 'package:connectivity_watcher/NetworkService/connectivity_watcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ConnectivityWatcherAppWrapper extends StatefulWidget {
  /// [app] will accept MaterialApp or CupertinoApp must be non-null
  final Widget app;
  Widget? noInternetWidget;

  ConnectivityWatcherAppWrapper({super.key, required this.app,this.noInternetWidget});

  @override
  State<ConnectivityWatcherAppWrapper> createState() => _ConnectivityWatcherAppWrapperState();
}

class _ConnectivityWatcherAppWrapperState extends State<ConnectivityWatcherAppWrapper> {

@override
  void initState() {
    // TODO: implement initState
    ConnectivityWatcher.shared.setup(widgetForNoInternet: NoInternetWidget(widget: widget.noInternetWidget));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConnectivityController(),
      builder: (context, child) {
        return Builder(builder: (context) {
          Provider.of<ConnectivityController>(context, listen: false)
              .setupConnectivityListner();
          return widget.app;
        });
      },
    );
  }
}
