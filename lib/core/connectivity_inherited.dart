import 'package:connectivity_watcher/core/connectivity_controller.dart';
import 'package:flutter/material.dart';

typedef ConnectionBuilder = Widget Function(
    BuildContext, GlobalKey<NavigatorState>);

// ignore: must_be_immutable
class ConnectivityInheritedWidget extends InheritedWidget {
  ConnectivityInheritedWidget({
    this.controller,
    required Widget child,
  }) : super(child: child);
  ConnectivityController? controller;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
