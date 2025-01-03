import 'package:connectivity_watcher/core/service/zo_connectivity_watcher_service.dart';
import 'package:flutter/material.dart';

class ZoNetworkAware extends StatelessWidget {
  final Widget Function(
      BuildContext context, ConnectivityWatcherStatus internetStatus) builder;
  ZoNetworkAware({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityWatcherStatus>(
        stream: ZoConnectivityWatcher().connectivityController.stream,
        initialData: ConnectivityWatcherStatus.connected,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return builder(context, snapshot.data!);
          }
          return Container();
        });
  }
}
