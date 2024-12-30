import 'package:connectivity_watcher/connectivity_watcher.dart';

import 'package:flutter/material.dart';

typedef ConnectionBuilder = Widget Function(
    BuildContext, GlobalKey<NavigatorState>);

// ignore: must_be_immutable
class ZoConnectivityInheritedWidget extends InheritedWidget {
  ZoConnectivityInheritedWidget({
    this.controller,
    required Widget child,
  }) : super(child: child);
  ZoConnectivityController? controller;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
