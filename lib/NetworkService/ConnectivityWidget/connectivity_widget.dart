import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../connectivity_enum.dart';

class ConnectivityWidget extends StatefulWidget {
  /// Builder function
  ConnectivityBuilder builder;

  ConnectivityWidget({required this.builder});

  @override
  State<ConnectivityWidget> createState() => _ConnectivityWidgetState();
}

class _ConnectivityWidgetState extends State<ConnectivityWidget> {
  ConnectivityWatcherStatus? internetStatus;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
        context, internetStatus ?? ConnectivityWatcherStatus.disconnected);
  }
}
