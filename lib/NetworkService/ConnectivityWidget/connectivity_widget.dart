import 'package:connectivity_watcher/NetworkService/ConnectivityWidget/connectivity_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../connectivity_enum.dart';

// ignore: must_be_immutable
class ConnectivityWidget extends StatefulWidget {
  /// Builder function
  ConnectivityBuilder builder;
  ConnectivityWidget({required this.builder});

  @override
  State<ConnectivityWidget> createState() => _ConnectivityWidgetState();
}

class _ConnectivityWidgetState extends State<ConnectivityWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityController>(
        builder: (context, controller, child) {
      return widget.builder(context,
          controller.internetStatus ?? ConnectivityWatcherStatus.disconnected);
    });
  }
}
