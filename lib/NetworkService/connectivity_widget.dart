import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'connectivity_enum.dart';

typedef ConnectivityBuilder = Widget Function(
    BuildContext context, ConnectivityWatcherStatus s);

class ConnectivityWidget extends StatefulWidget {
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
    InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          try {
            widget.builder(context, ConnectivityWatcherStatus.connected);
          } catch (e) {}
          print('You are Connected to the internet.');
          break;
        case InternetConnectionStatus.disconnected:
          widget.builder(context, ConnectivityWatcherStatus.disconnected);
          print('You are disconnected from the internet.');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
    );
  }
}
