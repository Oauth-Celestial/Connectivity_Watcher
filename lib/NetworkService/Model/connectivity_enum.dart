import 'package:flutter/material.dart';

typedef ConnectivityBuilder = Widget Function(
    BuildContext context, ConnectivityWatcherStatus internetStatus);

enum ConnectivityWatcherStatus {
  /// connected to internet
  connected,

  /// disconnected from internet
  disconnected,
}