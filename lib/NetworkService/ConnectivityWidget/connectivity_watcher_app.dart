import 'package:flutter/material.dart';

///[ConnectivityAppWrapper] is a StatelessWidget.
class ConnectivityWatcherAppWrapper extends StatelessWidget {
  /// [app] will accept MaterialApp or CupertinoApp must be non-null
  final Widget app;

  ConnectivityWatcherAppWrapper({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return app;
  }
}
